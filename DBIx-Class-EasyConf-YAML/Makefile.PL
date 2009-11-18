use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'DBIx::Class::EasyConf::YAML',
    VERSION_FROM      => 'lib/DBIx/Class/EasyConf/YAML.pm', # finds $VERSION
    PREREQ_PM         => { DBIx::Class                              => 0,
			   DBIx::Class::InflateColumn::Object::Enum => 0,
			   YAML                                     => 0 },
    ($] >= 5.005 ?     
      (ABSTRACT_FROM  => 'lib/DBIx/Class/EasyConf/YAML.pm', 
       AUTHOR         => 'Kevin Montuori <montuori@gmail.com>') : ()),
);
