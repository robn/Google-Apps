package Google::Apps::API::Reporting;

use warnings;
use strict;

use Carp;
use POSIX qw(strftime);
use XML::Spice qw(rest type token domain date page reportType reportName);
use Text::CSV;

sub new {
    my ($class, %args) = @_;

    my $self = {};

    $self->{apps} = $args{apps} or croak "required argument 'apps' not supplied";

    return bless $self, $class;
}

sub report_csv {
    my ($self, %args) = @_;

    my $name = $args{name} or croak "required argument 'name' not supplied";
    my $date = $args{date} || strftime("%Y-%m-%d", localtime(time - 86400));
    my $page = $args{page} || 1;

    my $auth = $self->{apps}->auth;

    my $xml = 
        q{<?xml version="1.0" encoding="UTF-8"?>} .
        rest({ xmlns => "google:accounts:rest:protocol" },
            type("Report"),
            token($auth->sid),
            domain($self->{apps}->domain),
            reportName($name),
            reportType("daily"),
            date($date),
            page($page),
        );

    my $res = $self->{apps}->ua->post("https://www.google.com/hosted/services/v1.0/reports/ReportingData", Content => $xml);

    return $res->content if $res->is_success;

    die "XXX error bad bad bad";
}

sub report_hash {
    my ($self, %args) = @_;

    my $csv = $self->report_csv(%args);

    my $c = Text::CSV->new;

    my @report;

    my @header;
    while ($csv =~ m/\G\s*^(.*?)$/mgc) {
        $c->parse($1);
        if (!@header) {
            @header = $c->fields;
            next;
        }

        my %row;
        @row{@header} = $c->fields;
        push @report, \%row;
    }

    return \@report;
}

1;
