
#use Finance::Quote::Moex;
#my %fields = &Finance::Quote::Moex::getfields("f1;f2;f3");

#print (%fields);
#print ($fields{"f3"});

#exit;
use Finance::Quote;


# my $module = "Moexbondt0";
my $module = "Moex";

#my $method = "moex_bond_ofz";
my $method = "moex_stock";
my $quoter = Finance::Quote->new($module);

#my $ticker="SU26218RMFS6"; # ОФЗ 26218
my $ticker="SBER"; # Сбербанк
#my $ticker="RU000A0JSGV0"; # РЖД-32
#my $ticker="RU000A0JUFE4"; # ВЭБ USD
my %info = $quoter->fetch($method, $ticker); 
print "$ticker: \n";
print "   date: $info{$ticker,'date'}\n";
print "   price: $info{$ticker,'price'}\n";
print "   currency: $info{$ticker,'currency'} \n";
print "   isodate: $info{$ticker,'isodate'} \n";