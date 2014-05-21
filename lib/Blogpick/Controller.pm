package Blogpick::Controller;

use Moo;

has index => (
  is => 'ro',
  builder => '_build_index',
);

has auth => (
  is => 'ro',
  builder => '_build_auth',
);

has blog => (
  is => 'ro',
  builder => '_build_blog',
);

has tag => (
  is => 'ro',
  builder => '_build_tag',
);

has post => (
  is => 'ro',
  builder => '_build_post',
);

########## BUILDERS ##########
{
  use Blogpick::Controller::Auth;
  sub _build_auth {
	return Blogpick::Controller::Auth->new;
  }
}
{
  use Blogpick::Controller::Blog;
  sub _build_blog {
	return Blogpick::Controller::Blog->new;
  }
}
{
  use Blogpick::Controller::Tag;
  sub _build_tag {
	return Blogpick::Controller::Tag->new;
  }
}
{
  use Blogpick::Controller::Post;
  sub _build_post {
	return Blogpick::Controller::Post->new;
  }
}

sub dispatch_request {
  my $self = bp->controller;
  'GET + /' => sub {$self->index->index(@_)},
  'GET + /blog' => sub {$self->blog->all(@_);},
  'GET + /blog/*' => sub {$self->blog->all(@_);},
  'GET + /blog/*/tag' => sub {$self->tag->all(@_);},
  'GET + /blog/*/tag/*' => sub {$self->tag->get(@_);},
  'GET + /blog/*/*' => sub {$self->blog->year(@_);},
  'GET + /blog/*/*/*' => sub {$self->blog->get(@_);},
  'GET + /login' => sub {$self->auth->login_GET(@_);},
  'POST + /login' => sub {$self->auth->login_POST(@_);},
};

sub run {
  my $self = shift;
  Blogpick::Controller->to_app->(@_);
}
########## Getting things off my back ##########

sub to_app {
  sub {}
}


1
__END__
