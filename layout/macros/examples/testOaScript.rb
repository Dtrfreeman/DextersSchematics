
require "oa"
include Oa

p=OaPointArray.new

p.append([45,67])
p.append([85,34])
p.append([35,55])
puts p.getArea
#puts p.methods
