use ExtUtils::MakeMaker;
use Test::Dependencies
exclude => [qw(
	Test::Dependencies Test::Base Test::Perl::Critic
	PHP::Var
)], style   => 'light';
ok_dependencies();
