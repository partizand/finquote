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


# Пока только ОФЗ

package Finance::Quote::Moexbonds;

use 5.000000;
use strict;
use warnings;
#use encoding 'utf-8';

use vars qw($VERSION);


our $VERSION = '0.1';
our $BONDS_URL = "https://iss.moex.com/iss/engines/stock/markets/bonds/boardgroups/58/securities.csv?lang=RU&amp;security_collection=186";



#securities
#
#SECID;BOARDID;SHORTNAME;PREVWAPRICE;YIELDATPREVWAPRICE;COUPONVALUE;NEXTCOUPON;ACCRUEDINT;PREVPRICE;LOTSIZE;FACEVALUE;BOARDNAME;STATUS;MATDATE;DECIMALS;COUPONPERIOD;ISSUESIZE;PREVLEGALCLOSEPRICE;PREVADMITTEDQUOTE;PREVDATE;SECNAME;REMARKS;MARKETCODE;INSTRID;SECTORID;MINSTEP;FACEUNIT;BUYBACKPRICE;BUYBACKDATE;ISIN;LATNAME;REGNUMBER;CURRENCYID;ISSUESIZEPLACED;LISTLEVEL;SECTYPE;COUPONPERCENT
#RU000A0JXYA7;TQOB;КОБР-1;100;8.41;21.76;2017-11-15;20.63;100;1;1000;Т+ Облигации;A;2017-11-15;4;92;150000000;100;100;2017-11-08;КОБР-1;;FNDT;BOBR;EQ-N;0.001;SUR;;0000-00-00;RU000A0JXYA7;KOBR-1;4-01-22BR1-7;SUR;149529700;3;5;
#RU000A0ZYDL2;TQOB;КОБР-2;100.028;8.34;19.25;2018-01-17;3.88;100.03;1;1000;Т+ Облигации;A;2018-01-17;4;85;500000000;100.03;100.03;2017-11-08;КОБР-2;;FNDT;BOBR;EQ-N;0.001;SUR;;0000-00-00;RU000A0ZYDL2;KOBR-2;4-02-22BR1-7;SUR;226118710;3;5;
#SU24018RMFS2;TQOB;ОФЗ 24018;100.265;8.41;52.16;2017-12-27;38.69;100.278;1;1000;Т+ Облигации;A;2017-12-27;4;182;200000000;100.278;100.278;2017-11-08;Обл.федеральный займ;;FNDT;GOFZ;EQ-N;0.001;SUR;;0000-00-00;RU000A0JV7K7;OFZ-PD 24018;24018RMFS;SUR;200000000;1;3;10.46
#SU24019RMFS0;TQOB;ОФЗ 24019;102.397;7.92;45.52;2018-04-18;5.75;102.3;1;1000;Т+ Облигации;A;2019-10-16;4;182;150000000;102.302;102.302;2017-11-08;Обл.федеральный займ;;FNDT;GOFZ;EQ-N;0.001;SUR;;0000-00-00;RU000A0JX0J2;OFZ-PD 24019;24019RMFS;SUR;108215274;1;3;9.13
#
#marketdata
#
#SECID;BID;BIDDEPTH;OFFER;OFFERDEPTH;SPREAD;BIDDEPTHT;OFFERDEPTHT;OPEN;LOW;HIGH;LAST;LASTCHANGE;LASTCHANGEPRCNT;QTY;VALUE;YIELD;VALUE_USD;WAPRICE;LASTCNGTOLASTWAPRICE;WAPTOPREVWAPRICEPRCNT;WAPTOPREVWAPRICE;YIELDATWAPRICE;YIELDTOPREVYIELD;CLOSEYIELD;CLOSEPRICE;MARKETPRICETODAY;MARKETPRICE;LASTTOPREVPRICE;NUMTRADES;VOLTODAY;VALTODAY;VALTODAY_USD;BOARDID;TRADINGSTATUS;UPDATETIME;DURATION;NUMBIDS;NUMOFFERS;CHANGE;TIME;HIGHBID;LOWOFFER;PRICEMINUSPREVWAPRICE;LASTBID;LASTOFFER;LCURRENTPRICE;LCLOSEPRICE;MARKETPRICE2;ADMITTEDQUOTE;OPENPERIODPRICE;SEQNUM;SYSTIME;VALTODAY_RUR;IRICPICLOSE;BEICLOSE
#RU000A0JXYA7;;;;;0;;;;;;;0;0;0;0.00;8.44;0;;0;0;0;0;0;0;;100.002;100.002;0;0;0;0;0;TQOB;N;19:14:28;7;;;;19:14:28;;;;;;100;100;100.003;;;318479;2017-11-08 19:29:28;0;;
#RU000A0ZYDL2;;;;;0;;;100.02;100.02;100.03;100.03;0.01;0.01;100000;100030000.00;8.33;1711210.37;100.028;0.011;0.01;0.009;8.34;-0.07;0;;100.015;100.005;0.01;4;500000;500140000;8555881;TQOB;N;19:14:28;70;;;0.01;16:57:11;;;0.011;;;100.03;100.03;100.019;;;318479;2017-11-08 19:29:28;500140000;;
#SU24018RMFS2;;;;;0;;;100.279;100.24;100.295;100.278;0.008;0.01;1181;1184283.18;8.3;20259.5;100.265;0.017;0;0.004;8.41;-0.07;0;;100.279;100.26;0;361;1235128;1238574758;21188263;TQOB;N;19:14:28;49;;;0;18:47:19;;;0.017;;;100.278;100.278;100.279;;;318479;2017-11-08 19:29:28;1238574758;;
#SU24019RMFS0;;;;;0;;;102.213;102.213;102.448;102.3;-0.026;-0.03;750;767250.00;7.97;13125.32;102.397;-0.045;0.05;0.052;7.92;-0.03;0;;102.397;102.336;-0.1;124;52869;54136030;926104;TQOB;N;19:14:28;661;;;-0.1;18:35:10;;;-0.045;;;102.302;102.302;102.397;;;318479;2017-11-09 09:21:08;54136030;8.07;
#SU25081RMFS9;;;;;0;;;99.73;99.667;99.756;99.7;-0.047;-0.05;55;54835.00;7.63;938.06;99.708;0.032;0.04;0.04;7.6;-0.16;0;;99.709;99.659;0.04;202;162342;161868776;2769085;TQOB;N;19:14:28;84;;;0.038;18:49:27;;;0.032;;;99.7;99.7;99.709;;;318479;2017-11-08 19:29:28;161868776;;

