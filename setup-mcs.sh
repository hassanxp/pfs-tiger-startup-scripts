lsst=/tigress/HSC/PFS/stack/loadLSST.bash
echo "Sourcing ${lsst} ..."
source ${lsst}

# Use local development versions of each product
dev_home=/tigress/hassans/software

for i in ics_mcsActor pfs_utils; do
	a=${dev_home}/${i}
	cmd="setup -j -r ${a}"
	echo "running:${cmd}"
	${cmd}
done

