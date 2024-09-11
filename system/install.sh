#!/bin/bash

set -e -o pipefail

SYSTEM_SOURCE_DIR="${SOURCE_DIR:-$(dirname "$0")}"
SYSTEM_TARGET_DIR="${SYSTEM_TARGET_DIR}"

cp "${SYSTEM_SOURCE_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist" "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
cp "${SYSTEM_SOURCE_DIR}/usr/local/bin/apply-power-settings.sh" "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

chown root:wheel "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
chmod 644 "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"

chown root:wheel "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"
chmod 755 "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

if [ -z "${SYSTEM_TARGET_DIR}" ] || [ "${SYSTEM_TARGET_DIR}" == "/" ]; then
  launchctl bootstrap system "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
fi

