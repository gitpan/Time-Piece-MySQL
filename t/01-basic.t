use strict;

use Test;
BEGIN { plan tests => 39 };
use Time::Piece::MySQL;
ok(1); # If we made it this far, we're ok.

my $lt = localtime;
ok( UNIVERSAL::isa( $lt, 'Time::Piece' ) );

my $gmt = gmtime;
ok( UNIVERSAL::isa( $gmt, 'Time::Piece' ) );

for my $t ( $lt, $gmt )
{
    ok( $t->mysql_date, $t->ymd );

    ok( $t->mysql_time, $t->hms );

    my $mdt = join ' ', $t->ymd, $t->hms;
    ok( $t->mysql_datetime, $mdt );
}

# doesn't work right now because of some weirdness with strptime that
# Matt S will fix (I hope) some day.
my $t = Time::Piece->from_mysql_datetime( $lt->mysql_datetime );

ok( UNIVERSAL::isa( $t, 'Time::Piece' ) );

ok( $t->mysql_datetime, $lt->mysql_datetime );

my $t2 = Time::Piece->from_mysql_date( $lt->mysql_date );
ok( UNIVERSAL::isa( $t2, 'Time::Piece' ) );

ok( $t2->ymd, $lt->ymd );

{
    my $t = Time::Piece->from_mysql_timestamp(70);
    ok( $t->year, 1970 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(1202);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(120211);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
    ok( $t->day_of_month, 11 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(20120211);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
    ok( $t->day_of_month, 11 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(1202110545);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
    ok( $t->day_of_month, 11 );
    ok( $t->hour, 5 );
    ok( $t->min, 45 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(120211054537);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
    ok( $t->day_of_month, 11 );
    ok( $t->hour, 5 );
    ok( $t->min, 45 );
    ok( $t->sec, 37 );
}

{
    my $t = Time::Piece->from_mysql_timestamp(20120211054537);
    ok( $t->year, 2012 );
    ok( $t->mon, 2 );
    ok( $t->day_of_month, 11 );
    ok( $t->hour, 5 );
    ok( $t->min, 45 );
    ok( $t->sec, 37 );
}
