class ahb_xtn extends uvm_sequence_item;
  `uvm_object_utils(ahb_xtn)
  function new(string name = "ahb_xtn");
      super.new(name);
  endfunction  
  rand bit[31:0] haddr;
  rand bit[31:0] hwdata;
  
  bit[31:0] hrdata;
  
  //reset is controlled in the driver logic,so no need to declare as rand
  bit hresetn;
  //hreadyin is also declared in the driver logic
  bit hreadyin;
  //hreadyout is coming from brom the bridge
  bit hreadyout;
  
  rand bit hwrite;
  
  rand bit[2:0] hburst;
  rand bit[2:0] hsize;
  
  rand bit[1:0] htrans;
  bit [2:0] hresp;
  
  rand bit [9:0] length;//1024
  constraint valid_size {hsize inside{[0:2]};}
  constraint valid_haddr {haddr inside{[32'h8000_0000:32'h8000_03ff],
                                       [32'h8400_0000:32'h8400_03ff],
                                       [32'h8800_0000:32'h8800_03ff],
                                       [32'h8c00_0000:32'h8c00_03ff]};}
  constraint valid_length {
                           hburst == 3'b000 -> length == 1;
                           hburst == 3'b001 -> haddr%1024+length*(2**hsize)<=1023;
                           hburst == 3'b010 -> length == 4;
                           hburst == 3'b011 -> length == 4;
                           hburst == 3'b100 -> length == 8;
                           hburst == 3'b101 -> length == 8;
                           hburst == 3'b110 -> length == 16;
                           hburst == 3'b111 -> length == 16;
                          
                          }
  constraint valid_increment {hsize == 3'b001 -> haddr%2 ==0;
                         hsize == 3'b010 -> haddr%4 == 0;
                        }
  function void do_print (uvm_printer printer);
    printer.print_field("hresetn",hresetn,1,UVM_BIN);
    printer.print_field("haddr",haddr,32,UVM_HEX);
    printer.print_field("hwdata",hwdata,32,UVM_HEX);
    printer.print_field("hrdata",hrdata,32,UVM_HEX);
    printer.print_field("hwrite",hwrite,1,UVM_BIN);
    printer.print_field("hsize",hsize,3,UVM_BIN);
    printer.print_field("hburst",hburst,3,UVM_BIN);
    printer.print_field("htrans",htrans,2,UVM_BIN);
    printer.print_field("hresp",hresp,3,UVM_BIN);
    printer.print_field("hreadyin",hreadyin,1,UVM_BIN);
    printer.print_field("hreadyout",hreadyout,1,UVM_BIN);
    printer.print_field("length",length,10,UVM_DEC);
  endfunction
endclass

  