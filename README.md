# 🏡 benchi

## Bootstrap

Fresh machine:

```sh
./scripts/bootstrap-from-github.sh
```

Existing checkout:

```sh
./scripts/bootstrap.sh
```

The bootstrap flow now does four things end to end:

1. installs system packages, native apps, and language/toolchain managers
2. links Casa-managed config into `~/.config` and the home-directory entrypoints that still need to exist (`~/.zshrc`, `~/.zshenv`, `~/.tmux.conf`, etc.)
3. provisions Neovim dependencies, Python provider envs, Node globals, and fonts
4. keeps Casa as a normal git checkout in `~/Developer/casa`

Package manifests live under [`packages/`](packages/). Native apps are driven by [`packages/apps.txt`](packages/apps.txt) and per-app installers under [`scripts/apps/`](scripts/apps/). The bootstrap scripts treat these manifests as the source of truth instead of the old one-off `brew_packages`/`package.json` files.

Manual follow-up items that are still intentionally not automated are documented in [`packages/manual-setup.txt`](packages/manual-setup.txt).

[Project Bootstrap Notion](https://www.notion.so/Project-Bootstrap-6b9156f85daa49bda8d53a46b34500e1)

## Vim Configuration

`nvim/lua/` holds all vim configuration files most notably `plugins.lua` and `init.lua`.

`nvim/lua/plugin/packer_compiled.lua` is a generated file.

## Misc.

### vim-kitty-navigator

https://sw.kovidgoyal.net/kitty/faq/#how-do-i-specify-command-line-options-for-kitty-on-macos

This setup is key for using hjkl navigation for all panes in a window seamlessly within vim and kitty terminal.

1. Make sure the pass_keys and get_layout code is right and being called
2. Use cmdline options so kitty listens for messages from vim
    * i've had this break before. navigation works partially but doesn't work in vim splits/panes. when this happens it's likely because kitty wasn't started with the options

-- Latest --

```log
-2)][☁️  g@engi.network][⏱ 11s]
❯ pstree -p 48933    
ps -ef --forest | grep 48933
-+= 00001 root /sbin/launchd
 \-+= 47965 g kitty -o allow_remote_control=yes --single-instance --listen-on unix:/tm
   \-+= 48933 root /usr/bin/login -f -l -p g /Applications/kitty.app/Contents/MacOS/ki
     \-+- 48950 g zsh (qterm)
       \-+= 49715 g /bin/zsh --login
         \-+= 78791 g nvim /Users/g/Developer/Casa/README.md
           \-+= 78808 g nvim --embed /Users/g/Developer/Casa/README.md
             |--= 09389 g node /Users/g/.local/share/nvim/mason/bin/pyright-langserver
             |--= 79557 g node /Users/g/.local/share/nvim/mason/bin/tailwindcss-langua
             \--= 88435 g /Users/g/.local/share/nvim/mason/packages/lua-language-serve
```

Essentially, the process of the keypress was too high to detect. Simple change to search beneath.

### Installing python packages to workbench environments

Workbench itself has environments (like any source) where dependencies are installed.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
</dict>
</plist>
```

```
sudo codesign --remove-signature /Applications/kitty.app
sudo codesign --deep --force --options runtime --entitlements ~/kitty_entitlements.plist -s - /Applications/kitty.app
```

Resigning kitty to allow for sourcing packages from .venv. Now can install anything into that venv and use in scripts used by kitty (such as now psutil in pass_keys).

```
source ~/.workbench/bin/activate
pip install psutil
```
