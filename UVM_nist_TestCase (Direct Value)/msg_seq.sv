class msg_seq extends uvm_sequence;
   `uvm_object_utils(msg_seq)

   function new(string name="msg_seq");
      super.new(name);
   endfunction 
   virtual task body();
      msg_seq_item msg = msg_seq_item::type_id::create("msg");
      start_item(msg);
     `uvm_info("MSG_SEQ", $sformatf("Generated sg message item: %h", msg.message_single), UVM_HIGH)
     `uvm_info("MSG_SEQ", $sformatf("Generated b1 message item: %h", msg.message_double_first), UVM_HIGH)
     `uvm_info("MSG_SEQ", $sformatf("Generated b2 message item: %h", msg.message_double_last), UVM_HIGH)
      finish_item(msg);
   endtask 
endclass 
