# var
# MODULE = $(notdir $(CURDIR))
HW     ?= ISDS205A
MODULE  = $(HW)

# dir
CWD  = $(CURDIR)
BIN  = $(CWD)/bin
SRC  = $(CWD)/src
TMP  = $(CWD)/tmp
REF  = $(CWD)/ref
GZ   = $(HOME)/gz

# tool
CURL = curl -L -o
CF   = clang-format

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# all

LIBS += bin/libvdso.so bin/libvdso.so.1.0
LIBS += lib/libvdso.so lib/libvdso.so.1.0

.PHONY: all
all: $(LIBS) ref

bin/%: SharedLibrary/Linux/X64/Debug/%
	ln -fs ../$< $@
lib/%: SharedLibrary/Linux/X64/Debug/%
	ln -fs ../$< $@

# doc
.PHONY: doc
doc:

# install
.PHONY: install update gz ref
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.Debian11`
gz:

.PHONY: ref
GITREF = git clone -o gh --depth 1
ref: ref/sigrok-util/README.md

ref/sigrok-util/README.md:
	$(GITREF) https://github.com/sigrokproject/sigrok-util.git ref/sigrok-util

# merge
MERGE += Makefile README.md apt.*
MERGE += .clang-format .editorconfig .doxygen .gitignore
MERGE += .vscode bin doc lib inc src tmp ref

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
