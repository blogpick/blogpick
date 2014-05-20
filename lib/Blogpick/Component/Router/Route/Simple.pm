package Blogpick::Component::Router::Route::Simple;

use Moo;
with 'Blogpick::Component::Router::Route';

has route => (
  is => 'ro',
  required => 1,
);

sub matches {
  my ($self, $url) = @_;
  return $url eq $self->route;
}

1
__END__
