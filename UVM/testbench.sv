import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../../src/UVM/msg_if.sv"
`include "../../src/UVM/msg_seq_item.sv"
`include "../../src/UVM/msg_seq.sv"
`include "../../src/UVM/msg_driver.sv"
`include "../../src/UVM/msg_monitor.sv"
`include "../../src/UVM/msg_agent.sv"
`include "../../src/UVM/sha_scoreboard.sv"
`include "../../src/UVM/sha_subs.sv"
`include "../../src/UVM/sha_env.sv"
`include "../../src/UVM/single_value_test.sv"

module sha_uvm_tb_top;
   bit clk;
   bit rst = 0;

   always  #10  clk <= ~clk;
   initial begin
   #100 rst <= 1;
   end
 
   msg_if           dut_msg_if  (clk);
   sha_algo_wrapper dut_wr0 (.clk_p(clk), .rst_p(rst), .msg(dut_msg_if));

   initial begin
      uvm_config_db #(virtual msg_if)::set (null, "uvm_test_top", "msg_if", dut_msg_if);
      run_test ("single_value_test");
   end
/*  initial begin
    #20000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end */
   initial begin
      $dumpvars;
      $dumpfile("waveforms.vcd");
   end
endmodule
