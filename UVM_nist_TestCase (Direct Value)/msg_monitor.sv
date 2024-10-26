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
     repeat(1) begin
       
       msg_seq_item msg = msg_seq_item::type_id::create("msg_seq_item");
       @(vif.cb);
       wait(vif.msg_valid==1); 
	   msg.message_single = vif.msg_data;
       msg.messagetmp = msg.message_single;
       `uvm_info("MSG_MON", $sformatf("Supplied sg message '%h'", msg.message_single), UVM_HIGH)
       msg.msg_valid = vif.msg_valid;
       msg.msg_nxt = vif.msg_nxt;
       `uvm_info("MSG_MON", $sformatf("Init ='%x', Next ='%x", msg.msg_valid, msg.msg_nxt), UVM_HIGH)
       @(vif.cb);
       wait(vif.hash_valid==1);
	   msg.hash = vif.hash_data;
       `uvm_info("HASH_MON", $sformatf("Found hash sg '%h'", msg.hash), UVM_LOW)
       mon_analysis_port.write(msg);
       		
       @(vif.cb);
       wait(vif.msg_valid==1); 
	   msg.message_double_first = vif.msg_data;
       msg.messagetmp = msg.message_double_first;
       `uvm_info("MSG_MON", $sformatf("Supplied b1 message '%h'", msg.message_double_first), UVM_HIGH)
       msg.msg_valid = vif.msg_valid;
       msg.msg_nxt = vif.msg_nxt;
       `uvm_info("MSG_MON", $sformatf("Init ='%x', Next ='%x", msg.msg_valid, msg.msg_nxt), UVM_HIGH)
       @(vif.cb);
       wait(vif.hash_valid==1);
	   msg.hash = vif.hash_data;
       `uvm_info("HASH_MON", $sformatf("Found hash b1 '%h'", msg.hash), UVM_LOW)
       mon_analysis_port.write(msg);
              
       @(vif.cb);
       wait(vif.msg_nxt==1);
	   msg.message_double_last = vif.msg_data;
       msg.messagetmp = msg.message_double_last;
       `uvm_info("MSG_MON", $sformatf("Supplied b2 message '%h'", msg.message_double_last), UVM_HIGH)
       msg.msg_valid = vif.msg_valid;
       msg.msg_nxt = vif.msg_nxt;
       `uvm_info("MSG_MON", $sformatf("Init ='%x', Next ='%x", msg.msg_valid, msg.msg_nxt), UVM_HIGH)
       @(vif.cb);
       wait(vif.hash_valid==1);
	   msg.hash = vif.hash_data;
       `uvm_info("HASH_MON", $sformatf("Found hash b2 '%h'", msg.hash), UVM_LOW)
       mon_analysis_port.write(msg); 
      end
   endtask 
endclass
 
