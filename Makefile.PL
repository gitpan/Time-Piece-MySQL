use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Time::Piece::MySQL',
    'VERSION_FROM'	=> 'lib/Time/Piece/MySQL.pm',
    'PREREQ_PM'		=> { 'Time::Piece' => 1.03 },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Time/Piece/MySQL.pm', # retrieve abstract from module
       AUTHOR     => 'Dave Rolsky <autarch@urth.org>') : ()),
);
