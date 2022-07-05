require 'LayoutScript'
include LayoutScript

# remove any text starting with "Generated with the LayoutEditor"

l=Project.new_layout()

s = Setup.macroDirectory
l.open(s + "/examples/test.gds") 

cl=l.drawing.firstCell # pointer to current cell

while (cl!=nil) do  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   while (el!=nil) do  #loop over all elements
      if (el.thisElement!=nil)
          if (el.thisElement.is_text())
              text=el.thisElement.get_name()
              if (text[0,31]=="Generated with the LayoutEditor")
                      el.thisElement.select_all();
              end
          end

     end
     el=el.nextElement
      
   end
   c.delete_select();
   cl=cl.nextCell
end

# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 