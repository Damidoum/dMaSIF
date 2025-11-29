#!/bin/bash
# 0. Set up a local temporary directory to avoid filling up /tmp during compilation
# This fixes "No space left on device" errors during linking
export TMPDIR=$HOME/tmp_build
mkdir -p $TMPDIR
echo "--- Temporary directory set to $TMPDIR ---"

echo "--- Install Python 3.7 ---"
conda install python=3.7 -y

echo "--- Install PyTorch ---"
conda install pytorch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1 cudatoolkit=11.1 -c pytorch -c conda-forge -y

# SAFETY: Clean conda cache to free up space for the next steps
conda clean --all -y

echo "--- Install Geometric ---"
pip install torch-scatter==2.0.7 -f https://data.pyg.org/whl/torch-1.8.1+cu111.html
pip install torch-sparse==0.6.11 -f https://data.pyg.org/whl/torch-1.8.1+cu111.html
pip install torch-cluster==1.5.9 -f https://data.pyg.org/whl/torch-1.8.1+cu111.html
pip install torch-geometric==1.6.1

echo "--- Install Requirements ---"
# Using requirements.txt as it is the standard filename
pip install -r requirements.txt

# SAFETY: Clean pip cache
pip cache purge

echo "--- Install Extras ---"
pip install biopython plyfile pyvtk pdbparser
conda install nglview -c conda-forge -y

# 6. Conditional Compilation of Reduce
if command -v reduce &> /dev/null; then
    echo "--- Reduce is already installed, skipping compilation ---"
else
    echo "--- Compiling Reduce ---"
    
    # Check if reduce folder exists, if not, clone it
    if [ ! -d "reduce" ]; then
        echo "Downloading Reduce from GitHub..."
        git clone --quiet https://github.com/rlabduke/reduce
    fi

    # Install CMake
    conda install cmake -y

    if [ -d "reduce" ]; then
        cd reduce
        
        # CRITICAL CLEANUP: Remove corrupted files from previous attempts
        echo "Cleaning previous build files..."a
        rm -rf CMakeCache.txt CMakeFiles
        
        cmake .
        make
        
        # Try sudo install, fallback to normal install if sudo is not available/needed
        sudo make install || make install
        cd ..
    else
        echo "WARNING: 'reduce' folder not found even after git clone. Skipping compilation."
    fi
fi

# Cleanup temporary build directory
rm -rf $TMPDIR

echo "--- DONE ---"