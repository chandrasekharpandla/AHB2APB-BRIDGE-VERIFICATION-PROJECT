class base_sequence extends uvm_sequence#(ahb_xtn);
  `uvm_object_utils(base_sequence)
  function new(string name = "base_sequence");
    super.new(name);
  endfunction

endclass

class single_sequence extends base_sequence;
  `uvm_object_utils(single_sequence)
  function new(string name = "single_sequence");
    super.new(name);
  endfunction
  
  task body();
   begin
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;hburst == 3'b000;hwrite==1'b1;hsize == 3'b010;});
    finish_item(req); end
  endtask
endclass

class increment_sequence extends base_sequence;
  `uvm_object_utils(increment_sequence)
  function new(string name = "increment_sequence");
    super.new(name);
  endfunction
  bit [31:0] Haddr;
  bit Hwrite;
  bit [2:0] Hsize;
  bit [2:0] Hburst;
  bit [9:0] Length;
  
  task body();
	
    req = ahb_xtn::type_id::create("ahb_xtn");
    //for non sequential tranfer
    start_item(req);
    assert(req.randomize() with {hburst inside {1,3,5,7};htrans == 2'b10; hwrite ==1'b1;});
    finish_item(req);
    Haddr  =  req.haddr + (2**req.hsize);
    Hwrite =  req.hwrite;
    Hburst =  req.hburst;
    Hsize  =  req.hsize;
    Length =  req.length;
    
    //forloop for sequential transfer
    
    for(int i = 1;i < Length;i++)
      begin
        start_item(req);
        assert(req.randomize() with {
          htrans == 2'b11;
          hsize == Hsize;
          hburst == Hburst;
          hwrite == Hwrite;
          haddr == Haddr;
                   
                             });
        finish_item(req);
        Haddr = req.haddr + (2**req.hsize);
      end
  endtask
endclass

//wrapping sequence

class wrapping_sequence extends base_sequence;
  `uvm_object_utils(wrapping_sequence)
  function new(string name = "wrapping_sequence");
    super.new(name);
  endfunction
  bit Hwrite;
  bit [31:0] Haddr;
  bit [2:0] Hsize;
  bit [9:0] Length;
  bit [2:0] Hburst;
  bit [31:0] starting_addr;
  bit [31:0] boundary_addr;
  task body();
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;
                          hburst inside {2,4,6};
                          hwrite == 1'b1;});
    finish_item(req);
    Haddr = req.haddr + (2**req.hsize);
    Hsize = req.hsize;
    Hwrite = req.hwrite;
	Hburst = req.hburst;
    Length = req.length;
    starting_addr = (req.haddr/(Length*(2**Hsize))*(Length*(2**Hsize)));
    boundary_addr = starting_addr + (Length*(2**Hsize));
    for(int i = 1;i < Length;i++)
      begin
        if(Haddr >= boundary_addr)
          Haddr = starting_addr;
        start_item(req);
        assert(req.randomize() with {htrans == 2'b11;
                              haddr == Haddr;
                              hsize == Hsize;
                              hwrite == Hwrite;
							  hburst == Hburst;
                             });
        finish_item(req);
        Haddr = req.haddr + (2**req.hsize);
        
      end
  endtask
endclass
class new_sequence extends base_sequence;
  `uvm_object_utils(new_sequence)
  function new(string name = "new_sequence");
    super.new(name);
  endfunction
  
  task body();
   begin
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;hburst == 3'b000;hsize == 3'b000;hwrite==1'b0;haddr inside{[32'h8000_0000:32'h8000_03ff]};});
    finish_item(req);
   end
  endtask
endclass

class new_sequence1 extends base_sequence;
  `uvm_object_utils(new_sequence1)
  function new(string name = "new_sequence1");
    super.new(name);
  endfunction
  
  task body();
   begin
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;hburst == 3'b000;hsize == 3'b010;hwrite==1'b0;haddr inside{[32'h8400_0000:32'h8400_03ff]};});
    finish_item(req);
   end
  endtask
endclass


class new_sequence2 extends base_sequence;
  `uvm_object_utils(new_sequence2)
  function new(string name = "new_sequence2");
    super.new(name);
  endfunction
  
  task body();
   begin
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;hburst == 3'b000;hsize == 3'b001;hwrite==1'b0;haddr inside{[32'h8800_0000:32'h8800_03ff]};});
    finish_item(req);
   end
  endtask
endclass

class new_sequence3 extends base_sequence;
  `uvm_object_utils(new_sequence3)
  function new(string name = "new_sequence3");
    super.new(name);
  endfunction
  
  task body();
   begin
    req = ahb_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;hburst == 3'b000;hwrite==1'b0;hsize ==3'b001; haddr inside{[32'h8c00_0000:32'h8c00_03ff]};});
    finish_item(req);
   end
  endtask
endclass
                     

    
    
