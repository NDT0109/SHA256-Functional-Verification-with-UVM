class msg_monitor extends uvm_monitor;
   `uvm_component_utils(msg_monitor)
   uvm_analysis_port #(msg_seq_item) mon_analysis_port;
   virtual msg_if vif;

   function new(string name="msg_monitor", uvm_component parent=null);
      super.new(name, parent);
   endfunction 
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual msg_if)::get(null, "uvm_test_top", "msg_if", vif))
	`uvm_fatal("MSG_MON", "Could not get message interface")
      mon_analysis_port = new("mon_analysis_port", this);
   endfunction

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

     forever begin
      msg_seq_item msg = msg_seq_item::type_id::create("msg_seq_item");
       @(vif.cb);
       wait(vif.msg_valid==1); 
	    msg.message = vif.msg_data;
	    `uvm_info("MSG_MON", $sformatf("Supplied message '%0h'", msg.message), UVM_LOW)
       
       @(vif.cb);
       wait(vif.hash_valid==1);
	   msg.hash = vif.hash_data;
       `uvm_info("HASH_MON", $sformatf("Found hash '%0h'", msg.hash), UVM_LOW)
        mon_analysis_port.write(msg);
      end
   endtask 
endclass 

