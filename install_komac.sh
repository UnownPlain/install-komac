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

repo="russellbanks/Komac"

if [[ "$RUNNER_OS" == "Windows" ]]; then
	install_dir="$HOME/.local/bin"
	mkdir -p "$install_dir"
	output_file="$install_dir/komac.exe"
else
	install_dir="/usr/local/bin"
	cd $(mktemp -d)
	output_file="komac.tar.gz"
fi

if [[ -n "${VERSION:-}" ]]; then
	if [[ "$VERSION" == nightly ]]; then
		version="nightly"
	else
		version="v${VERSION#v}"
	fi
else
	version=$(curl -fsSL -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')
fi

asset_url="https://github.com/$repo/releases/download/$version/komac-${version#v}-$arch_norm-$target"

log "Downloading from: $asset_url"
curl -fsSL -o "$output_file" "$asset_url"

if [[ "$RUNNER_OS" == "Windows" ]]; then
	echo $(cygpath -aw "$install_dir") >>"$GITHUB_PATH"
else
	tar -xzf komac.tar.gz
	sudo mv komac $install_dir
fi

log "Successfully Installed komac to $install_dir"
