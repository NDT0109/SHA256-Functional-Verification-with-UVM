class msg_seq_item extends uvm_sequence_item;
   `uvm_object_utils(msg_seq_item)

   rand bit [511:0] message;
   rand bit msg_valid;
   rand bit msg_nxt;
   bit [255:0] hash;

   // Random length of the message part (in bytes, 0 to 56 bytes)
   rand int unsigned message_length_bytes;

   // Length in bits, calculated from message_length_bytes
   int unsigned message_length_bits;

   function new(string name = "msg_seq_item");
      super.new(name);
   endfunction

   // Constraint 
   constraint message_constraint {
      // 1 byte = 8 bit => max = 56 byte = 448 bit
      message_length_bytes inside { [1:56] };
   }

   // Function to handle padding in post_randomize
   function void post_randomize();
      super.post_randomize();
      
      // 1 byte = 8 bit
      message_length_bits = message_length_bytes * 8;

      // Random with ASCII character
      for (int i = 0; i < message_length_bytes; i++) begin
         message[511 - i*8 -: 7] = $urandom_range(0, 127); 
         message[511 - i*8] = 0; 
      end

      // next bit after input data = 1 
      if (message_length_bits < 448) begin
         message[511 - message_length_bits] = 1;

         // Set the remaining bits  up to 448 to 0  
         for (int i = message_length_bits + 1; i < 448; i++) begin
            message[511 - i] = 0;
         end
      end

      // Last 64 bits = length of the input (in bits)
      message[63:0] = message_length_bits;
   endfunction
endclass

