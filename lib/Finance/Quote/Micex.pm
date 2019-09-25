#!/usr/bin/perl -w


#    Copyright (C) 2009, Andrey Kapustin <partizan-k@yandex.ru>
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

package Finance::Quote::Micex;

use 5.000000;
use strict;
use warnings;
#use encoding 'utf-8';

use vars qw($VERSION);


our $VERSION = '0.1';
our $MICEX_URL = "http://export.rbc.ru/free/micex.0/free.fcgi?period=DAILY&tickers=NULL&lastdays=5&separator=;&data_format=EXCEL&header=0";

use LWP::UserAgent;
use HTTP::Request::Common;
#use Time::Local;
use Carp;

sub methods { return ( micex => \&micex ); }

{
	my @labels = qw/name last open low high close waprica date isodate currency/;
	
	sub labels { return ( micex => \@labels ); }
}

sub micex {
	my $quoter = shift;
	my @stocks = @_;
	my $sym;
	my $stock;
	my %info;
	my %stockhash;
	my @q;
	
	
	my $ua = $quoter->user_agent; #http
	
	foreach my $stock (@stocks) # Обнуляем признаки обработки тикеров
	  {
	    $stockhash{$stock} = 0;
	  }

	
	my $url=$MICEX_URL;
	
		 my $response = $ua->request(GET $url); #http begin
		unless ($response->is_success) {
			foreach my $stock (@stocks) {
				$info{$stock, "success"} = 0;
				$info{$stock, "errormsg"} = "HTTP failure";
			}
		
			return wantarray() ? %info : \%info;
		     } #http end
		
		my $content = $response->content; #http
		
		
		foreach (split(/\n/,$content)) #http
		      {#chomp;
		      
		      
		      @q = split(/;/,$_);
		      
		      
		      $sym = $q[0]; #Код бумаги
		      if ($sym) {		      
		      
			foreach my $stock (@stocks) {
			if ( $sym eq $stock ) {  
			#if ($stockhash{$stock} == 0)
			 # {
			    #print (Msg "Found sym $stock close=$q[5] date=$q[1] \n");
		      $info{$stock, "symbol"} = $stock; #Код
					$info{$stock, "name"} = $stock; 
					$info{$stock, "currency"} = "RUB";
					$info{$stock, "method"} = "micex";
					$info{$stock, "open"} = $q[2];
					  $info{$stock, "high"} = $q[3];
					  $info{$stock, "low"} = $q[4];
					$info{$stock, "waprice"} = $q[7];
					$info{$stock, "close"} = $q[5];
					#$info{$stock, "ask"} = $q[11];
					$info{$stock, "last"} = $q[5];
					$quoter->store_date(\%info, $stock,  {isodate => $q[1]});
					$info{$stock, "success"} = 1;
					$stockhash{$stock} = 1;
					#print (Msg "Found sym $stock last=$info{$stock,'last'} date=$info{$stock,'date'} \n");  
			#		}
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

Finance::Quote::Micex- Obtain quotes from Micex

=head1 SYNOPSIS

	use Finance::Quote;

	my $quoter = Finance::Quote->new("Micex");
	my %info = $quoter->fetch("micex", "ALFT"); # Aeroflot
	print "$info{'ALFT','date'} $info{'ALFT','last'}\n";

=head1 DESCRIPTION

This module fetches share quotes information from the Micex  http://micex.ru. 
It fetches quotes for all shares
 
It's not loaded as default Finance::Quote module, so you need create it
 by Finance::Quote->new("Micex"). If you want it to load by default,
 make changes to Finance::Quote default module loader, or use 
 FQ_LOAD_QUOTELET environment variable. Gnucash example:
	FQ_LOAD_QUOTELET="-defaults Micex" gnucash

=head1 LABELS RETURNED

The following labels may be returned by Finance::Quote::Micex :

name last price date isodate currency
 
=head1 SEE ALSO

Micex shares, http://export.rbc.ru .

=head1 AUTHOR

,Andrey Kapustin, E<lt>partizan-k@yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Andrey Kapustin. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.0.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
