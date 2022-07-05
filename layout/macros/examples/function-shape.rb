require 'LayoutScript'
include LayoutScript

# create a polygon on the active layer with a entered function

def func( d)
        return d*d/100
end

l=Project.new_layout()

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="ruby_example_function"

dr.clear_points()
dr.activeLayer=4

# add a x^2 polygon
for x in (-100..100).step(10)
        dr.p(x,func(x))
end

dr.polygon()

#add a cos path

dr.activeLayer=2

for x in (-130..130).step(5)
        dr.p(x,-30*Math.cos((x.to_f-20)/50*Math::PI))
end 
dr.path() 


# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")

puts "Ruby script completed" 