package Google::Apps;

use warnings;
use strict;

use Carp;
use LWP::UserAgent;

use Google::Apps::Auth::ClientLogin;
use Google::Apps::API::Reporting;

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

sub auth {
    my ($self) = @_;

    $self->{auth} = Google::Apps::Auth::ClientLogin->new(ua => $self->{ua},
                                                         email => $self->{username}.'@'.$self->{domain},
                                                         password => $self->{password}) unless exists $self->{auth};

    return $self->{auth};
}

sub reporting_api {
    my ($self) = @_;

    $self->{api}->{reporting} = Google::Apps::API::Reporting->new(apps => $self) unless exists $self->{api}->{reporting};

    return $self->{api}->{reporting};
}

1;
