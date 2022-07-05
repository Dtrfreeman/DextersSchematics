 
 
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
