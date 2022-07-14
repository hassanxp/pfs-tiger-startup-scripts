#!/bin/bash


#
# Preparation for the reduction of the data using the PFS 2D pipeline code.
#
#

if [ $(uname -s) = Darwin ]; then
    if [ -z $DYLD_LIBRARY_PATH ]; then
        export DYLD_LIBRARY_PATH=$LSST_LIBRARY_PATH
    fi
fi

set -evx

# Parse command-line arguments
BRANCH=  # Branch to build
RERUN="rerun_3"  # Rerun name to use
TARGET="May_2019_run3"  # Directory name to give data repo
CORES=20  # Number of cores to use
CLEANUP=false  # Clean temporary products?
PREFIX=/tigress/ncaplar/ReducedData  # Directory to work in

mkdir -p $PREFIX
cd $PREFIX
TARGET="$(pwd)/$TARGET"
# which we pass as $REPO

# /tigress/ncaplar/ReducedData/May_2019_calibs

if [ $CORES = 1 ]; then
    batchArgs="--batch-type=none --doraise"
else
    batchArgs="--batch-type=smp --cores $CORES --doraise"
fi

export OMP_NUM_THREADS=1


# Construct repo
rm -rf $TARGET
mkdir -p $TARGET
mkdir -p $TARGET/CALIB
[ -e $TARGET/_mapper ] || echo "lsst.obs.pfs.PfsMapper" > $TARGET/_mapper

# Ingest images into repo
# Supply directory/directories with your files here

ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/2019-04-17/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/

ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/2019-04-26/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/

ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/2019-05-06/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/

ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/2019-05-07/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/

ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/2019-05-08/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/

# Ingest DetectorMap
ingestCalibs.py $TARGET --calib $TARGET/CALIB --validity 1000 \
		$OBS_PFS_DIR/pfs/camera/detectorMap-sim-*.fits --mode=copy --config clobber=True || exit 1

# build calibs
sh pfs_build_calibs.sh -c 20 -C $TARGET/CALIB -b visit=16562..16576 -d visit=16577..16606 -f visit=16612..16740:3 -F visit=16607..16611 $TARGET


echo "Done."


