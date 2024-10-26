`timescale 1ns/1ns
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../../src/UVM_nist_TestCase/msg_if.sv"
`include "../../src/UVM_nist_TestCase/msg_seq_item.sv"
`include "../../src/UVM_nist_TestCase/msg_seq.sv"
`include "../../src/UVM_nist_TestCase/msg_driver.sv"
`include "../../src/UVM_nist_TestCase/msg_monitor.sv"
`include "../../src/UVM_nist_TestCase/msg_agent.sv"
`include "../../src/UVM_nist_TestCase/sha_scoreboard.sv"
`include "../../src/UVM_nist_TestCase/sha_env.sv"
`include "../../src/UVM_nist_TestCase/double_value_test.sv"

module sha_uvm_tb_top;
   bit clk;
   bit rst = 0;

   always  #10  clk <= ~clk;
   initial begin
   #5 rst <= 1;
//    #10000 rst <=0; 
   end
   msg_if           dut_msg_if  (clk);
   sha_algo_wrapper dut_wr0 (.clk_p(clk), .rst_p(rst), .msg(dut_msg_if));

   initial begin
      uvm_config_db #(virtual msg_if)::set (null, "uvm_test_top", "msg_if", dut_msg_if);
      run_test ("double_value_test");
   end
  
  initial begin
    #5000;
    $display("Ran out of clock cycles!");
    $finish();
  end
   initial begin
      $dumpvars;
      $dumpfile("waveforms.vcd");
   end

endmodule
