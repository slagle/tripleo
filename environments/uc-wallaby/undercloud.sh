set -eux

UC_HOSTNAME=${UC_HOSTNAME:-"uc-wallaby"}

rpm -q git || sudo dnf -y install git
sudo dnf -y install python3 python3-setuptools python3-requests
git clone https://git.openstack.org/openstack/tripleo-repos
pushd tripleo-repos
sudo python3 setup.py install
popd
sudo /usr/local/bin/tripleo-repos current-tripleo-dev

sudo dnf -y install git bash-completion tmux python3-tripleoclient expect tripleo-ansible libibverbs

if [ ! -f ~/.tmux.conf ]; then
    cat >~/.tmux.conf<<EOF
# Prefix key
set-option -g prefix2 C-a
bind-key C-a send-prefix -2
bind-key T command-prompt -p "title:" "set set-titles-string %1"
set-option -g set-titles on
EOF
fi

tmux new-session -d -s undercloud

tmux send-keys -t undercloud:0 '
cp tripleo/environments/uc-wallaby/undercloud.conf ~/undercloud.conf
cp -a /usr/share/openstack-tripleo-heat-templates tripleo-heat-templates
if [ ! -f /swapfile ]; then
    sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo tee -a /etc/fstab << EOF
/swapfile swap swap defaults 0 0
EOF
fi
sudo hostnamectl set-hostname $UC_HOSTNAME
openstack undercloud install
echo "source ~/stackrc" >> ~/.bashrc
openstack complete | grep -v osc_lib | sudo tee /etc/bash_completion.d/openstack
source /etc/bash_completion.d/openstack
'

