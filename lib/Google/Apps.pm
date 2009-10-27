package Google::Apps;

use warnings;
use strict;

use Carp;
use LWP::UserAgent;

use base qw(Class::Accessor);
__PACKAGE__->mk_ro_accessors(qw(domain username password ua));

our $VERSION = '0.01';

sub new {
    my ($class, %args) = @_;

    my $self = {};

    $self->{domain}   = $args{domain}   or croak "required argument 'domain' not supplied";
    $self->{username} = $args{username} or croak "required argument 'username' not supplied";
    $self->{password} = $args{password} or croak "required argument 'password' not supplied";

    $self->{ua} = $args{ua} || LWP::UserAgent->new(timeout => 10, env_proxy => 1);

    return bless $self, $class;
}

1;
