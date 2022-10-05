# Run
docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v $PWD/config:/etc/openfortivpn --name forti openfortivpn

# Debug
# docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v $PWD/config:/etc/openfortivpn --name forti --entrypoint bash openfortivpn-debug
