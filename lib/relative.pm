package relative;
use strict;
use Carp;
use UNIVERSAL::require;

{
    no strict "vars";
    $VERSION = '0.01';
}

=head1 NAME

relative - Load modules with relative names

=head1 VERSION

Version 0.01

=cut

sub import {
    return if @_ <= 1;  # called with no args
    my ($package, @modules) = @_;
    my ($caller) = caller();

    # read the optional parameters
    my %param = ();

    if (ref $modules[0] eq 'HASH') {
        %param = %{shift @modules}
    }
    elsif (ref $modules[0] eq 'ARRAY') {
        %param = @{shift @modules}
    }
    elsif ($modules[0] eq 'to') {
        %param = ( shift(@modules) => shift @modules )
    }

    # determine the base name
    my $base = exists $param{to} ? $param{to} : $caller;

    # load the modules
    for my $relname (@modules) {
        # resolve the module relative name to absolute name
        my $module = "$base\::$relname";
        1 while $module =~ s/::\w+::..::/::/g;
        $module =~ s/^:://;

        # load the module, die if it failed
        $module->require;
        croak $@ if $@;

        # import the symbols from the loaded module into the caller module
        eval qq{ package $caller; $module->import };
    }
}


=head1 SYNOPSIS

    package BigApp::Report;

    use relative qw(Create Publish);
    # loads BigApp::Report::Create, BigApp::Report::Publish

    use relative qw(..::Utils);
    # loads BigApp::Utils

    use relative to => "Enterprise::Framework" => qw(Base Factory);
    # loads Enterprise::Framework:Base, Enterprise::Framework::Factory


=head1 DESCRIPTION

This module allows you to load modules using only parts of their name, 
relatively to the caller module. Module names are by default searched 
below the current module, but can be searched upper in the hierarchy
using the C<..::> syntax.


=head1 IMPORT OPTIONS

Import options can be given as an hashref or an arrayref as the first 
argument:

    # options as a hashref
    use relative { param => value, ... }  qw(Name ...);

    # options as an arrayref
    use relative [ param => value, ... ]  qw(Name ...);

In order to simplify the syntax, the following shortcut is also valid:

    use relative to => "Another::Hierarchy" => qw(Name ...)

Only one parameter is currently supported, C<to>, which can be used to 
indicate another hierarchy to search modules inside.


=head1 AUTHOR

SE<eacute>bastien Aperghis-Tramoni, C<< <sebastien at aperghis.net> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-relative at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=relative>.
I will be notified, and then you'll automatically be notified of progress 
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc relative

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/relative>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/relative>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=relative>

=item * Search CPAN

L<http://search.cpan.org/dist/relative>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to Aristotle Pagaltzis and Andy Armstrong for their advice.


=head1 COPYRIGHT & LICENSE

Copyright 2007 SE<eacute>bastien Aperghis-Tramoni, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

"evitaler fo dnE" # "End of relative"
