package Excel::Writer::XLSX::Package::Table;

###############################################################################
#
# Table - A class for writing the Excel XLSX Table file.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2012, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Carp;
use Excel::Writer::XLSX::Package::XMLwriter;

our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.49';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new();

    $self->{_writer}     = undef;
    $self->{_properties} = {};

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    return unless $self->{_writer};

    $self->_write_xml_declaration;

    # Write the table element.
    $self->_write_table();

    # Write the autoFilter element.
    $self->_write_auto_filter();

    # Write the tableColumns element.
    $self->_write_table_columns();

    # Write the tableStyleInfo element.
    $self->_write_table_style_info();


    # Close the table tag.
    $self->{_writer}->endTag( 'table' );

    # Close the XML writer object and filehandle.
    $self->{_writer}->end();
    $self->{_writer}->getOutput()->close();
}


###############################################################################
#
# _set_properties()
#
# Set the document properties.
#
sub _set_properties {

    my $self       = shift;
    my $properties = shift;

    $self->{_properties} = $properties;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_xml_declaration()
#
# Write the XML declaration.
#
sub _write_xml_declaration {

    my $self       = shift;
    my $writer     = $self->{_writer};
    my $encoding   = 'UTF-8';
    my $standalone = 1;

    $writer->xmlDecl( $encoding, $standalone );
}


##############################################################################
#
# _write_table()
#
# Write the <table> element.
#
sub _write_table {

    my $self                 = shift;
    my $xmlns                = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
    my $id                   = 1;
    my $name                 = 'Table1';
    my $display_name         = 'Table1';
    my $ref                  = 'C3:F13';
    my $totals_row_shown     = 0;

    my @attributes = (
        'xmlns'              => $xmlns,
        'id'                 => $id,
        'name'               => $name,
        'displayName'        => $display_name,
        'ref'                => $ref,
        'totalsRowShown'     => $totals_row_shown,
    );

    $self->{_writer}->startTag( 'table', @attributes );
}



##############################################################################
#
# _write_auto_filter()
#
# Write the <autoFilter> element.
#
sub _write_auto_filter {

    my $self       = shift;
    my $autofilter = $self->{_properties}->{_autofilter};

    return unless $autofilter;

    my @attributes = ( 'ref' => $autofilter, );

    $self->{_writer}->emptyTag( 'autoFilter', @attributes );
}


##############################################################################
#
# _write_table_columns()
#
# Write the <tableColumns> element.
#
sub _write_table_columns {

    my $self = shift;
    my @columns = @{ $self->{_properties}->{_columns} };

    my $count = scalar @columns;

    my @attributes = ( 'count' => $count, );

    $self->{_writer}->startTag( 'tableColumns', @attributes );

    for my $col_data ( @columns ) {

        # Write the tableColumn element.
        $self->_write_table_column( @$col_data );
    }

    $self->{_writer}->endTag( 'tableColumns' );
}


##############################################################################
#
# _write_table_column()
#
# Write the <tableColumn> element.
#
sub _write_table_column {

    my $self = shift;
    my $id   = shift;
    my $name = shift;

    my @attributes = (
        'id'   => $id,
        'name' => $name,
    );

    $self->{_writer}->emptyTag( 'tableColumn', @attributes );
}



##############################################################################
#
# _write_table_style_info()
#
# Write the <tableStyleInfo> element.
#
sub _write_table_style_info {

    my $self  = shift;
    my $props = $self->{_properties};

    my $name                = $props->{_style};
    my $show_first_column   = $props->{_show_first_col};
    my $show_last_column    = $props->{_show_last_col};
    my $show_row_stripes    = $props->{_show_row_stripes};
    my $show_column_stripes = $props->{_show_col_stripes};

    my @attributes = (
        'name'              => $name,
        'showFirstColumn'   => $show_first_column,
        'showLastColumn'    => $show_last_column,
        'showRowStripes'    => $show_row_stripes,
        'showColumnStripes' => $show_column_stripes,
    );

    $self->{_writer}->emptyTag( 'tableStyleInfo', @attributes );
}



1;


__END__

=pod

=head1 NAME

Table - A class for writing the Excel XLSX Table file.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMXII, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut