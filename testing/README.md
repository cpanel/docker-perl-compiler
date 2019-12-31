
    # docker build . --no-cache

    docker rm -f mytest
    docker run --name mytest  --entrypoint "/bin/bash" -it -d at00mic/perl-compiler:perl-v5.30.0

    docker ps -a
    docker exec -it mytest bash
