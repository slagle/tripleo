FROM centos

ADD tripleo-virt-setup /root/tripleo-virt-setup
RUN yum -y install git sudo
RUN yum clean all
RUN ssh-keygen -N '' -f /root/.ssh/id_rsa

ENTRYPOINT ["/bin/bash"]
