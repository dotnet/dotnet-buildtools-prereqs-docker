#!/bin/sh

echo "$0 $@"
set -x

while [ -n "$*" ]; do
  opt="$(echo "$1" | awk '{print tolower($0)}')"
  case "$opt" in
    --os)
      OS=$2
      shift
      ;;
    --version)
      VERSION=$2
      shift
      ;;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
  shift
done

echo "Installing v8"
(
# When needed, get new versions from https://storage.googleapis.com/chromium-v8/official/canary/
curl -sSL "https://netcorenativeassets.blob.core.windows.net/resource-packages/external/linux/chromium-v8/v8-$OS-rel-$VERSION.zip" -o ./v8.zip

unzip ./v8.zip -d /usr/local/v8

cat > /usr/local/bin/v8 << EOF
#!/usr/bin/env bash
"/usr/local/v8/d8" --snapshot_blob="/usr/local/v8/snapshot_blob.bin" "\$@"
EOF

chmod +x /usr/local/bin/v8
)

echo "Finished installing V8"