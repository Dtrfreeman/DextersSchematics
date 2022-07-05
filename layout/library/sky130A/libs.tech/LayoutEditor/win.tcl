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


