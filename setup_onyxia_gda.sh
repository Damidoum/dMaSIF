wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /home/onyxia/work/miniconda
source /home/onyxia/work/miniconda/bin/activate
conda init bash

git clone https://github.com/Damidoum/dMaSIF.git
cd /home/onyxia/work/dMaSIF

conda create -n dmasif
conda activate dmasif

./setup.sh
