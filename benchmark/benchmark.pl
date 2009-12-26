#!/usr/bin/perl

use strict;
use warnings;

use File::Temp qw/ tempfile /;

use PHP::Var;
use PHP::Session::Serializer::PHP;
my $serializer = PHP::Session::Serializer::PHP->new;

use Benchmark qw(cmpthese);

my %data = ();
foreach my $k1 ('a' .. 'z') {
	$data{$k1} = {};
	foreach my $k2 (1 .. 10) {
		$data{$k1}{$k2} = [
		'a' x 1000, 'b' x 1000, '"' x 20, "'" x 20, '\\' x 20,
		],
	}
}

sub php_session {
	my $enc = $serializer->encode(@_);
}

sub php_var {
	my $enc = PHP::Var::export(@_);
}

cmpthese(1_00, {
	pnp_session => sub { &php_session(\%data) },
	php_var => sub { &php_var(\%data) },
	php_var_purity => sub { &php_var('purity' => 1, \%data) },
	php_var_enclose => sub { &php_var('enclose' => 1, \%data) },
});

my ($sess_fh, $sess_fn) = tempfile();
print($sess_fh "<?php \$var = unserialize(<<<__EOD__\n" . &php_session(\%data) . "\n__EOD__\n);");
close($sess_fh);

my ($var_fh, $var_fn) = tempfile();
print($var_fh &php_var('enclose' => 1, 'var' => \%data));
close($var_fh);

cmpthese(1_00, {
	unserialize => sub { system("php $sess_fn") },
	code => sub { system("php $var_fn") },
});
