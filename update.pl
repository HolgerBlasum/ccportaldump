#!/usr/bin/perl

# related work: http://atsec-information-security.blogspot.de/2012/10/deep-thought-on-pps.html

use strict;

# check for existence of helper tools

foreach my $tool ('csvtool', 'wget', 'pdftotext', 'ack-grep') { 
	if (! -e "/usr/bin/$tool" and ! -e "/bin/$tool") {
		print "'sudo apt-get install $tool' to get $tool first\n";
	}
}

# get overviews
# the cleaning is needed because the input csv broken (it is not valid csv because it contains extra quotes)

if (! -e 'certified_products.csv') {
	`wget http://www.commoncriteriaportal.org/products/certified_products.csv`;
}
`ack-grep '^"([^"]*"){27}.\$' certified_products.csv > certified_products-clean.csv`;
if (! -e 'certified_products-archived.csv') {
	`wget http://www.commoncriteriaportal.org/products/certified_products-archived.csv`
}
`ack-grep '^"([^"]*"){27}.\$' certified_products-archived.csv > certified_products-archived-clean.csv`;
if (! -e 'pps.csv') {
	`wget http://www.commoncriteriaportal.org/pps/pps.csv`;
}
`ack-grep '^"([^"]*"){23}.\$' pps.csv > pps-clean.csv`;
if (! -e 'pps-archived.csv') {
	`wget http://www.commoncriteriaportal.org/pps/pps-archived.csv`;
}
`ack-grep '^"([^"]*"){23}.\$' pps-archived.csv > pps-archived-clean.csv`;

sub posix {

	my ($new) = @_;
	$new =~ s/[^.0-9A-Za-z_-]/-/g;
	$new =~ s/-+/-/g;
	$new =~ s/^-*//g;
	$new =~ s/-*$//g;
	return $new;	
}

sub update_dir { 

	my ($lines, $target) = @_;
	my $counter = 0;
	for my $url (@$lines) {
		print $url; 
		chomp $url;
		my $fn = $url;
		# filename is part after slash
		$fn =~ s/.*\///;
		# normalize filename
		# replace any %-encoded characters
		while ($fn =~ /%([A-E0-9]{2})/) {
			my $char = chr(hex($1));
			$fn =~ s/%([A-E0-9]{2})/$char/g;
		}
		# fix commoncriteriaportal (temporary?) CSV sheet bug for PP entries
		if ($target =~ "^pp") {
			$url =~ s/epfiles/ppfiles/;
		}
		# POSIX-normalize file names
		my $pfn = posix($fn);
		print "FILENAME($fn)\n";
		# download PDF
		if (!-e "$target/$pfn") {
			print "NOTEXIST($pfn)\n";
			`cd $target && wget -t 1 '$url'`;
			if ($fn ne $pfn) {
				`cd $target && mv '$fn' $pfn`;
			}
			`cd $target && pdftotext -raw $pfn && echo "done"`;
		}
		# convert to text
		if ($pfn =~ /\.pdf$/) {
			my $pfntxt = $pfn;
			$pfntxt =~ s/\.pdf$/\.txt/;	
			if (! -e "$target/$pfntxt") {
				`cd $target && pdftotext -raw $pfn\n`;		
		    }
		}		
	$counter++;
	# comment in following line for debugging
	# if ($counter > 5) {last}; 
	}
}

# update STs
my @st_lines = `csvtool col 10 certified_products-clean.csv`; 
update_dir(\@st_lines, "st");
my @stcr_lines = `csvtool col 9 certified_products-clean.csv`; 
update_dir(\@stcr_lines, "stcr");

# update archived STs
my @st_lines = `csvtool col 10 certified_products-archived-clean.csv`; 
update_dir(\@st_lines, "st-archived");
my @stcr_lines = `csvtool col 9 certified_products-archived-clean.csv`; 
update_dir(\@stcr_lines, "stcr-archived");


# update PPs 
my @pp_lines = `csvtool col 8 pps-clean.csv`; 
update_dir(\@pp_lines, "pp");
my @ppcr_lines = `csvtool col 7 pps-clean.csv`; 
update_dir(\@ppcr_lines, "ppcr");

# update archived PPs 
my @pp_lines = `csvtool col 8 pps-archived-clean.csv`; 
update_dir(\@pp_lines, "pp-archived");
my @ppcr_lines = `csvtool col 7 pps-archived-clean.csv`; 
update_dir(\@ppcr_lines, "ppcr-archived");
