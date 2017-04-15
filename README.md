# ccportaldump
Create dump of STs and CCs at commoncriteriaportal.org

Note: this is a script that creates a dump, *not* the dump itself,
hence folder structure below is intentionally empty on checkout.
Run "make" to populate it.

Might be useful for answering question such as: "who else uses FRU\_RSA.2?".

* Makefile <- what you can do to update the collection (invoking update.pl or 
	doing clean-ups)
* pp <- (initially empty) folder for protection profiles
* ppcr <- (initially empty) folder for protection profile certification reports 
* st <- (initially empty) folder for security targets
* stcr <- (initially empty) folder for security target certification reports
* pp-archived <- (initially empty) folder for legacy protection profiles
* ppcr-archived <- (initially empty) folder for legacy protection profile certification reports 
* st-archived <- (initially empty) folder for legacy security targets
* stcr-archived <- (initially empty) folder for legacy security target certification reports

Note: the total number of downloaded files will be somewhat lower (as of 2017: about 25%) than the number of lines in the csv, this is mostly due to that the same ST/PP may occur multiple times in the csv (e.g. multiple product classes).

The default mode of "make" is that only not-yet-downloaded PDFs are downloaded.  Run "make clean" to remove existing PDFs (but then you will have to download everything afresh).

The interface for an update of the downloaded csv files is to simply delete the csv files, then a fresh copy of the csv files will be downloaded again by invoking "make".
