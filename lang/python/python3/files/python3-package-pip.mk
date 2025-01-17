#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Package/python3-pip
$(call Package/python3/Default)
  TITLE:=Python $(PYTHON3_VERSION) pip module
  VERSION:=$(PYTHON3_PIP_VERSION)-$(PYTHON3_PIP_PKG_RELEASE)
  DEPENDS:=+python3 +python3-setuptools +python-pip-conf
endef

define Py3Package/python3-pip/install
	$(INSTALL_DIR) $(1)/opt/bin $(1)/opt/lib/python$(PYTHON3_VERSION)/site-packages
	$(CP) $(PKG_BUILD_DIR)/install-pip/bin/pip3* $(1)/opt/bin
	$(SED) 's,^#!$(HOST_PYTHON3_BIN),#!/opt/bin/python3,g' $(1)/opt/bin/pip3*
	$(CP) \
		$(PKG_BUILD_DIR)/install-pip/lib/python$(PYTHON3_VERSION)/site-packages/pip \
		$(PKG_BUILD_DIR)/install-pip/lib/python$(PYTHON3_VERSION)/site-packages/pip-$(PYTHON3_PIP_VERSION).dist-info \
		$(1)/opt/lib/python$(PYTHON3_VERSION)/site-packages/
	for _ in \$(seq 1 10) ; do \
		find $(1)/opt/lib/python$(PYTHON3_VERSION)/site-packages/ -name __pycache__ -exec rm -rf {} \; || continue ; \
		break ; \
	done
endef

$(eval $(call Py3BasePackage,python3-pip, \
	, \
	DO_NOT_ADD_TO_PACKAGE_DEPENDS \
))
