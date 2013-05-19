package MyMojoliciousApp::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message

  #$self->param(name => 'asjkk');

  $self->render( tx => 1 );
}

1;
