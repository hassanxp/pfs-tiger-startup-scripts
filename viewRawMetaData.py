from lsst.daf.persistence import Butler
from lsst.pipe.drivers import utils
butler = Butler("/tigress/hassans/subaru-runs/repo-02")
dataId = {"visit": 436, "arm": 'r'}
metadata = dataRef.get('raw_md')
dataRef = utils.getDataRef(butler, dataId)

metadata = dataRef.get('raw_md')
for p in metadata:
    print(p)


