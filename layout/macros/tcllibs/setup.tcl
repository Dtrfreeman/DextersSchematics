
set application [ list [::LayoutEditor::tool] [::LayoutEditor::version] ]

if {[::LayoutEditor::debug]} { 
        if {[info commands ::LayoutEditor::version] !=""} {
          ::LayoutEditor::setMessageParameter true false true 3000
        }
}