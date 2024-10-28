class apbagent_top extends uvm_env;
  `uvm_component_utils(apbagent_top)
  function new(string name = "apbagent_top",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  apb_agent apb_agt[];
  apb_config apb_cfg[];
  env_config cfg;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",cfg))
      begin
        `uvm_fatal(get_type_name(),"check hierarchy")
      end
      apb_agt = new[cfg.no_of_apb_agents];
      apb_cfg = new[cfg.no_of_apb_agents];
    foreach(apb_cfg[i])
      begin
        apb_agt[i] = apb_agent::type_id::create($sformatf("apb_agt[%0d]",i),this);
        apb_cfg[i] = cfg.apb_cfg[i];
        uvm_config_db#(apb_config)::set(this,$sformatf("apb_agt[%0d]*",i),"apb_config",apb_cfg[i]);
      end
  endfunction
endclass
                                         