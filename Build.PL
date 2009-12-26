use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'PHP::Var',
	license             => 'perl',
	dist_author         => q{Taku Amano <taku@toi-planning.net>},
	dist_version_from   => 'lib/PHP/Var.pm',
	build_requires => {
		'Test::More' => 0,
		'Tie::IxHash' => 0,
	},
	add_to_cleanup      => [ 'PHP-Var-*' ],
	create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
