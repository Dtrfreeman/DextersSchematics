import LayoutScript
from LayoutScript import *


l=project.newLayout(); # open new instance of layout class


SetUp=setup()  # work around as static string variables are not handled correctly

l.open(SetUp.macroDirectory+"/examples/test.gds") # load example design

c=l.drawing.currentCell # pointer to current cell

cellname=c.cellName+"_copy" # get name of current cell

cl=l.drawing.addCell() # add new empty cell

cl.thisCell.cellName=cellname # set the name of the new cell

l.drawing.setCell(cl.thisCell) # set new cell as current cell

p=point(0,0)

e=cl.thisCell.addCellref(c,p)

cl.thisCell.selectAll()
cl.thisCell.flatSelect()

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


