

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)
  uvm_analysis_port #(ahb_xtn) ahb_ap;
  function new(string name = "ahb_monitor",uvm_component parent = null);
    super.new(name,parent);
    ahb_ap = new("ahb_ap",this);
  endfunction
  
  virtual ahb_interface.ahb_mon_mp vif;
  ahb_config ahb_cfg;
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
      begin
         `uvm_fatal(get_type_name(),"CHECK HIERARCHY")
      end
      
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif  = ahb_cfg.vif;
  endfunction
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
     @(vif.ahb_mon_cb);
     @(vif.ahb_mon_cb);
     @(vif.ahb_mon_cb);
    forever
     begin
       
        collect_data();
     end
  endtask
  
  
  task collect_data();
    ahb_xtn xtn;
    xtn = ahb_xtn::type_id::create("xtn");
    while(vif.ahb_mon_cb.hreadyout !== 1 &&(vif.ahb_mon_cb.htrans != 2'b10 || vif.ahb_mon_cb.htrans != 2'b11))
	   begin
	     @(vif.ahb_mon_cb);
	   end
      xtn.hwrite = vif.ahb_mon_cb.hwrite;
      xtn.haddr = vif.ahb_mon_cb.haddr;
      xtn.htrans = vif.ahb_mon_cb.htrans;
      xtn.hsize = vif.ahb_mon_cb.hsize;
      xtn.hreadyin = vif.ahb_mon_cb.hreadyin;
    @(vif.ahb_mon_cb);
    while(vif.ahb_mon_cb.hreadyout !== 1 &&(vif.ahb_mon_cb.htrans != 2'b10 || vif.ahb_mon_cb.htrans != 2'b11))
	   begin
	     @(vif.ahb_mon_cb);
	   end
    if(vif.ahb_mon_cb.hwrite)
       xtn.hwdata = vif.ahb_mon_cb.hwdata;
    else
       xtn.hrdata = vif.ahb_mon_cb.hrdata;
    //`uvm_info(get_type_name(),"AHB-MONITOR",UVM_NONE)
   // xtn.print();
    ahb_ap.write(xtn);
  endtask   
  
  
endclass

