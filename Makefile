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

LLVM_EXTRA_PROJECT:= \
	$(if $(or $(CONFIG_PACKAGE_clang),$(CONFIG_PACKAGE_libclang)),clang) \
	$(if $(CONFIG_PACKAGE_clang-tools),clang-tools-extra) \
	$(if $(CONFIG_PACKAGE_lldb),lldb)
	# libunwind lld \
	openmp parallel-libs polly pstl
	#libc
	#libcxxabi
	#libcxx
	#libclc
	#compiler-rt debuginfo-tests 

CMAKE_OPTIONS+= \
		-DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS:BOOL=ON -DLLVM_CCACHE_BUILD:BOOL=ON 			\
		-DLLVM_ENABLE_BINDINGS:BOOL=OFF 																\
		-DLLVM_TABLEGEN=$(STAGING_DIR_HOSTPKG)/bin/llvm-tblgen 											\
		-DCLANG_TABLEGEN=$(STAGING_DIR_HOSTPKG)/bin/clang-tblgen 										\
		-DLLDB_TABLEGEN=$(STAGING_DIR_HOSTPKG)/bin/lldb-tblgen 											\
		-DLLVM_DEFAULT_TARGET_TRIPLE=$(shell $(TARGET_CC) -dumpmachine) 								\
		-DLLVM_BUILD_DOCS:BOOL=OFF 																		\
		-DLLVM_BUILD_TESTS:BOOL=OFF -DLLVM_INCLUDE_GO_TESTS:BOOL=OFF -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF 	\
		-DLLVM_INCLUDE_TESTS:BOOL=OFF -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF 								\
		-DCMAKE_CROSSCOMPILING=True -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_TARGET_ARCH=X86 					\
		-DLLVM_ENABLE_PROJECTS:STRING="$(subst $() $(),;,$(strip $(LLVM_EXTRA_PROJECT)))"

CMAKE_HOST_OPTIONS+= -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS:BOOL=OFF -DLLVM_CCACHE_BUILD:BOOL=ON 			\
		-DLLVM_ENABLE_BINDINGS:BOOL=OFF 																				\
		-DLLVM_BUILD_DOCS:BOOL=OFF 																						\
		-DLLVM_BUILD_TESTS:BOOL=OFF -DLLVM_INCLUDE_GO_TESTS:BOOL=OFF -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF 					\
		-DLLVM_INCLUDE_TESTS:BOOL=OFF -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF 												\
		-DLLVM_ENABLE_PROJECTS:STRING="clang;lldb"
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
	# read
endef

define Package/llvm/default
        SECTION:=base
        CATEGORY:=Base system
        URL:=https://github.com/msgpack/ootoc
endef

define Package/llvm/description/default
	LLVM is a compiler-writer's toolkit that purports to 
	make it easy to implement new languages without getting bogged down in lots of machine-specific details like Instruction Set Architectures, 
	or theoretic details like graph-coloring, register-spill algorithms and peephole optimizations.
endef
define Package/libllvm/description
	$(call Package/llvm/description/default)
	The LLVM Core libraries provide a modern source- and target-independent optimizer, 
	along with code generation support for many popular CPUs (as well as some less common ones!).
	These libraries are built around a well specified code representation known as the LLVM intermediate representation ("LLVM IR").
endef
define Package/llvm/description
	$(call Package/llvm/description/default)
endef
define Package/libllvm-dev/description
	$(call Package/llvm/description/default)
endef

define Package/libllvm
		$(call Package/llvm/default)
        TITLE:=Low-Level Virtual Machine (LLVM), library
		DEPENDS:=+librt +libpthread +libc +libstdcpp
endef

