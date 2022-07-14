from lsst.daf.persistence import Butler
from lsst.afw.display import Display
import numpy as np
backend = "ds9"

butler = Butler("/tigress/pprice/pipe2d-483/DATA/rerun/calibs/fiberTrace")
dataId = dict(visit=21122, arm="r", spectrograph=1)
quartz = butler.get("postISRCCD", dataId)
detMap = butler.get("detectormap", dataId)
traces = butler.get("fibertrace", dataId)

# Plot traces on top of quartz
display = Display(1, backend)
display.mtv(quartz)
step = 100  # Looks like display_ds9 can't handle a really long list of points for the line
with display.Buffering():
    for tt in traces:
        display.line(list(zip(detMap.getXCenter(tt.fiberId)[::step], np.arange(tt.trace.getHeight(), step=step))))

# Show fiberTrace residuals
spectra = traces.extractSpectra(quartz.maskedImage)
for tt, ss in zip(traces, spectra):
    image = tt.constructImage(ss)
    quartz.maskedImage[image.getBBox()] -= image
Display(2, backend).mtv(quartz)

