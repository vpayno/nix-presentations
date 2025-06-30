# nix-presentations

My NixOS/Nix presentations & notes.

## Dev Shells

### Direnv

Using `direnv` to automatically start/stop dev shells in the project to make the
needed tools available without having to install them first.

### nix develop

`nix develop` creates a shell environment with tools like `prsenterm` without
having to install the tools since they're only needed when working/using this
project.

### nix-shell

`nix-shell` is the legacy version of `nix develop` that uses Nix Channels
instead of Nix Flakes.

### devbox shell

`devbox shell` uses nix to create a development environment.

## Tools

### tmux+presenterm

To enable special escape sequence pass-through mode in `tmux` type:

```text
:set allow-passthrough on
```

Use with care and only if you need it.

### Editor - neovim

Using the `nvf` `neovim` editor demo for editing:

```bash
nix run github:notashelf/nvf#default --
```

## Presentations

`nix run` can be used to run the Flake app to run presentation launcher.

```bash
nix run .#presentationLauncher
```
