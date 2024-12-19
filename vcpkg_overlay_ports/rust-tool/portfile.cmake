vcpkg_find_acquire_program(7Z x )
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

function(unzip_tar_gz OUTPUT_DIR FILE_NAME)
    string(LENGTH "${FILE_NAME}" FILE_NAME_LENGTH)
    math(EXPR BASE_NAME_LENGTH "${FILE_NAME_LENGTH} - 7")
    # NO_EXT_NAME: name w/o extension, but keeps parent directories
    string(SUBSTRING "${FILE_NAME}" 0 "${BASE_NAME_LENGTH}" NO_EXT_NAME)
    # BASE_NAME: name w/o extension, no parent dir
    get_filename_component(BASE_NAME "${NO_EXT_NAME}" NAME)

    message("extracting to ${FILE_NAME} at ${CURRENT_BUILDTREES_DIR}")
    execute_process(
        COMMAND "${7Z}" "x" "-y" "${FILE_NAME}"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
        OUTPUT_QUIET
        COMMAND_ERROR_IS_FATAL ANY
    )
    execute_process(
        COMMAND "${7Z}" "x" "-y" "${BASE_NAME}.tar"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
        OUTPUT_QUIET
        COMMAND_ERROR_IS_FATAL ANY
    )

    set(${OUTPUT_DIR} "${CURRENT_BUILDTREES_DIR}/${BASE_NAME}" PARENT_SCOPE)

endfunction()

set(RUSTC_FILE_BASE_NAME "rustc-1.83.0-x86_64-pc-windows-msvc")
set(CARGO_FILE_BASE_NAME "cargo-1.83.0-x86_64-pc-windows-msvc")
set(RUST_STD_FILE_BASE_NAME "rust-std-1.83.0-x86_64-pc-windows-msvc")

vcpkg_download_distfile(
    RUSTC_TARGZ
    URLS "https://static.rust-lang.org/dist/2024-11-28/${RUSTC_FILE_BASE_NAME}.tar.gz"
    FILENAME "${RUSTC_FILE_BASE_NAME}.tar.gz"
    SHA512 "6530eaccbfc3464dc31af9c8a2e6a2296c1b8e3883d2ef169e35c2f099b8fd0eaaaf7891ea2d4ad3e4345326336529566cc802789a7c55677649a0c308d86221"
)

vcpkg_download_distfile(
    CARGO_TARGZ
    URLS "https://static.rust-lang.org/dist/2024-11-28/${CARGO_FILE_BASE_NAME}.tar.gz"
    FILENAME "${CARGO_FILE_BASE_NAME}.tar.gz"
    SHA512 "7b121fbcf0cada9ce29b10005e9eb6baa2151531639d233b124263600d34f5fe74abf9d1f13f302659dd953dda85f00d85a860a52be86d5e318480b449723a7f"
)

vcpkg_download_distfile(
    RUST_STD_TARGZ
    URLS "https://static.rust-lang.org/dist/2024-11-28/${RUST_STD_FILE_BASE_NAME}.tar.gz"
    FILENAME "${RUST_STD_FILE_BASE_NAME}.tar.gz"
    SHA512 "b69e1683de8be7690aa195deae068fb40dc1114315309a54b73baf0963141198faafd73e09d686b418a9ceab0ab850c6cb499671244ffaa1a604b167ff9387fa"
)

unzip_tar_gz(RUSTC_DIR "${RUSTC_TARGZ}")
unzip_tar_gz(CARGO_DIR "${CARGO_TARGZ}")
unzip_tar_gz(RUST_STD_DIR "${RUST_STD_TARGZ}")

file(COPY "${RUSTC_DIR}/rustc/" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/rust")
file(COPY "${CARGO_DIR}/cargo/" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/rust")
file(COPY "${RUST_STD_DIR}/rust-std-x86_64-pc-windows-msvc/" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/rust")

vcpkg_install_copyright(FILE_LIST
    "${RUSTC_DIR}/COPYRIGHT"
    "${RUSTC_DIR}/LICENSE-APACHE"
    "${RUSTC_DIR}/LICENSE-MIT"
    "${CARGO_DIR}/LICENSE-THIRD-PARTY"
    "${CARGO_DIR}/LICENSE-APACHE"
    "${CARGO_DIR}/LICENSE-MIT"
    "${RUST_STD_DIR}/COPYRIGHT"
    "${RUST_STD_DIR}/LICENSE-APACHE"
    "${RUST_STD_DIR}/LICENSE-MIT"
)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/tools/rust/lib/rustlib/x86_64-pc-windows-msvc/lib/self-contained")
