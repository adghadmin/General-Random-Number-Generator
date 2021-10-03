//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_VIDEO_MEMS_CLK_Control_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_MEMS_CLK_Control_Module(

	//system signals
	
	//FPGA_VIDEO_MEMS_CLK_Control_Module Interface
	input			wire					FPGA_VIDEO_MEMS_CLK_Control_CS,
	input			wire					XWE,
	input 		wire		[3:0]		A3_0,
	
	inout			wire		[15:0]	D15_00,
	
	output		reg		[15:0]	WR_MAX_VIDEO_MEMS_CLK_Freq_DATA,
	output		wire					MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n,
	output		wire					MAX_VIDEO_DATA_Send_Trigger,
	output		wire					MAX_VIDEO_DATA_Send_Control_Module_Rst_n,
	output		wire					MAX_DPRAM_T_Rst_n,
	output		wire					MAX_DPRAM_P_Rst_n
);


//============================Define Parameter and Internal Signals===============//
	reg						[15:0]	MAX_VIDEO_Ctrl_REG;
	reg									WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_CS;
	reg									MAX_VIDEO_Ctrl_REG_CS;
	wire						[4:0]		MAX_VIDEO_DCLK_Control_CS_ADDR3_0 = {FPGA_VIDEO_MEMS_CLK_Control_CS,A3_0}; 
	
//=================================Main Code======================================//
always @ (MAX_VIDEO_DCLK_Control_CS_ADDR3_0) begin
	case(MAX_VIDEO_DCLK_Control_CS_ADDR3_0)
		5'B0_0000	:	begin
								WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_CS = 1'B0;
								MAX_VIDEO_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0001	:	begin
								WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_CS = 1'B1;
								MAX_VIDEO_Ctrl_REG_CS = 1'B0;
							end
		default		:	begin
								WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_CS = 1'B1;
								MAX_VIDEO_Ctrl_REG_CS = 1'B1;
							end
	endcase
end

//================================================================================//
//DSP or RAM Write WR_MAX_VIDEO_MEMS_CLK_Freq_DATA reg
always @(posedge XWE) begin
	if(WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_CS == 1'b0)
		begin
			WR_MAX_VIDEO_MEMS_CLK_Freq_DATA = D15_00;
		end
end

//================================================================================//
//DSP or RAM Write MAX_VIDEO_Ctrl_REG reg
always @(posedge XWE) begin
	if(MAX_VIDEO_Ctrl_REG_CS == 1'b0)
		begin
			MAX_VIDEO_Ctrl_REG = D15_00;
		end
end
assign MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n = MAX_VIDEO_Ctrl_REG[0];
assign MAX_VIDEO_DATA_Send_Trigger = MAX_VIDEO_Ctrl_REG[1];
assign MAX_VIDEO_DATA_Send_Control_Module_Rst_n = MAX_VIDEO_Ctrl_REG[2];
assign MAX_DPRAM_T_Rst_n = MAX_VIDEO_Ctrl_REG[3];
assign MAX_DPRAM_P_Rst_n = MAX_VIDEO_Ctrl_REG[4];

endmodule
//================================================================================//
//The end
//================================================================================//
