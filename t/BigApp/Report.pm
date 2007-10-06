package BigApp::Report;
use Test::More;

use_ok( relative => qw(..::Utils) );
is( $BigApp::Utils::VERSION, 3.12, 
    "checking that BigApp::Utils was actually loaded" );

use_ok( relative => qw(Create Publish) );
is( $BigApp::Report::Create::VERSION, 2.16, 
    "checking that BigApp::Report::Create was actually loaded" );
is( $BigApp::Report::Publish::VERSION, 2.53, 
    "checking that BigApp::Report::Publish was actually loaded" );

can_ok( "BigApp::Report::Create", qw(new_report) );
can_ok( __PACKAGE__, qw(new_report) );
my $report = eval { new_report() };
is( $@, "", "calling new_report()" );
isa_ok( $report, "BigApp::Report::Create", "checking that \$report" );

can_ok( "BigApp::Report::Publish", qw(render) );
can_ok( __PACKAGE__, qw(render) );
my $r = eval { render($report) };
is( $@, "", "calling render()" );
is( $r, 1, "checking result code" );

use_ok( relative => to => "Enterprise::Framework" => qw(Base Factory) );
is( $Enterprise::Framework::Base::VERSION, "10.5.32.14",
    "checking that Enterprise::Framework::Base was actually loaded" );
is( $Enterprise::Framework::Factory::VERSION, "10.5.43.58",
    "checking that Enterprise::Framework::Factory was actually loaded" );

can_ok( "Enterprise::Framework::Base", qw(new) );
my $obj = eval { Enterprise::Framework::Base->new() };
is( $@, "", "calling Enterprise::Framework::Base->new()" );
isa_ok( $obj, "Enterprise::Framework::Base", "checking that \$obj" );

1
