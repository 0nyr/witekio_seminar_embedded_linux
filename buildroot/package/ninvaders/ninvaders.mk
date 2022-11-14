################################################################################
#
# nInvaders
#
################################################################################
# tips: have a look at clinfo.mk in package/clinfo


# get sources before compiling
NINVADERS_VERSION = 0.1.1
NINVADERS_SITE = https://sourceforge.net/projects/ninvaders/files/latest/download
NINVADERS_SOURCE = ninvaders-0.1.1.tar.gz # name of downloaded file
NINVADERS_LICENSE = GPL
NINVADERS_LICENSE_FILES = gpl.txt
NINVADERS_DEPENDENCIES = ncurses

# build step
define NINVADERS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

# install step
define NINVADERS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/nInvaders $(TARGET_DIR)/usr/bin/nInvaders
endef

$(eval $(generic-package))

