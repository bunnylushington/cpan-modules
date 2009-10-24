package XWrap::Utility::PasswordReader;

# this is a hacked up and pared down version of jim's more
# comprehensive ReadConfig.  kevin montuori 2006-06-15

use strict;
use Crypt::RC4;
use File::Basename;
use Carp;

our $VERSION = '2.10';

sub new {
  my ($class, $directory, $environment) = @_;
  unless ($directory) {
    $! = "PasswordReader Control file directory was not set.";
    return undef;
  }
  return bless { dir => $directory,
		 env => $environment }, $class;
}

# convenience.
sub environment { my $self = shift; return $self->{env} }
sub directory   { my $self = shift; return $self->{dir} }


# name of the token file
sub control_filename { 
  my ($self, $token_name) = @_;
  my ($env, $dir) = ($self->environment, $self->directory);
  $env ||= '';
  my ($with_env, $without_env) = ("$dir/$token_name.$env", "$dir/$token_name");
  return -f $with_env ? $with_env : $without_env;
}

# a list of the available files.
sub list_files {
  my $self = shift;
  my $control_directory = $self->directory;
  opendir CTRL, $control_directory
    or croak "cannot open directory $control_directory for reading: $!";
  my @control_files = 
    sort grep { -f "$control_directory/$_"
		  and not /^\.$/ and not /^\.\.$/ } readdir CTRL;
  closedir CTRL;
  return @control_files;
}

#
# creation subroutines.
#
sub produce_config_value {
  my ($self, $file, $value) = @_;
  my $basename = basename($file);
  return 'crypt::' . RC4($basename, "$value\n");
}

#
# recovery subroutines.
#
sub read_config_value { 
  my $self = shift;
  return (scalar @_ > 1) 
    ? map { $self->first_line($_) } @_ 
    : $self->first_line(shift)
  }
     

sub first_line {
  my ($self, $token) = @_;
  my $file = $self->control_filename($token);
  unless (-e $file) { croak "tried to read $file but does not exist." }
  unless (-r _) { croak "error reading $file (exists but unreadable)." }
  
  open (my $h, '<', $file) or croak "cannot open $file for reading: $!";
  my $value = ();
  { # the encryption can introduce newlines, so do this.  
    local $/ = undef;
    $value = <$h>;
  }
  if ($value =~ /^crypt::(.*)$/s) {
    chomp(my $return =  RC4(basename($file), $1));
    return $return;
  }
  else { return $value }
}

sub value_from_filehandle {
  my ($self, $fh, $object_name) = @_;
  seek $fh, 0, 0;
  my $value = ();
  {
    local $/ = undef;
    $value = <$fh>;
  }
  if ($value =~ /^crypt::(.*)/s) {
    chomp(my $return = RC4($object_name, $1));
    return $return
  }
  else { return $value }
}


1;

__END__

=head1 NAME

  XWrap::Utility::PasswordReader -- read/write bits of information
  in configuration files.

=head1 SYNOPSIS

  use XWrap::Utility::PasswordReader;
  my $tc = XWrap::Utility::PasswordReader->new("/path/to/.control"
                                                  "environment")
    or die "couldn't create TC object: $!";


  # list the available files (presumably in control directory).
  my @config_files = $tc->list_files;

  # generate the crypted value 
  my $crypt_value = $tc->produce_config_value(filename => 'value');

  # recover the crypted value
  my $plain_text = $tc->read_config_value(filename);
  my @plain_text = $tc->read_config_value(@filenames);

=head1 NOTES

  for anything other than trivial encrypted one file/one value pairs,
  MW::ReadConfig should be used.

  there used to be a default control directory.  this worked for shit
  and has been removed.  you must provide new() with a directory and
  an environment.


=head1 AUTHOR

  original concept and MW::ReadConfig implementation by Jim Lambert.
  this trivial version hacked up by kevin montuori.
