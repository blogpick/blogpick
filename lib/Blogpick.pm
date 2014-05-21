package Blogpick;

# ABSTRACT: Blogpick: Blogging software that doesn't suck

my $_inst = Blogpick->new;
sub bp { $_inst; }

use Blogpick::Config;
use Blogpick::Controller;
use Blogpick::Router;
use Blogpick::Template;
use Data::Dumper 'Dumper';

use Sub::Exporter -setup => {
  exports => ['bp'],
};

use Moo;

has config => (
  is => 'ro',
  lazy => 1,
  builder => '_build_config',
);

has config_file => (
  is => 'ro',
  lazy => 1,
  default => sub {'/Users/james/code/blogpick/config'},
);

has config_include_path => (
  is => 'ro',
  lazy => 1,
  default => sub {'/Users/james/code/blogpick/includes'},
);

has conf => (
  is => 'ro',
  lazy => 1,
  builder => '_build_conf',
);

has confject => (
  is => 'ro',
  lazy => 1,
  builder => '_build_confject',
);

has router => (
  is => 'ro',
  init_arg => undef,
  lazy => 1,
  builder => '_build_router',
);

has controller => (
  is => 'ro',
  lazy => 1,
  builder => '_build_controller',
);

has template => (
  is => 'ro',
  lazy => 1,
  builder => '_build_template',
);

########## BUILDERS ##########

sub _build_config {
  return Blogpick::Config->new
}

sub _build_conf {
  my $self = shift;
  my $ret = $self->config->read_stems([$self->config_file],'include',$self->config_include_path,'r');
  $ret;
}

sub _build_confject {
  my $self = shift;
  my $ret = $self->config->_process($self->conf);
  warn "Built confject: " . Dumper $ret;
  $ret;
}

sub _build_controller {
  return Blogpick::Controller->new;
}

sub _build_router {
  return Blogpick::Router->new;
}

sub _build_template {
  return Blogpick::Template->new;
}

########## METHODS ##########

sub to_psgi {
  return shift->router->to_psgi;
}

1
__END__
