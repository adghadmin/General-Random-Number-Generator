// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Mon Sep 27 23:04:38 2021
// Host        : LAPTOP-H3OQ0T62 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/1.work_user/1.noise_gen/noise_LCG/noise_LCG.srcs/sources_1/ip/mult_a_x/mult_a_x_stub.v
// Design      : mult_a_x
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku085-flva1517-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_13,Vivado 2017.4" *)
module mult_a_x(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[31:0],B[31:0],P[63:0]" */;
  input CLK;
  input [31:0]A;
  input [31:0]B;
  output [63:0]P;
endmodule
