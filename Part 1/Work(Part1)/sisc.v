// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

  // declare all internal wires here
  wire        rf_we, wb_sel;
  wire [3:0]  alu_op;
  wire [31:0] rsa, rsb;
  wire [31:0] alu_result;
  wire [3:0]  stat, stat_en;
  wire [3:0]  cc;
  wire [31:0] write_data;

  // component instantiation goes here
  ctrl      processor_ctrl    (clk, rst_f, ir[31:28], ir[27:24], cc, rf_we, alu_op, wb_sel);
  rf        processor_rf      (clk, ir[19:16], ir[15:12], ir[23:20], write_data, rf_we, rsa, rsb);
  alu       processor_alu     (clk, rsa, rsb, ir[15:0], cc[3], alu_op, ir[27:24], alu_result, stat, stat_en);
  statreg   processor_statreg (clk, stat, stat_en, cc);
  mux32     processor_mux     (alu_result, 32'h00000000, wb_sel, write_data);

  initial
    $monitor("IR=%h R1=%h R2=%h R3=%h R4=%h R5=%h ALU_OP=%b WB_SEL=%b RF_WE=%b WRITE_DATA=%h",
             ir, processor_rf.ram_array[1], processor_rf.ram_array[2], processor_rf.ram_array[3],
             processor_rf.ram_array[4], processor_rf.ram_array[5],
             alu_op, wb_sel, rf_we, write_data);

endmodule


