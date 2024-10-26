class msg_agent extends uvm_agent;
   `uvm_component_utils(msg_agent)

   function new(string name="agent", uvm_component parent=null);
      super.new(name, parent);
   endfunction
   msg_driver                    drv;
   msg_monitor                   mon;
   uvm_sequencer #(msg_seq_item) seqr;
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      seqr = uvm_sequencer#(msg_seq_item)::type_id::create("seqr", this);
      drv = msg_driver::type_id::create("drv", this);
      mon = msg_monitor::type_id::create("mon", this);
   endfunction 

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction
endclass 
