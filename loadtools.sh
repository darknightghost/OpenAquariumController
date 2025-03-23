#! /bin/bash

ROOT_DIR="$(dirname "$(realpath "$0")")"
TOOLS_DIR="${ROOT_DIR}/tools"
BUILD_SCRIPTS_DIR="${ROOT_DIR}/tools-build-scripts"
TOOLS_SRC_DIR="${ROOT_DIR}/tools-src"

export PROJECT_ROOT="${ROOT_DIR}"

function build_tools () {
    if [ $(id -u) -eq 0 ]; then
        echo "Do not build as root."
        exit -1;

    fi

    # Create directory.
    rm -rf "${TOOLS_SRC_DIR}"
    mkdir "${TOOLS_SRC_DIR}" || return $?
    rm -rf "${TOOLS_DIR}"
    mkdir "${TOOLS_DIR}" || return $?

    # Run scripts.
    for path in "${BUILD_SCRIPTS_DIR}"/build-*.sh; do
        tool_name="$(echo ${path} | sed "s/.*\/build-\([^/]\+\)\.sh/\\1/g")"
        echo Building 3rd-party tool \"${tool_name}\"...
        tool_src_dir="${TOOLS_SRC_DIR}/${tool_name}"
        mkdir "${tool_src_dir}" || return $?
        "${path}" "${tool_src_dir}" "${TOOLS_DIR}" || return $?

    done

    touch "${TOOLS_DIR}/ready"

}

if [ ! -f "${TOOLS_DIR}/ready" ]; then
    build_tools || exit $?

fi

bash --init-file "${ROOT_DIR}/tools-env.sh"
