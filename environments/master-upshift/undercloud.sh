set -eux

rpm -q git || sudo yum -y install git
sudo yum -y install python-setuptools python-requests
git clone https://git.openstack.org/openstack/tripleo-repos 
pushd tripleo-repos
sudo python setup.py install
popd
sudo tripleo-repos current-tripleo-dev

sudo dnf -y install git bash-completion tmux python-tripleoclient expect
  
cat >~/.tmux.conf<<EOF
# Prefix key
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
  
EOF
  
git clone https://github.com/slagle/tripleo
cp tripleo/environments/master-upshift/undercloud.conf ~/undercloud.conf
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo hostnamectl set-hostname osp16-scale.localdomain
sudo cat >> /etc/fstab << EOF
swap /swapfile swap defaults 0 0
EOF
openstack undercloud install
echo "source ~/stackrc" >> ~/.bashrc
openstack complete | grep -v osc_lib | sudo tee /etc/bash_completion.d/openstack
source /etc/bash_completion.d/openstack
sudo sed -i 's/num_engine_workers=8/num_engine_workers=12/' /var/lib/config-data/puppet-generated/heat/etc/heat/heat.conf
sudo systemctl restart tripleo_heat_engine
cp -a /usr/share/openstack-tripleo-heat-templates tripleo-heat-templates

