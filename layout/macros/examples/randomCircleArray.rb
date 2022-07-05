

require 'LayoutScript'
include LayoutScript

l=Project.new_layout()

c=l.drawing.currentCell
c.cellName="randomCircleArray"

sizeX=10000 #array width
sizeY=10000 #array height
diameter=100 #circle diameter
count=2000 #number circles
layer =11  #layer for circles
space=50 #minimum circle to circle distance


ds=diameter+space;

for i in 1..count
 try=0
 found=false
 while (found == false) do
    try += 1
    x=Random.rand(sizeX)
    y=Random.rand(sizeY)
    p=Point.new(x,y);
    e=c.nearest_element(p)
    if e==nil
       found=true
    else 
       p2=Point.new()
       radius=PointerInt.new()
       # to assign radius use
       #radius.assign(34)
       # to output radius use
       #puts radius.value()
       if e.thisElement.is_circle(p2,radius)
           if p2.x()>x+ds
               found=true
           elsif p2.x()<x-ds
               found=true
           elsif p2.y()<y-ds
               found=true
           elsif p2.y()>y+ds
               found=true
           end
       end
    end

    if try>1000
       return 1
    end
 end
 c.add_circle(layer,p,diameter/2)

end

# save to your home folder
l.drawing.save_file("#{Dir.home}/testout.gds")
#l.drawing.save_file("/Users/apple/testout.gds")



puts "circle array completed" 
