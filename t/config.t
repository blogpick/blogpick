use Test::More;
use Test::Differences;

use Blogpick::Config;
use Path::Tiny;

my $c = Blogpick::Config->new;
my $confdir = "@{[path(__FILE__)->parent->child('configs')]}";

# This also tests that includes are working, but is not exhaustive.
# See the Config::DWIM tests for more exhaustive tests
eq_or_diff(
  $c->read_stems([$confdir.'/sample'],'include',$confdir,'r'),
  {foo => {bar =>[{qw(baz quux)}],baz => {foo => {qw(bar baz baz quux)}}}}
);

done_testing;
