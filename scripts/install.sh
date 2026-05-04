#!/bin/sh
# Install the Specific CLI on a GitHub Actions runner.
#
# Differences from the public install.sh at https://specific.dev/install.sh:
# - Requires SPECIFIC_VERSION (resolved by the caller, so the cache key is stable).
# - Always installs to $HOME/.local/bin; the action adds it to $GITHUB_PATH.
# - No shell-profile editing, no analytics, no npm cleanup.
set -eu

BASE_URL="https://binaries.specific.dev/cli"
INSTALL_DIR="$HOME/.local/bin"

if [ -z "${SPECIFIC_VERSION:-}" ]; then
  echo "Error: SPECIFIC_VERSION env var is required" >&2
  exit 1
fi

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) OS_TARGET="darwin" ;;
  Linux)  OS_TARGET="linux" ;;
  *) echo "Error: unsupported OS: $OS (only macOS and Linux are supported)" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64)  ARCH_TARGET="x64" ;;
  arm64|aarch64) ARCH_TARGET="arm64" ;;
  *) echo "Error: unsupported architecture: $ARCH (only x64 and arm64 are supported)" >&2; exit 1 ;;
esac

DOWNLOAD_URL="$BASE_URL/$SPECIFIC_VERSION/specific-${OS_TARGET}-${ARCH_TARGET}"

mkdir -p "$INSTALL_DIR"
echo "Installing Specific CLI v${SPECIFIC_VERSION} (${OS_TARGET}/${ARCH_TARGET})..."
curl -fsSL "$DOWNLOAD_URL" -o "$INSTALL_DIR/specific"
chmod +x "$INSTALL_DIR/specific"
echo "Installed to $INSTALL_DIR/specific"
