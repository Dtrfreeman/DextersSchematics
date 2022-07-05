
if {![llength [namespace which ::tcl::mathfunc::min]]} {
    namespace eval tcl::mathfunc:: {
        proc min args {
          set result [lindex $args 0]
           foreach a $args {
                    if { $a < $result } { set result $a}
                }
          return $result
        }
        proc max args {
          set result [lindex $args 0]
           foreach a $args {
                    if { $a > $result } { set result $a}
                }
          return $result
        }
     }
}

