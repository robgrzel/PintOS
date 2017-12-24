
#### FOLLOWING WILL INSTANTIATE MININET CONTAINER IN VOLUME
#create volume
docker volume create mininet

#download container (https://hub.docker.com/r/qvestor/mininet/)
docker pull qvestor/mininet

#create mininet container named mininet-container
#mount volume mininet at the (root) /mininet of container file system
#run /bin/bash to run shell inside container as root
docker run -it --privileged -v mininet:/mininet --name mininet-container qvestor/mininet /bin/bash
docker run --priviledged -h h1 --name=mininet-h1 -ti  --net='none' ubuntu /bin/bash

service openvswitch-switch start
#P.S. If error like Exception: Error creating interface pair (s1-eth1,s2-eth1): 
#RTNETLINK answers: File existsts occurs, type: mn -c to clean up mininet

#to resume after exit:
#check id with
docker ps -a
#then use "id" to resume without "" 
docker start -a -i "id"

#to remove 
#first get id
docker ps -a
#now remove without ""
docker rm "id"

#remove images with <none> name
docker rmi $(docker images -f "dangling=true" -q)

#build image with tag by -t and dockerfile in dir
docker build -t pintos "E:\PintOS\"

#docker remove all containers
docker rm $(docker ps -a -q)

#docker run interactive image with /bin/bash
docker run -it adc7e1e17105 /bin/bash

#build docker image locally
docker build -t pintos "E:\PintOS\dockerfile\local"

