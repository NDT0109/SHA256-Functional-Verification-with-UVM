class sha_env extends uvm_env;
   `uvm_component_utils(sha_env)
   msg_agent      agnt;  
   sha_scoreboard scb;

   function new(string name="sha_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction 

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agnt  = msg_agent::type_id::create("agnt", this);
      scb = sha_scoreboard::type_id::create("scb", this);
   endfunction 

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agnt.mon.mon_analysis_port.connect(scb.msg_analysis_imp);
   endfunction
endclass
