# Openfortivpn docker with proxy

## Build

```
docker build -t openfortivpn .
```

## Run 

  - Run docker interactive if 2nd factor is needed, otherwise it can be run in the background without _-it_ option
```
docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v ~/Proyectos/BBVA/VPN/bbva-config:/etc/openfortivpn --name forti ripo/openfortivpn
```
  - Run debug shell
```
docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v ~/Proyectos/BBVA/VPN/bbva-config:/etc/openfortivpn --name forti --entrypoint bash ripo/openfortivpn
```
  - Run image con:
    * _`--device=/dev/ppp`_: map ppp device for openfortivpn to work
    * _`--cap-add=NET_ADMIN`_: add network capabilities when running docker imate
    * _`-p 2000:8080`_: forward port to connect to the proxy (even when VPN is UP!)
    * _`~/Proyectos/BBVA/VPN/bbva-config`_: directory with openfortivpn configuration files
```
# Run
docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v ~/Proyectos/BBVA/VPN/bbva-config:/etc/openfortivpn --name forti ripo/openfortivpn

# Debug shell
docker run --rm -it --device=/dev/ppp --cap-add=NET_ADMIN -p 2000:8080 -v ~/Proyectos/BBVA/VPN/bbva-config:/etc/openfortivpn --name forti --entrypoint bash ripo/openfortivpn
```

> _NOTE_: Glider release used:
```
 https://github.com/nadoo/glider/releases/download/v0.15.0/glider_0.15.0_linux_amd64.tar.gz
```
