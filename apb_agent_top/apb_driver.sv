class apb_driver extends uvm_driver#(apb_xtn);
  `uvm_component_utils(apb_driver)
  
  function new(string name = "apb_driver",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual apb_interface.apb_drv_mp vif;
  apb_config apb_cfg;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
      begin
         `uvm_fatal(get_type_name(),"CHECK HIERARCHY")
      end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = apb_cfg.vif;
  endfunction
  
 task run_phase(uvm_phase phase);
  //  req = apb_xtn::type_id::create("req");
    forever
	     begin
      //seq_item_port.get_next_item(req);
	        send_to_dut();
      //seq_item_port.item_done();
	     end
  endtask
  
  task send_to_dut();
    wait(vif.apb_drv_cb.pselx !== 0)
	  if(vif.apb_drv_cb.pwrite == 0)
	    begin
	      wait(vif.apb_drv_cb.penable)
	      vif.apb_drv_cb.prdata <= $urandom;
	    end
    //`uvm_info(get_type_name(),"APB-DRIVER",UVM_NONE)
	  //req.print();
	repeat(2)
	  begin
	    @(vif.apb_drv_cb); 
	  end
 
  endtask

	
  
  
endclass