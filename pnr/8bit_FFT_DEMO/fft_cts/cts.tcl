set init_top_cell fft_8_top
set_global report_timing_format {instance arc net cell slew delay arrival required} 

source /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/config.tcl
create_ccopt_clock_tree_spec -file /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/run/${init_top_cell}_ccopt.spec 
source /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/run/${init_top_cell}_ccopt.spec 
ctd_win -id before_ccopt 

set_ccopt_property -delay_corner max_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type leaf  target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type leaf  target_max_trans 2 

set_ccopt_property -skew_group fft_clk/all  -delay_corner min_delay target_skew 0.5 
set_ccopt_property  -delay_corner min_delay target_skew 0.5 
set_ccopt_property source_driver pc3d01/CIN -clock_tree fft_clk 

set_ccopt_property balance_mode cluster 
ccopt_design -cts 
ctd_win -id cluster_mode 
set_ccopt_property balance_mode trial 
ccopt_design -cts 
ctd_win -id trial_mode 
set_ccopt_property balance_mode full 
ccopt_design -cts 
ctd_win -id full_mode 

report_ccopt_clock_trees -summary -file /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/run/${init_top_cell}_clock_trees.rpt 
report_ccopt_skew_groups -summary -file /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/run/${init_top_cell}_skew_group.rpt 
reportCongestion -overflow -hotSpot > /home/anirudh/Work/scl6m/RTL_to_GDS_TA/8bit_FFT/fft_cts/run/${init_top_cell}_congestion.rpt
