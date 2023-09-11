# Git LFS Dockerfiles

These Dockerfiles are designed specifically for use with the `git-lfs/git-lfs`
project.  See the `docker` directory in that project for more information
on how to use these Dockerfiles.

## Building Docker Images

The top-level script to build all the Docker images in this project
may be run as:

```
$ ./build_dockers.bsh
```

## Adding Docker Images

To add another Docker image, simply follow the existing pattern.
A new Dockerfile should be named:
```
{OS NAME}_{OS VERSION}.Dockerfile
```
where `{OS NAME}` and `{OS VERSION}` must not contain underscores (\_).

The Docker image should run a script that builds Git LFS from its
source files, which will be available in the `/src` directory inside the
container.  This directory may be assumed to be a mounted volume containing
a copy of the `git-lfs/git-lfs` project.  This files in this directory
should not be modified by the build script; instead, the build output should
be written to the `/repo` directory, which will be a separate mounted volume
in the container.

Depending on the operating system and version, a Docker image may need to
install Go, Ruby, Git, and other tools before running the script to build
Git LFS.

## Updating Go Versions

To update all the Dockerfiles and the top-level script so they use a
new version of the Go language, the `update-hashes` script may be run as:

```
$ ./update-hashes {GO VERSION}
```

This script will also update the SHA-256 hashes expected for the Go release
packages so the build scripts will continue to validate the Go distribution
used to build Git LFS.
