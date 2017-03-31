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
