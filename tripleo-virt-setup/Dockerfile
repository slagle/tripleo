FROM centos

RUN yum -y install git sudo
RUN yum clean all
RUN ssh-keygen -N '' -f /root/.ssh/id_rsa
ADD tripleo-virt-setup /root/tripleo-virt-setup

ENTRYPOINT ["/bin/bash"]
