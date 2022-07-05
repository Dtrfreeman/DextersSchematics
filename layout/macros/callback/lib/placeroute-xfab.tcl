puts "***********************************"
puts "*"
puts "* X-FAB place & route with openroad started"
puts "*"
puts "* WARNING: "
puts "* this integration and OpenROAD is still under development"
puts "* review the results carefully and adjust the flow to your requirements."
puts "*"
puts "* This file is a template only and comes without any warranty."
puts "*"
puts "*"
puts "***********************************"
puts "parameter passed by the LayoutEditor script:"
puts "PDK root folder: $::env(PDK_ROOT)"
puts "use PDK: $::env(PDK)"
puts "use libCode: $::env(LIBCODE)"
puts "use letter code: $::env(LCODE)"
puts "use library: $::env(STD_CELL_LIBRARY)"
puts "design name: $::env(DESIGN)"
puts "LEF file (created from currend design, not used): $::env(LEF)"
puts "merged LEF (created from pdk): $::env(LEF_MERGED)"
puts "tech LEF (created from pdk): $::env(LEF_TECH)"
puts "library LEF (created from pdk): $::env(LEF_LIB)"
puts "liberty file: $::env(LIBERTY)"
puts "DEF file: $::env(DEF)"
puts "work folder: $::env(WORK_ROOT)"
puts "temp folder: $::env(TEMP_DIR)"
puts "script folder: $::env(SCRIPT_DIR)"
puts "die area: $::env(DIEAREA)"
puts "core die area: $::env(COREAREA)"
puts "***********************************"

set design $::env(DESIGN)
set top_module $::env(DESIGN)

read_lef "$::env(LEF_TECH)"

read_lef "$::env(LEF_LIB)"

# a library is required, set_cmd_units alone will fail
read_liberty "$::env(LIBERTY)"

set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um

read_def "$::env(DEF)"

source "$::env(SCRIPT_DIR)/openroad-tools.tcl"

# no pad for power nets
#removeBTerm "vdd" "gnd"

set site [getUsedSite]
set die_area [split $::env(DIEAREA) ";" ]
set core_area [split $::env(COREAREA) ";" ]

set tracks_file "$::env(WORK_ROOT)/tracks.info"
write_track_info "$tracks_file"

if {[llength $die_area] ==4 } {
  initialize_floorplan  -site $site -die_area $die_area  -core_area $core_area -tracks $tracks_file
  } else {
  initialize_floorplan  -site $site -utilization 50 -aspect_ratio 1 -core_space 5 -tracks $tracks_file
  }


# remove_buffers

place_pins -random -hor_layer 2 -ver_layer 3

eval tapcell  -endcap_cpp 2 -distance 84  -tapcell_master DECAP3$::env(LCODE) -endcap_master DECAP3$::env(LCODE)

puts "Generate power net"

write_pdn "$::env(WORK_ROOT)/xfab.pdn" "$::env(SCRIPT_DIR)/xfab.pdn"

pdngen -verbose "$::env(WORK_ROOT)/xfab.pdn"

puts "Global placement"

# option "-skip_initial_place" may be required for small design <500 instances

global_placement -disable_routability_driven -density 1  -init_density_penalty 8e-5 -pad_left 3 -pad_right 3 -skip_initial_place

puts "Check parasitics"

set_wire_rc -layer "MET3"
set_wire_rc -layer "MET2"
set_wire_rc -layer "MET1"
estimate_parasitics -placement

repair_design -max_wire_length 20000


set_placement_padding -global -left 0 -right 0

detailed_placement
optimize_mirroring
check_placement -verbose

report_checks -path_delay min_max -format full_clock_expanded -fields {input_pin slew capacitance} -digits 3
report_check_types -max_slew -max_capacitance -max_fanout -violators

repair_clock_inverters

detailed_placement

puts "Filler placement"

filler_placement "FEED*$::env(LCODE)"
check_placement

set filler_def "$::env(WORK_ROOT)/tri_filler.def"
write_def $filler_def

puts "Guide route"

set route_guide "$::env(WORK_ROOT)/route_guide"

set global_routing_layers 2-[max_route_layer]
set global_routing_clock_layers 2-[max_route_layer]
set_global_routing_layer_adjustment * 0.2


puts "fast route"

fastroute -guide_file $route_guide \
  -layers $global_routing_layers \
  -clock_layers $global_routing_clock_layers \
  -unidirectional_routing \
  -overflow_iterations 100 \
  -verbose 2

report_checks -path_delay min_max -format full_clock_expanded \
  -fields {input_pin slew capacitance} -digits 3
report_wns
report_tns
report_check_types -max_slew -max_capacitance -max_fanout -violators
report_power

report_floating_nets -verbose
report_design_area

################################################################
# Detailed routing with TritonRoute
puts "Detail route"

set drv_count 0

  set tr_params "-lef \"$::env(LEF_MERGED)\" -def \"$filler_def\" -guide \"$route_guide\" -output \"$::env(WORK_ROOT)/placedrouted.def\""
  if { [catch "exec which TritonRoute"] } {
    error "TritonRoute not found."
  }
  # TritonRoute returns error even when successful.
  catch "exec TritonRoute $tr_params | tee /dev/tty" tr_log
  puts $tr_log
  regexp -all {number of violations = ([0-9]+)} $tr_log ignore drv_count


puts "openROAD script competed"

# output created by triton route
# write_def "$::env(WORK_ROOT)/placedrouted.def"
