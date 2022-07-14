#!/bin/bash

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

cd $PREFIX
TARGET="$(pwd)/$TARGET"

export OMP_NUM_THREADS=1

# Detrend only
#detrend.py $TARGET --calib $TARGET/CALIB --rerun $RERUN/detrend --clobber-versions --id visit=17017..17130 arm=r -j $CORES -c isr.doFlat=False repair.cosmicray.nCrPixelMax=25000 repair.cosmicray.keepCRs=True

# Process arc
reduceArc.py $TARGET --calib $TARGET/CALIB --rerun $RERUN/arc --clobber-versions --id visit=17071..17076 arm=r -j $CORES -c reduceExposure.isr.doFlat=False reduceExposure.doWriteCalexp=True reduceExposure.subtractSky2d.extractSpectra.useOptimal=False  || exit 1
#sqlite3 $TARGET/CALIB/calibRegistry.sqlite3 'DELETE FROM detectormap; DELETE FROM detectormap_visit'
#ingestCalibs.py $TARGET --calib $TARGET/CALIB --validity 1000 \
#             $TARGET/rerun/$RERUN/arc/DETECTORMAP/*.fits --config clobber=True || exit 1
#( $CLEANUP && rm -r $TARGET/rerun/$RERUN/arc ) || true

RERUN="rerun_3_subtract"
reduceArc.py $TARGET --calib $TARGET/CALIB --rerun $RERUN/arc --clobber-versions --id visit=17071..17076 arm=r -j $CORES --config reduceExposure.doSubtractContinuum=True reduceExposure.subtractSky2d.extractSpectra.useOptimal=False reduceExposure.doWriteCalexp=True reduceExposure.isr.doFlat=False #|| exit 1
#sqlite3 $TARGET/CALIB/calibRegistry.sqlite3 'DELETE FROM detectormap; DELETE FROM detectormap_visit'
#ingestCalibs.py $TARGET --calib $TARGET/CALIB --validity 1000 \
#             $TARGET/rerun/$RERUN/arc/DETECTORMAP/*.fits --config clobber=True || exit 1

# Read arc
python -c "
from lsst.daf.persistence import Butler
butler = Butler(\"${TARGET}/rerun/${RERUN}/arc\")
arc = butler.get(\"pfsArm\", visit=17071, arm=\"r\", spectrograph=1)
print(arc.flux)
" || exit 1
#( $CLEANUP && rm -r $TARGET/rerun/$RERUN/arc ) || true

echo "Done."