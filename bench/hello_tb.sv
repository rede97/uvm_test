//UVM test yop
//top
`include "uvm_pkg.sv"
 
module hello_tb;
 
  import uvm_pkg::*;
  `include "uvm_macros.svh"   
        	
  initial begin
  
    `uvm_info("info1","hello UVM",UVM_LOW);
	
  end
  
endmodule : hello_tb