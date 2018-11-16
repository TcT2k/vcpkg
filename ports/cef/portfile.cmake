# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cef_binary_3.3538.1851.g5622787_macosx64)
vcpkg_download_distfile(ARCHIVE
    URLS "http://opensource.spotify.com/cefbuilds/cef_binary_3.3538.1851.g5622787_macosx64.tar.bz2"
    FILENAME "cef_binary_3.3538.1851.g5622787_macosx64.tar.bz2"
    SHA512 cda916ffa5dd4bac813601b6af94c441756e0df461249cef9c6913716cf76697b8171c5b07168c4a6fbfa6c8bc997140c7835057cee139a4c4bb153aa8423068
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_build_cmake()

# Handle includes
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR})

# Handle prebuild libraries
file(INSTALL ${SOURCE_PATH}/Release/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/Debug/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/cef RENAME copyright)

# Post-build test for cmake libraries
 vcpkg_test_cmake(PACKAGE_NAME cef)
