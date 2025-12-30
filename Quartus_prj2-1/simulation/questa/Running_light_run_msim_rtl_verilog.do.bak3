transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/abc/Lab2/Lab2-2/Rtl {D:/abc/Lab2/Lab2-2/Rtl/Running_light.v}

vlog -vlog01compat -work work +incdir+D:/abc/Lab2/Lab2-2/Quartus_prj/../Sim {D:/abc/Lab2/Lab2-2/Quartus_prj/../Sim/tb_Running_light.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Running_light

add wave *
view structure
view signals
run 8 sec
