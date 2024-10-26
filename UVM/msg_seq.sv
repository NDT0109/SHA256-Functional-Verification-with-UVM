class msg_seq extends uvm_sequence;
   `uvm_object_utils(msg_seq)

   function new(string name="msg_seq");
      super.new(name);
   endfunction 

   virtual task body();
      msg_seq_item msg = msg_seq_item::type_id::create("msg");
      start_item(msg);
      msg.randomize();
      `uvm_info("MSG_SEQ", $sformatf("Generated message item: %h", msg.message), UVM_LOW)
      finish_item(msg);
   endtask 
endclass
