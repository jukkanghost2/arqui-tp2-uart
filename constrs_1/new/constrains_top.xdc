## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports i_clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports i_clock]
	create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports i_clock]
 
# Switches
set_property PACKAGE_PIN D17 [get_ports {i_reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_reset}]
set_property PACKAGE_PIN D18 [get_ports {i_tx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_tx}]
set_property PACKAGE_PIN D19 [get_ports {o_rx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {o_rx}]
set_property PACKAGE_PIN G18 [get_ports {o_tx_done}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {o_tx_done}]

	