use Test::More;
use strict;
use warnings;

use Test::WWW::Mechanize::PSGI;

use_ok 'Blogpick';

my $mech = Test::WWW::Mechanize::PSGI->new(
  app => Blogpick->to_psgi_app
);

$mech->get_ok('/');
$mech->get_ok('/login');
$mech->get_ok('/blog');
$mech->get_ok('/blog/foo');
$mech->get_ok('/blog/foo/tag');
$mech->get_ok('/blog/foo/tag/bar');
$mech->get_ok('/blog/foo/tag/baz');

$mech->post_ok('/login');

done_testing;
