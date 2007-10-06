use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'relative',
    license             => 'perl',
    AUTHOR              => 'Sébastien Aperghis-Tramoni <sebastien@aperghis.net>',
    VERSION_FROM        => 'lib/relative.pm',
    ABSTRACT_FROM       => 'lib/relative.pm',
    PREREQ_PM => {
        'UNIVERSAL::require' => 0,
        'Test::More'    => 0,
    },
    PL_FILES            => {},
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'relative-*' },
);
