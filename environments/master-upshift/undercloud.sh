set -eux

rpm -q git || sudo dnf -y install git
git clone https://github.com/slagle/tripleo
sudo dnf -y install python3 python3-setuptools python3-requests python3-pip
git clone https://git.openstack.org/openstack/tripleo-repos
pushd tripleo-repos
sudo python3 setup.py install
popd

if ! grep -q -i stream /etc/os-release; then
	NO_STREAM="--no-stream"
else
	NO_STREAM=""
fi
sudo /usr/local/bin/tripleo-repos current-tripleo-dev $NO_STREAM

sudo dnf -y install git bash-completion tmux python3-tripleoclient expect tripleo-ansible libibverbs

cat >~/.tmux.conf<<EOF
# Prefix key
set-option -g prefix2 C-a
bind-key C-a send-prefix -2
bind-key T command-prompt -p "title:" "set set-titles-string %1"
EOF

tmux new-session -d -s undercloud

tmux send-keys -t undercloud:0 '
git clone https://github.com/slagle/tripleo
cp tripleo/environments/master-upshift/undercloud.conf ~/undercloud.conf
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo hostnamectl set-hostname uc.localdomain
sudo tee -a /etc/fstab << EOF
/swapfile swap swap defaults 0 0
EOF
cp -a /usr/share/openstack-tripleo-heat-templates tripleo-heat-templates
openstack undercloud install
echo "source ~/stackrc" >> ~/.bashrc
openstack complete | grep -v osc_lib | sudo tee /etc/bash_completion.d/openstack
source /etc/bash_completion.d/openstack
sudo sed -i ''s/num_engine_workers=8/num_engine_workers=12/'' /var/lib/config-data/puppet-generated/heat/etc/heat/heat.conf
sudo systemctl restart tripleo_heat_engine
'

