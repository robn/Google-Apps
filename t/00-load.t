#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Google::Apps' );
}

diag( "Testing Google::Apps $Google::Apps::VERSION, Perl $], $^X" );
