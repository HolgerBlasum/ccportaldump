# ccportaldump
Create dump of STs and CCs at commoncriteriaportal.org

Note: this is a script that creates a dump, *not* the dump itself,
hence folder structure below is intentionally empty on checkout.
Run "make" to populate it.

Might be useful for answering question such as: "who else uses FRU\_RSA.2?".

Makefile <- what you can do to update the collection (invoking update.pl or 
	doing clean-ups)
pp <- protection profiles
ppcr <- protection profile certification reports 
st <- security targets
stcr <- security target certification reports
pp-archived <- legacy protection profiles
ppcr-archived <- legacy protection profile certification reports 
st-archived <- legacy security targets
stcr-archived <- legacy security target certification reports
