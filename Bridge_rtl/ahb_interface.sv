interface ahb_interface(input bit hclk);
  
  logic hresetn;
  
  logic [31:0] haddr;
  logic [31:0] hwdata;
  
  
  
  logic hwrite;
  logic hreadyin;
  logic hreadyout;
  
  logic [1:0] htrans;
  logic [1:0] hresp;
  
  logic [2:0] hsize;
 // logic [2:0] hburst;
  
  logic [31:0] hrdata;
  
  clocking ahb_drv_cb @(posedge hclk);
    default input #1 output #1;
    output hresetn;
    output haddr;
    output hwdata;
    input  hrdata;
    output hwrite;
    output hreadyin;
    input hreadyout;
    output htrans;
    
    output hsize;
   // output hburst;
  endclocking
  
  clocking ahb_mon_cb @(posedge hclk);
    default input #1 output #1;
    input hresetn;
    input haddr;
    input hwdata;
    input hrdata;
    input hwrite;
    input hreadyin;
    input hreadyout;
    input htrans;
    input hsize;
   // input hburst;
  endclocking
  
  modport ahb_drv_mp (clocking ahb_drv_cb);
  modport ahb_mon_mp(clocking ahb_mon_cb);
    
endinterface
      
