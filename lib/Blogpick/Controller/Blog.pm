package Blogpick::Controller::Blog;

use Blogpick 'bp';

use Moo;

sub all {
  my ($self, $req) = @_;
  Blogpick::bp->template->render('/Users/james/code/blogpick/theme/default/blog/all.html');
}

sub get {
  my ($self, $req) = @_;
  return "Hello World";
}

1
__END__
