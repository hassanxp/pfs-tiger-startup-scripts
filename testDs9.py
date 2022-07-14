# https://community.lsst.org/t/using-an-lsst-dev-stack-w-local-ipython-ds9-tutorial/592
import lsst.afw.display.ds9 as ds9
import lsst.afw.image as afwImage
import numpy as np
import random

random.seed(123)

# data = (np.random.standard_normal([28, 28, 3]) * 255).astype(np.uint8)
# data = np.zeros((100,100), dtype = np.float32)
data = np.identity((100), dtype=np.float32)

for i in range(1000):
	x = random.randint(0, 99)
	y = random.randint(0, 99)
	data[x, y] = random.random()
img = afwImage.ImageF(data)
ds9.mtv(img,frame=1)

