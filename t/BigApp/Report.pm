package BigApp::Report;
use Test::More;

my @loaded;
my $loaded;

use_ok( relative => qw(..::Utils) );
is( $BigApp::Utils::VERSION, 3.12, 
    "checking that BigApp::Utils was actually loaded" );
@loaded = import relative qw(..::Utils);
is_deeply( \@loaded, ["BigApp::Utils"],
    "checking what import returns in list context" );
$loaded = import relative qw(..::Utils);
is( $loaded, "BigApp::Utils",
    "checking what import returns in scalar context" );

use_ok( relative => qw(Create Publish) );
is( $BigApp::Report::Create::VERSION, 2.16, 
    "checking that BigApp::Report::Create was actually loaded" );
is( $BigApp::Report::Publish::VERSION, 2.53, 
    "checking that BigApp::Report::Publish was actually loaded" );
@loaded = import relative qw(Create Publish);
is_deeply( \@loaded, ["BigApp::Report::Create", "BigApp::Report::Publish"],
    "checking what import returns in list context" );
$loaded = import relative qw(Create Publish);
is( $loaded, "BigApp::Report::Publish",
    "checking what import returns in scalar context" );

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

use_ok( relative => -to => "Enterprise::Framework" => qw(Base Factory) );
is( $Enterprise::Framework::Base::VERSION, "10.5.32.14",
    "checking that Enterprise::Framework::Base was actually loaded" );
is( $Enterprise::Framework::Factory::VERSION, "10.5.43.58",
    "checking that Enterprise::Framework::Factory was actually loaded" );
@loaded = import relative -to => "Enterprise::Framework" => qw(Base Factory);
is_deeply( \@loaded, ["Enterprise::Framework::Base", "Enterprise::Framework::Factory"],
    "checking what import returns in list context" );
$loaded = import relative -to => "Enterprise::Framework" => qw(Factory Base);
is( $loaded, "Enterprise::Framework::Base",
    "checking what import returns in scalar context" );

can_ok( $loaded, qw(new) );
my $obj = eval { $loaded->new() };
is( $@, "", "calling $loaded->new()" );
isa_ok( $obj, $loaded, "checking that \$obj" );

1