LLVM_LIB_FILES:= \
	libLLVMAggressiveInstCombine.* \
	libLLVMAnalysis.* \
	libLLVMAsmParser.* \
	libLLVMAsmPrinter.* \
	libLLVMBinaryFormat.* \
	libLLVMBitReader.* \
	libLLVMBitstreamReader.* \
	libLLVMBitWriter.* \
	libLLVMCFGuard.* \
	libLLVMCodeGen.* \
	libLLVMCore.* \
	libLLVMCoroutines.* \
	libLLVMCoverage.* \
	libLLVMDebugInfoCodeView.* \
	libLLVMDebugInfoDWARF.* \
	libLLVMDebugInfoGSYM.* \
	libLLVMDebugInfoMSF.* \
	libLLVMDebugInfoPDB.* \
	libLLVMDemangle.* \
	libLLVMDlltoolDriver.* \
	libLLVMDWARFLinker.* \
	libLLVMExecutionEngine.* \
	libLLVMFrontendOpenMP.* \
	libLLVMFuzzMutate.* \
	libLLVMGlobalISel.* \
	libLLVMInstCombine.* \
	libLLVMInstrumentation.* \
	libLLVMInterpreter.* \
	libLLVMipo.* \
	libLLVMIRReader.* \
	libLLVMJITLink.* \
	libLLVMLibDriver.* \
	libLLVMLineEditor.* \
	libLLVMLinker.* \
	libLLVMLTO.* \
	libLLVMMC.* \
	libLLVMMCA.* \
	libLLVMMCDisassembler.* \
	libLLVMMCJIT.* \
	libLLVMMCParser.* \
	libLLVMMIRParser.* \
	libLLVMObjCARCOpts.* \
	libLLVMObject.* \
	libLLVMObjectYAML.* \
	libLLVMOption.* \
	libLLVMOrcError.* \
	libLLVMOrcJIT.* \
	libLLVMPasses.* \
	libLLVMProfileData.* \
	libLLVMRemarks.* \
	libLLVMRuntimeDyld.* \
	libLLVMScalarOpts.* \
	libLLVMSelectionDAG.* \
	libLLVMSupport.* \
	libLLVMSymbolize.* \
	libLLVMTableGen.* \
	libLLVMTarget.* \
	libLLVMTextAPI.* \
	libLLVMTransformUtils.* \
	libLLVMVectorize.* \
	libLLVMWindowsManifest.* \
	libLLVMX86AsmParser.* \
	libLLVMX86CodeGen.* \
	libLLVMX86Desc.* \
	libLLVMX86Disassembler.* \
	libLLVMX86Info.* \
	libLLVMX86Utils.* \
	libLLVMXRay.* \
	libLTO.* \
	libRemarks.*

define Package/libllvm/install
	$(INSTALL_DIR) $(1)/usr/lib
	( cd $(PKG_INSTALL_DIR)/usr/lib; $(CP) $(strip $(LLVM_LIB_FILES)) $(1)/usr/lib;)
endef
$(eval $(call BuildPackage,libllvm))

define Package/llvm
		$(call Package/llvm/default)
        TITLE:=Low-Level Virtual Machine (LLVM), binary
		DEPENDS:=+libllvm
        MENU:=1
endef

LLVM_BIN_FILES:= \
	bugpoint \
	dsymutil \
	llc \
	lli \
	llvm-addr2line \
	llvm-ar \
	llvm-as \
	llvm-bcanalyzer \
	llvm-cat \
	llvm-cfi-verify \
	llvm-config \
	llvm-cov \
	llvm-c-test \
	llvm-cvtres \
	llvm-cxxdump \
	llvm-cxxfilt \
	llvm-cxxmap \
	llvm-diff \
	llvm-dis \
	llvm-dlltool \
	llvm-dwarfdump \
	llvm-dwp \
	llvm-elfabi \
	llvm-exegesis \
	llvm-extract \
	llvm-ifs \
	llvm-install-name-tool \
	llvm-jitlink \
	llvm-lib \
	llvm-link \
	llvm-lipo \
	llvm-lto \
	llvm-lto2 \
	llvm-mc \
	llvm-mca \
	llvm-modextract \
	llvm-mt \
	llvm-nm \
	llvm-objcopy \
	llvm-objdump \
	llvm-opt-report \
	llvm-pdbutil \
	llvm-profdata \
	llvm-ranlib \
	llvm-rc \
	llvm-readelf \
	llvm-readobj \
	llvm-reduce \
	llvm-rtdyld \
	llvm-size \
	llvm-split \
	llvm-stress \
	llvm-strings \
	llvm-strip \
	llvm-symbolizer \
	llvm-tblgen \
	llvm-undname \
	llvm-xray \
	obj2yaml \
	opt \
	sancov \
	sanstats \
	verify-uselistorder \
	yaml2obj

