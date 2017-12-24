FROM centos:6.6
MAINTAINER Robert Grzelka <robert.grzelka@outlook.com>
#BASED ON: https://github.com/yhpark/dockerfile-pintos-kaist
#...https://github.com/JohnStarich/docker-pintos/blob/master/Dockerfile
#...https://hub.docker.com/r/hangpark/pintos-dev-env-kaist/

### INFO
#this file is meant to build remotely
###

RUN yum install -y compat-gcc-34 compat-gcc-34-c++ \
					tar patch ncurses-devel ncurses\
					git compat-glibc-headers \
					perl gdb libGL SDL libaio alsa-lib\ 
					bluez-libs celt051 esound-libs gnutls \
					libjpeg-turbo pixman libpng pulseaudio-libs\
					spice-server xpra rox-filer openssh-server \
					pwgen xserver-xephyr xdm fluxbox xvfb sudo \
					firefox xterm


					
RUN ln /usr/bin/gcc34 /usr/bin/gcc
RUN ln /usr/bin/g++34 /usr/bin/g++

RUN cp -r /usr/lib/x86_64-redhat-linux5E/include/* /usr/local/include/			
			
ENV user pintos

#################################### PINTOS SETTINGS #########################

#write env variables
ENV setup_dir /home/pintos/setup
ENV pintos_dir /home/pintos

#create volume that will appear at runtime mounted
VOLUME [$pintos_dir]

RUN mkdir -p $pintos_dir
RUN mkdir -p $setup_dir


#RUN git clone https://github.com/robgrzel/PintOS /tmp/$pintos_dir
#RUN mv /tmp/pintos/* $pintos_dir
#RUN ls -la
#RUN mv /PintOS/* $pintos_dir

WORKDIR $setup_dir

ADD setup $setup_dir
ADD pintos $pintos_dir/pintos
ADD pintos-misc $setup_dir/pintos/src/misc/
ADD pintos-utils $setup_dir/pintos-utils/

RUN ls -la $pintos_dir
RUN ls -la $setup_dir

#RUN mv $pintos_dir/bochs-2.2.6.tar.gz $setup_dir/
#RUN mv $pintos_dir/qemu-0.15.0-1.el6.rfx.x86_64.rpm  $setup_dir/
#RUN mv $pintos_dir/qemu-img-0.15.0-1.el6.rfx.x86_64.rpm  $setup_dir/

RUN chmod -R 777 $setup_dir/pintos/src/misc
RUN chmod 777 $setup_dir/pintos/src/misc/bochs-2.2.6-build.sh
RUN SRCDIR=$setup_dir DSTDIR=/usr/ PINTOSDIR=$setup_dir/pintos $setup_dir/pintos/src/misc/bochs-2.2.6-build.sh
RUN rpm -i $setup_dir/qemu-img-0.15.0-1.el6.rfx.x86_64.rpm
RUN rpm -i $setup_dir/qemu-0.15.0-1.el6.rfx.x86_64.rpm

WORKDIR $setup_dir/pintos-utils/

RUN make

WORKDIR $pintos_dir

env PATH $setup_dir/pintos-utils/:$PATH

			
#################################### SSH SETTINGS ####################################

# Configuring xdm to allow connections from any IP address and ssh to allow X11 Forwarding. 
RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config
RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess
RUN ln -s /usr/bin/Xorg /usr/bin/X
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Fix PAM login issue with sshd
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

EXPOSE 22

ADD ssh_startup.sh $pintos_dir
RUN chmod 777 $pintos_dir/ssh_startup.sh
CMD ["/bin/bash", $pintos_dir/ssh_startup.sh]
