require 'LayoutScript'
include LayoutScript

#sets the size of text with negative width to -10
# and round paths to a grid of 1000

l=Project.new_layout()

s = Setup.macroDirectory
l.open(s + "/examples/test.gds") 

cl=l.drawing.firstCell # pointer to current cell

while (cl!=nil) do  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   #puts("process cell :"+c.cellName)
   while (el!=nil) do  #loop over all elements
      if (el.thisElement!=nil)
          if (el.thisElement.is_path())
               # select this element
               el.thisElement.select_all()
          end
          if ((el.thisElement.get_width()<0) and (el.thisElement.is_text()))
               el.thisElement.set_width(-10)
          end
     end
     el=el.nextElement
      
   end
   c.round_select(1000)  # do a round of all selcted element in the cell
   c.deselect_all()
   cl=cl.nextCell
end

# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 