// Copyright (C) 1991-2012 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 32-bit"
// VERSION		"Version 12.0 Build 178 05/31/2012 SJ Full Version"
// CREATED		"Tue Jan 29 12:14:50 2019"

module one_short(
	data_in,
	clk_100M,
	data_out
);


input wire	data_in;
input wire	clk_100M;
output wire	data_out;

wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_3;





ffd	b2v_inst(
	.DATA_IN(data_in),
	.clk_100M(clk_100M),
	.DATA_OUT(SYNTHESIZED_WIRE_4));


ffd	b2v_inst1(
	.DATA_IN(SYNTHESIZED_WIRE_4),
	.clk_100M(clk_100M),
	.DATA_OUT(SYNTHESIZED_WIRE_1));

assign	SYNTHESIZED_WIRE_3 =  ~SYNTHESIZED_WIRE_1;

assign	data_out = SYNTHESIZED_WIRE_4 & SYNTHESIZED_WIRE_3;


endmodule
