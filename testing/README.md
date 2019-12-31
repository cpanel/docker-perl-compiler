
    docker build . --no-cache
    docker rm -f mytest
    docker run --name mytest  --entrypoint "/bin/bash" -it -d at00mic/test
    docker ps -a
    docker exec -it mytest bash
