include $(TOPDIR)/rules.mk

PKG_NAME:=llvm-project
PKG_VERSION:=10.0.0

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=ElonH <elonhhuang@gmail.com>

PKG_INSTALL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1
HOST_BUILD_PARALLEL:=1
CMAKE_INSTALL:=1

PKG_SOURCE:=llvm-project-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERSION)/
PKG_HASH:=6287a85f4a6aeb07dbffe27847117fe311ada48005f2b00241b523fe7b60716e
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

CMAKE_BINARY_SUBDIR:=build
CMAKE_SOURCE_SUBDIR:=llvm

PKG_BUILD_DEPENDS:=llvm/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS+= -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS:BOOL=OFF -DLLVM_CCACHE_BUILD:BOOL=ON \
                -DLLVM_ENABLE_BINDINGS:BOOL=OFF\
		-DLLVM_TABLEGEN=$(STAGING_DIR_HOSTPKG)/bin/llvm-tblgen -DCLANG_TABLEGEN=$(STAGING_DIR_HOSTPKG)/bin/clang-tblgen \
		-DLLVM_DEFAULT_TARGET_TRIPLE=$(shell $(TARGET_CC) -dumpmachine) \
		-DLLVM_BUILD_DOCS:BOOL=OFF \
		-DLLVM_BUILD_TESTS:BOOL=OFF -DLLVM_INCLUDE_GO_TESTS:BOOL=OFF -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF -DLLVM_INCLUDE_TESTS:BOOL=OFF -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF \
		-DCMAKE_CROSSCOMPILING=True -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_TARGET_ARCH=X86
		# -DLLVM_ENABLE_PROJECTS:STRING="clang"

CMAKE_HOST_OPTIONS+= -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS:BOOL=OFF -DLLVM_CCACHE_BUILD:BOOL=ON \
                -DLLVM_ENABLE_BINDINGS:BOOL=OFF \
		-DLLVM_BUILD_DOCS:BOOL=OFF \
		-DLLVM_BUILD_TESTS:BOOL=OFF -DLLVM_INCLUDE_GO_TESTS:BOOL=OFF -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF -DLLVM_INCLUDE_TESTS:BOOL=OFF -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF \
		-DLLVM_ENABLE_PROJECTS:STRING="clang"
		# -DCMAKE_CROSSCOMPILING=True -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_TARGET_ARCH=X86
		# -DCMAKE_CROSSCOMPILING=True -DLLVM_TARGETS_TO_BUILD=$(ARCH) -DLLVM_TARGET_ARCH=$(ARCH)

define Host/Install
	$(call Host/Install/Default,$(HOST_BUILD_PREFIX))	
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/bin/* $(STAGING_DIR_HOSTPKG)/bin
endef

define Build/InstallDev
	# Build/InstallDev
	# 1: $(1)
	# 2: $(2)
	read
endef

define Package/llvm
        SECTION:=base
        CATEGORY:=Base system
        URL:=https://github.com/msgpack/ootoc
        TITLE:=llvm
        #DEPENDS:=+libcurl +libyaml-cpp +libtar +spdlog
        MENU:=1
endef

define Package/llvm/description
        opkg over tar over curl
endef

define Package/llvm/install
	# Package/llvm/install
	# 1: $(1)
	# 2: $(2)
	read
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,llvm))
