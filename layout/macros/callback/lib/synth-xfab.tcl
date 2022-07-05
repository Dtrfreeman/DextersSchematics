yosys -import



read_verilog -defer -sv "$::env(VERILOG_FILE)"

#read_verilog -defer -sv "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/verilog/$::env(STD_CELL_LIBRARY).v"
#read_verilog  -sv -lib "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/verilog/primitives.v"
#read_liberty "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_1v80.lib"

synth  -top $::env(DESIGN) -flatten

opt -purge

dfflibmap -liberty "$::env(LIBERTY)"

abc -liberty "$::env(LIBERTY)"
opt_clean

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# remove unused cells and wires
opt_clean -purge

#source "$::env(SCRIPT_DIR)/openroad-tools.tcl"


# technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}LOGIC1"$::env(LCODE)" HI \
        -locell {*}LOGIC0"$::env(LCODE)" LO


# insert buffer cells for pass through wires
insbuf -buf {*}BU"$::env(LCODE)"X4 A X


write_verilog -noattr -noexpr -nohex -nodec $::env(WORK_ROOT)/synth.v

