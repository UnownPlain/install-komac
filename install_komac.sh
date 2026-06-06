#!/usr/bin/env bash
set -euo pipefail

log() {
	echo "[install-komac] $*"
}

repo="${REPO:-russellbanks/Komac}"
compression="${COMPRESSION:-gz}"
linux_libc="${LINUX_LIBC:-gnu}"

case "$RUNNER_OS" in
Linux | macOS)
	case "$compression" in
	tar)
		archive_suffix="tar"
		tar_args=(-xf -)
		;;
	gz | gzip)
		archive_suffix="tar.gz"
		tar_args=(-xzf -)
		;;
	bz2 | bzip2)
		archive_suffix="tar.bz2"
		tar_args=(-xjf -)
		;;
	xz)
		archive_suffix="tar.xz"
		tar_args=(-xJf -)
		;;
	zst | zstd)
		archive_suffix="tar.zst"
		tar_args=(--zstd -xf -)
		;;
	*)
		log "Unsupported compression: $compression"
		exit 1
		;;
	esac

	if [[ "$RUNNER_OS" == "Linux" ]]; then
		target="unknown-linux-$linux_libc.$archive_suffix"
	else
		target="apple-darwin.$archive_suffix"
	fi
	;;
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

install_dir="$HOME/.local/bin"
mkdir -p "$install_dir"

if [[ "$RUNNER_OS" == "Windows" ]]; then
	output_file="$install_dir/komac.exe"
fi

if [[ -n "${VERSION:-}" ]]; then
	version="${VERSION#v}"
	[[ "$version" != "nightly" ]] && version="v$version"
else
	version=$(
		u=$(curl -fsSI -o /dev/null -w '%header{location}' https://github.com/russellbanks/Komac/releases/latest)
		printf '%s' "${u##*/}"
	)
fi

asset_url="https://github.com/$repo/releases/download/$version/komac-${version#v}-$arch_norm-$target"
log "Downloading from: $asset_url"

if [[ "$RUNNER_OS" == "Windows" ]]; then
	curl -fsSL --retry 5 --max-time 10 -o "$output_file" "$asset_url"
	cygpath -aw "$install_dir" >>"$GITHUB_PATH"
else
	curl -fsSL --retry 5 --max-time 10 "$asset_url" |
		tar "${tar_args[@]}" -C "$install_dir" komac
	echo "$install_dir" >>"$GITHUB_PATH"
fi

log "Successfully installed komac to $install_dir"
