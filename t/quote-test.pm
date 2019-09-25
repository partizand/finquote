
#use Finance::Quote::Moex;



#print ($fields{"f3"});





# my $module = "Moexbondt0";
my $module = "Moex";

my $method = "moex_bond_ofz_nkd";
#my $method = "moex_stock";



#my $ticker="SBER"; # Сбербанк
#my $ticker="RU000A0JSGV0"; # РЖД-32
#my $ticker="RU000A0JUFE4"; # ВЭБ USD
my %info = $quoter->fetch($method, $ticker); 
print "$ticker: \n";
print "   date: $info{$ticker,'date'}\n";
print "   price: $info{$ticker,'price'}\n";
print "   currency: $info{$ticker,'currency'} \n";
print "   isodate: $info{$ticker,'isodate'} \n";