#PREVDATE;Дата последних торгов;Дата последних торгов;0;0;1;;0;0;date;;0
#CURRENCYID;Сопр. валюта инструмента;Сопр. валюта инструмента;0;0;1;;0;0;string;;0
#PREVADMITTEDQUOTE;Признаваемая котировка предыдущего дня;Признаваемая котировка предыдущего дня;0;0;1;;0;0;number;;0
#PREVLEGALCLOSEPRICE;Официальная цена закрытия предыдущего дня;Официальная цена закрытия предыдущего дня;0;0;1;;0;0;number;;0
#1940;PREVWAPRICE;Средневзвешенная цена предыдущего дня, % к номиналу;Средневзвешенная цена предыдущего дня, % к номиналу;0;0;1;;0;0;number;;0
#1931;PREVPRICE;Последняя цена пред. дня;Цена последней сделки предыдущего торгового дня, % к номиналу;0;0;0;;0;0;number;;0

use LWP::UserAgent;
use HTTP::Request::Common;
#use Time::Local;
#use Carp;

sub methods { return ( moexbonds => \&moexbonds ); }

{
	my @labels = qw/name price date isodate currency/;
	
	sub labels { return ( moexbonds => \@labels ); }
}

sub moexbonds {
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

	
	my $url=$BONDS_URL;
	
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

# - return current 'isodate' and 'time' string
sub _my_time {
    my $want = shift;
    my @now  = localtime();
    my $str;

    if ( $want eq 'isodate' ) {
        $str = sprintf( '%4d-%02d-%02d', $now[5] + 1900, $now[4] + 1, $now[3] );
    }
    elsif ( $want eq 'time' ) {
        $str = sprintf( '%02d:%02d:%02d', $now[2], $now[1], $now[0] );
    }

    return ($str);
}

1;
__END__
=head1 NAME

Finance::Quote::Moexbonds- Obtain quotes from Moex for ofz bonds

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
