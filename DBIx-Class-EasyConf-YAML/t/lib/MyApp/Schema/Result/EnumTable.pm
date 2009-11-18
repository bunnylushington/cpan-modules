package MyApp::Schema::Result::EnumTable;

use strict;
use parent qw[ DBIx::Class::Core ];
__PACKAGE__->load_components(qw[ EasyConf::YAML 
				 InflateColumn::Object::Enum ]);
our $DDL ||= __PACKAGE__->configure;


1;

__DATA__
--->
=head1 NAME

MyApp::Schema::Result::EnumTable - Test Enumeration

=head1 DESCRIPTION
---
  table: enum_table
  primary_key: id
  columns:
    id:
      type: int
      nullable: 0
      is_auto_increment: 1
    name:
      type: VARCHAR
      size: 16
      nullable: 0
    description:
      type: VARCHAR
      size: 128
      nullable: 1
    usertype:
      data_type:      VARCHAR
      is_nullable:    0
      size:           128
      is_enum:        1
      extra:
        list:
          - student
          - assistant
          - teacher
          - administrator
          - operator




# EndOfYAML
