#encoding: UTF-8
require 'LayoutScript'
include LayoutScript

#minimize the length of cell names
l=Project.new_layout()


s = Setup.macroDirectory
l.open(s + "/examples/test.gds") 

cl=l.drawing.firstCell # pointer to current cell
count=0
while (cl!=nil) do  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   cn=c.cellName
   if (cn.length>1) 
        count+=1
        c.cellName="c"+count.to_s  

   end
   cl=cl.nextCell
end



# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 