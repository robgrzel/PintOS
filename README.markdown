# to push to docker hub
```powershell
docker login
docker tag pintos robgrzel/pintos
docker push robgrzel/pintos
```
# to pull from docker
```powershell
docker pull robgrzel/pintos
docker run -it --privileged --name pintos-container --dns=8.8.8.8 -v E:\PintOS\workspace:/home/pintos/workspace -P robgrzel/pintos /bin/bash
```

# after exit if want to connect again
## manually with getting id first
```powershell
docker ps -a 
docker start -ia pintos 
```
## or in one line
```powershell
docker start -ia (docker ps -a | grep pintos | awk '{print $1;}')
```

# to remove image or container
```powershell
docker rm (docker ps -a | grep pintos | awk '{print $1;}')
docker rmi (docker ps -a | grep pintos | awk '{print $1;}')
```
