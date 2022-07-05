

require 'LayoutScript'
include LayoutScript

l=Project.new_layout()
Layers.num(6).name="new text"

c=l.drawing.currentCell
c.cellName="test-cell-ruby"

c.add_box(0,0,5000,7000,5)
c.add_rounded_box(10000,0,5000,7000,500,5)
c.add_chamfered_box(20000,0,5000,7000,500,5)
c.add_circle_box(Point.new(0,10000),Point.new(5000,17000),5)
c.add_ellipse(5,Point.new(12500,15000),2500,3500)
c.add_polygon_arc(Point.new(22500,15000),2500,3500,0,340,5)
e=c.add_text(5,Point.new(25,25000),Layers.num(6).name)
e.set_width(1000)

# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")
#l.drawing.save_file("/Users/apple/testout.gds")



puts "Ruby test completed" 
