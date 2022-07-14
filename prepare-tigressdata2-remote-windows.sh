# XPRA (for matplotlib)
xpra start :2001 --systemd-run=no
export DISPLAY=:2001
echo 'testing with xclock..'
xclock
echo 'ssh to tiger'
ssh -Y tiger

