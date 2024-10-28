class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
  function new(string name = "ahb_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  ahb_monitor ahb_mon;
  ahb_driver ahb_drv;
  ahb_sequencer ahb_seqr;
  
  ahb_config ahb_cfg;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
      begin
        `uvm_fatal(get_type_name(),"check hierarchy")
      end
    ahb_mon = ahb_monitor::type_id::create("ahb_mon",this);
    if(ahb_cfg.is_active == UVM_ACTIVE)
     begin
       ahb_drv = ahb_driver::type_id::create("ahb_drv",this);
       ahb_seqr = ahb_sequencer::type_id::create("ahb_seqr",this);
     end
    
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(ahb_cfg.is_active == UVM_ACTIVE)
      begin
          ahb_drv.seq_item_port.connect(ahb_seqr.seq_item_export);
      end
    
  endfunction
endclass