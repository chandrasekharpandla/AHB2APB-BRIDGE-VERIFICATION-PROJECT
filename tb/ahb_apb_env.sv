class ahb_apb_env extends uvm_env;
  `uvm_component_utils(ahb_apb_env)
  function new(string name = "ahb_apb_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  env_config cfg;
  
  ahbagent_top ahb_top;
  apbagent_top apb_top;
  ahb_apb_scoreboard sb;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",cfg))
     begin
       `uvm_fatal(get_type_name(),"CHECH HIERARCHY")
     end
    ahb_top = ahbagent_top::type_id::create("ahb_top",this);
    apb_top = apbagent_top::type_id::create("apb_top",this);
    sb = ahb_apb_scoreboard::type_id::create("sb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     ahb_top.ahb_agt[0].ahb_mon.ahb_ap.connect(sb.ahb_fifo.analysis_export);
     apb_top.apb_agt[0].apb_mon.apb_ap.connect(sb.apb_fifo.analysis_export);
  endfunction
endclass