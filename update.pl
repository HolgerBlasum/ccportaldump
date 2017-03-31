#!/usr/bin/perl

# related work: http://atsec-information-security.blogspot.de/2012/10/deep-thought-on-pps.html

use strict;

# check for existence of helper tools

foreach my $tool ('csvtool', 'wget', 'pdftotext', 'grep') { 
	if (! -e "/usr/bin/$tool" and ! -e "/bin/$tool") {
		print "'sudo apt-get install $tool' to get $tool first\n";
	}
}

# get overviews
# the cleaning is needed because the input csv broken (it is not valid csv because it contains extra quotes)

if (! -e 'certified_products.csv') {
	`wget http://www.commoncriteriaportal.org/products/certified_products.csv`;
}
`iconv -c certified_products.csv | grep -E  '^"([^"]*"){27}.\$' > certified_products-clean.csv`;
if (! -e 'certified_products-archived.csv') {
	`wget http://www.commoncriteriaportal.org/products/certified_products-archived.csv`
}
`iconv -c certified_products-archived.csv | grep -E  '^"([^"]*"){27}.\$' > certified_products-archived-clean.csv`;
if (! -e 'pps.csv') {
	`wget http://www.commoncriteriaportal.org/pps/pps.csv`;
}
`iconv -c pps.csv | grep -E  '^"([^"]*"){23}.\$' > pps-clean.csv`;
if (! -e 'pps-archived.csv') {
	`wget http://www.commoncriteriaportal.org/pps/pps-archived.csv`;
}
`iconv -c pps-archived.csv | grep -E  '^"([^"]*"){23}.\$' > pps-archived-clean.csv`;

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
		# normalize URL
		$fn =~ s/.*\///;
		$fn =~ s/%20/ /g;
		# fix commoncriteriaportal (temporary?) CSV sheet bug
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