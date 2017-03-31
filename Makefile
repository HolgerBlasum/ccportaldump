all:
	perl update.pl

clean: cleanpdf cleantxt
	rm certified_products.csv certified_products-archived.csv pps.csv pps-archived.csv certified_products-clean.csv certified_products-archived-clean.csv pps-clean.csv pps-archived-clean.csv 

cleanpdf:
	find . -name \*.pdf -exec rm '{}' ';'

cleantxt:
	cd pp && rm -rf *.txt
	cd ppcr && rm -rf *.txt
	cd st && rm -rf *.txt
	cd stcr && rm -rf *.txt
	cd pp-archived && rm -rf *.txt
	cd ppcr-archived && rm -rf *.txt
	cd st-archived && rm -rf *.txt
	cd stcr-archived && rm -rf *.txt
