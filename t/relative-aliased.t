#!perl -Tw
package BigApp::Report;
use strict;
use Test::More;
use lib "t";

plan tests => 6;

use_ok( "relative" );

# load modules and create aliases
my $loaded = eval { import relative -to => "Enterprise::Framework" => -aliased => qw(Factory Base) };
is( $@, "", "load modules and create aliases" );

# check that the aliases were created
can_ok( __PACKAGE__, "Base", "Factory" );

can_ok( $loaded, qw(new) );
my $obj = eval { Base()->new() };
is( $@, "", "calling Base()->new()" );
isa_ok( $obj, $loaded, "checking that \$obj" );
