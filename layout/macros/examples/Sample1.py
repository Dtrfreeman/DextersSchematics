# loading LayoutScript extension

import LayoutScript
from LayoutScript import *

# this is a single line comment


'''
this is a multiline 
comment

'''

i=6
b=True

d=6.678

s="This is a test!"

p=point(500,800)

p.setX(1000)
p.setY(2000)

pa=pointArray()

pa.attach(100,500) # append a point with x=100 y=500

pa.attachPoint(p) 

pa.resize(1)
pa.setPoint(0,p)

# if command
if i==6 :
      s+="i is equal to 6";
else :
      d+=i;
  
# for loop
for k in range (1,3):
	i+=k

# while loop

while (k<5):
	k+=1



