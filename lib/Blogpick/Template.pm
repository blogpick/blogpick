package Blogpick::Template;

use Blogpick 'bp';
use HTML::Zoom;

use Moo;

sub _zoom_file {
  my ($filename) = @_;
  HTML::Zoom->from_file($filename);
}

sub _zoom_string {
  my ($string) = @_;
  HTML::Zoom->from_html($string);
}

sub render {
  my ($sself, $filename) = @_;
  _zoom_file($filename)->to_html;
}

1
__END__
