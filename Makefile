# var
# MODULE = $(notdir $(CURDIR))
HW     ?= ISDS205C
MODULE  = $(HW)

AUTHOR = Dmitry Ponyatov
EMAIL  = dponyatov@gmil.com

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

NEW_DRIVER = $(CWD)/ref/sigrok-util/source/new-driver

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# all

LIBS += bin/libvdso.so bin/libvdso.so.1.0
LIBS += lib/libvdso.so lib/libvdso.so.1.0
LIBS += inc/VdsoLib.h

.PHONY: all
all: $(LIBS) ref $(C) src/0001-isds205c-Initial-driver-skeleton.patch

src/0001-isds205c-Initial-driver-skeleton.patch: $(NEW_DRIVER)
	cd src ; python3 $< -a "$(AUTHOR)" -e "$(EMAIL)" $(HW)

bin/%: SharedLibrary/Linux/X64/Debug/%
	ln -fs ../$< $@
lib/%: SharedLibrary/Linux/X64/Debug/%
	ln -fs ../$< $@
inc/%: SharedLibrary/%
	cp $< $@

# doc
.PHONY: doc
doc: doc/Sigrok-_Adventures_in_Integrating_a_Power-Measurement_Device.pdf

doc/Sigrok-_Adventures_in_Integrating_a_Power-Measurement_Device.pdf:
	$(CURL) $@ https://elinux.org/images/7/76/Sigrok-_Adventures_in_Integrating_a_Power-Measurement_Device.pdf
# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) -style=file -i $? && touch $@

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
ref: $(NEW_DRIVER)

$(NEW_DRIVER):
	$(GITREF) git://sigrok.org/sigrok-util $(CWD)/ref/sigrok-util

# merge
MERGE += Makefile README.md apt.*
MERGE += .clang-format .editorconfig .doxygen .gitignore
MERGE += .vscode bin doc lib inc src tmp ref
MERGE += demo-*

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
