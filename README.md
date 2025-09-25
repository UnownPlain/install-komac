# Install komac Action

Cross-platform action to install [komac](https://github.com/russellbanks/Komac).

## Usage

```yaml
- name: Install komac
  uses: UnownPlain/install-komac@main
# with:
#   version: nightly
```

## Options

- `version`: komac version to install. Supports any version 2.3.0+ or nightly.
  - **Required**: ❌ Installs latest stable version by default.
  - **Example**: `version: 2.13.0`, `version: nightly`
- `github_token`: GitHub token for API rate limit.
  - **Required**: ❌ Uses the default `GITHUB_TOKEN` present in runner.

## Supported Runners:

- `windows-2025`
- `windows-11-arm`
- `ubuntu-24.04`
- `ubuntu-24.04-arm`
- `macos-26`
- `macos-15-intel`

> [!NOTE]  
> Other runner images will likely work, but aren't tested.
