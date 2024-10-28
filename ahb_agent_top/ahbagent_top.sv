class ahbagent_top extends uvm_env;
  `uvm_component_utils(ahbagent_top)
  function new(string name = "ahbagent_top",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  ahb_agent ahb_agt[];
  env_config cfg;
  ahb_config ahb_cfg[];
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",cfg))
      begin
        `uvm_fatal(get_type_name(),"check hierarchy")
      end
      ahb_agt = new[cfg.no_of_ahb_agents];
      ahb_cfg = new[cfg.no_of_ahb_agents];
    foreach(ahb_cfg[i])
      begin
         ahb_agt[i] = ahb_agent::type_id::create($sformatf("ahb_agt[%0d]",i),this);
         ahb_cfg[i] = cfg.ahb_cfg[i];
        uvm_config_db#(ahb_config)::set(this,$sformatf("ahb_agt[%0d]*",i),"ahb_config",ahb_cfg[i]);
      end
  endfunction
endclass
                                         