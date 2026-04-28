#!/usr/bin/env bash
# see https://github.com/maxgoedjen/secretive/issues/795
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
exec ssh-keygen "$@"
