# tcl script test for OpenAccess


set p [ oa::PointArray ]

oa::append $p [oa::Point 45 67 ]
oa::append $p [oa::Point 85 34 ]
oa::append $p [oa::Point 35 55 ]

puts [ oa::getArea $p ]

