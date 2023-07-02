# Common prefix for installation directories.
prefix         ?= /usr/local
datarootdir    ?= $(prefix)/share
datadir        ?= $(datarootdir)
exec_prefix    ?= $(prefix)
bindir         ?= $(exec_prefix)/bin
libdir         ?= $(exec_prefix)/lib
libexecdir     ?= $(exec_prefix)/libexec
infodir        ?= $(datarootdir)/info
sysconfdir     ?= $(prefix)/etc
systemdunitdir ?= $(libdir)/systemd/system

# configuration options
ifneq ($(shell command -v systemctl 2>&1),)
HAVE_SYSTEMD   ?= 1
else
HAVE_SYSTEMD   ?= 0
endif

.PHONY: all
all:

.PHONY: install
install:
	install -D -m 755 -t $(bindir) wwd
	install -D -m 644 -t $(sysconfdir) wwd.conf
	@sed -i "s|/etc/wwd.conf|$$(realpath $(sysconfdir))/wwd.conf|" $(bindir)/wwd

ifeq ($(HAVE_SYSTEMD),1)
	install -D -m 644 -t $(systemdunitdir) wwd.service
	install -D -m 644 -t $(systemdunitdir) wwd.timer
	@sed -i "s|/usr/bin/wwd|$$(realpath $(bindir))/wwd|" $(systemdunitdir)/wwd.service
endif

.PHONY: uninstall
uninstall:
	$(RM) \
		$(bindir)/wwd \
		$(sysconfdir)/wwd.conf \
		$(systemdunitdir)/wwd.service \
		$(systemdunitdir)/wwd.timer
