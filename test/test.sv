class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  function new(string name = "base_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  ahb_apb_env env;
  //increment_sequence seqs;
  env_config cfg;
  ahb_config ahb_cfg[];
  apb_config apb_cfg[];
  int no_of_ahb_agents = 1;
  int no_of_apb_agents = 1;
  function void build_phase(uvm_phase phase);

    cfg = env_config::type_id::create("cfg");
   // seqs = increment_sequence::type_id::create("seqs");
    cfg.no_of_ahb_agents = 1;
    cfg.no_of_apb_agents = 1;
    ahb_cfg = new[no_of_ahb_agents];
    apb_cfg = new[no_of_apb_agents];
    
    cfg.ahb_cfg = new[no_of_ahb_agents];
    cfg.apb_cfg = new[no_of_apb_agents];
    
    foreach(ahb_cfg[i])
      begin
        ahb_cfg[i] = ahb_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
        if(!uvm_config_db#(virtual ahb_interface)::get(this,"","ahb_if",ahb_cfg[i].vif))
          begin
            `uvm_fatal(get_type_name(),"CHECK HIERARCHY")
          end
        ahb_cfg[i].is_active  = UVM_ACTIVE;
        cfg.ahb_cfg[i] = ahb_cfg[i];
      end
    foreach(apb_cfg[i])
      begin
        apb_cfg[i] = apb_config::type_id::create($sformatf("apb_cfg[%0d]",i));
        if(!uvm_config_db#(virtual apb_interface)::get(this,"","apb_if",apb_cfg[i].vif))
          begin
            `uvm_fatal(get_type_name(),"CHECK HIERARCHY")
          end
        apb_cfg[i].is_active  = UVM_ACTIVE;
        cfg.apb_cfg[i] = apb_cfg[i];
      end
    //cfg.no_of_ahb_agents = no_of_ahb_agents;
    //cfg.no_of_apb_agents = no_of_apb_agents;
    env = ahb_apb_env::type_id::create("env",this);
    
    uvm_config_db#(env_config)::set(this,"*","env_config",cfg);
    
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
 /* task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this,"objection raised");
    seqs.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask*/
  
endclass

class single_sequence_test extends base_test;
  `uvm_component_utils(single_sequence_test)
  function new(string name = "single_sequence_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  single_sequence seqs1;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
	
    phase.raise_objection(this,"objection raised");
    seqs1 = single_sequence::type_id::create("seqs1");
    seqs1.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class increment_sequence_test extends base_test;
  `uvm_component_utils(increment_sequence_test)
  function new(string name = "increment_sequence_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  increment_sequence seqs2;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
   
    phase.raise_objection(this,"objection raised");
    seqs2 = increment_sequence::type_id::create("seqs2");
    seqs2.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class wrapping_sequence_test extends base_test;
  `uvm_component_utils(wrapping_sequence_test)
  function new(string name = "wrapping_sequence_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  wrapping_sequence seqs3;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
    phase.raise_objection(this,"objection raised");
    seqs3 = wrapping_sequence::type_id::create("seqs3");
    seqs3.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class new_sequence_test extends base_test;
  `uvm_component_utils(new_sequence_test)
  function new(string name = "new_sequence_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  new_sequence seqs4;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
    phase.raise_objection(this,"objection raised");
    seqs4 = new_sequence::type_id::create("seqs4");
    seqs4.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class new_sequence1_test extends base_test;
  `uvm_component_utils(new_sequence1_test)
  function new(string name = "new_sequence1_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  new_sequence1 seqs5;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
    phase.raise_objection(this,"objection raised");
    seqs5 = new_sequence1::type_id::create("seqs5");
    seqs5.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class new_sequence2_test extends base_test;
  `uvm_component_utils(new_sequence2_test)
  function new(string name = "new_sequence2_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  new_sequence2 seqs6;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
    phase.raise_objection(this,"objection raised");
    seqs6 = new_sequence2::type_id::create("seqs6");
    seqs6.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass

class new_sequence3_test extends base_test;
  `uvm_component_utils(new_sequence3_test)
  function new(string name = "new_sequence3_test",uvm_component parent = null);
     super.new(name,parent);
  endfunction
  new_sequence3 seqs7;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
  
    phase.raise_objection(this,"objection raised");
    seqs7 = new_sequence3::type_id::create("seqs7");
    seqs7.start(env.ahb_top.ahb_agt[0].ahb_seqr);
   	#80;
    phase.drop_objection(this,"objection droped");
  endtask
endclass


  
