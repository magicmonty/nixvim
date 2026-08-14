#!/usr/bin/env bash
#
# install_netcoredbg.sh
#
# Purpose:
#   Portable, maintainable installer for netcoredbg on macOS and Linux.
#   - Downloads the correct official prebuilt release for your platform (default),
#     or builds from source only if --source is supplied.
#   - All installed assets are contained in /usr/local/netcoredbg
#   - Only the launcher script is created in /usr/local/bin (makes $PATH tidy and predictable)
#   - Ensures dynamic libraries are found regardless of $PATH or shell.
#   - Clean uninstall supported.
#   - Robust error checking and future-proof design for easy maintenance.
#
# Usage:
#   chmod +x install_netcoredbg.sh
#   ./install_netcoredbg.sh [--force] [--uninstall] [--source]
# Options:
#   --force: forces reinstall even if already latest version.
#   --uninstall: interactively removes all files/symlinks this script has installed (takes precedence if given).
#   --source: build from source rather than downloading a prebuilt release

set -euo pipefail

REPO="Samsung/netcoredbg"

REQUIRED_TOOLS=(curl git cmake clang make cargo cargo-binstall ouch sudo sd fd)
MISSING_TOOLS=()

echo "Checking required tools are available..."
for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    MISSING_TOOLS+=("$tool")
  fi
done
if [ "${#MISSING_TOOLS[@]}" -ne 0 ]; then
  echo "The following required tools are missing:"
  for tool in "${MISSING_TOOLS[@]}"; do echo "  - $tool"; done
  echo "Please install these and re-run the script."
  exit 1
fi

# Flags for uninstall, force, and use source
FORCE=0
UNINSTALL=0
USE_SOURCE=0
for arg in "$@"; do
  case "$arg" in
  --force) FORCE=1 ;;
  --uninstall) UNINSTALL=1 ;;
  --source) USE_SOURCE=1 ;;
  esac
done

# Uninstallation block, interactive and robust
uninstall_netcoredbg() {
  echo "Preparing to uninstall netcoredbg."
  TO_REMOVE=()
  [ -e /usr/local/bin/netcoredbg ] && TO_REMOVE+=("/usr/local/bin/netcoredbg")
  [ -d /usr/local/netcoredbg ] && TO_REMOVE+=("/usr/local/netcoredbg")
  for dll in /usr/local/ManagedPart.dll /usr/local/Microsoft.CodeAnalysis*.dll /usr/local/libdbgshim.dylib; do
    for f in $dll; do
      [ -e "$f" ] && TO_REMOVE+=("$f")
    done
  done
  if [ ${#TO_REMOVE[@]} -eq 0 ]; then
    echo "Nothing to remove. netcoredbg assets not found."
    return
  fi
  echo "The following will be removed:"
  for f in "${TO_REMOVE[@]}"; do
    echo "  $f"
  done
  read -r -p "Proceed with removal? [y/N] " confirm
  case "$confirm" in
  [yY][eE][sS] | [yY])
    for f in "${TO_REMOVE[@]}"; do
      sudo rm -rf "$f" && echo "Removed $f"
    done
    echo "Uninstall completed."
    ;;
  *)
    echo "Aborted. No files were removed."
    ;;
  esac
}

# If uninstall is set, always uninstall and exit
if [ "$UNINSTALL" -eq 1 ]; then
  uninstall_netcoredbg
  exit 0
fi

# Create a clean build directory for all temp files
BUILD_DIR="$(mktemp -d)"

# This function cleans up the build directory when the script exits,
# even if interrupted. It is registered as a trap for EXIT,
# so shellcheck SC2317 (unreachable code) is disabled.
# shellcheck disable=SC2317
cleanup() {
  # This cleanup is only reachable via EXIT trap
  echo "Cleaning up..."
  rm -rf "$BUILD_DIR"
}
trap cleanup EXIT

