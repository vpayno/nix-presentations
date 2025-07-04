---
title: Why Nix?
author: Victor Payno
theme:
  name: gruvbox-dark
  override:
    default:
      colors:
        background: "000000"
options:
  incremental_lists: false
---

<!-- speaker_note: |
- Quick look to the questions of why I use Nix and why you probably want to as well.
- Nerdy details will be provided in other presentations, this slide deck is just a quick into.
-->

# Why Nix?

<!-- incremental_lists: true -->

- TLDR: Because I want my software to always build and run anytime, anywhere.

- Use Nix flakes when you want to make sure everyone can always build and run
  your software.

- Nix is the package manager that takes control away from distributions and give
  it to users.

- Data Science, AI, HPC, Finance, etc. use Nix to make sure their code compiles
  and runs the same way everywhere without hidden instructions that are time and
  system dependent.

- Cross-compiling in Nix is built in. Nix takes care of everything for you.

- Nix can build `Darwin` and `Windows` executables from Linux and vice-versa.

- Pure Nix flake builds and locks means flakes always build.

- Nix flakes can build and configure tools, packages, bare-metal hosts, VMs and
  docker images with Nix.

- Nix can manage your dotfiles, editors and other applications on your
  workstation and on a server.

- No more "it worked on my machine last week" problems.

- No more "the Dockerfile worked last week" problems.

- No more "CI was working this morning" problems.

- No more "ansible/apt/rpm deploys breaking mid-fleet deploy " problems.

- Changes are atomic because it's all symlinks to the `/nix/store`.

- Rollbacks are atomic and "immediate".

- Rollbacks can be performed at the boot loader, system, user, and configuration
  system levels.

<!-- end_slide -->

# TLDR: Because I want my software to always build and run anytime, anywhere

- Nix will work on most Linux systems and architectures.
  - x86_64, aarch64, riscv64, armv6l, armv7l, powerpc64le

<!-- pause -->

- Also works on
  - MacOS/Darwin x86_64, aarch64
  - FreeBSD x86_64

<!-- speaker_note: |
  blah
  blah
-->

<!-- pause -->

- Nix can cross-compile to over 70 targets.

<!-- end_slide -->

# Nix Cross Compile Targets (77)

<!-- column_layout: [1,1,1] -->

<!-- column: 0 -->

- aarch64-android
- aarch64-android-prebuilt
- aarch64-darwin
- aarch64-embedded
- aarch64-freebsd
- aarch64-multiplatform
- aarch64-multiplatform-musl
- aarch64be-embedded
- arm-embedded
- arm-embedded-nano
- armhf-embedded
- armv7a-android-prebuilt
- armv7l-hf-multiplatform
- avr
- ben-nanonote
- bluefield2
- fuloongminipc
- ghcjs
- gnu32
- gnu64
- gnu64_simplekernel
- i686-embedded
- iphone64
- iphone64-simulator
- loongarch64-linux
- loongarch64-linux-embedded

<!-- column: 1 -->

- m68k
- microblaze-embedded
- mingw32
- mingwW64
- mips-embedded
- mips-linux-gnu
- mips64-embedded
- mips64-linux-gnuabi64
- mips64-linux-gnuabin32
- mips64el-linux-gnuabi64
- mips64el-linux-gnuabin32
- mipsel-linux-gnu
- mmix
- msp430
- musl-power
- musl32
- musl64
- muslpi
- or1k
- pogoplug4
- powernv
- ppc-embedded
- ppc64
- ppc64-elfv1
- ppc64-elfv2
- ppc64-musl
- ppcle-embedded

<!-- column: 2 -->

- raspberryPi
- remarkable1
- remarkable2
- riscv32
- riscv32-embedded
- riscv64
- riscv64-embedded
- riscv64-musl
- rx-embedded
- s390
- s390x
- sheevaplug
- ucrt64
- ucrtAarch64
- vc4
- wasi32
- wasm32-unknown-none
- x86_64-darwin
- x86_64-embedded
- x86_64-freebsd
- x86_64-netbsd
- x86_64-netbsd-llvm
- x86_64-openbsd
- x86_64-unknown-redox

<!-- reset_layout -->

<!-- end_slide -->

# Time and Place Dependency of Traditional Package Managers

<!-- incremental_lists: true -->

