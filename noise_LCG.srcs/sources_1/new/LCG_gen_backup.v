`timescale 1ns/1ps

module LCG_gen #(
	parameter						Q				= 32  //number of bits used to represent integer random numbers
)
(
	input 	wire					I_sys_clk			, //system clock
	input	wire					I_sys_rst			, //system reset,active high
	
	input	wire					I_seqgen_en			, //sequence data generate enable, active high
	input	wire	[31:00]			I_seed_value		, //seed value, range: [2^31 - 2] 

	output	wire					O_seq_dvld			, //sequence data valid
	output	wire	[Q-1:00]		O_seq_data			  //sequence data
);

//=======================================================
// Register the Input system reset
//=======================================================
reg									R_rst_1d	= 'd0	;
reg									R_rst_2d	= 'd0	;
always @(posedge I_sys_clk) begin
	R_rst_1d <= I_sys_rst;
	R_rst_2d <= R_rst_1d;
end	

reg												R_seqgen_en		= 'd0	;
reg						[6:0]					R_seqgen_en_pos	= 'd0	;
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_seqgen_en <= 'd0;
	end
	else begin
		R_seqgen_en <= I_seqgen_en;
	end
end
wire W_seqgen_en_pos = (~R_seqgen_en) & ( I_seqgen_en);
wire W_seqgen_en_neg = ( R_seqgen_en) & (~I_seqgen_en);
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_seqgen_en_pos <= 'd0;
	end
	else begin
		R_seqgen_en_pos <= {R_seqgen_en_pos[5:0],W_seqgen_en_pos};
	end
end

//=======================================================
// Register the Input seed value
//=======================================================
reg					[31:00]						R_seed_value	= 'd0	;
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_seed_value <= 'd0;
	end
	else if(W_seqgen_en_pos) begin
		R_seed_value <= I_seed_value;
	end
	else begin
		R_seed_value <= R_seed_value;
	end
end

//69069 = 2^16 + 2^11 + 2^10 + 2^8 + 2^7 + 2^6 + 2^3 + 2^2 + 2^0
reg					[63:00]						R_value_x1		= 'd0	;
reg					[63:00]						R_value_x2		= 'd0	;
reg					[63:00]						R_value_x3		= 'd0	;
reg					[63:00]						R_value_x4		= 'd0	;
reg					[63:00]						R_value_x5		= 'd0	;
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x1 <= 'd0;
	end
	else if(R_seqgen_en_pos[0]) begin
		R_value_x1 <=((R_seed_value <<< 'd16) + (R_seed_value <<< 'd11) + (R_seed_value <<< 'd10) 
					+ (R_seed_value <<< 'd08) + (R_seed_value <<< 'd07) + (R_seed_value <<< 'd06) 
					+ (R_seed_value <<< 'd03) + (R_seed_value <<< 'd02) + (R_seed_value <<< 'd00))& 32'h_FFFF_FFFF;
	end
	else begin
		R_value_x1 <= R_value_x1;
	end
end
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x2 <= 'd0;
	end
	else if(R_seqgen_en_pos[1]) begin
		R_value_x2 <=((R_value_x1 <<< 'd16) + (R_value_x1 <<< 'd11) + (R_value_x1 <<< 'd10) 
					+ (R_value_x1 <<< 'd08) + (R_value_x1 <<< 'd07) + (R_value_x1 <<< 'd06) 
					+ (R_value_x1 <<< 'd03) + (R_value_x1 <<< 'd02) + (R_value_x1 <<< 'd00))& 32'h_FFFF_FFFF;
	end
	else begin
		R_value_x2 <= R_value_x2;
	end
end
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x3 <= 'd0;
	end
	else if(R_seqgen_en_pos[2]) begin
		R_value_x3 <=((R_value_x2 <<< 'd16) + (R_value_x2 <<< 'd11) + (R_value_x2 <<< 'd10) 
					+ (R_value_x2 <<< 'd08) + (R_value_x2 <<< 'd07) + (R_value_x2 <<< 'd06) 
					+ (R_value_x2 <<< 'd03) + (R_value_x2 <<< 'd02) + (R_value_x2 <<< 'd00))& 32'h_FFFF_FFFF;
	end
	else begin
		R_value_x3 <= R_value_x3;
	end
end
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x4 <= 'd0;
	end
	else if(R_seqgen_en_pos[3]) begin
		R_value_x4 <=((R_value_x3 <<< 'd16) + (R_value_x3 <<< 'd11) + (R_value_x3 <<< 'd10) 
					+ (R_value_x3 <<< 'd08) + (R_value_x3 <<< 'd07) + (R_value_x3 <<< 'd06) 
					+ (R_value_x3 <<< 'd03) + (R_value_x3 <<< 'd02) + (R_value_x3 <<< 'd00))& 32'h_FFFF_FFFF;
	end
	else begin
		R_value_x4 <= R_value_x4;
	end
end
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x5 <= 'd0;
	end
	else if(R_seqgen_en_pos[4]) begin
		R_value_x5 <=((R_value_x4 <<< 'd16) + (R_value_x4 <<< 'd11) + (R_value_x4 <<< 'd10) 
					+ (R_value_x4 <<< 'd08) + (R_value_x4 <<< 'd07) + (R_value_x4 <<< 'd06) 
					+ (R_value_x4 <<< 'd03) + (R_value_x4 <<< 'd02) + (R_value_x4 <<< 'd00))& 32'h_FFFF_FFFF;
	end
	else begin
		R_value_x5 <= R_value_x5;
	end
end
reg					[63:00]						R_value_y[04:00]		;
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_y[0] <= 'd0;
		R_value_y[1] <= 'd0;
		R_value_y[2] <= 'd0;
		R_value_y[3] <= 'd0;
		R_value_y[4] <= 'd0;
	end
	else if(R_seqgen_en_pos[5]) begin
		R_value_y[0] <= (R_value_x1 & 31'h_7FFF_FFFF) + (R_value_x1 >>> 31);
		R_value_y[1] <= (R_value_x2 & 31'h_7FFF_FFFF) + (R_value_x2 >>> 31);
		R_value_y[2] <= (R_value_x3 & 31'h_7FFF_FFFF) + (R_value_x3 >>> 31);
		R_value_y[3] <= (R_value_x4 & 31'h_7FFF_FFFF) + (R_value_x4 >>> 31);
		R_value_y[4] <= (R_value_x5 & 31'h_7FFF_FFFF) + (R_value_x5 >>> 31);
	end
	else begin
		R_value_y[0] <= R_value_y[0];
		R_value_y[1] <= R_value_y[1];
		R_value_y[2] <= R_value_y[2];
		R_value_y[3] <= R_value_y[3];
		R_value_y[4] <= R_value_y[4];
	end
end

reg					[63:00]						R_value_x[04:00]		;
reg					[31:00]						R_out = 'd0;
always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
		R_value_x[0] <= 'd0;
		R_value_x[1] <= 'd0;
		R_value_x[2] <= 'd0;
		R_value_x[3] <= 'd0;
		R_value_x[4] <= 'd0;
	end
	else if(R_seqgen_en_pos[6]) begin
		R_value_x[0] <= R_value_y[0];
		R_value_x[1] <= R_value_y[1];
		R_value_x[2] <= R_value_y[2];
		R_value_x[3] <= R_value_y[3];
		R_value_x[4] <= R_value_y[4];
	end
	else begin //x_n = (a_1 x_{n-1} + a_5 x_{n-5}) mod m
		R_value_x[4] <=(((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
					   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
					   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
					   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
					   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)                    
					   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
					   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05))& 64'h_0000_0000_7FFF_FFFF) //(a_1 x_{n-1} + a_5 x_{n-5}) mod (m+1)
					   
					   +
					   (((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
					   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
					   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
					   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
					   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)
					   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
					   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05)) >> 31); //(a_1 x_{n-1} + a_5 x_{n-5}) / $clog2(m+1)
		R_out <= (R_value_x[4] * 104480 + R_value_x[0] * 107374182) % 2147483647;
		//R_value_x[4] <= (R_value_x[4] * 104480 + R_value_x[0] * 107374182) % 2147483647;
		R_value_x[3] <= R_value_x[4];
		R_value_x[2] <= R_value_x[3];
		R_value_x[1] <= R_value_x[2];
		R_value_x[0] <= R_value_x[1];
		
	end
end
wire [63:0] aa =((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
			   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
			   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
			   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
			   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)                    
			   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
			   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05))& 64'h_0000_0000_7FFF_FFFF;
			   
wire [63:0] a1 =((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
			   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
			   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
			   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
			   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)                    
			   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
			   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05));
			   
wire [63:0] bb =(((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
			   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
			   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
			   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
			   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)
			   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
			   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05)) >> 'd31);
			   
wire [63:0] b1 =(((R_value_x[0] << 'd26) + (R_value_x[0] << 'd25) + (R_value_x[0] << 'd22) 
			   + (R_value_x[0] << 'd21) + (R_value_x[0] << 'd18) + (R_value_x[0] << 'd17) 
			   + (R_value_x[0] << 'd14) + (R_value_x[0] << 'd13) + (R_value_x[0] << 'd10)
			   + (R_value_x[0] << 'd09) + (R_value_x[0] << 'd06) + (R_value_x[0] << 'd05)
			   + (R_value_x[0] << 'd02) + (R_value_x[0] << 'd01)
			   + (R_value_x[4] << 'd16) + (R_value_x[4] << 'd15) + (R_value_x[4] << 'd12)
			   + (R_value_x[4] << 'd11) + (R_value_x[4] << 'd05)));
wire	[63:0]		P1;			   
wire	[63:0]		P2;			   
mult_a_x mult_a1_xn1 (
  .CLK(I_sys_clk),  // input wire CLK
  .A(107374182),      // input wire [31 : 0] A
  .B(R_value_x[0]),      // input wire [31 : 0] B
  .P(P1)      // output wire [63 : 0] P
);
mult_a_x mult_a5_xn5 (
  .CLK(I_sys_clk),  // input wire CLK
  .A(104480),      // input wire [31 : 0] A
  .B(R_value_x[4]),      // input wire [31 : 0] B
  .P(P2)      // output wire [63 : 0] P
); 
wire m_axis_dout_tvalid;
wire [95 : 0] m_axis_dout_tdata;
wire [31:0]remain = m_axis_dout_tdata[31:0];
wire [63:0]s_axis_dividend_tdata = P1+P2;
div_gen_remain div_gen_remain (
  .aclk(I_sys_clk),                                      // input wire aclk
  .s_axis_divisor_tvalid(~R_rst_2d),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(32'd2147483647),      // input wire [31 : 0] s_axis_divisor_tdata
  
  .s_axis_dividend_tvalid(~R_rst_2d),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [63 : 0] s_axis_dividend_tdata
  
  .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [95 : 0] m_axis_dout_tdata
);

//x_n = (a_1 x_{n-1} + a_5 x_{n-5}) mod m
//a_1 107374182 = 2^26 + 2^25 + 2^22 + 2^21 + 2^18 + 2^17 + 2^14 + 2^13 + 2^10 + 2^9 + 2^6 + 2^5 + 2^2 + 2
//a_5 104480 = 2^16 + 2^15 + 2^12 + 2^11 + 2^5

always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end

always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end


always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end


always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end



always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end


always @(posedge I_sys_clk) begin
	if(R_rst_2d) begin
	
	end
	else begin
	
	end
end
endmodule