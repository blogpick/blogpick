use Test::More;
use Test::Differences;
use strictures;
use Blogpick::Router;

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
  make_friendly('/foo/:baz',{bar => '[0-9]+'}),
);

eq_or_diff($fri[0]->matches('/foo'), {});
eq_or_diff($fri[0]->matches('/bar'), undef);
eq_or_diff($fri[1]->matches('/foo/bar'), {bar => 'bar'});
eq_or_diff($fri[1]->matches('/bar/foo'), undef);
eq_or_diff($fri[2]->matches('/foo/123'), {bar => '123'});
eq_or_diff($fri[2]->matches('/foo/456'), {bar => '456'});
eq_or_diff($fri[2]->matches('/foo/bar'), undef);
eq_or_diff($fri[3]->matches('/foo/123'), {baz => '123'});
eq_or_diff($fri[3]->matches('/foo/abc'), {baz => 'abc'});
like('/foo/abc', $fri[3]->re);
eq_or_diff($fri[3]->matches('/foo/abc'), {baz => 'abc'});

########## ::Regex ##########

sub make_regex {
  Blogpick::Router::Route::Regex->new(path => shift, names => shift);
}

my @re = (
  make_regex('/foo'),
  make_regex('/foo/(?<bar>[0-9]+)'),
  make_regex('/foo/(?<bar>[^\/]+)/(?<baz>[0-9]+)'),
);

eq_or_diff($re[0]->matches('/foo'), {});
eq_or_diff($re[0]->matches('/bar'), undef);
eq_or_diff($re[1]->matches('/foo/123'), {bar => 123});
eq_or_diff($re[1]->matches('/foo/abc'), undef);
eq_or_diff($re[2]->matches('/foo/abc/123'), {bar => 'abc', baz => '123'});
eq_or_diff($re[2]->matches('/foo/abc/def'), undef);

done_testing;
__END__
