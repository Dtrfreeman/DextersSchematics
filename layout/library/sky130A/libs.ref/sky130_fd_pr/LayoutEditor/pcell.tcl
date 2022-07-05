proc pmos_check {} {
    puts "check triggered"
    set ci [iPDK_getCurrentInst]
    set w [iPDK_getParameterValue W ]
    set wmax [iPDK_getParameterValue wmax ]
    set wmin  [iPDK_getParameterValue wmin ]
    if {  [expr $w > $wmax] } { iPDK_setParameterValue W $wmax }
    if {  [expr $w <  $wmin] } { iPDK_setParameterValue W $wmin }
    set l [iPDK_getParameterValue L ]
    set lmax [iPDK_getParameterValue lmax ]
    set lmin  [iPDK_getParameterValue lmin ]
    if {  [expr $l > $lmax] } { iPDK_setParameterValue L $lmax }
    if {  [expr $l <  $lmin] } { iPDK_setParameterValue L $lmin }

}
 
 
proc pmos_draw {} {
    puts "This is an example device only!"
    set ci [iPDK_getCurrentInst]
    set w [iPDK_getParameterValue W ]
    set l [iPDK_getParameterValue L ]
    pcell_setLayer 66
    pcell_box 0 0 $w $l
    pcell_text "G" 0 $l
    pcell_setLayer "MET1"
    pcell_box -100 -100 -500 [expr $l+100]
    pcell_text "S" -100 -100
    pcell_box [expr $w+100] -100 [expr $w+600]  [expr $l+100]
    pcell_text "D"  [expr $w+100] -100
    pcell_setLayer 122
    pcell_polygon -100 [expr $l+100]  0 $l 0 0 -100 -100
    pcell_setLayer 0
    pcell_text "Example, do not use for productive applications!" -4000 -2000 2000

}

puts "sky130_fd_pr pcells loaded"


