global env

proc getCurrentScriptDirectory {} {
    return [file dirname [file normalize [info script]]]
}

# load translations if required
if { [::LayoutEditor::isLibraryUsed "tsmcN65"]} {
    # only briefly integrated, most callbacks are disfunctional
    # that iPDK is far away from a real iPDK
    set folder [getCurrentScriptDirectory]
    ::LayoutEditor::loadTranslations "$folder/tsmcN65.translations"
    ::LayoutEditor::overwrite_iPDK
}



