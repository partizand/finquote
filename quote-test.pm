use Finance::Quote;

print ("Start script \n");

# my $module = "Moexbondt0";
my $module = "Moexbonds";

my $method = "moexbondt1";
my $quoter = Finance::Quote->new($module);

my $ticker="SU26218RMFS6"; # ОФЗ 26218
#my $ticker="RU000A0JSGV0"; # РЖД-32
my %info = $quoter->fetch($method, $ticker); 
print "$ticker: \n";
print "   date: $info{$ticker,'date'}\n";
print "   price: $info{$ticker,'price'}\n";
print "   currency: $info{$ticker,'currency'} \n";
print "   isodate: $info{$ticker,'isodate'} \n";