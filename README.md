# softforge-cxpm-docker-amazonlinux

A ready-to-use build image for Soft Forge projects on Amazon Linux 2023. It starts with `cxpm` installed and a current compiler already in place, so a project can be built in a clean container without any setup.

## What is inside

- Amazon Linux 2023 base.
- GCC 14 (C and C++), available under the usual names `gcc`, `g++`, `cc`, and so on.
- `cmake`, `make`, `git`, `tar`, `gzip`, `curl`.
- `rpm-build`, to produce RPM packages.
- `bubblewrap`, `openssl-devel` and `openssh-clients`.
- `cxpm` 0.4.0, installed for the `builder` user in `~/.local`.

The container runs as the non-root user `builder` (home `/home/builder`), with an empty `~/.ssh` ready for keys.

## Build the image

```sh
docker build -t softforge-cxpm-amazonlinux .
```

The build downloads `cxpm` from `https://soft-forge.dev/cxpm/download/` and ends by running `cxpm help`. The build fails if the install is broken.

## Use it

Open a shell:

```sh
docker run --rm -it softforge-cxpm-amazonlinux
```

Build a project from the current directory:

```sh
docker run --rm -it \
  -v "$PWD":/home/builder/work -w /home/builder/work \
  softforge-cxpm-amazonlinux cxpm help
```

To fetch private repositories over SSH, mount your keys and known hosts:

```sh
docker run --rm -it \
  -v "$HOME/.ssh":/home/builder/.ssh:ro \
  softforge-cxpm-amazonlinux
```

## Updating the `cxpm` version

Edit the version in the `Dockerfile` (the download URL and the directory name both carry it), then rebuild.

## Files

- `Dockerfile`: the image definition.