define Package/llvm/install
	$(INSTALL_DIR) $(1)/usr/{bin,share}
	( cd $(PKG_INSTALL_DIR)/usr/bin; $(CP) $(strip $(LLVM_BIN_FILES)) $(1)/usr/bin;)
	$(CP) $(PKG_INSTALL_DIR)/usr/share/opt-viewer $(1)/usr/share
endef
$(eval $(call BuildPackage,llvm))

define Package/libllvm-dev
		$(call Package/llvm/default)
        TITLE:=Low-Level Virtual Machine (LLVM), headers
		DEPENDS:=+llvm
endef

define Package/libllvm-dev/install
	$(INSTALL_DIR) $(1)/usr/{include,lib/cmake}
	$(CP) $(PKG_INSTALL_DIR)/usr/include/{llvm,llvm-c} $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/llvm $(1)/usr/lib/cmake
endef
$(eval $(call BuildPackage,libllvm-dev))

define Package/clang/description/default
	The Clang project provides a language front-end and tooling infrastructure 
	for languages in the C language family (C, C++, Objective C/C++, OpenCL, CUDA, and RenderScript) for the LLVM project. 
	Both a GCC-compatible compiler driver (clang) and an MSVC-compatible compiler driver (clang-cl.exe) are provided. 
endef
define Package/libclang/description
	$(call Package/clang/description/default)
endef
define Package/clang/description
	$(call Package/clang/description/default)
endef
define Package/libclang-dev/description
	$(call Package/clang/description/default)
endef

define Package/libclang
		$(call Package/llvm/default)
        TITLE:=C, C++ and Objective-C compiler (LLVM based), library
		DEPENDS:=+libllvm
endef

CLANG_LIB_FILES:= \
	libclangAnalysis.* \
	libclangARCMigrate.* \
	libclangASTMatchers.* \
	libclangAST.* \
	libclangBasic.* \
	libclangCodeGen.* \
	libclang-cpp.* \
	libclangCrossTU.* \
	libclangDependencyScanning.* \
	libclangDirectoryWatcher.* \
	libclangDriver.* \
	libclangDynamicASTMatchers.* \
	libclangEdit.* \
	libclangFormat.* \
	libclangFrontend.* \
	libclangFrontendTool.* \
	libclangHandleCXX.* \
	libclangHandleLLVM.* \
	libclangIndex.* \
	libclangLex.* \
	libclangParse.* \
	libclangRewriteFrontend.* \
	libclangRewrite.* \
	libclangSema.* \
	libclangSerialization.* \
	libclang.* \
	libclangStaticAnalyzerCheckers.* \
	libclangStaticAnalyzerCore.* \
	libclangStaticAnalyzerFrontend.* \
	libclangToolingASTDiff.* \
	libclangToolingCore.* \
	libclangToolingInclusions.* \
	libclangToolingRefactoring.* \
	libclangTooling.* \
	libclangToolingSyntax.* \
	libclangTransformer.* \
	$(if $(CONFIG_PACKAGE_clang-tools), \
		libclangIncludeFixerPlugin.* \
		libclangTidyPlugin.* \
		libclangIncludeFixer.* \
		libclangTidy.* \
		libclangTidyAbseilModule.* \
		libclangTidyAndroidModule.* \
		libclangTidyBoostModule.* \
		libclangTidyBugproneModule.* \
		libclangTidyCERTModule.* \
		libclangTidyCppCoreGuidelinesModule.* \
		libclangTidyDarwinModule.* \
		libclangTidyFuchsiaModule.* \
		libclangTidyGoogleModule.* \
		libclangTidyHICPPModule.* \
		libclangTidyLLVMModule.* \
		libclangTidyLinuxKernelModule.* \
		libclangTidyMPIModule.* \
		libclangTidyMiscModule.* \
		libclangTidyModernizeModule.* \
		libclangTidyObjCModule.* \
		libclangTidyOpenMPModule.* \
		libclangTidyPerformanceModule.* \
		libclangTidyPortabilityModule.* \
		libclangTidyReadabilityModule.* \
		libclangTidyZirconModule.* \
		libclangTidyUtils.* \
		libfindAllSymbols.* \
	)

