class sha_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(sha_scoreboard)
   `uvm_analysis_imp_decl(_msg_mon)


   uvm_analysis_imp_msg_mon #(msg_seq_item, sha_scoreboard) msg_analysis_imp;

   bit [255:0] expected_hashes[$]; 
   int current_index;
   string expected_hash_file = "../../src/model/sha256_output.log";
   string message_file = "../../src/model/message.log";

   function new(string name="sha_scoreboard", uvm_component parent=null);
      super.new(name, parent);
      current_index = 0;
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      msg_analysis_imp = new("msg_analysis_imp", this);
      
      read_expected_hashes_from_file();
   endfunction 
  
   function string trim_string(input string s);
      string trimmed = "";
      foreach (s[i]) begin
         if (s[i] != "\n" && s[i] != "\r" && s[i] != " ") begin
            trimmed = {trimmed, s[i]};
         end
      end
      return trimmed;
   endfunction
 

  
   function void read_expected_hashes_from_file();
      integer file;
      string line;

      file = $fopen(expected_hash_file, "r");
      if (file) begin
         while (!$feof(file)) begin
            line = "";
            void'($fgets(line, file));
            line = trim_string(line);
            if (line != "") begin
               bit [255:0] hash_value;
               if (!$sscanf(line, "%h", hash_value)) begin
                 `uvm_error("SCBD", $sformatf("Invalid hash format: %h", line))
               end else begin
                  expected_hashes.push_back(hash_value); 
                 `uvm_info("SCBD", $sformatf("Read expected hash: %h", hash_value), UVM_LOW)
               end
            end
         end
         $fclose(file);
      end else begin
        `uvm_error("SCBD", "Cant open log file")
      end
   endfunction

   virtual function void write_msg_mon(msg_seq_item msg);

      bit [255:0] expected_hash;
      bit [255:0] actual_hash;

	 write_msg_to_file(msg);

      if (current_index >= expected_hashes.size()) begin
         `uvm_error("SCBD", "No Hash Value To Compare")
         return;
      end

      expected_hash = expected_hashes[current_index++]; 
      actual_hash = msg.hash;

      `uvm_info("SCBD", $sformatf("Message found: %h", msg.message), UVM_LOW)
      `uvm_info("SCBD", $sformatf("Expected Hash: %h", expected_hash), UVM_LOW)
      `uvm_info("SCBD", $sformatf("Actual Hash: %h", actual_hash), UVM_LOW)

      if (actual_hash == expected_hash) begin
        `uvm_info("SCBD", "//-----------------------------------------------------------------", UVM_LOW)
        `uvm_info("SCBD", $sformatf("//Hash matches the expected value! Expected: %h, Got: %h ",expected_hash, actual_hash), UVM_LOW)
        `uvm_info("SCBD", "//-----------------------------------------------------------------.", UVM_LOW)
      end else begin
         `uvm_error("SCBD", $sformatf("Hash mismatch! Expected: %h, Got: %h", expected_hash, actual_hash))
      end
   endfunction

   function void write_msg_to_file(msg_seq_item msg); 
     integer file;
     file = $fopen(message_file, "a");
	if(file != 0) begin
		$display("Open message file sucessfull: %s",message_file);
        	$fwrite(file, "%h\n",msg.message);
        	$fclose(file);
        end
	else
		$display("Open message file fail: %s",message_file);
   endfunction

endclass

