import LayoutScript
from LayoutScript import *

# create a polygon on the active layer with a entered function

def func( d):
        return d*d/100
        

l=project.newLayout(); 

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="python_example_function"

dr.clearPoints()
dr.activeLayer=4

# add a x^2 polygon
for x in range (-100,101,10):
        dr.p(x,func(x))

dr.polygon()

#add a cos path
import math
dr.activeLayer=2

for x in range (-130,130,5):
        dr.p(x,-30*math.cos((float(x)-20)/50*math.pi))
       
dr.path() 

# writes result to the home folder

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


