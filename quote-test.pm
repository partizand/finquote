use Finance::Quote;

print ("Start script \n");

my $quoter = Finance::Quote->new("Moexbonds");

my $ticker="SU26208RMFS7"; # ОФЗ 26208
my %info = $quoter->fetch("moexbonds", $ticker); 
print "$ticker date: $info{$ticker,'date'} price: $info{$ticker,'price'}\n";