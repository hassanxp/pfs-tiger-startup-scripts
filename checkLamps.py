from lsst.daf.persistence import Butler
from lsst.pipe.drivers import utils
from lsst.obs.pfs.utils import getLampElements
butler = Butler("/tigress/hassans/subaru-runs/repo-02")
qmd = butler.queryMetadata("raw", ["lamps"], visit=436, arm="r", spectrograph=1)
print(f"butler.queryMetadata: {qmd}")
dataId = {"visit": 436, "arm": 'r'}
dataRef = utils.getDataRef(butler, dataId)
metadata = dataRef.get('raw_md')
print(f"getLampElements: {getLampElements(metadata)}")
print(f"raw_md: W_AITNEO: {metadata['W_AITNEO']}")
print(f"raw_md: W_AITKRY: {metadata['W_AITKRY']}")

raw_metadata = dataRef.get('raw').getMetadata()
print(f"raw: W_AITNEO: {raw_metadata['W_AITNEO']}")
print(f"raw: W_AITKRY: {raw_metadata['W_AITKRY']}")
