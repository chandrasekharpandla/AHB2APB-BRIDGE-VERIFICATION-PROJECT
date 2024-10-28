//APB-interface

interface apb_interface(input bit hclk);
  
  logic penable;
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic [3:0] pselx;
  logic pwrite;
  
  clocking apb_drv_cb @(posedge hclk);
    default input #1 output #1;
    input penable;
    input pselx;
    input pwrite;
    output prdata;
  endclocking
  
  clocking apb_mon_cb @(posedge hclk);
    default input #1 output #1;
    input penable;
    input paddr;
    input pwdata;
    input prdata;
    input pselx;
    input pwrite;
  endclocking
  
  modport apb_drv_mp (clocking apb_drv_cb);
  modport apb_mon_mp (clocking apb_mon_cb);
      
endinterface
