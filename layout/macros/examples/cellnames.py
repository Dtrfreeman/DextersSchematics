# -*- coding: utf-8 -*-
import LayoutScript
from LayoutScript import *

#minimize the length of cell names

l=project.newLayout(); # open new instance of layout class

SetUp=setup()  # work around as static string variables are not handled correctly

l.open(SetUp.macroDirectory+"/examples/test.gds") # load example design

cl=l.drawing.firstCell # pointer to current cell
count=0
while (cl!=None):  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   cn=c.cellName
   if (len(cn)>1):
        count+=1
        c.cellName="c"+str(count);
   cl=cl.nextCell


import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


