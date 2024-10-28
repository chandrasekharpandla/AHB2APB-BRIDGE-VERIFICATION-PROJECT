class apb_xtn extends uvm_sequence_item;
  `uvm_object_utils(apb_xtn)
  function new(string name = "apb_xtn");
    super.new(name);
  endfunction
  
  bit [31:0] paddr,pwdata;
  rand bit [31:0] prdata;
  bit pwrite,penable;
  bit [3:0] pselx;
  
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("paddr", this.paddr, 32, UVM_HEX);
    printer.print_field("penable", this.penable, 1, UVM_DEC);
    printer.print_field("pwrite", this.pwrite, 1, UVM_DEC);
    printer.print_field("pselx", this.pselx, 4, UVM_BIN);
    printer.print_field("prdata", this.prdata, 32, UVM_HEX);
    printer.print_field("pwdata", this.pwdata, 32, UVM_HEX);
    
  endfunction
endclass