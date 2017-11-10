use Finance::Quote;

print ("Start script \n");

my $quoter = Finance::Quote->new("Cbrcur");

my %info = $quoter->fetch("cbrcur", "EUR"); # ОФЗ 26208
print "EUR date: $info{'EUR','date'} price: $info{'EUR','last'}\n";

   #$q->timeout(60);

   #$conversion_rate = $q->currency("AUD","USD");
   #$q->set_currency("EUR");  # Return all info in Euros.

   #$q->require_labels(qw/price date high low volume/);

   #$q->failover(1); # Set failover support (on by default).

   #%quotes  = $q->fetch("nasdaq",@stocks);
   #%quotes  = $q->fetch("moexbonds", "SU26208RMFS7");
   #print($qoutes)
   
   #print($hashref {"SU26208RMFS7"})