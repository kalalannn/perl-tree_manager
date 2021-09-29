use utf8;
package TreeManager::Schema::Result::Node;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TreeManager::Schema::Result::Node

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Nodes>

=cut

__PACKAGE__->table("Nodes");

=head1 ACCESSORS

=head2 node_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 parent_node_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 depth

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "node_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "parent_node_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "path",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "depth",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</node_id>

=back

=cut

__PACKAGE__->set_primary_key("node_id");

=head1 RELATIONS

=head2 nodes

Type: has_many

Related object: L<TreeManager::Schema::Result::Node>

=cut

__PACKAGE__->has_many(
  "nodes",
  "TreeManager::Schema::Result::Node",
  { "foreign.parent_node_id" => "self.node_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent_node

Type: belongs_to

Related object: L<TreeManager::Schema::Result::Node>

=cut

__PACKAGE__->belongs_to(
  "parent_node",
  "TreeManager::Schema::Result::Node",
  { node_id => "parent_node_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-04-19 20:42:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ofQiQWMaAhzO0rExLKQ3GA

__PACKAGE__->meta->make_immutable;

1;
