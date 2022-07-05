puts "***********************************"
puts "*"
puts "* sky130a place & route with openroad started"
puts "*"
puts "* WARNING: "
puts "* The skywater PDK, this integration and OpenROAD is still under development"
puts "* and its status is still experimental. It is not yet intended for productive use."
puts "*"
puts "*"
puts "***********************************"
puts "parameter passed by the LayoutEditor script:"
puts "PDK root folder: $::env(PDK_ROOT)"
puts "use PDK: $::env(PDK)"
puts "use library: $::env(STD_CELL_LIBRARY)"
puts "design name: $::env(DESIGN)"
puts "merged LEF (created from pdk): $::env(LEF_MERGED)"
puts "tech LEF (created from pdk): $::env(LEF_TECH)"
puts "work folder: $::env(WORK_ROOT)"
puts "temp folder: $::env(TEMP_DIR)"
puts "verilog file: $::env(VERILOG_FILE)"
puts "sdc file: $::env(SDC_FILE)"
puts "***********************************"


if { [info exists ::env(WINDOWSPATHMAPPING)] } {
   puts "mapping for Windows Subsystem for Linux (wsl) required to run yosys"
   source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/LayoutEditor/win.tcl"
}


puts "start synth"

set yosys_params "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/LayoutEditor/synth.tcl"

catch "exec yosys $yosys_params | tee /dev/tty" yosys_log
puts $yosys_log

puts "synth complete"

set design $::env(DESIGN)
set top_module $::env(DESIGN)

read_lef "$::env(LEF_TECH)"

read_lef "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lef/$::env(STD_CELL_LIBRARY).lef"

# a library is required, set_cmd_units alone will fail
read_liberty "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_1v80.lib"

set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um

read_verilog "$::env(WORK_ROOT)/synth.v"
link_design $::env(DESIGN)

read_sdc "$::env(SDC_FILE)"


set site "unithd"
set die_area { 0 0 3000 3000 }
set core_area { 5 5 2950 2950 }
set tracks_file "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/LayoutEditor/tracks.info"

#initialize_floorplan  -site $site -die_area $die_area  -core_area $core_area -tracks $tracks_file

initialize_floorplan  -site $site -utilization 30 -aspect_ratio 1 -core_space 5 -tracks $tracks_file


remove_buffers



place_pins -random -hor_layer 5 -ver_layer 4
eval tapcell  -endcap_cpp 2 -distance 14  -tapcell_master $::env(STD_CELL_LIBRARY)__tap_1 -endcap_master $::env(STD_CELL_LIBRARY)__decap_4

puts "Generate power net"
pdngen -verbose $::env(PDK_ROOT)/$::env(PDK)/libs.tech/LayoutEditor/sky130.pdn


puts "Global placement"
global_placement -disable_routability_driven -density 1  -init_density_penalty 8e-5 -pad_left 4 -pad_right 4

puts "Check parasitics"

set_wire_rc -layer "met3"
set_wire_rc -clock -layer "met5"
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

filler_placement "$::env(STD_CELL_LIBRARY)__fill_*"
check_placement

set filler_def "$::env(WORK_ROOT)/tri_filler.def"
write_def $filler_def

puts "Guide route"

set route_guide "$::env(WORK_ROOT)/route_guide"

set global_routing_layers 2-6
set global_routing_clock_layers 4-6
set global_routing_layer_adjustments {{3 0.15} {4 0.15} {5 0.15} {6 0.15}}

foreach layer_adjustment $global_routing_layer_adjustments {
  lassign $layer_adjustment layer adjustment
  set_global_routing_layer_adjustment $layer $adjustment
}

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

  puts "starting TritonRoute with parameter: $tr_params"

  catch "exec TritonRoute $tr_params | tee /dev/tty" tr_log
  puts $tr_log
  regexp -all {number of violations = ([0-9]+)} $tr_log ignore drv_count


puts "openROAD script competed"

# output created by triton route
# write_def "$::env(WORK_ROOT)/result.def"
