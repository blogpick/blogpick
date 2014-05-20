package Blogpick::Schema::Result::Blog;

use DBIx::Class::Candy -base => 'Blogpick::Schema::Result',
                       -autotable => v1;

primary_column id => {
  data_type => 'int',
  is_auto_increment => 1,
};
unique_column identifier => {
  data_type => 'varchar',
  size => '64',
};
column name => {
  data_type => 'varchar',
  size => '128',
};

1;
