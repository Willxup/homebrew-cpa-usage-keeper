# Homebrew Tap for CPA Usage Keeper

Choose a release line:

| Formula | Release line |
| --- | --- |
| `cpa-usage-keeper` | Current stable release; upgrades can move to a newer major version |
| `cpa-usage-keeper@1` | v1 maintenance releases |

## Current stable release

Install CPA Usage Keeper on macOS with Homebrew:

```sh
brew tap Willxup/cpa-usage-keeper
brew install cpa-usage-keeper
```

Configure the service before starting it:

```sh
vim "$(brew --prefix)/etc/cpa-usage-keeper.env"
brew services start cpa-usage-keeper
```

Upgrade to the latest release:

```sh
brew update
brew upgrade cpa-usage-keeper
brew services restart cpa-usage-keeper
```

## Stay on v1

```sh
brew tap Willxup/cpa-usage-keeper
brew install cpa-usage-keeper@1
vim "$(brew --prefix)/etc/cpa-usage-keeper@1.env"
brew services start cpa-usage-keeper@1
```

Upgrade within v1:

```sh
brew update
brew upgrade cpa-usage-keeper@1
brew services restart cpa-usage-keeper@1
```

The v1 formula is keg-only, so it does not replace the default `cpa-usage-keeper`
command. To run it directly, use
`"$(brew --prefix cpa-usage-keeper@1)/bin/cpa-usage-keeper"`.

Each formula uses separate paths under `$(brew --prefix)`:

| Path | Current stable | v1 |
| --- | --- | --- |
| Configuration | `etc/cpa-usage-keeper.env` | `etc/cpa-usage-keeper@1.env` |
| Data (`WORK_DIR`) | `var/cpa-usage-keeper` | `var/cpa-usage-keeper@1` |
| Service log | `var/log/cpa-usage-keeper.log` | `var/log/cpa-usage-keeper@1.log` |
| Service error log | `var/log/cpa-usage-keeper.err.log` | `var/log/cpa-usage-keeper@1.err.log` |

Both services default to port `8080`. Run one at a time, or configure different
ports and keep their data directories separate.

### Switch an existing v1 installation to the v1 formula

Do this while the existing application and database are still v1:

1. Stop the existing service with `brew services stop cpa-usage-keeper`.
2. Back up its configuration and complete `WORK_DIR`, then install
   `cpa-usage-keeper@1`.
3. Copy the stopped v1 data into `$(brew --prefix)/var/cpa-usage-keeper@1`.
   Transfer the existing configuration to
   `$(brew --prefix)/etc/cpa-usage-keeper@1.env`, setting `WORK_DIR` to the new
   directory. Review custom paths before starting the service.
4. Start v1 with `brew services start cpa-usage-keeper@1`.

Installing `@1` does not move existing data automatically. Do not point it at a
database already migrated by v2 or a later version.
