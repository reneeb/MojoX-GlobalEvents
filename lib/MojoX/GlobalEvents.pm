package MojoX::GlobalEvents;

# ABSTRACT: A module to handle events

use strict;
use warnings;

use File::Find::Rule;
use File::Spec;
use Scalar::Util qw(blessed);

use base 'Exporter';
our @EXPORT = qw(on publish);

our $VERSION = 0.01;

my %subscriber;

sub init {
    my ($class, $namespace) = @_;

    my @spaces = split /::/, $namespace;
    my @dirs   = map{ File::Spec->catdir( $_, @spaces ) }@INC; 
    my @files  = File::Find::Rule->file->name( '*.pm' )->in( @dirs );

    for my $file ( @files ) {
        require $file;
    }
}

sub on {
    my $object = shift;

    my ($event,$sub) = @_;

    if ( !blessed $object ) {
        $sub   = $event;
        $event = $object;
    }

    return if ref $event or !ref $sub or ref $sub ne 'CODE';

    my $package = "$object" || caller;
    $subscriber{$event}->{$package} = $sub;
}

sub publish {
    my ($event, @param) = @_;

    for my $package ( sort keys %{ $subscriber{$event} || {} } ) {
        $subscriber{$event}->{$package}->(@param);
    }
}


1;

=head1 SYNOPSIS

Initialize the module once:

  use MojoX::GlobalEvents;

  # load all event listeners located in "Name::Space"
  MojoX::GlobalEvents->init( 'Name::Space' );

In any Perl module:

  use MojoX::GlobalEvents;
  publish event_name => $param1, $param2;

In your event handler modules;

  use MojoX::GlobalEvents;
  on event_name => sub {
      print "received event event_name\n";
  };

or subscribe with a single object

  package Cat;
  use Mojo::Base '-base';
  use MojoX::GlobalEvents;
  
  has eyes => 2;

  package main;
  
  my $cat = Cat->new;
  $cat->on( 'sunset' => sub {
      print "even when it's dark I can see with my " . shift->eyes . " eyes\n";
  });

  publish 'sunset';

=head1 FUNCTIONS

=head2 init

=head2 on

=head2 publish
