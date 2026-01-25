# install-komac Action [![License][license-badge]][license-link]

[license-badge]: https://img.shields.io/github/license/UnownPlain/install-komac?style=for-the-badge&labelColor=0c0d10&color=3a71c1&&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEwLjk2ODQgMi4zMjQ2NUMxMS41ODMgMS44NzYxNiAxMi40MTcgMS44NzYxNiAxMy4wMzE2IDIuMzI0NjVMMjAuNDUzNCA3Ljc0MDZDMjEuNDI5OSA4LjQ1MzE1IDIwLjkyNjggOS45OTgzNSAxOS43MTg5IDEwLjAwMDNINC4yODEwOEMzLjA3MzE4IDkuOTk4MzUgMi41NzAxMSA4LjQ1MzE1IDMuNTQ2NTcgNy43NDA2TDEwLjk2ODQgMi4zMjQ2NVpNMTMgNi4yNTAzNEMxMyA1LjY5ODA1IDEyLjU1MjMgNS4yNTAzNCAxMiA1LjI1MDM0QzExLjQ0NzcgNS4yNTAzNCAxMSA1LjY5ODA1IDExIDYuMjUwMzRDMTEgNi44MDI2MiAxMS40NDc3IDcuMjUwMzQgMTIgNy4yNTAzNEMxMi41NTIzIDcuMjUwMzQgMTMgNi44MDI2MiAxMyA2LjI1MDM0WiIgZmlsbD0iIzNhNzFjMSIvPgo8cGF0aCBkPSJNMTEuMjUgMTYuMDAwM0g5LjI1VjExLjAwMDNIMTEuMjVWMTYuMDAwM1oiIGZpbGw9IiMzYTcxYzEiLz4KPHBhdGggZD0iTTE0Ljc1IDE2LjAwMDNIMTIuNzVWMTEuMDAwM0gxNC43NVYxNi4wMDAzWiIgZmlsbD0iIzNhNzFjMSIvPgo8cGF0aCBkPSJNMTguNSAxNi4wMDAzSDE2LjI1VjExLjAwMDNIMTguNVYxNi4wMDAzWiIgZmlsbD0iIzNhNzFjMSIvPgo8cGF0aCBkPSJNMTguNzUgMTcuMDAwM0g1LjI1QzQuMDA3MzYgMTcuMDAwMyAzIDE4LjAwNzcgMyAxOS4yNTAzVjE5Ljc1MDNDMyAyMC4xNjQ1IDMuMzM1NzkgMjAuNTAwMyAzLjc1IDIwLjUwMDNIMjAuMjVDMjAuNjY0MiAyMC41MDAzIDIxIDIwLjE2NDUgMjEgMTkuNzUwM1YxOS4yNTAzQzIxIDE4LjAwNzcgMTkuOTkyNiAxNy4wMDAzIDE4Ljc1IDE3LjAwMDNaIiBmaWxsPSIjM2E3MWMxIi8+CjxwYXRoIGQ9Ik03Ljc1IDE2LjAwMDNINS41VjExLjAwMDNINy43NVYxNi4wMDAzWiIgZmlsbD0iIzNhNzFjMSIvPgo8L3N2Zz4K
[license-link]: https://github.com/UnownPlain/install-komac/blob/HEAD/LICENSE.md

Cross-platform action to install [komac](https://github.com/russellbanks/Komac).

## Example Usage

```yaml
- name: Install komac
  uses: UnownPlain/install-komac@b74704bf4efcae71fe5b5b21fe5dde889da57714 # v1
- name: Update Package
  run: komac update foo.bar --version "$VERSION" --urls "https://example.com/downloads/$VERSION/installer.msix" --submit
  env:
    VERSION: ${{ github.event.release.tag_name }}
    GITHUB_TOKEN: ${{ secrets.WINGET_TOKEN }}
```

> [!NOTE]  
> It's highly recommend to pin all actions to a commit hash for [security](https://docs.github.com/en/actions/reference/security/secure-use#using-third-party-actions) [reasons](https://nesbitt.io/2025/12/06/github-actions-package-manager). Tools such as [Renovate](https://docs.renovatebot.com/) or [Dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide) can automatically keep your actions up to date.

## Options

- `version`: komac version to install. Supports any version 2.3.0+ or nightly.
  - **Required**: ❌ Installs the latest stable version by default.
  - **Example**: `version: 2.13.0`, `version: nightly`
- `repo`: Custom GitHub repository to download komac from.
  - **Required**: ❌ Uses russellbanks/Komac by default.
  - **Example**: `octocat/Komac`
- `github_token`: GitHub token for API rate limit.
  - **Required**: ❌ Uses the default `GITHUB_TOKEN` present in runner.

## Supported Runners

- `windows-2025`
- `windows-11-arm`
- `ubuntu-24.04`
- `ubuntu-24.04-arm`
- `ubuntu-slim`
- `macos-26`
- `macos-15-intel`

> [!NOTE]  
> Other runner images will likely work, but aren't tested.
