
proc not args {
        return [expr !$args]
 }

proc checkNotEqual { a  b} {
        if {[string is integer -strict $a]} {
            if { $a == $b ]} {return 0 }  else {return 1 }
        }
        if {[string equal "$a" "$b"]} {return 0 }  else {return 1 }
};

proc checkEqual { a  b} {
        if {[string is integer -strict $a]} {
            if { $a == $b ]} {return 1 }  else {return 0 }
        }
        if {[string equal "$a" "$b"]} {return 1 }  else {return 0 }
};


proc or args {
        set result 0
        foreach a $args {
           set result [expr $result||$a]
        }
        return $result
 }
 
proc and args {
        set result 1
        foreach a $args {
           set result [expr $result&&$a]
        }
        return $result
 }
