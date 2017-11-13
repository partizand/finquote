#!/usr/bin/perl -w


#    Copyright (C) 2017, Partizand https://github.com/partizand/finquote
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.


# Получает цены облигаций на ММВБ
# Получает средневзвешенную цену предыдущего дня.

package Finance::Quote::Moexbonds;

use 5.000000;
use strict;
use warnings;
#use encoding 'utf-8';

use vars qw($VERSION);


our $VERSION = '0.1';
# T+1 (ОФЗ)
our $BONDS_URL_T1 = "https://iss.moex.com/iss/engines/stock/markets/bonds/boardgroups/58/securities.csv";
# T0 (Всё остальное)
our $BONDS_URL_T0 = "https://iss.moex.com/iss/engines/stock/markets/bonds/boardgroups/7/securities.csv";

#PREVDATE;Дата последних торгов;Дата последних торгов;0;0;1;;0;0;date;;0
#CURRENCYID;Сопр. валюта инструмента;Сопр. валюта инструмента;0;0;1;;0;0;string;;0
#PREVADMITTEDQUOTE;Признаваемая котировка предыдущего дня;Признаваемая котировка предыдущего дня;0;0;1;;0;0;number;;0
#PREVLEGALCLOSEPRICE;Официальная цена закрытия предыдущего дня;Официальная цена закрытия предыдущего дня;0;0;1;;0;0;number;;0
#1940;PREVWAPRICE;Средневзвешенная цена предыдущего дня, % к номиналу;Средневзвешенная цена предыдущего дня, % к номиналу;0;0;1;;0;0;number;;0
#1931;PREVPRICE;Последняя цена пред. дня;Цена последней сделки предыдущего торгового дня, % к номиналу;0;0;0;;0;0;number;;0

use LWP::UserAgent;
use HTTP::Request::Common;

sub methods { return (moexbondt0       => \&moexbondt0,
                      moexbondt1         => \&moexbondt1) }

{
  my @labels = qw/name price date isodate currency/;

  sub labels { return (moexbondt0       => \@labels,
                       moexbondt0        => \@labels) }
}

sub moexbondt1
	{
	return moexbond ($BONDS_URL_T1, @_);
	}
	
sub moexbondt0
	{
	return moexbond ($BONDS_URL_T0, @_);
	}


sub moexbond {
	my $url = shift;
	my $quoter = shift;
	my @stocks = @_;
	my $sym;
	my $stock;
	my %info;
	my %stockhash;
	my @q;
	
	# Номера столбцов полей
	my %fields = ("PREVDATE", 19,
			   "CURRENCYID", 32,
			   "PREVADMITTEDQUOTE", 18,
			   "PREVLEGALCLOSEPRICE", 17,
			   "PREVWAPRICE", 3);
	
	my $ua = $quoter->user_agent; #http
	
	foreach my $stock (@stocks) # Обнуляем признаки обработки тикеров
	  {
	   $stockhash{$stock} = 0;
	  }

	
	#my $url=$BONDS_URL;
	
	my $response = $ua->request(GET $url); #http begin
	
	unless ($response->is_success) 
		{
		foreach my $stock (@stocks) 
			{
			$info{$stock, "success"} = 0;
			$info{$stock, "errormsg"} = "HTTP failure";
			}
	
		return wantarray() ? %info : \%info;
		} #http end
		
	my $content = $response->content; #http
		
	my $currency; 
	
	foreach (split(/\n/,$content)) # split by lines
		{
		if ($_ eq 'marketdata') # После раздела marketdata все игнорируем
			{
			last;
			}
	
		@q = split(/;/,$_); # split by columns
		
		$sym = $q[0]; #Код бумаги
		if ($sym) 
			{		      
			foreach my $stock (@stocks) 
				{
				if ( $sym eq $stock ) 
					{  
				
					#print (Msg "Found sym $stock close=$q[5] date=$q[1] \n");
					$info{$stock, "symbol"} = $stock; #Код
					$info{$stock, "name"} = $stock; 
					#$info{$stock, "currency"} = "RUB";
					$currency = $q[$fields{'CURRENCYID'}];
					if ($currency eq 'SUR')
						{
						$currency = "RUB";
						}
					$info{$stock, "currency"} = $currency;
					$info{$stock, "method"} = "moexbonds";
					
					
					
					$info{$stock, "price"} = $q[$fields{'PREVWAPRICE'}] * 10; 
					
				
					#$quoter->store_date(\%info, $stock,  {isodate => _my_time('isodate')});
					$quoter->store_date(\%info, $stock,  {isodate => $q[$fields{'PREVDATE'}]});
					
					$info{$stock, "success"} = 1;
					$stockhash{$stock} = 1;
					#print ("Found sym $stock last=$info{$stock,'last'} date=$info{$stock,'date'} \n");  
				
					}
				}
			}

		}
	
	# check to make sure a value was returned for every fund requested
	foreach my $stock (keys %stockhash)
		{
		if ($stockhash{$stock} == 0)
			{
			$info{$stock, "success"}  = 0;
			$info{$stock, "errormsg"} = "Stock lookup failed";
			}
		}
		
		
	return wantarray() ? %info : \%info;
		
	
}


1;
__END__
=head1 NAME

Finance::Quote::Moexbonds- Obtain quotes from Moex for bonds

=head1 SYNOPSIS

	use Finance::Quote;

	my $quoter = Finance::Quote->new("Moexbonds");
	my %info = $quoter->fetch("moexbonds", "SU26208RMFS7"); # ОФЗ 26208
	print "$info{'SU26208RMFS7','date'} $info{'SU26208RMFS7','price'}\n";

=head1 DESCRIPTION

This module fetches bond share quotes information from the Moex http://www.moex.com. 
It fetches quotes for ofz bonds shares
 
It's not loaded as default Finance::Quote module, so you need create it
 by Finance::Quote->new("Moexbonds"). If you want it to load by default,
 make changes to Finance::Quote default module loader, or use 
 FQ_LOAD_QUOTELET environment variable. Gnucash example:
	FQ_LOAD_QUOTELET="-defaults Moexbonds" gnucash

=head1 LABELS RETURNED

The following labels may be returned by Finance::Quote::Moexbonds :

name price date isodate currency
 
=head1 AUTHOR

,Partizand, https://github.com/partizand/finquote

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by Partizand. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.0.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
