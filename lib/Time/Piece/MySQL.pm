package Time::Piece::MySQL;

use strict;

use vars qw($VERSION);

$VERSION = '0.03';

use Time::Piece;

sub import { shift; @_ = ('Time::Piece', @_); goto &Time::Piece::import }

package Time::Piece;

use Time::Seconds;

BEGIN
{
    my $has_dst_bug =
	Time::Piece->strptime( '20000601120000', '%Y%m%d%H%M%S' )->hour != 12;
    sub HAS_DST_BUG () { $has_dst_bug }
}

sub mysql_date
{
    my $self = shift;
    my $old_sep = $self->date_separator('-');
    my $ymd = $self->ymd;
    $self->date_separator($old_sep);
    return $ymd;
}

sub mysql_time
{
    my $self = shift;
    my $old_sep = $self->time_separator(':');
    my $hms = $self->hms;
    $self->time_separator($old_sep);
    return $hms;
}

sub mysql_datetime
{
    my $self = shift;
    return join ' ', $self->mysql_date, $self->mysql_time;
}

sub from_mysql_date
{
    my $class = shift;
    return $class->strptime( shift, '%Y-%m-%d' );
}

sub from_mysql_datetime
{
    my $class = shift;
    my $time = $class->strptime( shift, '%Y-%m-%d %H:%M:%S' );
    $time -= ONE_HOUR if HAS_DST_BUG && $time->isdst;
    return $time;
}

# We force all dates into 4 digit years before parsing because MySQL
# has different 2-digit parsing rules than strptime
my %ts =
    ( 14 => '%Y%m%d%H%M%S',
      12 => '%Y%m%d%H%M%S',
      10 => '%Y%m%d%H%M',
      8  => '%Y%m%d',
      6  => '%Y%m%d',
      4  => '%Y%m',
      2  => '%Y',
    );

sub mysql_timestamp {
	my $self = shift;
	return $self->strftime('%Y%m%d%H%M%S');
}

sub from_mysql_timestamp
{
    my $class = shift;
    my $timestamp = shift;
    my $length = length $timestamp;
    my $format = $ts{$length}
	or return;
    if ( $length ne 14 &&
	 $length ne 8 )
    {
	if ( substr( $timestamp, 0, 2 ) <= 69 )
	{
	    $timestamp = "20$timestamp";
	}
	else
	{
	    $timestamp = "19$timestamp";
	}
    }
    return Time::Piece->strptime( $timestamp, $format );
}

1;

__END__

=head1 NAME

Time::Piece::MySQL - Adds MySQL-specific methods to Time::Piece

=head1 SYNOPSIS

  use Time::Piece::MySQL;

  my $time = localtime;

  print $time->mysql_datetime;
  print $time->mysql_date;
  print $time->mysql_time;

  my $time = Time::Piece->from_mysql_datetime( $mysql_datetime );
  my $time = Time::Piece->from_mysql_date( $mysql_date );
  my $time = Time::Piece->from_mysql_timestamp( $mysql_timestamp );

=head1 DESCRIPTION

Using this module instead of, or in addition to C<Time::Piece> adds a
few MySQL-specific date/time methods to C<Time::Piece> objects.

=head1 OBJECT METHODS

=over 4

=item * mysql_date

=item * mysql_time

=item * mysql_datetime

=item * mysql_timestamp

Returns the date and/or time in a format suitable for use by MySQL.

=back

=head1 CONSTRUCTORS

=over 4

=item * from_mysql_date

=item * from_mysql_datetime

=item * from_mysql_timestamp

Given a date, date/time, or timestamp as returned from MySQL, these
constructors return a new Time::Piece object.

=back

=head1 BUGS

C<Time::Piece> itself only works with times in the Unix epoch, this
module has the same limitation.  However, MySQL itself handles date
and datetime columns from '1000-01-01' to '9999-12-31'.  Feeding in
times outside of the Unix epoch to any of the constructors has
unpredictable results.

=head1 AUTHOR

Original author: Dave Rolsky <autarch@urth.org>

Current maintainer: Marty Pauley <marty+perl@kasei.com>

=head1 COPYRIGHT

(c) 2002 Dave Rolsky

(c) 2003 Marty Pauley

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Time::Piece>

=cut