define Package/libclang/install
	$(INSTALL_DIR) $(1)/usr/{lib,libexec}
	(cd $(PKG_INSTALL_DIR)/usr/lib; $(CP) $(strip $(CLANG_LIB_FILES)) $(1)/usr/lib;)
	$(CP) $(PKG_INSTALL_DIR)/usr/libexec/{c++,ccc}-analyzer $(1)/usr/libexec
endef
$(eval $(call BuildPackage,libclang))

define Package/clang
		$(call Package/llvm/default)
        TITLE:=C, C++ and Objective-C compiler (LLVM based), binary
		DEPENDS:=+llvm +libclang
endef

CLANG_BIN_FILES:= \
	c-index-test \
	clang \
	clang++ \
	clang-10 \
	clang-check \
	clang-cl \
	clang-cpp \
	clang-extdef-mapping \
	clang-format \
	clang-import-test \
	clang-offload-bundler \
	clang-offload-wrapper \
	clang-refactor \
	clang-rename \
	clang-scan-deps \
	diagtool \
	git-clang-format \
	hmaptool \
	scan-build \
	scan-view

define Package/clang/install
	$(INSTALL_DIR) $(1)/usr/{bin,share}
	(cd $(PKG_INSTALL_DIR)/usr/bin; $(CP) $(strip $(CLANG_BIN_FILES)) $(1)/usr/bin;)
	$(CP) $(PKG_INSTALL_DIR)/usr/share/{clang,scan-build,scan-view} $(1)/usr/share
endef
$(eval $(call BuildPackage,clang))

define Package/libclang-dev
		$(call Package/llvm/default)
        TITLE:=C, C++ and Objective-C compiler (LLVM based), headers
		DEPENDS:=+llvm +clang
endef

define Package/libclang-dev/install
	$(INSTALL_DIR) $(1)/usr/{include,lib/cmake}
	$(CP) $(PKG_INSTALL_DIR)/usr/include/{clang,clang-c} $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/clang $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/clang $(1)/usr/lib/cmake
endef
$(eval $(call BuildPackage,libclang-dev))

CLANG_TOOLS_BIN_FILES:= \
	clang-apply-replacements \
	clang-change-namespace \
	clangd \
	clang-doc \
	clang-include-fixer \
	clang-move \
	clang-query \
	clang-reorder-fields \
	clang-tidy \
	find-all-symbols \
	modularize \
	pp-trace

CLANG_TOOLS_LIB_FILES:= \
	libclangApplyReplacements.* \
	libclangChangeNamespace.* \
	libclangDaemon.* \
	libclangDaemonTweaks.* \
	libclangDoc.* \
	libclangMove.* \
	libclangQuery.* \
	libclangReorderFields.*

define Package/clang-tools
		$(call Package/llvm/default)
        TITLE:=clang-based tools for C/C++ developments
		DEPENDS:=+clang
endef

define Package/clang-tools/install
	$(INSTALL_DIR) $(1)/usr/{bin,lib}
	(cd $(PKG_INSTALL_DIR)/usr/bin; $(CP) $(strip $(CLANG_TOOLS_BIN_FILES)) $(1)/usr/bin;)
	(cd $(PKG_INSTALL_DIR)/usr/lib; $(CP) $(strip $(CLANG_TOOLS_LIB_FILES)) $(1)/usr/lib;)
endef
$(eval $(call BuildPackage,clang-tools))

define Package/lldb/description/default
	LLDB is a next generation, high-performance debugger. 
	It is built as a set of reusable components which highly leverage existing libraries in the larger LLVM Project, 
	such as the Clang expression parser and LLVM disassembler.
endef
define Package/liblldb/description
	$(call Package/lldb/description/default)
endef
define Package/lldb/description
	$(call Package/lldb/description/default)
endef
define Package/liblldb-dev/description
	$(call Package/lldb/description/default)
