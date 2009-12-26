#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'PHP::Var' );
}

diag( "Testing PHP::Var $PHP::Var::VERSION, Perl $], $^X" );
