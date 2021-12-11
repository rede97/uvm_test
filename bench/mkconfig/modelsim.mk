######################################################################
####                                                              ####
#### WISHBONE SD Card Controller IP Core                          ####
####                                                              ####
#### Makefile                                                     ####
####                                                              ####
#### This file is part of the WISHBONE SD Card                    ####
#### Controller IP Core project                                   ####
#### http://opencores.org/project,sd_card_controller              ####
####                                                              ####
#### Description                                                  ####
#### Simulation makefile                                          ####
####                                                              ####
#### Author(s):                                                   ####
####     - Marek Czerski, ma.czerski@gmail.com                    ####
####                                                              ####
######################################################################
####                                                              ####
#### Copyright (C) 2013 Authors                                   ####
####                                                              ####
#### This source file may be used and distributed without         ####
#### restriction provided that this copyright statement is not    ####
#### removed from the file and that any derivative work contains  ####
#### the original copyright notice and the associated disclaimer. ####
####                                                              ####
#### This source file is free software; you can redistribute it   ####
#### and/or modify it under the terms of the GNU Lesser General   ####
#### Public License as published by the Free Software Foundation; ####
#### either version 2.1 of the License, or (at your option) any   ####
#### later version.                                               ####
####                                                              ####
#### This source is distributed in the hope that it will be       ####
#### useful, but WITHOUT ANY WARRANTY; without even the implied   ####
#### warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ####
#### PURPOSE. See the GNU Lesser General Public License for more  ####
#### details.                                                     ####
####                                                              ####
#### You should have received a copy of the GNU Lesser General    ####
#### Public License along with this source; if not, download it   ####
#### from http://www.opencores.org/lgpl.shtml                     ####
####                                                              ####
######################################################################

MODELSIM_DIR ?= /d/modeltech64_2020.4/win64

VCOM = $(MODELSIM_DIR)/vcom
VLOG = $(MODELSIM_DIR)/vlog
VOPT = $(MODELSIM_DIR)/vopt
SCCOM = $(MODELSIM_DIR)/sccom
VLIB = $(MODELSIM_DIR)/vlib
VMAP = $(MODELSIM_DIR)/vmap
VSIM = $(MODELSIM_DIR)/vsim

# Define path to each library
LIB_SV_STD = $(MODELSIM_DIR)/sv_std
LIB_WORK = work
LIB_TEST = test

CLI_STARTUP_FILE = ./tcl/cli_startup.do

UVM_HOME ?= 
UVM_DPI_HOME ?= 
WORL_HOME = $(WORK_DIR)

ifeq ($(UVM_HOME),)
$(error env 'UVM_HOME' undefined to src)
endif

ifeq ($(UVM_DPI_HOME),)
$(error env 'UVM_DPI_HOME' undefined, to binary)
endif

work_library: $(LIB_WORK) work_objects

work_objects: $(WORK_SOURCES)
	$(V)$(VLOG) -work $(LIB_WORK) +incdir+$(WORK_DIR) $?
	
$(LIB_WORK) :
	$(V)echo "creating library $@ ..."
	$(V)$(VLIB) $(LIB_WORK)
	$(V)$(VMAP) $(LIB_WORK) $(LIB_WORK)

test_library: $(LIB_TEST) test_objects

test_objects: $(TEST_SOURCES)
	$(V)$(VLOG) -work $(LIB_TEST) +incdir+$(WORK_DIR) +incdir+$(TEST_DIR) +incdir+$(UVM_HOME)/src -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $?

$(LIB_TEST) : 
	$(V)echo "creating library $@ ..."
	$(V)$(VLIB) $(LIB_TEST)
	$(V)$(VMAP) $(LIB_TEST) $(LIB_TEST)

compile: work_library test_library

%_tb: compile
	$(V)$(VSIM) -c -L $(RUN_DIR)/$(LIB_WORK) -sv_lib $(UVM_DPI_HOME)/uvm_dpi +UVM_NO_RELNOTES -do $(CLI_STARTUP_FILE) $(LIB_TEST).$@
	-$(V)mv -f *.vcd $(OUT_DIR);
	-$(V)mv -f *.log $(LOG_DIR);
	-$(V)mv -f transcript $(LOG_DIR);

simulate: $(TESTBENCHES)

print_work_objects:
	$(V)@echo $(WORK_OBJECTS)

sim_clean:
	$(V)rm -rfv $(LIB_WORK)
	$(V)rm -rfv $(LIB_TEST)
	$(V)rm -fv modelsim.ini *.wlf transcript
