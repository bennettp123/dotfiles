#!/bin/bash

set -e -o pipefail

SYSTEM_SOURCE_DIR="${SOURCE_DIR:-$(dirname "$0")}"
SYSTEM_TARGET_DIR="${SYSTEM_TARGET_DIR}"

if [ -z "${SYSTEM_TARGET_DIR}" ] || [ "${SYSTEM_TARGET_DIR}" == "/" ]; then
  xattr -d -r -v com.apple.provenance "${SYSTEM_SOURCE_DIR}"
  if launchctl bootout system "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"; then
    echo 'removed existing launchd service'
  fi
fi

rm -fv "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
rm -fv "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

cp -fv "${SYSTEM_SOURCE_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist" "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
cp -fv "${SYSTEM_SOURCE_DIR}/usr/local/bin/apply-power-settings.sh" "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

chown root:wheel "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"
chmod 644 "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"

chown root:wheel "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"
chmod 755 "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

if [ -z "${SYSTEM_TARGET_DIR}" ] || [ "${SYSTEM_TARGET_DIR}" == "/" ]; then
  if ! launchctl bootstrap system "${SYSTEM_TARGET_DIR}/Library/LaunchDaemons/com.bennettp123.fix-chimpy-power-settings.plist"; then
    echo 'failed to install launchd service'
    exit 1
  fi
fi

