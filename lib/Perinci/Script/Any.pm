package Perinci::Script::Any;

# DATE
# VERSION

# IFUNBUILT
use strict;
use warnings;
# END IFUNBUILT

my %Opts = (
    -prefer_lite => 1,
);

sub import {
    my ($class, %args) = @_;
    $Opts{$_} = $args{$_} for keys %args;
}

sub new {
    my $class = shift;

    my @mods;
    if ($ENV{GATEWAY_INTERFACE}) {
        @mods = ('Perinci::WebScript::JSON');
    } else {
        @mods = qw(Perinci::CmdLine::Any);
    }

    for my $i (1..@mods) {
        my $mod = $mods[$i-1];
        my $modpm = $mod; $modpm =~ s!::!/!g; $modpm .= ".pm";
        if ($i == @mods) {
            require $modpm;
            return $mod->new(@_);
        } else {
            my $res;
            eval {
                require $modpm;
                $res = $mod->new(@_);
            };
            if ($@) {
                next;
            } else {
                return $res;
            }
        }
    }
}

1;
# ABSTRACT: Allow a script to be a command-line script or PSGI (CGI, FCGI)

=for Pod::Coverage ^(new)$

=head1 SYNOPSIS

In your script:

 #!/usr/bin/env perl
 use Perinci::Script::Any;
 Perinci::Script::Any->new(url => '/Package/func')->run;


=head1 DESCRIPTION

This module lets you have a script that can be a command-line script as well as
a PSGI (CGI, FCGI) script.


=head1 ENVIRONMENT


=head1 SEE ALSO

L<Perinci::CmdLine::Any>, L<Perinci::WebScript::JSON>

=cut
