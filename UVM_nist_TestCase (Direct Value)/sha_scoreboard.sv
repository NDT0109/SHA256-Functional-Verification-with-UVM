class sha_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(sha_scoreboard)
   `uvm_analysis_imp_decl(_msg_mon_sg)
   uvm_analysis_imp_msg_mon_sg #(msg_seq_item, sha_scoreboard)             msg_analysis_imp;
   msg_seq_item transactions[$];
  
   function new(string name="sha_scoreboard", uvm_component parent=null);
      super.new(name, parent);
   endfunction
  
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      msg_analysis_imp = new("msg_analysis_imp", this);
   endfunction
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write_msg_mon_sg(msg_seq_item msg);
    transactions.push_back(msg);
  endfunction

// Print Message same as Monitor  
//      virtual function void write_msg_mon_sg(msg_seq_item msg);
//        `uvm_info("SCBD", $sformatf("Message found: %h", msg.messagetmp), UVM_LOW)
//        `uvm_info("SCBD", $sformatf("Hash found: %h", msg.hash), UVM_LOW)
//    endfunction
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
   
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */
      msg_seq_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
      
    end
    
  endtask: run_phase
  
  task compare(msg_seq_item curr_trans);
    logic [255:0] expectsgvalue = 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;
    logic [255:0] expectdbvalue1 = 256'h85E655D6417A17953363376A624CDE5C76E09589CAC5F811CC4B32C1F20E533A;
    logic [255:0] expectdbvalue2 = 256'h248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1;
    logic [255:0] actual;
    actual = curr_trans.hash;
 
    if (actual == expectsgvalue) begin
        `uvm_info("SCBD COMPARE", $sformatf("Transaction Passed! ACT=%h, EXP=%h", actual, expectsgvalue), UVM_LOW)
    end
    else if (actual == expectdbvalue1) begin
        `uvm_info("SCBD COMPARE", $sformatf("Transaction Passed! ACT=%h, EXP=%h", actual, expectdbvalue1), UVM_LOW)
    end
    else if (actual == expectdbvalue2) begin
        `uvm_info("SCBD COMPARE", $sformatf("Transaction Passed! ACT=%h, EXP=%h", actual, expectdbvalue2), UVM_LOW)
    end
    else begin
        `uvm_error("SCBD COMPARE", $sformatf("Transaction failed! ACT=%h, EXP=%h, %h, or %h", actual, expectsgvalue, expectdbvalue1, expectdbvalue2))
    end
endtask: compare
  
endclass
