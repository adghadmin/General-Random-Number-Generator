//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_VIDEO_DPRAM_T_Control_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//============================Define Parameter and Internal Signals===============//





//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_DPRAM_T_Control_Module(

	//system signals
	
	//FPGA_VIDEO_DPRAM_T_Control_Module Interface
	input			wire					MAX_VIDEO_DPRAM_T_Control_CS,
	input 		wire		[8:0]		A8_0,
	input			wire					A16,
	input			wire					XWE,
	
	inout			wire		[15:0]	D15_00,
	
	output		reg		[15:0]	WR_MAX_VIDEO_DATA_T_DATA,
	output		wire		[9:0]		WR_MAX_VIDEO_DATA_T_ADDR,
	output		wire					WR_MAX_VIDEO_DATA_T_EN
);
//============================Define Parameter and Internal Signals===============//

always @(negedge XWE)
begin
	if(MAX_VIDEO_DPRAM_T_Control_CS == 1'b0)
		begin
			WR_MAX_VIDEO_DATA_T_DATA = D15_00;
		end
end
	
assign WR_MAX_VIDEO_DATA_T_ADDR = {A16,A8_0[8:0]};
assign WR_MAX_VIDEO_DATA_T_EN = ((~MAX_VIDEO_DPRAM_T_Control_CS) & (~XWE));

endmodule
//================================================================================//
//The end
//================================================================================//
