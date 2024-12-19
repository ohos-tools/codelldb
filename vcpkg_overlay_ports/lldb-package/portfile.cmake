vcpkg_find_acquire_program(SWIG)
vcpkg_find_acquire_program(7Z)
set(VCPKG_BUILD_TYPE "release")
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_ALLOW_EXES_IN_BIN enabled)
set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)
set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
set(LLVM_REPO "https://gitee.com/openharmony/third_party_llvm-project.git")

if (VCPKG_CROSSCOMPILING)
    message(FATAL_ERROR "Cross-compiling is not supported for this port")
endif()

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "${LLVM_REPO}"
    REF 25b15389c9569dfd12501a56bf1ad3d0aa9a51d3
    HEAD_REF master
    PATCHES
      0001-fix-lldb-build-errors.patch
      0002-disable-BUILD_SHARED_LIBS-to-prevent-errors-on-msvc.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/llvm"
    OPTIONS
        "-DLLVM_TARGETS_TO_BUILD=X86;ARM;AArch64"
        "-DLLVM_ENABLE_PROJECTS=clang;lldb"
        "-DLLDB_ENABLE_PYTHON=ON"
        "-DLLDB_ENABLE_LZMA=ON"
        "-DLLDB_EMBED_PYTHON_HOME=ON"
        "-DPython3_ROOT_DIR=${CURRENT_INSTALLED_DIR}/tools/python3"
        "-DSWIG_EXECUTABLE=${SWIG}"
        "-DLLDB_PYTHON_HOME=."
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
        "-DLLDB_INCLUDE_TESTS=OFF"
        "-DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}/tools/llvm/"
)

vcpkg_cmake_install(ADD_BIN_TO_PATH)

# Copy Python3.dll, Python311.dll, Dlls folder and Libs folder to bin
foreach(build_type IN ITEMS debug release)
    if(NOT DEFINED VCPKG_BUILD_TYPE OR "${VCPKG_BUILD_TYPE}" STREQUAL "${build_type}")
        if("${build_type}" STREQUAL "debug")
            set(config "Debug")
            set(debug_or_none "debug")
        else()
            set(config "Release")
            set(debug_or_none "")
        endif()
        message(STATUS "Creating ${config} LLDB package")
        # Copy python DLLs and Lib
        file(COPY "${CURRENT_INSTALLED_DIR}/tools/python3/DLLs"
            DESTINATION "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/bin/")
        file(COPY "${CURRENT_INSTALLED_DIR}/tools/python3/Lib"
            DESTINATION "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/bin/")
        # Delete everything in lib (static libs, we don't need them),
        # except for site-packages folder
        file(RENAME "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/lib/site-packages" "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/temp-site-packages")
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/lib/")
        file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/lib/")
        file(RENAME "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/temp-site-packages" "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/lib/site-packages")
         # Remove __pycache__ directories from bin
        file(GLOB_RECURSE files "${CURRENT_PACKAGES_DIR}/tools/llvm/${debug_or_none}/**/*.pyc")
        foreach(file ${files})
            file(REMOVE ${pycache_dir})
        endforeach()
        vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/lldb/LICENSE.TXT")
    endif()
endforeach()
