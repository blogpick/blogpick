package Blogpick::Component::Router;

use Carp qw(carp cluck croak confess);

{
  package Blogpick::Router::Route::Simple;
  use Moo;
  has path => (
    is => 'ro',
    required => 1,
  );
  sub matches {
    my ($self, $path) = @_;
    $path eq $self->path;
  }
  sub reverse {
    my ($self) = @_;
	return $self->path;
  }
}
{
  package Blogpick::Router::Route::Regex;
  use Moo;
  has path => (
    is => 'ro',
    required => 1,
  );
  sub matches {
	my ($self, $url) = @_;
  }
  sub reverse {
    my ($self, @placeholders) = @_;
  }
}
{
  package Blogpick::Router::Route::Friendly;
  use Moo;
  has path => (
    is => 'ro',
    required => 1,
  );
  has rules => (
    is => 'ro',
    required => 1,
  );
  sub _zip_arrayrefs_to_hashref {
	my ($keys, $values) = @_;
	my %new;
	while (@$keys && @$values) {
	  $new{(shift @$keys)} = (shift @$values);
	}
	return {%new};
  }
  sub matches {
	my ($self, $url) = @_;
	if (my @matches = ($url =~ $self->{'re'})) {
	  return _zip_arrayrefs_to_hashref($self->{'vars'},[@matches]);
	} else {
	  return 0;
	}
  }
  sub reverse {
    my ($self, @matches) = @_;
  }
  sub _decompose {
    my ($self, $url, $rules) = @_;
	my $working = $url;
	my @vars;
	my @pieces;
	while ($working) {
	  if ($working =~ s/^:([a-z-]*[a-z])//) {
		no autovivification;
		# We need to be able to identify it by name for reverse
		push @vars, $1;
		push @pieces, '(' . ($rules->{$1} || '.+?') . ')';
	  } elsif ($working =~ s/^([^:]+)//) {
		# constant, we just need to escape it as regex
		push @pieces, quotemeta($1);
	  }
	}
	my $re = join '', @pieces;
	$re = qr/$re/;
	return ($re, [@vars]);
  }
  sub BUILD {
    my $self = shift;
	my ($re, @vars) = $self->_decompose($self->path, $self->rules);
	$self->{'re'} = $re;
	$self->{'vars'} = [@vars];
  }
}
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
