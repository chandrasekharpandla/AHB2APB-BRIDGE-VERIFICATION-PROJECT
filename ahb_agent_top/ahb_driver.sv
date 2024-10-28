class ahb_driver extends uvm_driver#(ahb_xtn);
  `uvm_component_utils(ahb_driver)
  
  function new(string name = "ahb_drv",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual ahb_interface.ahb_drv_mp vif;
  ahb_config ahb_cfg;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
      begin
         `uvm_fatal(get_type_name(),"CHECK HIERARCHY")
      end
      
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //super.connect_phase(phase);
    vif  = ahb_cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
     //super.run_phase(phase);
     @(vif.ahb_drv_cb);
       vif.ahb_drv_cb.hresetn <= 1'b0;
	   //repeat(3)
       @(vif.ahb_drv_cb);
       vif.ahb_drv_cb.hresetn <= 1'b1;
     forever
       begin
          seq_item_port.get_next_item(req);
          send_to_dut(req);
          seq_item_port.item_done();
          
       end
  endtask
  
  task send_to_dut(ahb_xtn req);
     while(vif.ahb_drv_cb.hreadyout !== 1'b1)
	    begin
	        @(vif.ahb_drv_cb);	
		end
       vif.ahb_drv_cb.hwrite <= req.hwrite;
       vif.ahb_drv_cb.hreadyin <= 1'b1;
       vif.ahb_drv_cb.htrans <= req.htrans;
       vif.ahb_drv_cb.hsize <= req.hsize;
       vif.ahb_drv_cb.haddr <= req.haddr;
       
	   
     @(vif.ahb_drv_cb);
     while(vif.ahb_drv_cb.hreadyout !== 1'b1)
	   begin
		@(vif.ahb_drv_cb);
	   end
     if(req.hwrite == 1)
       vif.ahb_drv_cb.hwdata <= req.hwdata;
     else
       vif.ahb_drv_cb.hwdata <= 32'd0;
   //`uvm_info(get_type_name(),"AHB-DRIVER",UVM_NONE)
   // req.print();
  endtask
  
  
  
endclass



