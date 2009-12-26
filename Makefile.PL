use inc::Module::Install;
name 'PHP-Var';
all_from 'lib/PHP/Var.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Tie::IxHash';
auto_set_repository;
auto_include;
WriteAll;
