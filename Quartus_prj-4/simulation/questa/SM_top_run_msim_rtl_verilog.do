transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/SM_top.v}
vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/vga_pic.v}
vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/vga_pic_color.v}
vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/vga_pic_end.v}
vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Rtl {D:/abc/Lab4/Rtl/pll.v}

vlog -vlog01compat -work work +incdir+D:/abc/Lab4/Quartus_prj/../Sim {D:/abc/Lab4/Quartus_prj/../Sim/tb_SM_top.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_SM_top

add wave *
view structure
view signals
run -all
