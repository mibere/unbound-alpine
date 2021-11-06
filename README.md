[![Build](https://github.com/mibere/unbound-alpine/actions/workflows/publish-image.yml/badge.svg?branch=main)](https://github.com/mibere/unbound-alpine/actions/workflows/publish-image.yml)

_Image for my personal use, not for the general public._

### Download pre-built Docker image for _armv7_
```
docker pull ghcr.io/mibere/unbound-alpine
```

### or build locally
```
mkdir ~/docker-builds
cd ~/docker-builds
git clone https://github.com/mibere/unbound-alpine.git
cd unbound-alpine
docker build -t unbound-alpine --pull --no-cache .
docker rmi $(docker images -qa -f "dangling=true")
```

### Start container
```
docker run --name=unbound --restart=always --network=host --security-opt seccomp=unconfined -d ghcr.io/mibere/unbound-alpine
```

### Update container
```
docker stop unbound
docker rm unbound
docker pull ghcr.io/mibere/unbound-alpine
docker run --name=unbound --restart=always --network=host --security-opt seccomp=unconfined -d ghcr.io/mibere/unbound-alpine
```
