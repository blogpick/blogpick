use Test::Most;

use Blogpick 'bp';
use Test::Mech;
use Data::Dumper 'Dumper';
use Path::Tiny;
#warn Dumper bp;
my $mech = Test::Mech->new(
  app => bp->router->to_psgi,
);
my $ret = $mech->get('/');
warn Dumper $ret;
eq_or_diff($mech->get('/'),bp->template->render(path(__FILE__)->parent->parent->child('theme/default/blog/all.html')));
eq_or_diff($mech->get('/login'),"Hello World");
eq_or_diff($mech->get('/blog'),bp->template->render(path(__FILE__)->parent->parent->child('theme/default/blog/all.html')));
eq_or_diff($mech->get('/blog/foo'),"Hello World");
eq_or_diff($mech->get('/blog/foo/tag'),"Hello World");
eq_or_diff($mech->get('/blog/foo/tag/bar'),"Hello World");
eq_or_diff($mech->get('/blog/foo/tag/baz'),"Hello World");

eq_or_diff($mech->post('/login'),"Hello World");

done_testing;
