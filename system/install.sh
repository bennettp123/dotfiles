#!/bin/bash

set -e -o pipefail

SYSTEM_SOURCE_DIR="${SOURCE_DIR:-$(dirname "$0")}"
SYSTEM_TARGET_DIR="${SYSTEM_TARGET_DIR}"

cd "${SYSTEM_SOURCE_DIR}" || exit 1

if [ -z "${SYSTEM_TARGET_DIR}" ] || [ "${SYSTEM_TARGET_DIR}" == "/" ]; then
  xattr -d -r -v com.apple.provenance "${SYSTEM_SOURCE_DIR}"
fi

rm -fv "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"
cp -fv "${SYSTEM_SOURCE_DIR}/usr/local/bin/apply-power-settings.sh" "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"
chown root:wheel "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"
chmod 755 "${SYSTEM_TARGET_DIR}/usr/local/bin/apply-power-settings.sh"

for file in Library/LaunchDaemons/*.plist Library/LaunchAgents/*.plist; do

  if ! [ -r "$file" ]; then continue; fi

  rm -fv "${SYSTEM_TARGET_DIR}/${file}"
  cp -fv "${SYSTEM_SOURCE_DIR}/${file}" "${SYSTEM_TARGET_DIR}/${file}"

  chown root:wheel "${SYSTEM_TARGET_DIR}/${file}"
  chmod 644 "${SYSTEM_TARGET_DIR}/${file}"

  if [ -z "${SYSTEM_TARGET_DIR}" ] || [ "${SYSTEM_TARGET_DIR}" == "/" ]; then
    if grep -q LaunchDaemons <<<"$(dirname "${file}")" ; then
      launchctl bootout system "${SYSTEM_TARGET_DIR}/${file}" || :
      if ! launchctl bootstrap system "${SYSTEM_TARGET_DIR}/${file}"; then
	echo "failed to bootstrap launch daemon ${file}"
	exit 1
      fi
    else
      LABEL="$(defaults read "${SYSTEM_TARGET_DIR}/${file}" Label 2>/dev/null || echo "")"
      if [ -z "${LABEL}" ]; then
	LABEL=$(basename "${file}" .plist)
      fi

      if ! launchctl enable system/"${LABEL}" && launchctl start system/"${LABEL}"; then
	echo "failed to enable launch agent ${file}"
	exit 1
      fi
    fi
  fi

done

