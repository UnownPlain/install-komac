#!/usr/bin/env bash
set -euo pipefail

log() {
	echo "[install-komac] $*"
}

repo="${REPO:-russellbanks/Komac}"
compression="${COMPRESSION:-gz}"
linux_libc="${LINUX_LIBC:-gnu}"

case "$RUNNER_OS" in
Linux) target="unknown-linux-$linux_libc.tar.$compression" ;;
macOS) target="apple-darwin.tar.$compression" ;;
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

if [[ "$RUNNER_OS" == "Windows" ]]; then
	install_dir="$HOME/.local/bin"
	mkdir -p "$install_dir"
	output_file="$install_dir/komac.exe"
else
	install_dir="/usr/local/bin"
	cd "$(mktemp -d)"
	output_file="komac.tar.$compression"
fi

if [[ -n "${VERSION:-}" ]]; then
	version="${VERSION#v}"
	[[ "$version" != "nightly" ]] && version="v$version"
else
	version=$(curl -fsSL --retry 3 --max-time 10 \
		-H "Authorization: Bearer $GH_TOKEN" \
		"https://api.github.com/repos/$repo/releases/latest" |
		jq -r '.tag_name')
fi

asset_url="https://github.com/$repo/releases/download/$version/komac-${version#v}-$arch_norm-$target"
log "Downloading from: $asset_url"
curl -fsSL --retry 5 --max-time 10 -o "$output_file" "$asset_url"

if [[ "$RUNNER_OS" == "Windows" ]]; then
	cygpath -aw "$install_dir" >>"$GITHUB_PATH"
else
	tar -xf "$output_file"
	sudo mv komac "$install_dir"
fi

log "Successfully installed komac to $install_dir"
