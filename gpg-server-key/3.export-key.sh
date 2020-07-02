#!/bin/sh

KEY_ID=$1
if [[ -z ${KEY_ID} ]]; then
  echo ""
  echo "      Help: 3.export-key.bat <KEY-ID>"
  echo ""
  exit
fi

gpg --armor --export $KEY_ID > serverkey.asc
gpg --armor --export-secret-keys $KEY_ID > serverkey_private.asc