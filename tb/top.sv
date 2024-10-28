
import uvm_pkg::*;
import ahb_apb_package::*;
`include "uvm_macros.svh"

module top();

 bit clk = 1'b0;
 
 always #10 clk = ~clk;
 
 ahb_interface ahb_if(clk);
 apb_interface apb_if(clk);
 
 //AHB_APB_top instantiation
 
 rtl_top DUT (.Hclk(clk),
             .Hresetn(ahb_if.hresetn),
             .Htrans(ahb_if.htrans),
             .Hsize(ahb_if.hsize),
             .Hreadyin(ahb_if.hreadyin),
             .Haddr(ahb_if.haddr),
             .Hwdata(ahb_if.hwdata),
             .Hwrite(ahb_if.hwrite),
             .Hrdata(ahb_if.hrdata),
             .Prdata(apb_if.prdata),
             .Hresp(ahb_if.hresp),
             .Hreadyout(ahb_if.hreadyout),
             .Pselx(apb_if.pselx),
             .Pwrite(apb_if.pwrite),
             .Penable(apb_if.penable),
             .Paddr(apb_if.paddr),
             .Pwdata(apb_if.pwdata));

  
  initial
    begin
       uvm_config_db#(virtual ahb_interface)::set(null,"*","ahb_if",ahb_if);
       uvm_config_db#(virtual apb_interface)::set(null,"*","apb_if",apb_if);
       run_test();
    end
    
  initial
     begin
		   `ifdef VCS
         		$fsdbDumpvars(0, top);
   		`endif
     end
  
 
  
endmodule