package TreeManager::Controller::Nodes;
use Moose;
use namespace::autoclean;

use Data::Dumper;

BEGIN {
    extends 'Catalyst::Controller::HTML::FormFu';
}

=head1 NAME

TreeManager::Controller::Nodes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 base

Can place common logic to start chained dispatch here

=cut

sub base :Chained('/') :PathPart('nodes') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash( resultset => $c->model('DB::Node') );

    $c->log->debug('*** BASE () ***');
}

### ###

sub node :Chained('base') PathPart('node') CaptureArgs(1) {
    my ( $self, $c, $node_id ) = @_;

    # Store the Node in stash so it's available for other methods
    $c->stash( node => $c->stash->{resultset}->find( $node_id) );

    $c->log->debug("*** NODE (node_id=${node_id}) ***");
}

sub tree_default :Chained('base') PathPart('tree') Args(1) {
    my ( $self, $c, $arg ) = @_;

    if ($arg =~ /^sql|perl$/) {
        my $root_node_id = $c->session->{root_node_id} || 1;

        $c->response->redirect($c->uri_for(
            "tree/". $root_node_id ."/manager_". $arg
        ));
    }
    else {
        my $sql_perl = $c->session->{sql_perl} || 'sql';

        $c->response->redirect($c->uri_for(
            "tree/". $arg ."/manager_". $sql_perl
        ));
    };

    $c->detach;
}

sub tree :Chained('base') PathPart('tree') CaptureArgs(1) {
    my ( $self, $c, $root_node_id ) = @_;

    # Change Session variable
    $c->session->{root_node_id} = $root_node_id;

    $c->log->debug("*** BASE TREE (root_node_id=". $c->session->{root_node_id} .") ***");
}

### ###

sub tree_sql :Chained('tree') PathPart('') CaptureArgs(0) {
    my ( $self, $c, $root_node_id ) = @_;

    # Store the Report and  in stash so it's available for other methods
    $c->stash->{resultset}->report;
    $c->stash->{resultset}->tree_sql( $c->session->{root_node_id} );

    $c->log->debug("*** TREE_SQL (root_node_id=". $c->session->{root_node_id} .") ***");
}

sub tree_perl :Chained('tree') PathPart('') CaptureArgs(0) {
    my ( $self, $c, $root_node_id ) = @_;

    $c->stash->{resultset}->tree_recursive_perl( $c->session->{root_node_id} );

    $c->log->debug("*** TREE_PERL (root_node_id=". $c->session->{root_node_id} .") ***");
}

### ###

# GET
sub manager_sql :Chained('tree_sql') PathPart('manager_sql') Args(0) FormConfig('nodes/formfu_create.yml') {
    my ( $self, $c ) = @_;

    $c->load_status_msgs;

    $c->session->{sql_perl} = 'sql';

    my @tree = $c->stash->{resultset}->{tree}->all;
    my $root_node = $tree[0];

    unless ($root_node) {
        $c->session->{root_node_id} = undef;
        $c->session->{sql_perl} = undef;
        $c->response->redirect('/default');
        $c->detach;
    };

    $c->stash( tree => \@tree, root_node => $root_node, last_depth => $root_node->depth - 1 );
    $c->stash( manager_action => 'manager_sql');
    $c->stash( sql_perl => $c->session->{sql_perl}, template => 'nodes/manager.tt2');
}

# GET
sub manager_perl :Chained('tree_perl') PathPart('manager_perl') Args(0) FormConfig('nodes/formfu_create.yml') {
    my ( $self, $c ) = @_;

    $c->load_status_msgs;

    $c->session->{sql_perl} = 'perl';

    my $tree = $c->stash->{resultset}->{tree};
    my $root_node = $c->stash->{resultset}->{root_node};

    unless ($root_node) {
        $c->session->{root_node_id} = undef;
        $c->session->{sql_perl} = undef;
        $c->response->redirect('/default');
        $c->detach;
    };

    $c->stash( tree => $tree, root_node => $root_node, last_depth => $root_node->depth - 1 );
    $c->stash( manager_action => 'manager_perl');
    $c->stash( sql_perl => $c->session->{sql_perl}, template => 'nodes/manager.tt2');
}

# POST
sub formfu_create :Chained('base') PathPart('formfu_create') Args(0) FormConfig {
    my ( $self, $c ) = @_;

    my $status;
    my $form = $c->stash->{form};

    # Check if the form has been submitted and if the data passed validation.
    # "submitted_and_valid" == ( $form->submitted && !$form->has_errors )
    if ($form->submitted_and_valid) {
        # Create a new node
        my $node = $c->model('DB::Node')->new_result({});

        # Save the form data for the node
        $form->model->update($node);

        # Set a status message
        $status = { mid => $c->set_status_msg("Node was created") };

        # For now Cache is OFF, but for future it should be.
        # $c->response->header('Cache-Control' => 'no-cache');
    }
    else {
        $status = { mid => $c->set_error_msg("Error: parent_id. Node was not created") };
    };

    # Redirect to Manager
    $c->response->redirect(
        $c->uri_for(
            "tree/". $c->session->{root_node_id} ."/manager_". $c->session->{sql_perl},
            $status,
        )
    );
    $c->detach;
}

=encoding utf8

=head1 AUTHOR

Nikolaj Vorobiev

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
