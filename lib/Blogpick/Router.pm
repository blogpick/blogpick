package Blogpick::Component::Router;

use Blogpick::Router::Route::Simple;
use Blogpick::Router::Route::Friendly;
use Blogpick::Router::Route::Regex;

use Moo;

has routes => (
  is => 'ro',
  init_arg => undef,
  default => sub {[]},
);

sub _valid_route {
  my ($item, $rules, $kwargs) = @_;
  return 0 if $item !~ m{^/};
  my @parts = split qr{/}, $item;
  foreach my $p (@parts) {
    next unless $p;
    if ($p =~ m{^:([a-z-]+)$}) {
	}
  }
}

sub map_route {
  my ($self, $string) = @_;
  cluck("Cannot map route as it is not valid: $string")
    unless _valid_route($string);
}

sub simple {
  my ($self, $url) = @_;
  return sub {shift eq $url};
}

sub friendly {
  my ($self, $url, $rules) = @_;
  return Blogpick::Router::Route::Friendly->new($url, %$rules);;
}

sub regex {
  my ($self, $url, $names) = @_;
  return Blogpick::Router::Route::Regex->new($url, %$names);
}

1
__END__