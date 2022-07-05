 
 
proc removeBTerm { args } {
  set block [[[::ord::get_db] getChip] getBlock]
  if { $block eq "NULL" } return ""
  foreach  {term}  $args {
    set net [$block findNet "$term"]
    if { $net eq "NULL" } continue
    set bterm [$net get1stBTerm]
    if { $bterm eq "NULL" } continue
    ::odb::dbBTerm_destroy $bterm
    puts "terminal $term removed"
  }
}

proc write_track_info { filename } {
    set tech [[::ord::get_db] getTech]
    set rlay [$tech getRoutingLayerCount]
    set fo [open "$filename" "w"]
    for {set i 1} {$i <= $rlay} {incr i} {
        set l [$tech findRoutingLayer $i]
        set lname [$l getName]
        set lpit [expr double([$l getPitchX])/1000]
        set loff [expr double([$l getOffsetX])/1000]
        puts $fo "$lname X $loff $lpit"
        set lpit [expr double([$l getPitchY])/1000]
        set loff [expr double([$l getOffsetY])/1000]
        puts $fo "$lname Y $loff $lpit"
    }
    close $fo
}

proc write_pdn { filename template } {
    set fi [open "$template" "r"]
    set template [read $fi]
    close $fi

    set rWidth 0.0
    set rOffset 0
    set rPitch 20
    set cPitch 0
    set cOffset 0
    set cWidth 0
    set cLayer "MET6"

    set tech [[::ord::get_db] getTech]
    set rlay [$tech getRoutingLayerCount]
    set l [$tech findRoutingLayer 1]
    set rWidth [expr double([$l getWidth])/1000]

    # get most upper vertical routing layer
    set l [$tech findRoutingLayer $rlay ]
    set dir [$l getDirection]
    if { $dir == "VERTICAL" } { puts "vert" } else {
    set l [$tech findRoutingLayer [expr $rlay -1 ]]
    set rlay [expr $rlay -1 ]
    }
    set cLayer [$l getName]
    set cWidth [expr (double([$l getWidth])+double([$l getPitch]))/1000]
    set cPitch [expr double([$l getPitch])/20]
    set cOffset [expr (double([$l getOffset])+0.5*double([$l getPitch]))/1000 ]
    # no stripes when top vertical layer is MET2
    if {$rlay==2} { set cWidth 0 }

    set template [string map [list rWidth $rWidth rPitch $rPitch rOffset $rOffset cWidth $cWidth cPitch $cPitch cOffset $cOffset cLayer $cLayer] $template ]

    set fo [open "$filename" "w"]
    puts $fo $template
    close $fo
}

proc max_route_layer { } {
   set tech [[::ord::get_db] getTech]
   set rlay [$tech getRoutingLayerCount]
   return $rlay
}

proc getUsedSite {} {
   set sites [[[::ord::get_db] getLibs] getSites]
   foreach a $sites  {
         #puts [$a getName]
         return [$a getName]
     }
}

proc adjustWindowsPath {} {
    puts "***********************************"
    puts "adjust parameters including copy of required files"
    puts "to a different name be be accessable by yosys"
    puts ""
    puts "openroad/yosys will be copy to the WSL home folder"
    puts "library will get a symbolic link in the home folder"
    puts "resulting files names should no longer contain a space character"
    puts "***********************************"

    if { [info exists ::env(WINDOWSPATHMAPPING)] } {
    puts "mapping required"
    }


    if {![file exists "$::env(HOME)/openroad$::env(WINDOWSPATHMAPPING)" ] } {
    set source [ string map { "/lib/" "" "/lib" "" } $::env(LD_LIBRARY_PATH) ]
    exec cp -r "$source" "$::env(HOME)/openroad$::env(WINDOWSPATHMAPPING)"
    } 

    set ::env(PATH) "$::env(HOME)/openroad$::env(WINDOWSPATHMAPPING)/bin:$::env(PATH)"
    set ::env(LD_LIBRARY_PATH) "$::env(HOME)/openroad$::env(WINDOWSPATHMAPPING)/lib"

    if {[file exists "$::env(HOME)/library$::env(WINDOWSPATHMAPPING)" ] } {
    exec rm "$::env(HOME)/library$::env(WINDOWSPATHMAPPING)"
    }

    file link -symbolic "$::env(HOME)/library$::env(WINDOWSPATHMAPPING)" "$::env(PDK_ROOT)"

    set ::env(PDK_ROOT) "$::env(HOME)/library$::env(WINDOWSPATHMAPPING)"

    puts ""
    puts ""
    puts "***********************************"
    puts "adjusted parameters for Windows Subsystem for Linux (wsl):"
    puts "PDK root folder: $::env(PDK_ROOT)"
    puts "PATH: $::env(PATH)"
    puts "LD_LIBRARY_PATH: $::env(LD_LIBRARY_PATH)"
    puts "***********************************"
}


