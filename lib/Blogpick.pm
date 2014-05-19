
package Blogpick;

# ABSTRACT: Blogpick: Blogging software that doesn't suck

use OX;
use OX::RouteBuilder::REST;

has indexc => (
  is => 'ro',
  isa => 'Blogpick::Controller::Index',
#  lifecycle => 'singleton',
);

has authc => (
  is => 'ro',
  isa => 'Blogpick::Controller::Auth',
#   lifecycle => 'singleton',
);

has blogc => (
   is => 'ro',
  isa => 'Blogpick::Controller::Blog',
#  lifecycle => 'singleton',
);

has tagc => (
  is => 'ro',
  isa => 'Blogpick::Controller::Tag',
#  lifecycle => 'singleton',
);

has postc => (
  is => 'ro',
  isa => 'Blogpick::Controller::Post',
#  lifecycle => 'singleton',
);

my $router = router as {
  route '/' => 'REST.indexc.index';
  route '/login' => 'REST.authc.login';
  route '/blog' => 'REST.blogc.all';
  route '/blog/:blog' => 'REST.blogc.get';
  route '/blog/:blog/tag' => 'REST.tagc.all';
  route '/blog/:blog/tag/:tag' => 'REST.tagc.get';
  route '/blog/:blog/:year' => 'REST.blogc.year';
  route '/blog/:blog/:year/:slug' => 'REST.postc.get';
};

sub to_psgi_app {
  return $router;
}

sub run {
  $router->();
}

1
__END__
