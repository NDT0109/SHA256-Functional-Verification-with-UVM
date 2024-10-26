class double_value_test extends uvm_test;
  `uvm_component_utils(double_value_test)
   sha_env env_e0;
  
   function new (string name = "double_value_test", uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      env_e0 = sha_env::type_id::create("env_e0", this);
   endfunction 

   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction 

   virtual task run_phase (uvm_phase phase);
      msg_seq test_msgs = msg_seq::type_id::create("test_msgs");
      super.run_phase(phase);
      phase.raise_objection(this);
      test_msgs.start(env_e0.agnt.seqr);
      `uvm_info("TST", "TEST IS RUNNING!!!", UVM_LOW)
      #100us phase.drop_objection(this);
   endtask

endclass
