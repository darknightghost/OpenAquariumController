#! /bin/bash

TOOLS_DIR="${PROJECT_ROOT}/tools"
SUDO_EXEC="$(which sudo)"

function call_sudo () {
    cmd="\"${SUDO_EXEC}\" \"--preserve-env=PATH,LD_LIBRARY_PATH,PROJECT_ROOT\""
    converted=0
    for arg in "$@"; do
        if [ ${converted} -eq 0 ] \
            && [ $(echo "${arg}" | grep "^-" | wc -l) -eq 0 ]; then
            converted=1
            cmd_path="$(which ${arg})"
            if [ $? -eq 0 ]; then
                cmd="${cmd} '${cmd_path}'"
            else
                cmd="${cmd} '${arg}'"
            fi

        else
            cmd="${cmd} '${arg}'"

        fi

    done

    eval "$cmd"
}

export PATH="${TOOLS_DIR}/bin:${TOOLS_DIR}/usr/bin:${TOOLS_DIR}/usr/local/bin:${TOOLS_DIR}/sbin:${TOOLS_DIR}/usr/sbin:${TOOLS_DIR}/usr/local/sbin:${PATH}"
export LD_LIBRARY_PATH="${TOOLS_DIR}/lib:${TOOLS_DIR}/usr/lib:${TOOLS_DIR}/usr/local/lib:${LD_LIBRARY_PATH}"

alias sudo="call_sudo"
