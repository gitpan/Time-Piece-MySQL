use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Time::Piece::MySQL',
    VERSION_FROM => 'lib/Time/Piece/MySQL.pm',
    PREREQ_PM    => { 'Time::Piece' => 1.03, 'Test::More' => 0.47 },
    ( $] >= 5.005
    ? (    # Add these new keywords supported since 5.005
          ABSTRACT_FROM => 'lib/Time/Piece/MySQL.pm',
          AUTHOR        =>
          'Dave Rolsky <autarch@urth.org>, Marty Pauley <marty+perl@kasei.com>',
    )
    : () ),
);
