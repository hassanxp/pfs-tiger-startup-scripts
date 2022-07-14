# Pull the latest updates from the respective git repo
# build

setup-dev
root_dir=${WORK_DIR}/software
for repo in datamodel pfs_utils obs_pfs drp_stella pfs_pipe2d
do
        echo "Updating and building ${repo}.."
	( cd ${root_dir}/${repo} || exit 1
         git checkout master || exit 1
         git pull || exit 1
         scons || exit 1 )
done

