yosys -import



read_verilog -defer -sv $::env(VERILOG_FILE)

#read_verilog -defer -sv "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/verilog/$::env(STD_CELL_LIBRARY).v"
#read_verilog  -sv -lib "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/verilog/primitives.v"

#read_liberty "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_1v80.lib"

synth  -top $::env(DESIGN) -flatten

opt -purge

dfflibmap -liberty "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_1v80.lib"

abc -liberty "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_1v80.lib"
opt_clean

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# remove unused cells and wires
opt_clean -purge

# technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}sky130_fd_sc_hd__conb_1 HI \
        -locell {*}sky130_fd_sc_hd__conb_1 LO

# insert buffer cells for pass through wires
insbuf -buf {*}$::env(STD_CELL_LIBRARY)__buf_4 A X


write_verilog -noattr -noexpr -nohex -nodec $::env(WORK_ROOT)/synth.v

