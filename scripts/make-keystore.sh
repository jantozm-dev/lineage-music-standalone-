#!/usr/bin/env bash
# Generates a fresh signing keystore + base64 blob to configure the
# FDROID_KEYSTORE repository secrets. Run locally; never commit the .jks.
set -euo pipefail

cd "$(dirname "$0")"

pass="${1:?Usage: make-keystore.sh <keystore-password> [alias]}"
alias="${2:-twelve}"

keytool -genkeypair -v -keystore fdroid-keystore.jks \
  -alias "$alias" -keyalg RSA -keysize 4096 -validity 36500 \
  -storepass "$pass" -keypass "$pass" \
  -dname "CN=Twelve Standalone, OU=F-Droid, O=Twelve Standalone, L=YourCity, S=YourState, C=US"

echo
echo "Now configure the repository secrets:"
echo "  gh secret set FDROID_KEYSTORE          < <(base64 -w0 fdroid-keystore.jks)"
echo "  gh secret set FDROID_KEYSTORE_PASSWORD < <(printf '%s' \"$pass\")"
echo "  gh secret set FDROID_KEY_ALIAS         < <(printf '%s' \"$alias\")"
echo "  gh secret set FDROID_KEY_PASSWORD      < <(printf '%s' \"$pass\")"
echo
echo "Keep fdroid-keystore.jks + the password backed up safely. Do NOT commit them."
