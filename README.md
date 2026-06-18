# Homebrew Tap for CPA Usage Keeper

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
