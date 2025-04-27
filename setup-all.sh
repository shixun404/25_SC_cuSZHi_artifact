#!/bin/bash

RED='\033[0;31m'
BOLDRED='\033[1;31m' 
GRAY='\033[0;37m'
NOCOLOR='\033[0m'

export NVCOMP_VER="3.0.5"
NVCOMP_DIR11="nvcomp${NVCOMP_VER}-cuda11"
NVCOMP_DIR12="nvcomp${NVCOMP_VER}-cuda12"

export WORKSPACE=$(pwd)

export PATH=$(pwd)/cusz-interp/build:$PATH
export PATH=$(pwd)/fzgpu:$PATH
export PATH=$(pwd)/cuszp/build/examples/bin:$PATH
export PATH=$(pwd)/szx-cuda/build:$PATH
export PATH=$(pwd)/szx-cuda/build/example:$PATH
export PATH=$(pwd)/zfp-cuda/build:$PATH
export PATH=$(pwd)/zfp-cuda/build/bin:$PATH

## for bitcomp_example
export PATH=$(pwd):$PATH
## for benchmark_bitcomp_chunked
export PATH=$(pwd)/nvcomp${NVCOMP_VER}-cuda$1/bin:$PATH

export PATH=$(pwd)/analyzer/build/examples:$PATH
export LD_LIBRARY_PATH=$(pwd)/analyzer/build/qcat:$LD_LIBRARY_PATH


export LD_LIBRARY_PATH=$(pwd)/${NVCOMP_DIR11}/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$(pwd)/${NVCOMP_DIR12}/lib:$LD_LIBRARY_PATH

if [ $# -eq 0 ]; then
    echo "bash setup-all.sh [arg1] [arg2]"
    echo "arg1:"
    echo "  * \"purge\"  to reset this workspace"
    echo "  * \"11\"     to initialize the artifacts for CUDA 11"
    echo "  * \"12\"     to initialize the artifacts for CUDA 12"
    echo "arg2:"
    echo "  * \"where to put data dirs\""
elif [ $# -eq 1 ]; then
    if [[ "$1" = "purge" ]]; then
        echo "purging build files..."
        rm -fr \
            cusz-interp/build \
            fzgpu/claunch_cuda.o fzgpu/fz-gpu \
            cuszp/build/examples/bin \
            szx-cuda/build \
            zfp-cuda/build 
    fi
elif [ $# -eq 2 ]; then 
    echo -e "\n${BOLDRED}specified CUDA version $1${NOCOLOR}"
    bash setup-compressors.sh
    bash setup-analyzer.sh
    python setup-nvcomp.py $1

    export DATAPATH=$(readlink -f $2)
    echo -e "\n${BOLDRED}specified data path as "$2" (abs path: "${DATAPATH}")${NOCOLOR}"
fi
