use strict;

use Test::More tests => 46;
use Time::Piece::MySQL;
ok(1, "loaded");

my $lt = localtime;
isa_ok( $lt, 'Time::Piece' );

my $gmt = gmtime;
isa_ok( $gmt, 'Time::Piece' );

for my $t ( $lt, $gmt )
{
    is( $t->mysql_date, $t->ymd );

    is( $t->mysql_time, $t->hms );

    my $mdt = join ' ', $t->ymd, $t->hms;
    is( $t->mysql_datetime, $mdt );
}

# doesn't work right now because of some weirdness with strptime that
# Matt S will fix (I hope) some day.
my $t = Time::Piece->from_mysql_datetime( $lt->mysql_datetime );

isa_ok( $t, 'Time::Piece' );

is( $t->mysql_datetime, $lt->mysql_datetime );

my $t2 = Time::Piece->from_mysql_date( $lt->mysql_date );
isa_ok( $t2, 'Time::Piece' );

is( $t2->ymd, $lt->ymd );

{
    my $t = Time::Piece->from_mysql_timestamp('70');
    is( $t->year, 1970 );
    is( $t->mysql_timestamp, '19700101000000' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('1202');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->mysql_timestamp, '20120201000000' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('120211');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->day_of_month, 11 );
    is( $t->mysql_timestamp, '20120211000000' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('20120211');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->day_of_month, 11 );
    is( $t->mysql_timestamp, '20120211000000' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('1202110545');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->day_of_month, 11 );
    is( $t->hour, 5 );
    is( $t->min, 45 );
    is( $t->mysql_timestamp, '20120211054500' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('120211054537');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->day_of_month, 11 );
    is( $t->hour, 5 );
    is( $t->min, 45 );
    is( $t->sec, 37 );
    is( $t->mysql_timestamp, '20120211054537' );
}

{
    my $t = Time::Piece->from_mysql_timestamp('20120211054537');
    is( $t->year, 2012 );
    is( $t->mon, 2 );
    is( $t->day_of_month, 11 );
    is( $t->hour, 5 );
    is( $t->min, 45 );
    is( $t->sec, 37 );
    is( $t->mysql_timestamp, '20120211054537' );
}
