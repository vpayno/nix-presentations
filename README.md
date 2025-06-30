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
