require 'LayoutScript'
include LayoutScript

# automatic labeling of an array

l=Project.new_layout()

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="ruby_example_label"


for x in (0..9)
        for y in (0..9)
                dr.point(x*1800,y*800)
                dr.text("##{x}/#{y}")
        end
end

dr.select_all()
dr.set_width(400)
dr.to_polygon()
dr.deselect_all();


# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 