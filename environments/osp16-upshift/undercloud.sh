set -eux

sudo dnf localinstall -y http://download.lab.bos.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm
sudo rhos-release 16.1
sudo dnf -y install git bash-completion tmux python3-tripleoclient expect tripleo-ansible libibverbs git

cat >~/.tmux.conf<<EOF
# Prefix key
set-option -g prefix2 C-a
bind-key C-a send-prefix -2
bind-key T command-prompt -p "title:" "set set-titles-string %1"
EOF

git clone https://github.com/slagle/tripleo
cp tripleo/environments/osp16-upshift/undercloud.conf ~/undercloud.conf
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo hostnamectl set-hostname osp16.localdomain
sudo tee -a /etc/fstab << EOF
/swapfile swap swap defaults 0 0
EOF
openstack undercloud install
echo "source ~/stackrc" >> ~/.bashrc
openstack complete | grep -v osc_lib | sudo tee /etc/bash_completion.d/openstack
source /etc/bash_completion.d/openstack
cp -a /usr/share/openstack-tripleo-heat-templates tripleo-heat-templates

sudo ip addr add 10.0.0.5/24 dev eth2 

