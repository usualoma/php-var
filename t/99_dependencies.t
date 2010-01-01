use ExtUtils::MakeMaker;
use Test::Dependencies
exclude => [qw(
	Test::Dependencies Test::Perl::Critic
	PHP::Var
)], style   => 'light';
ok_dependencies();
