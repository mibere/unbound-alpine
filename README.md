[![Build](https://github.com/mibere/unbound-alpine/actions/workflows/publish-image.yml/badge.svg?branch=main)](https://github.com/mibere/unbound-alpine/actions/workflows/publish-image.yml)

Image for my personal use, not for the general public. Based on [Alpine Linux (edge)](https://www.alpinelinux.org/).

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

### Preparations on the host
```
sudo nano /etc/sysctl.d/99-sysctl.conf
```

> net.ipv6.conf.all.disable_ipv6 = 1  
> net.core.rmem_default = 2097152  
> net.core.rmem_max = 4194304  
> net.core.wmem_default = 2097152  
> net.core.wmem_max = 4194304  
> #net.core.somaxconn = (a minimum value of 256)

```
sudo sysctl -p
```

### Start container for the first time
```
docker run --name=unbound --restart=always --cap-add=SYS_NICE --network=host -d ghcr.io/mibere/unbound-alpine
```

### Update existing container
```
docker stop unbound
docker rm unbound
docker pull ghcr.io/mibere/unbound-alpine
docker run --name=unbound --restart=always --cap-add=SYS_NICE --network=host -d ghcr.io/mibere/unbound-alpine
```
<br/>
:point_right: Unbound is listening on port 8253
