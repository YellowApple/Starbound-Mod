# Starbound Mod Template

This repo is a solid starting point for new Starbound mods, intended
for folks developing on Linux or macOS (wherein their native Starbound
versions don't have the graphical mod tools present in the Windows
version).  This *might* work on Windows via Windows Subsystem for
Linux, but I can make no guarantees and any support on my end will be
minimal, at best.

## What do I need to use it?

- [Starbound](https://playstarbound.com/) (obviously)
- [GNU Make](https://www.gnu.org/software/make/)
  - On Linux: install it with your package manager (usually the
    package is just called `make`)
  - On macOS: install it via [Homebrew](https://brew.sh/) (`brew
    install make`), and any time you see `make` in the below
    instructions replace it with `gmake` (so: `make upload` → `gmake
    upload`)
- [direnv](https://direnv.net/)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD), if
  you want to upload to the Steam Workshop with `make upload` per
  below

## How do I use it?

Once you've created a new repo with this as a basis (e.g. by using
this as a template for a new GitHub repo, via the relevant UI option)
and have cloned it to Starbound's `mods` folder, there will be some
starting files with which you'll want to familiarize yourself:

### `Makefile`

This is the heart of this template; if you have GNU Make installed,
you'll be able to run any of the following in the mod directory:

- `make`: generate `out/pkg/$(MODNAME).pak`
- `make upload`: generate `metadata.vdf` and
  `out/workshop/contents.pak`, then use those to create/upload the mod
  to the Steam Workshop
- `make clean`: cleanup the generated `out/` and `metadata.vdf`
  (necessary to make Starbound happy if you're developing within your
  `mods` folder, as this repo assumes)
  
You'll want to change the `MODNAME` variable at the top from
`StarboundMod` to the name of your mod.

### `_metadata`

This is Starbound's usual mod metadata; you'll want to update all of
these fields to match the mod you're actually creating.  See [the
Starbound wiki](https://starbounder.org/Modding:Basics#Metadata_File)
for more information on what this should look like.

### `.envrc.sample`

This is used with [direnv](https://direnv.net/) to automatically set
environment variables.  Run `cp .envrc.sample .envrc`, change
`STEAMCMD_USER`'s value to your Steam login name (i.e. the same one
you use to log into Steam itself), and run `direnv allow` to activate
it.  This way, any time you `cd` into your mod folder, you'll be all
set to run `make upload` for Steam Workshop uploads.

### `metadata.vdf.template`

This is used to generate `metadata.vdf`, which sets the info for the
Steam Workshop.  You'll want to change the `"title"` field to whatever
title you want to show up in the Steam Workshop.  After your first
successful upload via `make upload`, the `"publishedfileid"` field
should automatically be set to whatever ID the Steam Workshop assigned
your mod, but it's worth double-checking lest you accidentally create
duplicate mod pages the next time you run `make upload`.

### `.gitignore`

This just tells `git` to leave some files out of the repository; for
example, it's probably not a good idea to tell the whole world your
Steam login name, and it's a good practice to keep package files and
such separate from the published source code.
