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
	serialize => sub { &php_session(\%data) },
	php_var => sub { &php_var(\%data) },
	php_var_purity => sub { &php_var('purity' => 1, \%data) },
	php_var_enclose => sub { &php_var('enclose' => 1, \%data) },
});

print("\n");

sub _tempfile {
	my $data = shift;
	my ($fh, $fn) = tempfile();
	print($fh $data);
	close($fh);
	$fn;
}

my $sess_data = &_tempfile(&php_session(\%data));
my $sess = &_tempfile(
	"<?php \$var = unserialize(file_get_contents('$sess_data')); ?>"
);

my $var_code = &_tempfile(&php_var('enclose' => 1, 'var' => \%data));
my $var = &_tempfile("<?php include('$var_code'); ?>");

my $eval_data = &_tempfile(&php_var(\%data));
my $eval = &_tempfile("<?php eval(file_get_contents('$eval_data')); ?>");

cmpthese(1_00, {
	unserialize => sub { system("php $sess") },
	code_embed => sub { system("php $var_code") },
	code_include => sub { system("php $var") },
	'eval' => sub { system("php $eval") },
});
