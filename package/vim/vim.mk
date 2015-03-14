################################################################################
#
# vim
#
################################################################################

VIM_SITE = ftp://ftp.vim.org/pub/vim/unix
VIM_VERSION = 7.4
VIM_SOURCE = vim-$(VIM_VERSION).tar.bz2
VIM_DEPENDENCIES = ncurses $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
VIM_SUBDIR = src
VIM_CONF_ENV = vim_cv_toupper_broken=no \
		vim_cv_terminfo=yes \
		vim_cv_tty_group=world \
		vim_cv_tty_mode=0620 \
		vim_cv_getcwd_broken=no \
		vim_cv_stat_ignores_slash=yes \
		vim_cv_memmove_handles_overlap=yes \
		ac_cv_sizeof_int=4 \
		ac_cv_small_wchar_t=no
# GUI/X11 headers leak from the host so forcibly disable them
VIM_CONF_OPT = --with-tlib=ncurses --enable-gui=no --without-x \
			   --with-features=huge --enable-cscope
VIM_LICENSE = Charityware
VIM_LICENSE_FILES = README.txt

define VIM_INSTALL_TARGET_CMDS
	cd $(@D)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installvimbin; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installlinks
endef

define VIM_INSTALL_RUNTIME_CMDS
	cd $(@D)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installrtbase; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installmacros
endef

define VIM_REMOVE_DOCS
	find $(TARGET_DIR)/usr/share/vim -type f -name "*.txt" -delete
endef

ifeq ($(BR2_PACKAGE_VIM_RUNTIME),y)
VIM_POST_INSTALL_TARGET_HOOKS += VIM_INSTALL_RUNTIME_CMDS
VIM_POST_INSTALL_TARGET_HOOKS += VIM_REMOVE_DOCS
endif

$(eval $(autotools-package))
