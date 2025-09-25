#!/usr/bin/env bash
set -euo pipefail

log() { echo "[install-komac] $*"; }

case "$RUNNER_OS" in
Linux) target="unknown-linux-gnu.tar.gz" ;;
macOS) target="apple-darwin.tar.gz" ;;
Windows) target="pc-windows-msvc.exe" ;;
*)
	log "Unsupported RUNNER_OS: $RUNNER_OS"
	exit 1
	;;
esac

case "$RUNNER_ARCH" in
X64) arch_norm="x86_64" ;;
ARM64) arch_norm="aarch64" ;;
*)
	log "Unsupported RUNNER_ARCH: $RUNNER_ARCH"
	exit 1
	;;
esac

log "Downloading asset from release"

download_args=(-R "russellbanks/Komac" -p "komac-[0-9n]*-$arch_norm-$target")

if [[ "$RUNNER_OS" == "Windows" ]]; then
	install_dir="$HOME/.local/bin"
	mkdir -p "$install_dir"
	download_args+=(-O "$install_dir/komac.exe")
else
	install_dir="/usr/local/bin"
	cd $(mktemp -d)
	download_args+=(-O "komac.tar.gz")
fi

if [[ -n "${VERSION:-}" ]]; then
	if [[ "$VERSION" == nightly ]]; then
		gh release download "$VERSION" "${download_args[@]}"
	else
		gh release download "v${VERSION#v}" "${download_args[@]}"
	fi
else
	gh release download "${download_args[@]}"
fi

if [[ "$RUNNER_OS" == "Windows" ]]; then
	echo $(cygpath -aw "$install_dir") >>"$GITHUB_PATH"
else
	tar -xzf komac.tar.gz
	sudo mv komac $install_dir
fi

log "Successfully Installed komac to $install_dir"
