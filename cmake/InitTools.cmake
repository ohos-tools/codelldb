macro(SetupToolchain)

    if (NOT VCPKG_TARGET_TRIPLET)
        if (WIN32)
            set(VCPKG_TARGET_TRIPLET "x64-windows")
            message("VCPKG_TARGET_TRIPLET not set, defaulting to ${VCPKG_TARGET_TRIPLET}")
        endif()
    endif()

    if (NOT VCPKG_TARGET_TRIPLET)
        message(FATAL_ERROR "VCPKG_TARGET_TRIPLET is not set.")
    endif()

    if (NOT CMAKE_TOOLCHAIN_FILE)
        if (VCPKG_TARGET_TRIPLET MATCHES "x64-windows")
            set(_path "${CMAKE_CURRENT_LIST_DIR}/toolchain-x86_64-windows-msvc.cmake")
            message("CMAKE_TOOLCHAIN_FILE not set, defaulting to ${_path}")
            set(CMAKE_TOOLCHAIN_FILE "${_path}" CACHE "PATH" "" FORCE)
        endif()
    endif()

    if (NOT CMAKE_TOOLCHAIN_FILE)
        message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE is not set.")
    endif()

endmacro()
