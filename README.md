# Private Repository for cuSZ-i Workgroup

This detached repo is based on the SC '24 artifacts for continous development.

## Artifact Setup

### Hardware

We require NVIDIA A100 GPU (40-GB, i.e., the common variant) to cover the essential functionality and, optionally, NVIDIA A40 GPU to cover the throughput scalability.

### Software

- We require an up-to-date mainstream Linux distro as the base environment.
  - e.g., CentOS 7 onward, Ubuntu 22.04.
- We require CUDA SDK of version 11.4 onward but lower than 12.5 (i.e., 11.4 to 12.4, inclusively).
  - corresponding to CUDA driver of version 470 onward.
  - CUDA 12.5 was tested not compatible.
- We require C++17-compliant host compiler.
  - e.g., GCC 9.3 onward.
- We require a modern cmake build system.
  - e.g., 3.18 onward. 


### Datasets/Inputs

The data setup will be done in setting up the workplace. 

<details>
<summary>
The details are folded here.
</summary>

- JHTDB 
  - Though hosted on https://turbulence.pha.jhu.edu/ as open data, it requires a token to access the data, which prohibits us from automating the data preprocessing. Thus, we don't include JHTDB datafields for the artifacts.
- Miranda, Nyx, QMCPack, S3D 
  - hosted on https://sdrbench.github.io
- RTM data are from proprietary simulations
  - which are not open to the public.
  - We exclude the use of RTM in this artifact.

</details>  

### Setup Compilers

To use `module-load` to setup the toolchain:

```bash
## Please change the version accordingly.
module load cuda/11.4
module load gcc/9.3
````

<details>
<summary>
Alternative Compiler Setup using Spack 
</summary>

```bash
cd $HOME
git clone -c feature.manyFiles=true \
https://github.com/spack/spack.git
## Now, initialize Spack on terminal start
## It is recommended to add the next line to
## "$HOME/.bashrc" or "$HOME/.zshrc"
. $HOME/spack/share/spack/setup-env.sh
## For other shells, please refer to the
## instruction by typing (quotes not included)
## "$HOME/spack/bin/spack load"
spack compiler find
spack install gcc@9.3.0
spack install cuda@12.4.4%gcc@9.3.0

spack load gcc@9.3.0 cuda@12.4.4
export LD_LIBRARY_PATH=$(dirname $(which nvcc))/../lib64:$LD_LIBRARY_PATH
```

</details>

### Setup: Workspace

```bash
## (1) get the artifacts repo
cd $HOME ## It can be anywhere.
git clone --recursive \
  https://github.com/jtian0/24_SC_artifacts.git \
  sc24cuszi
cd sc24cuszi

## (2) setup
## If you use CUDA 11
source setup-all.sh 11 <WHERE_TO_PUT_DATA_DIRS>
## If you use CUDA 12
# source setup-all.sh 12 <WHERE_TO_PUT_DATA_DIRS>

## (!!) clear build cache without removing data
bash setup-all.sh purge

## (3) prepare the data
python setup-data-v2.py
```

## Artifact Execution

Navigate back to the workplace using `cd $WORKSPACE`. Then, run for each dataset.

<details>
<summary>
Unfold to see commands to run the fast experiments covering cuSZ-i only.
</summary>

```bash
## $DATAPATH is set in setup-all.sh
## Please copy-paste each text block to run the per-dataset experiments.

## Nyx
THIS_DATADIR=SDRBENCH-EXASKY-NYX-512x512x512
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 512 512 512 --cmp cuSZi

## Miranda
THIS_DATADIR=SDRBENCH-Miranda-256x384x384
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 384 384 256 --cmp cuSZi

## QMC
THIS_DATADIR=SDRBENCH-SDRBENCH-QMCPack
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 69 69 33120 --cmp cuSZi

## S3D
THIS_DATRADIR=SDRBENCH-S3D
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 500 500 500 --cmp cuSZi
```
</details>


</details>

<details>
<summary>
Unfold to see commands to run the full experiments covering all compressors.
</summary>

```bash
## $DATAPATH is set in setup-all.sh
## Please copy-paste each text block to run the per-dataset experiments.

## Nyx
THIS_DATADIR=SDRBENCH-EXASKY-NYX-512x512x512
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 512 512 512

## Miranda
THIS_DATADIR=SDRBENCH-Miranda-256x384x384
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 384 384 256

## QMC
THIS_DATADIR=SDRBENCH-SDRBENCH-QMCPack
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 69 69 33120

## S3D
THIS_DATRADIR=SDRBENCH-S3D
python script_data_collection.py  \
  --input ${DATAPATH}/${THIS_DATADIR} \
  --output $DATAPATH/${THIS_DATADIR}_log \
  --dims 500 500 500
```

</details>


## Artifact Analysis

<details>
<summary>
Unfold to see commands to analyze cuSZ-i only.
</summary>

```bash
## $DATAPATH is set in setup-all.sh
## Please copy-paste each text block to get the raw analysis results.

## Nyx
THIS_DATADIR=SDRBENCH-EXASKY-NYX-512x512x512
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 512 512 512 --cmp cuSZi

## Miranda
THIS_DATADIR=SDRBENCH-Miranda-256x384x384
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 384 384 256 --cmp cuSZi

## QMC
THIS_DATADIR=SDRBENCH-SDRBENCH-QMCPack
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 69 69 33120 --cmp cuSZi

## S3D
THIS_DATRADIR=SDRBENCH-S3D
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 500 500 500 --cmp cuSZi
```

</details>

<details>
<summary>
Unfold to see commands to analyze all compressors.
</summary>

```bash
## $DATAPATH is set in setup-all.sh
## Please copy-paste each text block to get the raw analysis results.

## Nyx
THIS_DATADIR=SDRBENCH-EXASKY-NYX-512x512x512
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 512 512 512

## Miranda
THIS_DATADIR=SDRBENCH-Miranda-256x384x384
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 384 384 256

## QMC
THIS_DATADIR=SDRBENCH-SDRBENCH-QMCPack
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 69 69 33120

## S3D
THIS_DATRADIR=SDRBENCH-S3D
python script_data_analysis.py  \
  --input ${DATAPATH}/${THIS_DATADIR}_log \
  --output $DATAPATH/${THIS_DATADIR}_csv \
  --dims 500 500 500
```

</details>
# 25_SC_cuSZHi_artifact
