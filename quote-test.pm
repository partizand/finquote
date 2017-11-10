use Finance::Quote;

print ("Start script \n");

my $quoter = Finance::Quote->new("Moexbonds");

my $ticker="SU26208RMFS7"; # ОФЗ 26208
my %info = $quoter->fetch("moexbonds", $ticker); 
print "$ticker: \n";
print "   date: $info{$ticker,'date'}\n";
print "   price: $info{$ticker,'price'}\n";
print "   currency: $info{$ticker,'currency'} \n";
print "   isodate: $info{$ticker,'isodate'} \n";