set -evx

OUTNAME="run-001"  # Directory name to give data repo
PREFIX=/tigress/hassans/reducedData  # Directory to work in

mkdir -p $PREFIX
cd $PREFIX
TARGET="$(pwd)/$OUTNAME"

pfs_build_calibs.sh \
    -n -c 16 \
    -C $TARGET/CALIB \
    -b visit=16562..16576 \
    -d visit=16577..16606 \
    -f visit=16612..16740:3 \
    -F visit=16607..16611 \
    $TARGET 


