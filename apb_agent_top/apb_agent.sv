class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  function new(string name = "apb_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  apb_monitor apb_mon;
  apb_driver apb_drv;
  apb_sequencer apb_seqr;
  
  apb_config apb_cfg;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
      begin
        `uvm_fatal(get_type_name(),"check hierarchy")
      end
    apb_mon = apb_monitor::type_id::create("apb_mon",this);
    if(apb_cfg.is_active == UVM_ACTIVE)
     begin
        apb_drv = apb_driver::type_id::create("apb_drv",this);
        apb_seqr = apb_sequencer::type_id::create("apb_seqr",this);
     end
    
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(apb_cfg.is_active == UVM_ACTIVE)
    begin
        apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
    end
    
  endfunction
endclass