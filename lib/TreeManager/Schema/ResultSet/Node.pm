use utf8;
package TreeManager::Schema::ResultSet::Node;

use strict;
use warnings;

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;

use List::MoreUtils qw{ first_index };

extends 'DBIx::Class::ResultSet';

use DBIx::Class::Report;

use Data::Dumper; $Data::Dumper::Indent = 1;

# my $resultset = $self->{report}->fetch( $root_node_id );
sub report {
    my ( $self ) = @_;

    my $sql = <<'SQL';
    WITH RECURSIVE Tree (node_id, parent_node_id, path, depth) AS (
        SELECT *
            FROM Nodes
            WHERE node_id = ?
      UNION ALL
        SELECT n.*
            FROM Tree AS t
                JOIN Nodes AS n
            WHERE n.parent_node_id = t.node_id
    ) 
    SELECT node_id, parent_node_id, path, depth FROM Tree
SQL
    
    $self->{report} = DBIx::Class::Report->new(
        schema  => $self->result_source->schema,
        sql     => $sql,
        columns => [
            "node_id"           => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
            "parent_node_id"    => { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
            "path"              => { data_type => "varchar", is_nullable => 1, size => 256 },
            "depth"             => { data_type => "integer", is_nullable => 1 },
        ],
        methods => {
            # show => sub {
            #     my $self = shift;
            #     return "[ $self->path ]";
            # },
            # show_root => sub {
            #     my $self = shift;
            #     return "<b>[ $self->path ]</b>";
            # }
            parent => sub {
                my $self = shift;
                # warn Dumper $self;
                return $self->result_source->schema->resultset('Node')->find( { node_id => $self->parent_node_id } );
            },
            children => sub {
                my $self = shift;
                # warn Dumper $self;
                return $self->result_source->schema->resultset('Node')->find( { parent_node_id => $self->node_id } );
            },
        }
    );
    
};

sub tree_sql {
    my ( $self, $root_node_id ) = @_;

    $self->{tree} = $self->{report}->fetch( $root_node_id );
}

sub _tree_depth_path {
    my ( $self ) = @_;

    return [ $self->all ];

    ### Here could be Perl Code for this SQL
    # SET NEW.path = CONCAT(
    #     IFNULL(
    #         (SELECT path FROM Nodes WHERE node_id = NEW.parent_node_id),
    #         'R'
    #     ),
    #     '.',
    #     future_node_id
    # );
    # SET NEW.depth = substr_count(NEW.path, '.');

=cc
    my @ret;

    my $parent_node;
    my $parent_path, $node_path;
    my $depth, $path;
    while ( my ( $i, $node ) = each $self->{tree}->all ) {
        # Root
        if ($i == 0) {
            $parent_node = $node;

            $depth = $node->depth;

            # IF IS NULL
            unless ($node->parent_node_id) {
                $path .= "R.${node_id}";
            } # SubRoot
            else {
                $path .= "..Sr.${node_id}";
            };
        } # Children
        else {
            my $_node_path = "\.$node->node_id";

            # Still this parent
            if ($node->parent_node_id == $parent_node->node_id) {
                $path =~ s/${node_path}$/${_node_path}/;
            }
            else {
                my $_parent_node_path = "\.$node->parent_node_id";

                $path =~ s/${parent_node_path}${node_path}$/${_node_path}/;

                $depth++;
            };
        };
    };
=cut
}

### Related pages ###
# https://metacpan.org/pod/DBIx::Class::ResultSet#Custom-ResultSet-classes
# https://stackoverflow.com/questions/192220/what-is-the-most-efficient-elegant-way-to-parse-a-flat-table-into-a-tree/

=head1 tree_recursive_perl

This method gets and returns tree(Hashref).

tree contains root, children and metadata.

This method could be used, but it is slow because of inner recursion.

See also: tree_sql method

=cut

sub tree_recursive_perl {
    my ($self, $root_node_id) = @_;

    $self->root_node($root_node_id);
    $self->children([ $root_node_id ], 1);

    # $self->_tree_meta;

    $self->{tree} = [ $self->{root_node}, @{ $self->{children} } ];
        # meta => $self->{meta},
}

=head1 root_node

Set Tree Root Node

=cut

sub root_node {
    my $self = shift;
    my ($root_node_id) = @_;

    $self->{root_node} = $self->search( { node_id => $root_node_id } )->first;
}

=head1 children

    This method gets and
        returns Arrayref of Children Nodes for Root Nodes,
            defined in Arrayref $root_node_ids
            ordered by parent_node_id, node_id

    Root:   1|
    Children [:
        2| 2| 2| 2|
      3| 3| 3| 3| 3| 3|
    ]

    B<root_node_ids> Array of node_ids

    B<recursive> Will get all InnerNodes->...->OuterNodes Nodes recursive. Default: false.

    <B>depth_limit Limit to recursive option. Default: 50. Could not be undefined.

=cut

sub children {
    my $self = shift;

    $self->{children} = $self->_children(@_);
};

sub _children {
    my ($self, $root_node_ids, $recursive, $depth_limit) = @_;

    # OuterNode
    return [] if @{ $root_node_ids } == 0;

    # Default Depth limit
    $depth_limit = 50 unless defined $depth_limit;

    # Depth limit
    return [] if $depth_limit == 0;

    # Get Children Nodes
    my @children;
    for my $root_node_id (@{ $root_node_ids }) {
        push @children,
            $self->search(
                { parent_node_id => $root_node_id },
                { order_by => { -asc => [qw { node_id } ] } },
            )->all;
    };

    # Recursive option
    if ($recursive) {
        my @child_node_ids = map { $_->node_id } @children;
        push @children, @{ $self->_children( \@child_node_ids, 1, $depth_limit-- ) };
    };

    return \@children;
}

### This is some old method, not used now
sub _tree_meta {
    my ($self, $by) = @_;

    $by |= 'depth';

    my %meta = (
        min_depth => $self->{root}->depth + 1,
        max_depth => $self->{children}->[-1]->depth,
        infos => [],
    );

    for my $child ( @{ $self->{children} } ) {

        my $info_index = first_index { $_->{depth} == $child->depth }
                            @{ $meta{infos} };

        if ($info_index == -1) {
            push @{ $meta{infos} },
              {
                depth => $child->depth,
                parents => [ ],
              };
            $info_index = @{ $meta{infos} } -1;
        };

        my $parents_index = first_index { $_->{parent_node_id} == $child->parent_node_id }
                                @{ $meta{infos}->[$info_index]->{parents} };

        if ($parents_index == -1) {
            push @{ $meta{infos}->[$info_index]->{parents} },
              {
                parent_node_id => $child->parent_node_id,
                count => 1,
              };
        }
        else {
            $meta{infos}->[$info_index]->{parents}->[$parents_index]->{count} += 1;
        };
    }

    for my $info_index ( 0 .. @{ $meta{infos} } -1 ) {

        # Looking for max
        $meta{infos}->[$info_index]->{max} = (sort { $a->{count} <=> $b->{count} }
                                                    @{ $meta{infos}->[$info_index]->{parents} }
                                    )[-1]->{count};
    };

    $self->{meta} = \%meta;
}

__PACKAGE__->meta->make_immutable;

1;