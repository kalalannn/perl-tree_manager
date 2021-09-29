use strict;
use warnings;

use TreeManager;

my $app = TreeManager->apply_default_middlewares(TreeManager->psgi_app);
$app;

