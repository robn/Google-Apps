use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Google::Apps',
    AUTHOR              => q{Robert Norris <rob@cataclysm.cx>},
    VERSION_FROM        => 'lib/Google/Apps.pm',
    ABSTRACT_FROM       => 'lib/Google/Apps.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Class::Accessor' => 0,
        'LWP::UserAgent' => 0,
        'XML::Spice' => 0,
        'Text::CSV' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Google-Apps-*' },
);
