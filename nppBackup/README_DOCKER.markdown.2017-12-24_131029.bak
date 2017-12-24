#to push to docker hub
docker login
docker tag pintos robgrzel/pintos
docker push robgrzel/pintos
docker volume create pintos
docker run -it --privileged -v pintos:/pintos --name pintos-container pintos /bin/bash
#after exit
docker ps -a 
docker start -ia pintos 