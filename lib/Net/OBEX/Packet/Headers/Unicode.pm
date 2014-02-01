
package Net::OBEX::Packet::Headers::Unicode;

use strict;
use warnings;

use Carp;
use Encode qw(encode_utf8);

use base 'Net::OBEX::Packet::Headers::Base';

# VERSION

my %Header_HI_For = (
    name        => "\x01",
    description => "\x05",
);

sub new {
    my ( $class, $name, $value ) = @_;

    croak "Missing header name or HI identifier"
        unless defined $name;

    $name = $Header_HI_For{ lc $name }
        if exists $Header_HI_For{ lc $name };

    $value = ''
        unless defined $value;

    return bless {
        value  => $value,
        hi     => $name,
    }, $class;
}

sub make {
    my $self = shift;

    my $value = $self->value;
    unless ( length $value ) {
        return $self->hi . "\x00\x03";
    }

    $value = pack 'n*', unpack 'U*', encode_utf8($value);

    my $header = $self->hi; # header code
    $header .= pack 'n', 4 + length $value;
    $header .= $value . "\x00";
    return $self->header($header);
}

1;

__END__

=encoding utf8

=head1 NAME

Net::OBEX::Packet::Headers::Unicode - construct
"null terminated Unicode text" OBEX headers.

=head1 SYNOPSIS

    use strict;
    use warnings;

    use Net::OBEX::Packet::Headers::Unicode;

    my $raw = Net::OBEX::Packet::Headers::Unicode->new(
        name    => 'foos'
    )->make;

=head1 DESCRIPTION

B<WARNING!!! This module is still in alpha stage. Use it for test purposes
only as interface might change in the future>.

The module provides means to create OBEX protocol C<0x00>
(null-terminated Unicode text) packet headers.
Unless you are making a custom header you
probably want to use L<Net::OBEX::Packet::Headers> instead.

=head1 CONSTRUCTOR

=head2 new

    # "Name" header
    my $header
    = Net::OBEX::Packet::Headers::Unicode->new( name => 'foos' );

    # Custom header with HI of 0x09
    my $header
    = Net::OBEX::Packet::Headers::Unicode->new( "\x09" => 'foos' );

Constructs and returns a Net::OBEX::Packet::Headers::Unicode object.
Two arguments: first is the byte of the HI identifier of the header
and second argument is the 1 byte value of the header.
B<Note:> instead of the HI identifier byte you may use one of the names
of standard OBEX headers. The possible names you can use are as follows:

=over 10

=item name

The C<Name> header (name of the object (often a file name))

=item description

The C<Description> header (text description on an object)

=back

B<Note:> You don't need to end your value with a null byte. The module
does this automatically.

=head1 METHODS

=head2 make

    my $raw_header = $header->make;

Takes no arguments, returns a raw data of the header suitable to go down
the wire.

=head2 header

    my $raw_header = $header->header;

Must be called after a call to C<make()>. Takes no arguments,
return value is the return of C<make()>, the only difference is that
data has been "made" already.

=head2 value

    my $old_value = $header->value;

    $header->value( $new_value );

Returns the currently set header value (see C<new()> method). If
called with an optional argument will set the header value to the
value of the argument, and the following calls to C<make()> will
produce headers with this new value.

=head2 hi

    my $old_hi = $header->hi;

    $header->hi( "\x01" );

Returns the currently set header HI identifier. If
called with an optional argument will set the header HI identifier to the
value of the argument, and the following calls to C<make()> will
produce headers with this new HI.

=head1 REPOSITORY

Fork this module on GitHub:
L<https://github.com/zoffixznet/Net-OBEX>

=head1 BUGS

To report bugs or request features, please use
L<https://github.com/zoffixznet/Net-OBEX/issues>

If you can't access GitHub, you can email your request
to C<bug-Net-OBEX at rt.cpan.org>

=head1 AUTHOR

Zoffix Znet <zoffix at cpan.org>
(L<http://zoffix.com/>, L<http://haslayout.net/>)

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut