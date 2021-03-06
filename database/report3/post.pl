#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use DBI;
use feature qw( say );
use Time::HiRes qw( usleep gettimeofday tv_interval );

die "Use:$0 arg2 for username  pass" if(@ARGV != 2);

my $dbh = DBI->connect("DBI:mysql:exam2","$ARGV[0]","$ARGV[1]",
    {
        PrintError => 0,
        AutoCommit => 0
    });

while (1) {
    
    my $sql=<STDIN>;
    chomp $sql;

    my $number=<STDIN>;
    chomp $number;
    &queryDo($dbh,$sql,$number);
    
}

$dbh->disconnect;


sub queryDo {
    my($dbh,$query,$number) = @_;
    say($query);

    my $sth = $dbh->prepare($query);

    my $result = 0;

    for(1..$number){

        my $t0 = [gettimeofday];

        $sth->execute;

        my $elapsed = tv_interval($t0);

        say(int($elapsed * 1000),"ms");

        $result +=(int($elapsed * 1000));
    }
    say("Result for",$result/($number),"ms");
    $sth->finish;
    say("-----------------------");
}
