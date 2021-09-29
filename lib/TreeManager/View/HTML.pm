package TreeManager::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    # Set the location for TT files
    INCLUDE_PATH => [
            TreeManager->path_to( 'root', 'src' ),
            # TreeManager->path_to( 'root', 'forms' ),
        ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER              => 0,
    # Template wrapper located in the 'root/src'
    WRAPPER => 'wrapper.tt2',
);

=head1 NAME

TreeManager::View::HTML - TT View for TreeManager

=head1 DESCRIPTION

TT View for TreeManager.

=head1 SEE ALSO

L<TreeManager>

=head1 AUTHOR

Nikolaj Vorobiev

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
