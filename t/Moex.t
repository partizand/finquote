# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Finance-Quote-Moex.t'
 
#########################
 
#use encoding 'utf8';
use Test::More;
 
if(not $ENV{ONLINE_TEST}) {
        plan skip_all => 'Set $ENV{ONLINE_TEST} to run this test';
}
 
plan tests => 9;
 
use_ok('Finance::Quote');
use_ok('Finance::Quote::Moex');


my $quoter = Finance::Quote->new("Moex");
 
ok(defined $quoter, "created");

# -----------------------------------------------
# bond tplus test 

my $ticker_ofz="SU29009RMFS6"; # ОФЗ 29009

my %info = $quoter->fetch("moex_bond_tplus", $ticker_ofz);

ok(%info, "fetched");
ok($info{$ticker_ofz, "name"}, $ticker_ofz);

diag("$ticker_ofz: (ОФЗ 29009)\n");
diag("   name: $info{$ticker_ofz,'name'}\n");
diag("   date: $info{$ticker_ofz,'date'}\n");
diag("   price: $info{$ticker_ofz,'price'}\n");
diag("   currency: $info{$ticker_ofz,'currency'} \n");
diag("   isodate: $info{$ticker_ofz,'isodate'} \n");

#
# -----------------------------------------------
# nkd

my %info = $quoter->fetch("moex_bond_tplus_nkd", $ticker_ofz);
ok(%info, "fetched");
ok($info{$ticker_ofz, "name"}, $ticker_ofz);


# -----------------------------------------------
# stock test
my $ticker="GAZP"; # Газпром

my %info = $quoter->fetch("moex_stock", $ticker);
ok(%info, "fetched");
ok($info{$ticker, "name"}, $ticker);

diag("$ticker: (Газпром)\n");
diag("   date: $info{$ticker,'date'}\n");
diag("   price: $info{$ticker,'price'}\n");
diag("   currency: $info{$ticker,'currency'} \n");
diag("   isodate: $info{$ticker,'isodate'} \n");
