require 'LayoutScript'
include LayoutScript

l=Project.new_layout()
# creates an array of donut with different parameter

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="ruby_example_donuts"

nx=5
ny=5
sizeStart=200
sizeStep=100
stepX=4000
stepY=3900
radiusouter=1000
radiusinner=500
radiusStep=50

for x in 0..nx
        for y in 0..ny
                dr.activeLayer=10
                dr.point(x*stepX,y*stepY)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.spiral()
                dr.currentCell.firstElement.thisElement.select_all()
                dr.point(x*stepX,y*stepY)
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.spiral()
                dr.currentCell.firstElement.thisElement.select_all()
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.path()
                dr.currentCell.firstElement.thisElement.select_all()
                dr.merge_select()
                dr.close_to_polygon()
                dr.deselect_all()
        end
end


# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 