# Grab latest version info from GitHub - robust for update-in-place upgrades
LATEST_JSON=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest")
EXPECTED_VERSION=$(echo "$LATEST_JSON" | grep -m1 '"tag_name"' | cut -d '"' -f4 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

if command -v netcoredbg &>/dev/null; then
  INSTALLED_VERSION=$(netcoredbg --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  if [ "$INSTALLED_VERSION" = "$EXPECTED_VERSION" ] && [ "$FORCE" -ne 1 ]; then
    echo "netcoredbg $INSTALLED_VERSION is already installed and up-to-date."
    echo "Nothing to do. Use --force or NETCOREDBG_FORCE=1 to force reinstall."
    exit 0
  elif [ "$INSTALLED_VERSION" = "$EXPECTED_VERSION" ] && [ "$FORCE" -eq 1 ]; then
    echo "netcoredbg $INSTALLED_VERSION is already installed, proceeding due to --force/NETCOREDBG_FORCE."
  fi
fi

# Download and install prebuilt binary by default (unless --source is passed)
if [ "$USE_SOURCE" -eq 0 ]; then
  echo "Installing official netcoredbg release binary..."
  # Detect architecture and set platform string exactly as needed for netcoredbg asset
  if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
      PLATFORM="osx-arm64"
    else
      PLATFORM="osx-amd64"
    fi
  else
    if [[ "$(uname -m)" == "aarch64" ]] || [[ "$(uname -m)" == "arm64" ]]; then
      PLATFORM="linux-arm64"
    else
      PLATFORM="linux-amd64"
    fi
  fi

  cd "$BUILD_DIR"
  ASSET_NAME="netcoredbg-$PLATFORM.zip"
  echo "Looking for asset $ASSET_NAME in the latest release..."

  REL_URL=$(echo "$LATEST_JSON" | grep -oE 'https?://[^\" ]+' | grep "$ASSET_NAME" | head -1 || true)

  if [ -z "$REL_URL" ]; then
    echo ""
    echo "ERROR: No release asset found for platform '$PLATFORM'."
    echo "Expected asset name: $ASSET_NAME"
    echo "Available assets in latest release:"
    echo "$LATEST_JSON" | grep -oE '\"name\": \"netcoredbg-[^\"]+' | sed 's/\"name\": //'
    if [[ "$(uname)" == "Darwin" && "$PLATFORM" == "osx-arm64" ]]; then
      echo ""
      echo "No Apple Silicon (osx-arm64) prebuilt binary available from Samsung."
      echo "You must run under Rosetta using the Intel (osx-amd64) binary,"
      echo "or rerun this script with --source to build from source for arm64."
    fi
    exit 12
  fi

  echo "Downloading $REL_URL ..."
  curl -L "$REL_URL" -o netcoredbg.zip
  ouch d netcoredbg.zip
  EXTRACT_DIR=$(find . -maxdepth 1 -type d -name 'netcoredbg*' | head -1)
  sudo mkdir -p /usr/local/netcoredbg && sudo rm -rf /usr/local/netcoredbg/*
  sudo cp -r "$EXTRACT_DIR"/* /usr/local/netcoredbg/
else
  echo "Building netcoredbg from source (--source supplied)..."
  TAR_URL=$(echo "$LATEST_JSON" | grep "tarball_url" | head -n 1 | cut -d '"' -f 4)
  [ -z "$TAR_URL" ] && {
    echo "Failed to get tarball URL from GitHub API."
    exit 2
  }
  curl -sL "$TAR_URL" -o source.tar.gz
  ouch d source.tar.gz
  cd source
  SRC_DIR=$(find . -maxdepth 1 -type d -name "Samsung-netcoredbg-*")
  [ ! -d "$SRC_DIR" ] && {
    echo "Source directory not found after extraction."
    exit 3
  }
  cd "$SRC_DIR"
  echo "Listing extracted directory contents for debugging:"
  ls -al
  echo "Patching all CMakeLists.txt for CMake >= 4 compatibility (if needed)..."
  fd --glob 'CMakeLists.txt' . | while read -r file; do
    sd 'cmake_minimum_required\(VERSION [^)]*\)' 'cmake_minimum_required(VERSION 3.5...4.0)' "$file"
    echo "Patched: $file (first line: $(head -1 "$file"))"
  done
  mkdir -p build && cd build
  export CC=clang
  export CXX=clang++
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local/netcoredbg ..
  make -j"$(nproc)"
  sudo mkdir -p /usr/local/netcoredbg
  sudo make install
  cd ../..
fi

# Write a cross-platform launcher. This ensures netcoredbg runs with
# correct DYLD_LIBRARY_PATH (macOS) or LD_LIBRARY_PATH (Linux).
# This avoids dynamic library "not found" errors regardless of $PATH or shell.
LAUNCHER_PATH="/usr/local/bin/netcoredbg"
echo "Installing cross-platform launcher script in $LAUNCHER_PATH (requires sudo)..."
cat <<'EOF' | sudo tee "$LAUNCHER_PATH" >/dev/null
#!/usr/bin/env bash
NETCOREDBG_DIR="/usr/local/netcoredbg"
if [[ "$(uname)" == "Darwin" ]]; then
  export DYLD_LIBRARY_PATH="$NETCOREDBG_DIR:${DYLD_LIBRARY_PATH:-}"
else
  export LD_LIBRARY_PATH="$NETCOREDBG_DIR:${LD_LIBRARY_PATH:-}"
fi
exec "$NETCOREDBG_DIR/netcoredbg" "$@"
EOF
sudo chmod +x "$LAUNCHER_PATH"

cd ..

echo "Verifying netcoredbg installation on PATH..."
if command -v netcoredbg &>/dev/null; then
  INSTALLED_VERSION=$(netcoredbg --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
else
  echo "netcoredbg not found on PATH after installation."
  exit 4
fi

echo "Expected version: $EXPECTED_VERSION"
echo "Installed version: $INSTALLED_VERSION"
if [[ "$INSTALLED_VERSION" == "$EXPECTED_VERSION" ]]; then
  echo "SUCCESS: netcoredbg $INSTALLED_VERSION installed and accessible via PATH."
else
  echo "WARNING: Installed netcoredbg version ($INSTALLED_VERSION) does not match release ($EXPECTED_VERSION)"
  exit 5
fi

echo "==== netcoredbg install completed ===="
exit 0
