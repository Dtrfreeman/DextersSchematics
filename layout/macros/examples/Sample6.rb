require 'LayoutScript'
include LayoutScript

#outputs all polygons on layer 23

l=Project.new_layout()

s = Setup.macroDirectory
l.open(s + "/examples/test.gds") 

cl=l.drawing.firstCell # pointer to current cell

while (cl!=nil) do  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   #print("process cell :"+c.cellName)
   while (el!=nil) do  #loop over all elements
      if (el.thisElement!=nil)
          if (el.thisElement.is_polygon() and (el.thisElement.layerNum==23))
               # polygon on layer 23
               pa=el.thisElement.get_points();
               puts("Polygon ("+pa.size().to_s+"): ");
               for i in 0..pa.size()-1 # output all coordinates
                     x=pa.point(i).x()
                     y=pa.point(i).y()
                     puts("("+x.to_s+", "+y.to_s+")")
               end
          end
     end
     el=el.nextElement
      
   end
   cl=cl.nextCell
end



# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 