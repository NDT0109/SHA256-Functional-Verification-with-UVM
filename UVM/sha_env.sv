class sha_env extends uvm_env;
   `uvm_component_utils(sha_env)
   msg_agent      msg_a0;  
   sha_scoreboard sha_sb0;
   sha_subs sub;

   function new(string name="sha_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction 

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      msg_a0  = msg_agent::type_id::create("msg_a0", this);
      sha_sb0 = sha_scoreboard::type_id::create("sha_sb0", this);
     sub = sha_subs::type_id::create("sub", this);
   endfunction 

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      msg_a0.m0.mon_analysis_port.connect(sha_sb0.msg_analysis_imp);
     msg_a0.m0.mon_analysis_port.connect(sub.analysis_export);
   endfunction 
endclass 
