
class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  uvm_analysis_port#(apb_xtn) apb_ap;
  function new(string name = "apb_monitor",uvm_component parent = null);
    super.new(name,parent);
	apb_ap = new("apb_ap",this);
  endfunction
  
  virtual apb_interface.apb_mon_mp vif;
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
    forever
      collect_data();
  endtask
  
  task collect_data();
        apb_xtn xtn;
      	xtn = apb_xtn::type_id::create("xtn");
      	wait(vif.apb_mon_cb.penable == 1)
      	 xtn.pwrite = vif.apb_mon_cb.pwrite;
         xtn.pselx = vif.apb_mon_cb.pselx;
      	 xtn.paddr = vif.apb_mon_cb.paddr;
      	 xtn.penable = vif.apb_mon_cb.penable;
      	if(xtn.pwrite == 1)
      	  begin
      	    xtn.pwdata = vif.apb_mon_cb.pwdata;
      	  end
      	else
      	  begin
      	    xtn.prdata = vif.apb_mon_cb.prdata;
      	  end
         //`uvm_info(get_type_name(),"APB-MONITOR",UVM_NONE)
		   //  xtn.print();
         apb_ap.write(xtn);
      	  repeat(2)
      	    begin
      		    @(vif.apb_mon_cb);
      		  end
     		
  endtask
endclass