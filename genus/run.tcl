set DESIGN microprocessor_pad_top
set GEN_EFF medium
set MAP_OPT_EFF high
set clockname clk

set DATE [clock format [clock seconds] -format "%b%d-%T"]
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
set LOG_PATH logs${DATE}
set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_ROOT [file normalize [file join $SCRIPT_DIR ..]]

set_db / .init_lib_search_path {/opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss}
#set_db /.script_search_path {"/home/soujanya/cit_alu_8bit/cit_alu_8bit_synth/cit_alu_8bit.v}
set_db / .init_hdl_search_path {/home/thoshith/work_riscv/scl6m/design}
set_db auto_ungroup none

set_db / .information_level 7
################################################################
### Library setup /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib
################################################################
set_db / .library {
/opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_max.lib /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_min.lib}

##set_db / .lef_library {../lef/tsl18fs120_scl.lef}

read_libs -max_libs {
/opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_max.lib} -min_libs {/opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib /opt/tools/Cadence/Cadence_lib/scl_pdk_v3/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_min.lib}

#lib_cell_list gcnfnn1 gcnfnn2 gcnfnn4 gcnfnn7 gcnfnna gcnrnn1 gcnrnn2 gcnrnn4 gcnrnn7 gcnrnna mx08*
#set_dont_use lib_cell_lists [ gcnfnn1 gcnfnn2 gcnfnn4 gcnfnn7 gcnfnna gcnrnn1 gcnrnn2 gcnrnn4 gcnrnn7 gcnrnna mx08*]

puts "load RTL"
set_db / .hdl_language sv

# READ ALL FILES
read_hdl [glob /home/thoshith/work_riscv/scl6m/design/*.v]

# If there are other module files that Microprocessor.v depends on, read them too
# read_hdl fft.sv
# read_hdl fifo.sv

puts "elobrate design"
elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration
check_design -unresolved

# Preserve pipeline/memory visibility and avoid aggressive pruning.
set_db delete_unloaded_insts false
set_db optimize_constant_feedback_seqs false
set_db optimize_merge_flops false
set_db optimize_merge_latches false
set_db optimize_constant_0_flops false
set_db hdl_unconnected_value 0

read_sdc /home/thoshith/work_riscv/scl6m/design/microprocessor_genus.sdc

path_adjust -from [all_inputs] -to [all_outputs] -delay -1300 -name PA_I2O
path_adjust -from [all_inputs] -to [all_registers] -delay -1500 -name PA_I2C
path_adjust -from [all_registers] -to [all_outputs] -delay -1500 -name PA_C2O
path_adjust -from [all_registers] -to [all_registers] -delay -1500 -name PA_C2C
report_timing -lint -verbose

puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"
if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
  }
if {![file exists ${_REPORTS_PATH}]} {
file mkdir ${_REPORTS_PATH}
puts "Creating directory ${_REPORTS_PATH}"
 }
if {![file exists ${_LOG_PATH}]} {
file mkdir ${_LOG_PATH}
puts "Creating directory ${_LOG_PATH}"
 }
if {![file exists "${_REPORTS_PATH}/generic"]} {
file mkdir "${_REPORTS_PATH}/generic"
 }
if {![file exists "${_REPORTS_PATH}/map"]} {
file mkdir "${_REPORTS_PATH}/map"
 }
 set_db lp_power_analysis_effort high

 set_db syn_generic_effort $GEN_EFF
 syn_generic
 puts "Runtime & Memory after 'syn_generic'"
 time_info GENERIC
 report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
 write_snapshot -outdir $_REPORTS_PATH -tag generic
 write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_generic.v
 write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_generic.sdc

 set_db / .syn_map_effort high
 syn_map
 puts "Runtime & Memory after 'syn_map'"
 time_info MAPPED
 write_snapshot -outdir $_REPORTS_PATH -tag map
 report_summary -directory $_REPORTS_PATH
 report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt
 write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_map.v
 write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_map.sdc
 write_do_lec -revised_design fv_map -logfile ${LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

 set_db / .syn_opt_effort high
 syn_opt
 write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
 report_summary -directory $_REPORTS_PATH
 puts "Runtime & Memory after 'syn_opt'"
 time_info OPT
 write_snapshot -outdir $_REPORTS_PATH -tag final
 report_summary -directory $_REPORTS_PATH
 write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_incremental.v
 write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_incremental.sdc

 write_sdf -version 2.1 -recrem split -setuphold merge_when_paired -edges check_edge >${_OUTPUTS_PATH}/srff_pad.sdf

 set _LOG_PATH ./logs
 set _OUTPUTS_PATH ./outputs

 write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/${DESIGN}_incremental.v -logfile ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
 write_do_lec -revised_design fv_map -logfile ${_LOG_PATH}/rtl2intermediate.lec.log >${_OUTPUTS_PATH}/rtl2intermediate.lec.do


 puts "Final Runtime & Memory."
 time_info FINAL
 puts "============================"
 puts "Synthesis Finished ........."
 puts "============================"
