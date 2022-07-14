# stack=/tigress/HSC/PFS/stack/current
stack=/projects/HSC/PFS/stack/20190925
echo "Sourcing ${stack}/loadLSST.bash ..."
source ${stack}/loadLSST.bash

export EUPS_PKGROOT='https://eups.lsst.codes/stack/src|http://tigress-web.princeton.edu/~HSC/pfs-drp-2d/src'

# Appears to be bug when calling loadLSST.bash twice
# Restore version of python in lsst-scipipe virtual env
# Note: may bloat path 
export PATH=${stack}/python/miniconda3-4.5.12/envs/lsst-scipipe/bin:${PATH}

setup lsst_distrib
setup display_matplotlib
setup display_ds9

#setup pfs_pipe2d 
#setup numpy
echo "Python path is [$(which python)]"

# test numpy
echo 'testing numpy import..'
python -c 'import numpy'
echo 'test DONE.'

export PYTHONPATH=/tigress/hassans/debugPath/:${PYTHONPATH}

#
# Useful functions
#

# List versions currently setup for 2D DRP
list_drp(){
for i in datamodel obs_pfs drp_stella pfs_utils pfs_pipe2d; do
	eups list -s $i
done
}

# For running create_weekly etc
export OMP_NUM_THREADS=1
