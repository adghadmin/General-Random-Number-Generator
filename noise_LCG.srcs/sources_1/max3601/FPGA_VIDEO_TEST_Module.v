//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_VIDEO_TEST_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_TEST_Module(

	//system signals
	input			wire					sys_clk_100MHz,
	
	//FPGA_VIDEO_DPRAM_T_Control_Module Interface
	input			wire					MAX_VIDEO_TEST_Module_CS,
	input			wire					XWE,
	
	inout			wire		[15:0]	D15_00,
	output		wire		[11:0]	MAX_VIDEO_DATA_TEST
);
//============================Define Parameter and Internal Signals===============//
	reg						[11:0]	MAX_VIDEO_DATA_TEST_REG;
//=================================Main Code======================================//

//================================================================================//
always @(negedge XWE) begin
	if(MAX_VIDEO_TEST_Module_CS == 1'b0)
		begin
			MAX_VIDEO_DATA_TEST_REG = D15_00[11:0];
		end
end

assign MAX_VIDEO_DATA_TEST = (MAX_VIDEO_TEST_Module_CS == 1'b0) ? MAX_VIDEO_DATA_TEST_REG : 12'bz;

endmodule
//================================================================================//
//The end
//================================================================================//
