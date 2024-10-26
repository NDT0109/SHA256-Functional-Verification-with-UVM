class msg_driver extends uvm_driver #(msg_seq_item);
   `uvm_component_utils(msg_driver)
   virtual msg_if vif;

   function new(string name = "driver", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual msg_if)::get(null, "uvm_test_top", "msg_if", vif))
	`uvm_fatal("MSG_DRV", "Could not get message interface")
   endfunction 

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
     
     repeat(1) begin
	 msg_seq_item msg;
	 `uvm_info("MSG_DRV", $sformatf("Waiting for message from sequencer"), UVM_HIGH)
	 seq_item_port.get_next_item(msg);
	 drive_item(msg);
	 seq_item_port.item_done();
      end
   endtask

   virtual task drive_item(msg_seq_item msg);
      @(vif.cb);
      vif.cb.msg_data  <= msg.message_single; //single message
      vif.cb.msg_valid <= 1; 
      vif.cb.msg_nxt <= 0;
      @(vif.cb);
      vif.cb.msg_valid <= 0;
	  //wait 66 clk cycle
      #1300;
      //double message
      @(vif.cb);
      vif.cb.msg_data  <= msg.message_double_first; //message block1
      vif.cb.msg_valid <= 1; 
	  @(vif.cb);
      vif.cb.msg_valid <= 0;
      //wait 66 clk cycle
      #1300;
      @(vif.cb);
      vif.cb.msg_data  <= msg.message_double_last; //message block2
      vif.cb.msg_nxt <= 1;  
      @(vif.cb);
      vif.cb.msg_nxt <= 0;
     
   endtask 
endclass 
