setuppfs=/tigress/hassans/scripts/setup-pfs.sh
echo "Sourcing ${setuppfs} .."
source ${setuppfs}

# Use local development versions of each product
dev_home=/tigress/hassans/software

for i in display_matplotlib drp_pfs_data datamodel pfs_utils obs_pfs drp_stella pfs_pipe2d; do
	a=${dev_home}/${i}
	cmd="setup -k -r ${a}"
	echo "running:${cmd}"
	${cmd}
done

eups declare drp_instdata git -t current -r ${dev_home}/drp_instdata
eups declare drp_instmodel git -t current -r ${dev_home}/drp_instmodel

setup drp_instdata
setup drp_instmodel
