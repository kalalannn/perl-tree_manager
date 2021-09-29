use strict;
use warnings;
use Test::More;


use Catalyst::Test 'TreeManager';
use TreeManager::Controller::Nodes;

ok( request('/nodes')->is_success, 'Request should succeed' );
done_testing();
