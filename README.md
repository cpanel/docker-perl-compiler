# Docker container for the Perl Compiler

## Sumary

Docker container recipes to build Perl with a few extra patches required by the Perl Compiler.
The goal is to provide a docker container to speedup the [Perl Compiler](https://github.com/atoomic/perl-compiler) testsuite.

You can view the [last testsuite run here](https://github.com/atoomic/perl-compiler/actions).

The docker containers are available from the public docker hub [at00mic/perl-compiler](https://hub.docker.com/repository/docker/at00mic/perl-compiler/general).

## Tips & Tricks

### Rebuilding the image

You should not need to rebuild the container, and prefer using the one from upstream.
Docker images are automatically build and published on pushes.

You can trigger a manual build locally using:

    docker build . --no-cache

### Testing a container

You can test locally the container by overriding the entrypoint then bash to it.
Adjust the tag `at00mic/perl-compiler:perl-v5.30.0` to point to any other flavor you want.
(for example `at00mic/perl-compiler:latest`)

    docker pull at00mic/perl-compiler:perl-v5.30.0
    docker rm -f mytest
    docker run --name mytest  --entrypoint "/bin/bash" -it -d at00mic/perl-compiler:perl-v5.30.0

    docker ps -a
    docker exec -it mytest bash
