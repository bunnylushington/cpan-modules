use 5.010001;
use ExtUtils::MakeMaker;

WriteMakefile
  (
   NAME              => 'XWrap::Utility::PasswordReader',
   VERSION_FROM      => 'lib/XWrap/Utility/PasswordReader.pm',
   PREREQ_PM         => { Crypt::RC4 => 0 }, 
   EXE_FILES         => [ 'bin/pwread', 'bin/pwwrite' ],

   ($] >= 5.005 ?     
    (AUTHOR         => 'Kevin Montuori <montuori@gmail.com>') : ()),
);