- `emerge sync`, `apt update`, `yum update`, et cetera aren't reproducible
  because their `update` function can produce different results every time they
  are run.

  - Their results aren't' content addressable either so you can go back in time
    or freeze time.

    - No, copying the update cache from one host to another isn't freezing time,
      it's a nightmare for you and other users/admins.

    - It needs to be content address fetchable on demand.

- There are two versions of Nix, traditional/legacy/channels and flakes.

  - Flakes fix the problem of time and place dependency on builds and execution.

- Using Nix flakes locks allows us to freeze time and always get the same result
  regardless of when you run it.

- Pure builds with flakes allow us to always get the same result regardless of
  time and place.

- Because `nixpkgs` and other flake inputs are content addressable, you can even
  go back in time to the last time the flake worked or a package use to be
  available.

  - You can even have multiple `nixpkgs` inputs in a flake, one for now and one
    for last year for instance and pick and choose the things you need from the
    old one while keeping everything else up to date with the latest one.

  - For example, you can setup `nixpkgs-mongo3` to a hash when MongoDB 3.6 was
    available so you can use an old mongo version while keeping `nixpkgs`, the
    rest of the flake/OS, up to date.

<!-- end_slide -->

# Dependency Hell of Traditional Package Managers

Traditional package managers have a single dependency tree for all the installed
applications.

<!-- incremental_lists: true -->

- If something needs an old library, everything else on the system that needs
  that library needs to be OK with the older version.

- You are also not installing random libraries because you might need them. If
  your applications need them, they're part of their dependency tree.

- Sometimes you need multiple versions of a compiler to build different packages
  but you can only have one available in your `PATH` or you have a bunch of
  versioned versions of the commands in your `PATH`.

  - With Nix, compilers, libraries, headers, et cetera are build inputs, you
    don't have to have them installed at all.

  - Build inputs are stored in `/nix/store` so they're shared with all builds.

  - Because build inputs don't have to be installed and are assembled as inputs
    for a specific build, you can have multiple versions without them stepping
    on each other.

  - You no longer have to Google for which `-dev` or `-lib` package you're
    missing or the missing build manual for the thing you're trying to build.

<!-- end_slide -->

# No Missing Build Instructions, Inconsistent Build Environments

In the days of yore when trying to build software off the Internet, one had to

<!-- incremental_lists: true -->

- read the `README.md` file in a repo

- then read configure, Make/Cmake files, et cetera

- use Google to see if someone else posted the missing part(s) of instructions
  somewhere

- keep retrying until your system matched the intended build environment

With Nix flakes, you no longer have to Google for which `-dev` or `-lib` package
you're missing for the thing you're trying to build.

- It's a pure build environment so Nix will have the information it needs to
  recreate the temporary build environment.

- You don't have to install, uninstall, upgrade, downgrade build dependencies on
  your system when building different pieces of software.

  - That prevented you from working on more than one project at a time when they
    had conflicting version dependencies.

  - With Nix, each project has it's own build time dependency tree and you don't
    have to uninstall anything after you're done.

<!-- end_slide -->

# Python Dependency Hell

Python can be hell, specially when older programs only work with an older
version but you have a newer version.

<!-- incremental_lists: true -->

- Gentoo supports multiple Python versions simultaneously; However their time in
  the tree is limited and eventually will be removed and ebuilds will stop
  referencing it even if it's still installed.

- In other Linux distros, specially when using Docker files, people do silly
  things like running pip, usually without a virtual env to install Python
  packages.

- With Nix you have a lot of options on how you can install your Python packages
  and even how you manage it's dependency tree independently from other Nix
  packages on the system.

- You no longer need to suffer pip's sloppy package dependency version
  matchmaking and can make sure your applications are always using the correct
  version of a dependency, not a just a close enough one.

- All the Python applications on the system share the same `/nix/store` so no
  duplication or virtual env management nightmares on a fleet of servers.

- Some will use containers to create an independent dependency tree but that
  comes with extra disk space, unreliable/sloppy build systems, can make
  networking more difficult, et cetera.

<!-- end_slide -->

# Hiding Runtime Dependencies with Nix Wrappers

<!-- incremental_lists: true -->

Since you can only have one version of a program in `PATH` at a time unless all
the binaries are versioned, using Nix wrappers allows different programs to
coexist on a system without having the same versions of shared dependencies.

Wrappers enable programs to

- have private `PATH`, `LD_LIBRARY_PATH`, variables with the versions it needs
  without braking other programs.

