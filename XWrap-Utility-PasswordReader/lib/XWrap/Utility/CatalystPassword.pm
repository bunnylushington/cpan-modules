package XWrap::Utility::CatalystPassword;

use strict;
use XWrap::Utility::PasswordReader;

sub password_substitution {
  my ($class, $ctl_file) = @_;
  my $file = $class->path_to('') . "/.control/$ctl_file";
  my ($env, $user) = ($XWrap::ENV, $ENV{USER});
  
  if ($env and -e "${file}.$env") {
    $file = "${file}.$env";
    $ctl_file = "${ctl_file}.$env";
  }
  elsif ($user and -e "${file}.$user") {
    $file = "${file}.$user";
    $ctl_file = "${ctl_file}.$user";
  }

  my $reader = XWrap::Utility::PasswordReader->new('/dev/null');
  open my $fh, '<', $file or return '';
  $reader->value_from_filehandle($fh, $ctl_file);
}
				   

1;
