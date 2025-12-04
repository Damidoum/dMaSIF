wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /home/onyxia/work/miniconda
source /home/onyxia/work/miniconda/bin/activate
conda init bash

exit  # kills the terminal to operate changes

# reopen a new terminal - you should see '(base)' on the left
# of a bash terminal line

cd /home/onyxia/work/
git clone https://github.com/Damidoum/dMaSIF.git
cd dMaSIF

conda create -n dmasif
# you will be prompt to accept 2 terms & condition (press "a" * 2)
# you will be prompt to start the download (press "y")
conda activate dmasif

./setup.sh
