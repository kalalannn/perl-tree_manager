package TreeManager;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

=head1 Catalyst Plugins

Set flags and add plugins for the application.

Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
therefore you almost certainly want to keep ConfigLoader at the head of the
list if you're using it.

-Debug => activates the debug mode for very useful log messages

ConfigLoader => will load the configuration from a Config::General file in the
                        application's home directory

Static::Simple => will serve static files from the application's root
                        directory

Stacktrace provides powerfull Debug Output to logs.
Export your ENV DBIC_TRACE=1 to get SQL Trace.

StatusMessage is used for display messages after user actions

=cut

use Catalyst qw/
    Session
      Session::Store::File
      Session::State::Cookie
    -Debug
    ConfigLoader
    Static::Simple
    StackTrace
    StatusMessage
    URI
/;

extends 'Catalyst';

our $VERSION = '1.0';

### Default config.
__PACKAGE__->config(
    name => 'TreeManager',
        # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);

### Config from file.
__PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'treemanager.conf.pl' });

### Configure the view
__PACKAGE__->config(
    'View::HTML' => {
        # Set the location for TT files
        INCLUDE_PATH => [
            __PACKAGE__->path_to( 'root', 'src' ),
        ],
    },
);

# __PACKAGE__->config(
#     'Plugin::StatusMessage' => {
#         session_prefix          => 'my_status_msg',
#         token_param             => 'my_mid',
#         status_msg_stash_key    => 'my_status_msg',
#         error_msg_stash_key     => 'my_error_msg',
#     }
# );

### Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

TreeManager - Catalyst based application

=head1 SYNOPSIS

    script/treemanager_server.pl

=head1 DESCRIPTION

TreeManager is a Root application module. Configuration and Setup.

=head1 SEE ALSO

L<TreeManager::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Nikolaj Vorobiev

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
