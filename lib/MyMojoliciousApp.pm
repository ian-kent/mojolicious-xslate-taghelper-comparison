package MyMojoliciousApp;
use Mojo::Base 'Mojolicious';
use Text::Xslate qw/ mark_raw /;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;

  # Use Xslate templates
  $self->{xsc} = {
    begin => [],
    end => [],
  };
  $self->plugin('xslate_renderer' => {
    template_options => {
      syntax => 'Kolon',
      function => {
        form_for => sub {
            my %args = @_;
            push $self->{xsc}{begin}, mark_raw("<form action=\"" . $args{url} . "\" method=\"" . $args{method} . "\">");
            push $self->{xsc}{end}, mark_raw("</form>");
            return;
        },
        ctx => sub {
            my $ctx = shift;
            $self->{xsc}->{ctx} = $ctx;
            return '';
        },
        begin => sub {
            return pop$self->{xsc}{begin};
        },
        end => sub {
            return pop $self->{xsc}{end};
        },
        text_field => sub {
use Data::Dumper;
#print Dumper $self->{xsc}->{ctx};
            my %args = @_;
            my $name = $args{name} // '';
print "Getting value for name '$name'\n";
            my $value = $self->{xsc}->{ctx}->param($name) // '';
print "Value is: $value\n";
            return mark_raw("<input type=\"text\" name=\"$name\" value=\"$value\" />");
        },
        submit_button => sub {
            my %args = @_;
            my $name = $args{name} // '';
            my $value = $args{text} // 'Submit';
            return mark_raw("<input type=\"submit\" name=\"$name\" value=\"$value\" />");
        },
      }
    }
  });

  # Normal route to controller
  $r->any('/')->to('example#welcome');
}

1;
