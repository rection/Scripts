if [[ $UID -ne 0 ]]; then
    echo "You need to be root user."
    exit()
fi


echo "These are options for packages:"
read -p "Would you install the Docker? => " DOCKER
read -p "Would you install the RVM? => " RVM
read -p "Would you install the vagrant with vagrant-libvirt? => " VAGRANT
read -p "Would you install the Spotify => " SPOTIFY
read -p "Would you install the emacs => " EMACS
read -p "Would you install the vim for c/c++ => " VIM

sudo apt install vim vim-common vim-addon-manager qemu-kvm libvirt-clients libvirt-daemon-system emacs25 openvpn mpv pass git

## VIM

if [[ vim -eq 1 ]]; then
	cp vimrc ~/.vimrc
	cp -r vim ~/.vim 
fi


## DOCKER

if [[ docker -eq 1 ]]; then
   
   sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common


   curl -fsSL http s://download.docker.com/linux/debian/gpg | sudo apt-key add -

   sudo apt-key fingerprint 0EBFCD88

   sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
   	$(lsb_release -cs) \
   	stable"

   sudo apt-get update

   sudo apt-get install docker-ce docker-ce-cli containerd.io
fi
       
## RVM

if [[ RVM -eq 1 ]]; then
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    \curl -sSL https://get.rvm.io | bash -s stable --ruby --gems=rails,bundler,serve
fi

## Vagrant

if [[ VAGRANT -eq 1 ]]; then
    curl -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb
    sudo apt install ./vagrant_2.2.6_x86_64.deb
    vagrant install vagrant-libvirt
fi

## SPOTIFY

if [[ SPOTIFY -eq 1 ]]; then
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
fi

## EMACS

if [[ EMACS -eq 1 ]]; then
    curl -o https://github.com/emacs-mirror/emacs/archive/emacs-26.3.tar.gz
    cd emacs
    apt-get install build-essential
    apt-get build-dep emacs
    ./autogen.sh
    ./configure
    make -j4
    make install
    cp installation/emacs ~/.emacs
    echo "Copied emacs configuration file. You need to run these commands in emacs;"
    echo "M-x package-refresh-contents"
    echo "M-x package-install-selected-packages"
fi
