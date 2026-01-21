source "${HOME}/.aws-helpers.sh"

_SSAPI_INFRA_DIR="${_SSAPI_INFRA_DIR:-${HOME}/src/ssapi/infrastructure}"

function get-instance-ids() { (
    set -e -o pipefail
    aws-list-instances \
        | jq -cr . \
        | ( test -z ${@} && cat || grep ${@/#/-e} ) \
        | awk '{ print $1 }' \
        | sed 's/,*$//g'
) }

function _parse_url_hostname() {
    node -e 'const { createInterface } = require("node:readline"); const rl = createInterface({ input: process.stdin }); rl.on("close", () => process.exit(0)); rl.on("line", (line) => console.log(new URL(line.trim()).hostname));'
}

function _parse_url_port() {
    node -e 'const { createInterface } = require("node:readline"); const rl = createInterface({ input: process.stdin }); rl.on("close", () => process.exit(0)); rl.on("line", (line) => console.log(new URL(line.trim()).port));'
}

function _parse_url_user() {
    node -e 'const { createInterface } = require("node:readline"); const rl = createInterface({ input: process.stdin }); rl.on("close", () => process.exit(0)); rl.on("line", (line) => console.log(new URL(line.trim()).username));'
}

function _parse_url_password() {
    node -e 'const { createInterface } = require("node:readline"); const rl = createInterface({ input: process.stdin }); rl.on("close", () => process.exit(0)); rl.on("line", (line) => console.log(new URL(line.trim()).password));'
}

### SSAPI

function _configure_ssapi_pulumi() {
    STACKNAME="${1}"
    if [ -z "${STACKNAME}" ]; then eche 'usage: configure-ssapi-pulumi <stack>' >&2; return 1; fi
    DBURI="$(AWS_PROFILE=aad pulumi stack output --stack "${STACKNAME}" --cwd "${_SSAPI_INFRA_DIR}" dbUri --show-secrets --json | jq -rc '.')"
    DB_REMOTE_HOSTNAME="$(echo "${DBURI}" | _parse_url_hostname)"
    DB_REMOTE_PORT="$(echo "${DBURI}" | _parse_url_port)"
    DB_REMOTE_USER="$(echo "${DBURI}" | _parse_url_user)"
    DB_REMOTE_PASSWORD="$(echo "${DBURI}" | _parse_url_password)"
    unset DBURI
}

function get-ssapi() { (
    set -e -o pipefail
    if [ "${1}" = 'dev' ]; then
        get-ssapi ssapi-shared-dev
    elif [ "${1}" = 'prd' ] || [ "${1}" = 'prod' ]; then
        get-ssapi ssapi-shared-prd
    else
        AWS_PROFILE="wandigital" get-instance-ids ${@}
    fi
) }

SSAPI_TUNNEL_USAGE='usage: ssapi-tunnel <env> <service>

  <env>      dev or prd
  <service>  mysql or dti
'

function ssapi-tunnel() { (
    set -e -o pipefail
    ENVIRON="${1}"
    SERVICE="${2}"

    if [ "${SERVICE}" != 'mysql' ] \
        && [ "${SERVICE}" != 'dti' ]; then
        echo "${SSAPI_TUNNEL_USAGE}" >&2
	exit 1
    fi

    if [ "${ENVIRON}" = 'dev' ]; then
        if [ "${SERVICE}" = 'mysql' ]; then
            _configure_ssapi_pulumi ssapi.shared-dev
	    DB_LOCAL_PORT=33061
	fi
    elif [ "${ENVIRON}" = 'prd' ] || [ "${ENVIRON}" = 'prod' ]; then
        if [ "${SERVICE}" = 'mysql' ]; then
            _configure_ssapi_pulumi ssapi.shared-prd
	    DB_LOCAL_PORT=33062
	fi
    else
        echo "${SSAPI_TUNNEL_USAGE}"
	exit 1
    fi

    IFS=$'\n' INSTANCE_ID=( $(get-ssapi "${ENVIRON}") )

    if [ "${#INSTANCE_ID[@]}" -gt 1 ]; then
        echo "warning: multiple instances match ${@}; using ${INSTANCE_ID[1]}" >&2
    fi

    LOCALSOCK="${DB_LOCAL_HOSTNAME:-localhost}:${DB_LOCAL_PORT}"
    REMOTESOCK="${DB_REMOTE_HOSTNAME}:${DB_REMOTE_PORT:-3306}"
    echo "Setting up tunnel on ${LOCALSOCK} forwarded to ${REMOTESOCK} via ${INSTANCE_ID[1]}" >&2
    echo >&2
    echo "connect using the command below" >&2
    echo "    mysql -h ::1 -P ${DB_LOCAL_PORT} -u ${DB_REMOTE_USER} -p" >&2
    echo "password: ${DB_REMOTE_PASSWORD} (when prompted)" >&2
    echo >&2
    AWS_PROFILE="wandigital" ssh "${SSH_USER:-bennett.perkins}@${INSTANCE_ID[1]}" -L "${LOCALSOCK}:${REMOTESOCK}" -N -o ExitOnForwardFailure=yes
) }


