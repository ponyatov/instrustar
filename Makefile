# var
# MODULE = $(notdir $(CURDIR))
HW     ?= ISDS205A
MODULE  = $(HW)

# doc
.PHONY: doc
doc:

# install
.PHONY: install update gz
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.Debian11`
gz:
