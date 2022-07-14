#!/bin/bash

if [ $(uname -s) = Darwin ]; then
    if [ -z $DYLD_LIBRARY_PATH ]; then
        export DYLD_LIBRARY_PATH=$LSST_LIBRARY_PATH
    fi
fi

set -evx

# Parse command-line arguments
OUTNAME="run-001"  # Directory name to give data repo
PREFIX=/tigress/hassans/reducedData  # Directory to work in

mkdir -p $PREFIX
cd $PREFIX
TARGET="$(pwd)/$OUTNAME"

#
# Construct repo
#
rm -rf $TARGET
mkdir -p $TARGET
mkdir -p $TARGET/CALIB
[ -e $TARGET/_mapper ] || echo "lsst.obs.pfs.PfsMapper" > $TARGET/_mapper

#
# Ingest images
#
echo "Ingesting images..."
for dt in 2019-04-17 2019-04-26 2019-05-06 2019-05-07 2019-05-08
do
echo "Processing images for date ${dt}..."
ingestPfsImages.py $TARGET --mode=link \
    /tigress/HSC/PFS/LAM/raw/${dt}/*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir /tigress/HSC/PFS/LAM/pfsConfig/
done

#
# Ingest detectormap
#
echo "Ingesting detectormap..."
ingestCalibs.py $TARGET --calib $TARGET/CALIB --validity 1000 \
		/tigress/hassans/data/detectorMaps/detectorMap-2019Apr-r1.fits  --mode=copy --config clobber=True || exit 1

#
# Build calibs
#
sh pfs_build_calibs.sh -c 20 -C $TARGET/CALIB -b visit=16562..16576 -d visit=16577..16606 -f visit=16612..16740:3 -F visit=16607..16611 $TARGET


echo "Done."


