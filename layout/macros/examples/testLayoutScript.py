
import LayoutScript
from LayoutScript import *


l=project.newLayout();

layers.num(6).name="new text"

c=l.drawing.currentCell
c.cellName="test-cell-python"

c.addBox(0,0,5000,7000,5)
c.addRoundedBox(10000,0,5000,7000,500,5)
c.addChamferedBox(20000,0,5000,7000,500,5)
c.addCircleBox(point(0,10000),point(5000,17000),5)
c.addEllipse(5,point(12500,15000),2500,3500)
c.addPolygonArc(point(22500,15000),2500,3500,0,340,5)
e=c.addText(5,point(25,25000),layers.num(6).name)
e.setWidth(1000)

# save result in your home folder
import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")
#l.drawing.saveFile("/Users/apple/testout.gds")



print ("Python test completed" )