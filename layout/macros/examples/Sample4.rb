require 'LayoutScript'
include LayoutScript

l=Project.new_layout()

s = Setup.macroDirectory
l.open(s + "/examples/test.gds") 

c=l.drawing.currentCell # pointer to current cell

cellname=c.cellName+"_copy" # get name of current cell

cl=l.drawing.add_cell() # add new empty cell

cl.thisCell.cellName=cellname # set the name of the new cell

l.drawing.set_cell(cl.thisCell) # set new cell as current cell

p=Point.new(0,0)

e=cl.thisCell.add_cellref(c,p)

cl.thisCell.select_all()
cl.thisCell.flat_select()


# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 