endef


define Package/liblldb
		$(call Package/llvm/default)
        TITLE:=Next generation, high-performance debugger (LLVM based), library
		DEPENDS:=+libclang
endef

LLDB_LIB_FILES:= \
	liblldbIntelFeatures.* \
	liblldb.*

define Package/liblldb/install
	$(INSTALL_DIR) $(1)/usr/lib
	(cd $(PKG_INSTALL_DIR)/usr/lib; $(CP) $(strip $(LLDB_LIB_FILES)) $(1)/usr/lib;)
endef
$(eval $(call BuildPackage,liblldb))

define Package/lldb
		$(call Package/llvm/default)
        TITLE:=Next generation, high-performance debugger (LLVM based), binary
		DEPENDS:=+clang +liblldb
endef

LLDB_BIN_FILES:= \
	lldb \
	lldb-argdumper \
	lldb-instr \
	lldb-server \
	lldb-vscode

define Package/lldb/install
	$(INSTALL_DIR) $(1)/usr/bin
	(cd $(PKG_INSTALL_DIR)/usr/bin; $(CP) $(strip $(LLDB_BIN_FILES)) $(1)/usr/bin;)
endef
$(eval $(call BuildPackage,lldb))

define Package/liblldb-dev
		$(call Package/llvm/default)
        TITLE:=Next generation, high-performance debugger, headers
		DEPENDS:=+lldb
endef

define Package/liblldb-dev/install
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/lldb $(1)/usr/include
endef
$(eval $(call BuildPackage,liblldb-dev))

define Package/emscripten
		$(call Package/llvm/default)
        TITLE:=LLVM-to-JavaScript Compiler
		DEPENDS:=+llvm
endef

define Package/ldc
		$(call Package/llvm/default)
        TITLE:=LLVM D Compiler
		DEPENDS:=+llvm
endef


define Package/libc++-dev
		$(call Package/llvm/default)
        TITLE:=LLVM C++ Standard library (development files)
		DEPENDS:=+llvm
endef

define Package/libc++1
		$(call Package/llvm/default)
        TITLE:=LLVM C++ Standard library
		DEPENDS:=+llvm
endef

define Package/libc++abi-dev
		$(call Package/llvm/default)
        TITLE:=LLVM low level support for a standard C++ library (development files)
		DEPENDS:=+llvm
endef

define Package/libc++abi1
		$(call Package/llvm/default)
        TITLE:=LLVM low level support for a standard C++ library
		DEPENDS:=+llvm
endef
define Package/libclang-cpp
		$(call Package/llvm/default)
        TITLE:=C++ interface to the Clang library
		DEPENDS:=+llvm
endef

define Package/libclang-perl
		$(call Package/llvm/default)
        TITLE:=C, C++ and Objective-C compiler (LLVM based)
		DEPENDS:=+llvm
endef

define Package/libclang1
		$(call Package/llvm/default)
        TITLE:=C interface to the clang library
		DEPENDS:=+llvm
endef

define Package/liblld
		$(call Package/llvm/default)
        TITLE:=LLVM-based linker, library
		DEPENDS:=+llvm
endef

define Package/liblld-dev
		$(call Package/llvm/default)
        TITLE:=LLVM-based linker, header files
		DEPENDS:=+llvm
endef

define Package/liblldb
		$(call Package/llvm/default)
        TITLE:=Next generation, high-performance debugger, library
		DEPENDS:=+llvm
endef

define Package/libllvm
		$(call Package/llvm/default)
        TITLE:=Modular compiler and toolchain technologies, runtime library
		DEPENDS:=+llvm
endef

define Package/lld
		$(call Package/llvm/default)
        TITLE:=LLVM-based linker
		DEPENDS:=+llvm
endef

define Package/llvm-runtime
		$(call Package/llvm/default)
        TITLE:=Low-Level Virtual Machine (LLVM), bytecode interpreter
		DEPENDS:=+llvm
endef

define Package/llvm-tools
		$(call Package/llvm/default)
        TITLE:=Modular compiler and toolchain technologies, tools
		DEPENDS:=+llvm
endef

$(eval $(call HostBuild))
