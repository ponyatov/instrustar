# var
# MODULE = $(notdir $(CURDIR))
HW     ?= ISDS205A
MODULE  = $(HW)

# all
.PHONY: all
all: update

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

# merge
MERGE += Makefile README.md apt.*
MERGE += .clang-format .editorconfig .gitignore
MERGE += .vscode bin doc lib inc src tmp

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
