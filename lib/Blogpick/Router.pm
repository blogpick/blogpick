package Blogpick::Router;

use Router::Easy;

use Blogpick 'bp';

use Carp qw(carp cluck croak confess);
use Module::Load;
use Data::Dumper 'Dumper';

use Moo;

has router => (
  is => 'ro',
  init_arg => undef,
  lazy => 1,
  default => sub { Router::Easy->new; },
);

has defaults => (
  is => 'ro',
  lazy => 1,
  default => sub {+{}},
);

sub _get_action {
  my ($self, $action) = @_;
  my @pieces = split /\./, $action;
  carp("Invalid action: $action") if @pieces < 2;
  my $fun = pop @pieces;
  my $package = join("::", @pieces);
  load $package;
  no strict 'refs';
  confess("Function '$fun' does not exist in package '$package'") unless defined &{$package .'::'. $fun};
  return sub {$package->$fun(@_)};
}

sub add_from_conf {
  my ($self) = @_;
  my $default = $self->defaults;
  my $builtin = {
    style => 'friendly',
    method => 'GET',
    rules => {},
    params => {},
  };
  my @routes = @{Blogpick::bp->conf->{'routing'}->{'routes'}};
  my %new;
  foreach my $r (@routes) {
    carp("Routes are required to have a 'path' attribute (url string)") if !$r->{'path'};
    $new{path} = $r->{'path'} || $default->{'path'} || carp("Routes are required to have a 'path' attribute");
    $new{action} = $r->{'action'} || $default->{'action'} || carp("Routes are required to have an 'action' attribute");
    $new{style} = $r->{'style'} || $default->{'style'} || $builtin->{'style'};
    $new{method} = $r->{'method'} || $default->{'method'} || $builtin->{'method'};
    $new{rules} = $r->{'rules'} || $default->{'rules'} || $builtin->{'rules'};
    $new{params} = $r->{'params'} || $default->{'params'} || $builtin->{'params'};
    if ($new{style} eq 'simple') {
      $self->router->sim($new{path},$new{method}, $self->_get_action($new{action}));
    } elsif ($new{style} eq 'friendly') {
      $self->router->f($new{path},$new{method}, $new{rules}, $self->_get_action($new{action}));
    } elsif ($new{style} eq 'regex') {
      $self->router->r($new{path},$new{method}, $self->_get_action($new{action}));
    } else {
      carp("Unknown style : " . $new{style});
    }
    if ($new{params}) {
      # Okay, we shouldn't rely on the assumption of uniquity, but this will fail anyway when they try to access it
      $self->defaults->{$new{action} .":". $new{path}} = $new{params};
    }
  }
}

sub match {
  my ($self,$url,$method) = @_;
  my @matches = $self->router->match($url,$method);
}

sub default_404 {
  my ($self, $url) = @_;
  return ['404',["Content-Type: text/plain"], "404 Page Not found: $url"];
}

sub default_500 {
  my ($self, $message) = @_;
  return ['500',["Content-Type: text/plain"], "500 Internal Server Error: $message"];
}

sub to_psgi {
  my $self = shift;
  return sub {
    my $env = shift;
    my ($url, $method) = ($env->{'REQUEST_URI'}, $env->{'REQUEST_METHOD'});
    my @matches = $self->match($url,$method);
    if (!@matches) {
      @matches = $self->match('/error/404','GET');
      return $self->default_404("/error/404 (original: 404 Not Found " . $url . ")") if !@matches;
      return $self->default_500("Multiple matching routes for url: $url") if @matches != 1;
      my $newenv = {%{$env}};
      $newenv->{'REQUEST_URI'} = '/error/404';
      $newenv->{'REQUEST_METHOD'} = 'GET';
      $newenv->{'X_ORIG_REQUEST'} = $env;
      return __SUB__->($newenv);
    }
    if (@matches != 1) {
      @matches = $self->match('/error/500', 'GET');
      return $self->default_404("/error/404 (original: 500 Server Error " . $url .")") if !@matches;
      return $self->default_500("Multiple matching routes for url: /error/500 (original url: $url)") if @matches != 1;
      my $newenv = {%{$env}};
      $newenv->{'REQUEST_URI'} = '/error/500';
      $newenv->{'REQUEST_METHOD'} = 'GET';
      $newenv->{'X_ORIG_REQUEST'} = $env;
      return __SUB__->($newenv);
    }
    return $matches[0]->($env);
  }
}

sub BUILD {
  my $self = shift;
  $self->add_from_conf;
}

1
__END__
