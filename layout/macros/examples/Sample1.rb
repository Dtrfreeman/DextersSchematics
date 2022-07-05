# loading LayoutScript extension

require 'LayoutScript'
include LayoutScript

# this is a single line comment

=begin
this is a multi
line comment

=end

i=6
b=true
d=6.567


s="This is a test!"

p=Point.new(34,76)

p.set_x(1000)
p.set_y(2000)


pa=PointArray.new()

pa.attach(100,500) # append a point with x=100 y=500

pa.attach_point(p) 

pa.resize(1)
pa.set_point(0,p)

# if command
  if i==6
       s+="i is equal to 6"
  else 
       d+=i
  end

  
  # for loop
  for k in 1..3
	i+=k;
  end

  # while loop
  while (k<5) do
	k+=1
  end

