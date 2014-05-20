use Test::More;
use Test::Differences;
use strictures;
use Blogpick::Component::Router;

########## ::Simple ##########

sub make_simple {
  Blogpick::Router::Route::Simple->new(path => shift);
}

my @sim = (
  make_simple('/foo'),
  make_simple('/foo/bar'),
);

ok( $sim[0]->matches('/foo'));
ok(!$sim[0]->matches('/bar'));
ok(!$sim[0]->matches('/foo/bar'));

ok( $sim[1]->matches('/foo/bar'));
ok(!$sim[1]->matches('/foo/baz'));
ok(!$sim[1]->matches('/foo'));

########## ::Friendly ##########

sub make_friendly {
  Blogpick::Router::Route::Friendly->new(path => shift, rules => shift);
}

my @fri = (
  make_friendly('/foo',{}),
  make_friendly('/foo/:bar', {}),
  make_friendly('/foo/:bar',{bar => '[0-9]+'}),
  make_friendly('/foo/:bar',{baz => '[0-9]+'}),
);

eq_or_diff({},$fri[0]->matches('/foo'));
eq_or_diff(0,$fri[0]->matches('/bar'));
eq_or_diff({bar=>'bar'}, $fri[1]->matches('/foo/bar'));
eq_or_diff({bar=>'foo'}, $fri[1]->matches('/bar/foo'));
eq_or_diff({bar=>'123'}, $fri[2]->matches('/foo/123'));
eq_or_diff(0,$fri[2]->matches('/foo/bar'));
eq_or_diff({bar=>'123'}, $fri[3]->matches('/foo/123'));
eq_or_diff({bar=>'abc'}, $fri[3]->matches('/foo/abc'));

########## ::Regex ##########

sub make_regex {
  Blogpick::Router::Route::Regex->new(path => shift, names => shift);
}

my @re = (
  make_regex('/foo'),
  make_regex('/foo/([0-9]+)','bar'),
  make_regex('/foo/(.+?)', 'bar'),
);

eq_or_diff


done_testing;
__END__
