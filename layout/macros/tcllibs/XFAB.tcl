global env

if {[info exists ::env(FTK_KIT_DIR)] } {
   if {[::LayoutEditor::debug]} { puts "\$FTK_KIT_DIR is $env(FTK_KIT_DIR)" }
} else {

        if { [file exists "c:/LayoutEditor"] } {
           set env(FTK_KIT_DIR) "c:/LayoutEditor"
        } else {
           if { [file exists "d:/LayoutEditor"] } {
           set env(FTK_KIT_DIR) "d:/LayoutEditor"
        } else {
          if { [file exists "e:/LayoutEditor"] } {
           set env(FTK_KIT_DIR) "e:/LayoutEditor"
         } else {
           if { [file exists "~/LayoutEditor"] } {
           set env(FTK_KIT_DIR) "~/LayoutEditor"
         }
         }}}
         
         if {[info exists ::env(FTK_KIT_DIR)] } {
           if {[::LayoutEditor::debug]} { puts "\$FTK_KIT_DIR not set, set to $env(FTK_KIT_DIR)" }
         } else {
          if {[::LayoutEditor::debug]} { puts "\$FTK_KIT_DIR not set, correct setting cannot be detected. Please set manual" }
         }

}

proc getCurrentScriptDirectory {} {
    return [file dirname [file normalize [info script]]]
}

set folder [getCurrentScriptDirectory]
::LayoutEditor::loadTranslations "$folder/XFAB.translations"

proc artParameterInToolDisplay { args } {
return [::il::artParameterInToolDisplay $args]
}

