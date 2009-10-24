package Catalyst::Log::WithDumper;

our $VERSION = '0.10';
use strict;
use base 'Catalyst::Log';

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

sub dumper {
  my ($self, $var, $label) = @_;
  local $Data::Dumper::Varname = $label if defined $label;
  $self->debug( Dumper($var) );
}

1;  


=head1 NAME

Catalyst::Log::WithDumper - Catalyst::Log subclass.

=head1 METHODS

=head2 dumper(var, [label])

Dumps (with Data::Dumper) the variable specified to the debug log,
appending the optional label if specified.

=head1 NOTE

This module is a replacement for Catalyst::Plugin::Dumper which,
perhaps rightly (it injected a dumper method into another module's
namespace), was depracated.

=head1 AUTHOR

kevin montuori <montuori@brandeis.edu>
