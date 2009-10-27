package Google::Apps::Auth::ClientLogin;

use warnings;
use strict;

use LWP::UserAgent;
use Carp;

use base qw(Class::Accessor);
__PACKAGE__->mk_ro_accessors(qw(auth sid lsid));

sub new {
    my ($class, %args) = @_;

    my $account_type = $args{account_type} || "HOSTED",
    my $service      = $args{service}      || "apps";

    my $source = $args{source} || "";

    my $email = $args{email}  or croak "required argument 'email' not supplied";
    my $password = $args{password} or croak "required argument 'password' not supplied";

    my $ua = $args{ua} || LWP::UserAgent->new(timeout => 10, env_proxy => 1);

    my $res = $ua->post("https://www.google.com/accounts/ClientLogin",
                        accountType => $account_type,
                        service     => $service,
                        source      => $source,
                        Email       => $email,
                        Passwd      => $password);
    
    croak "ClientLogin failed: ".$res->status_line if !$res->is_success;

    my $self = {
        auth => $res->content =~ m/^Auth=(.+?)$/mg,
        sid  => $res->content =~ m/^SID=(.+?)$/mg,
        lsid => $res->content =~ m/^LSID=(.+?)$/mg,
    };

    return bless $self, $class;
}

1;
