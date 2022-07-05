require 'LayoutScript'
include LayoutScript

l=Project.new_layout()


dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="ruby_example"

nx=10
ny=9
sizeStart=1000
sizeStep=50
stepX=4000
stepY=3900

for x in 0..nx
        for y in 0..ny
                radius=x*sizeStep+sizeStart
                dr.activeLayer=y
                dr.p(x*stepX,y*stepY)
                dr.p(x*stepX,y*stepY+radius)
                dr.circle()
        end
end


# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 