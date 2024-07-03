. "$HOME/.cargo/env"

# https://turbo.build/repo/docs/telemetry
export TURBO_TELEMETRY_DISABLED=1

# https://consoledonottrack.com/
export DO_NOT_TRACK=1

# enable colorized output for ls, etc
export CLICOLOR=1

# https://facebook.github.io/watchman/docs/config
export WATCHMAN_CONFIG_FILE="${HOME:-~}/.watchman.json"

# http://docs.fastlane.tools/getting-started/ios/setup/
# fastlane needs UTF-8
export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8


