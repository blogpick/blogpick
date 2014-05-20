package Blogpick::Config;

use Moo;
use Config::DWIM;

sub _dwim {
  my ($key, $path, $merger) = @_;
  Config::DWIM->new(
    include_key => $key,
    include_path => $path,
    include_merger => $merger
  );
}

sub read_stems {
  my ($self, $file_stems, $key, $path, $merger) = @_;
  _dwim($key,$path,$merger)->read_stems(@$file_stems);
}

sub process {
  my ($self, $file_stems, $key, $path, $merger) = @_;
  my $config = $self->read_stems($file_stems, $key, $path, $merger);
  $self->_process($config);
}

sub _process {
  my ($self, $config) = @_;
  Config::DWIM->_process($config);
}

1
__END__
