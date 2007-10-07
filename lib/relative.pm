package relative;
use strict;
use Carp;
use UNIVERSAL::require;

{
    no strict "vars";
    $VERSION = '0.02';
}

=head1 NAME

relative - Load modules with relative names

=head1 VERSION

Version 0.02

=cut

sub import {
    return if @_ <= 1;  # called with no args
    my ($package, @modules) = @_;
    my ($caller) = caller();
    my @loaded = ();

    # read the optional parameters
    my %param = ();

    if (ref $modules[0] eq 'HASH') {
        %param = %{shift @modules}
    }
    elsif (ref $modules[0] eq 'ARRAY') {
        %param = @{shift @modules}
    }
    elsif ($modules[0] eq '-to') {
        shift @modules;
        %param = ( to => shift @modules );
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

        # keep a list of the loaded modules
        push @loaded, $module;
    }

    return wantarray ? @loaded : $loaded[-1]
}


=head1 SYNOPSIS

    package BigApp::Report;

    use relative qw(Create Publish);
    # loads BigApp::Report::Create, BigApp::Report::Publish

    use relative qw(..::Utils);
    # loads BigApp::Utils

    use relative -to => "Enterprise::Framework" => qw(Base Factory);
    # loads Enterprise::Framework::Base, Enterprise::Framework::Factory


=head1 DESCRIPTION

This module allows you to load modules using only parts of their name, 
relatively to the current module or to a given module. Module names are 
by default searched below the current module, but can be searched upper 
in the hierarchy using the C<..::> syntax.

In order to further loosen the namespace coupling, C<import> returns 
the full names of the loaded modules, making object-oriented code easier
to write:

    use relative;

    my ($Maker, $Publisher) = import relative qw(Create Publish);
    my $report = $Maker->new;
    my $publisher = $Publisher->new;

    my ($Base, $Factory) = import relative -to => "Enterprise::Framework"
                                => qw(Base Factory);
    my $thing = $Factory->new;


=head1 IMPORT OPTIONS

Import options can be given as an hashref or an arrayref as the first 
argument:

    # options as a hashref
    import relative { param => value, ... }  qw(Name ...);

    # options as an arrayref
    import relative [ param => value, ... ]  qw(Name ...);

In order to simplify the syntax, the following shortcut is also valid:

    import relative -to => "Another::Hierarchy" => qw(Name ...)

Only one parameter is currently supported, C<to>, which can be used to 
indicate another hierarchy to search modules inside.

C<import> will C<die> as soon as a module can't be loaded. 

C<import> returns the full names of the loaded modules when called in 
list context, or the last one when called in scalar context.


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

Thanks to Aristotle Pagaltzis, Andy Armstrong and Ken Williams 
for their suggestions and ideas.


=head1 COPYRIGHT & LICENSE

Copyright 2007 SE<eacute>bastien Aperghis-Tramoni, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

"evitaler fo dnE" # "End of relative"
