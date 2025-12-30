onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_SM_top/sys_clk
add wave -noupdate /tb_SM_top/sys_rst_n
add wave -noupdate /tb_SM_top/key_n
add wave -noupdate /tb_SM_top/h_sync
add wave -noupdate /tb_SM_top/v_sync
add wave -noupdate /tb_SM_top/rgb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {70231999050 ps} {70232000050 ps}
