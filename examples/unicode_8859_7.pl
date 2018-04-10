#!/usr/bin/perl

##############################################################################
#
# A simple example of converting some Unicode text to an Excel file using
# Excel::Writer::XLSX.
#
# This example generates some Greek from a file with ISO-8859-7 encoded text.
#
#
# reverse ('(c)'), September 2004, John McNamara, jmcnamara@cpan.org
#

use strict;
use warnings;
use Excel::Writer::XLSX;


my $workbook = Excel::Writer::XLSX->new( 'unicode_8859_7.xlsx' );

die "Couldn't create new Excel file: $!.\n" unless defined $workbook;

my $worksheet = $workbook->add_worksheet();
$worksheet->set_column( 'A:A', 50 );


my $file = 'unicode_8859_7.txt';

open FH, '<:encoding(iso-8859-7)', $file or die "Couldn't open $file: $!\n";

my $row = 0;

while ( <FH> ) {
    next if /^#/;    # Ignore the comments in the sample file.
    chomp;
    $worksheet->write( $row++, 0, $_ );
}

$workbook->close();

__END__