- not pollute the user's default environment with unneeded programs.

- hide complexities of installation like Python virtual environments.

<!-- end_slide -->

# Problems with Docker files

<!-- incremental_lists: true -->

- Docker files are complicated and fragile bash scripts.

- Docker files make it really easy to leave garbage behind in every layer that
  needlessly adds to the size of the container.

- Docker files have poor layer management, huge layers make updates large, not
  small.

- No daisy-chained Docker files or builds required to build applications to then
  copy them into the final container.

- Multi-container builds create container clutter.

- Docker files promote manual, impure builds that may not work on other's
  computers or break over time.

- A Docker file's inputs aren't content addressable, usually it's whatever is
  currently the latest version or a specific version that may get
  redefined/updated over it's life cycle.

<!-- end_slide -->

# Things that Nix does better than a Dockerfile

<!-- incremental_lists: true -->

- Everything is build using reproducible recipes.

- Flake lock files freeze time.

- Containers can be built, anytime, any where.

- All inputs are content addressable and known. Things change when you say they
  can change.

- Nix builds slim, fairly immutable but extendable containers. The goal is pure,
  reproducible builds, not impure ones.

<!-- end_slide -->

# dev-containers

<!-- incremental_lists: true -->

dev-containers are interesting but are difficult to use, update and they waste a
lot of space.

- You end up with a lot of duplicated space.

- Packages from the containers aren't shared between the dev-containers (the
  Docker files from different repos aren't going to create shared layers).

- Editors/IDEs need special support to work with dev-containers.

- Docker files are impure and irreproducible, every user will end up with a
  different container unless you publish it first.

- dev-containers can be huge (10+ GB), docker is a pain with large images.

<!-- end_slide -->

# nix shells

<!-- incremental_lists: true -->

Nix shells are what dev-containers wished they were.

- Don't use containers (except for `nixos-shell` which uses VMs).

- All the content used by Nix shells reside in `/nix/store` so no needless
  duplication.

- Each repo can have a dedicated shell(s) defined in a text file or use a shared
  one from another repo.

- All changes to the shell are documented and immune to time and place problems.

  - Not all packages can compile everywhere, so Ceph can't be used in a shell on
    `darwin` for example.

    - Ceph on Darwin is a good example of using dev-containers (which runs in a
      Linux VM on MacOS).

    - TODO: see if `nixos-shell` (runs the nix shell in a Linux VM) works on
      MacOS.

- Add `direnv` to your dotfiles and you'll automatically enter and exit your
  developer environments as you navigate your checked out repos.

<!-- end_slide -->

# Things Nix Flakes can do that Traditional Package Managers can't (1/2)

<!-- incremental_lists: true -->

Nix is a functional language, a DSL, a package manager, Operating System, ...

- Nix is purpose built, not a general language so you can't compare it to
  general purpose languages like Rust.

- If you know Lisp, Haskell, you'll find Nix familiar territory.

Nix is also a DSL when being used with tools like NixOS Configuration or
Home-Manager.

Package manager with, if you barely scratch the surface, you'll be using
`nix profile install nixpkgs#name` a lot.

An operating system, NixOS, defined via `configure.nix` (legacy) or `flake.nix`
(modern).

- With flakes, NixOS is reproducible anytime, any where.

And a lot more...

<!-- end_slide -->

# Things Nix Flakes can do that Traditional Package Managers can't (2/2)

<!-- incremental_lists: true -->

A flake has several outputs, the more frequently used ones are `packages` and
`devShells`.

- packages can be a single package, a script, a bundle, VM image, docker image,
  sdcard image, iso image, et cetera.

- basically, anything that can be a directory or a file can be a package output.

- we also have streamed outputs that are piped into other programs.

Other outputs include `apps`, `formatter`, `homeConfigurations`,
`nixosConfigurations`.

- apps: Applications accessed via `nix run`. If a `package` has a `mainProgram`
  defined, it can also be accessed via `nix run`.

- formatter: Usually used with `treefmt` to format the repo. Run with `nix fmt`.

- homeConfigurations: home-manager configurations.

- nixosConfigurations: NixOS configurations.

<!-- end_slide -->

# Conclusion

With all of the different Nix flake outputs, 120k packages in nixpkgs,
architecture and operating systems support, Nix is the first and last word in
everything management.

<!-- end_slide -->

# The End
