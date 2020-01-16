#!/bin/bash

set -euxo pipefail

pacman-db-upgrade
pacman -Syyu --noconfirm

#--------------------
# add user for build
#--------------------
useradd duser
passwd -d duser
pacman -S --noconfirm sudo #needed before accessing /etc/sudoers
printf 'duser ALL=(ALL) ALL\n' | tee -a /etc/sudoers
mkdir -p /home/duser
chown duser:duser /home/duser

#-----------------
# build directory
#-----------------
mkdir -p /build
chown duser:duser /build
cd /build

#-------------
# yay
#-------------
pacman -S --noconfirm git
pacman -S --noconfirm base base-devel
sudo -u duser bash -c 'git clone https://aur.archlinux.org/yay.git'
cd yay
sudo -u duser bash -c 'makepkg -si --noconfirm'

#------------------
# x-window-system
#------------------
pacman -S --noconfirm xorg-server xterm

#-------------
# development
#-------------
# yay -S --noconfirm neovim xsel xclip
sudo -u duser bash -c 'yay -S --noconfirm vim gcc clang cmake boost boost-libs openmp openmpi eigen pybind11 fmt valgrind cuda openblas-lapack'
pacman -S --noconfirm tk

sudo -u duser bash -c 'yay -S --noconfirm anaconda'
ln -s /opt/anaconda/bin/conda /usr/bin/conda
ln -s /opt/anaconda/bin/ipython /usr/bin/ipython
ln -s /opt/anaconda/bin/jupyter /usr/bin/jupyter
chown duser:duser /usr/bin/conda
chown duser:duser /usr/bin/ipython
chown duser:duser /usr/bin/jupyter

# already installed: python ipython jupyter
# already installed: numpy scikit-learn pandas scipy sympy matplotlib seaborn tdqm cffi cython
conda install -y -c r rpy2
conda install -y -c conda-forge pillow mayavi plotly cymem xonsh

# set matplotlib backend TkAgg
sed -i -e "s/#backend      : Agg/backend      : TkAgg/" /opt/anaconda/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc

#-------------
# clean up
#-------------
yay -Scc --noconfirm
yay -Yc --noconfirm
rm -rf /build

# working directory
chown duser:duser /workdir

set +euxo pipefail
