set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)
set(VCPKG_ENV_PASSTHROUGH CCACHE_PATH)

# ccache
set(ccache_path "$ENV{CCACHE_PATH}")
if (NOT ccache_path)
    message(FATAL_ERROR "CCACHE_PATH not set. Please set this env var to the full path of the ccache executable.")
endif()
set(VCPKG_CMAKE_CONFIGURE_OPTIONS "-DCMAKE_CXX_COMPILER_LAUNCHER=${ccache_path}" "-DCMAKE_C_COMPILER_LAUNCHER=${ccache_path}")
