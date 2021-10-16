//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2019/01/02
//Module Name		:	FPGA_VIDEO_DCLK_SELECT_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2019.01.02,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_DCLK_SELECT_Module(

	//system signals
	
	//FPGA_VIDEO_DCLK_SELECT_Module Interface
	input			wire					MAX_TEST_OR_NORMAL_SEL,
	input			wire		[11:0]	MAX_VIDEO_DATA_NORMAL,
	input			wire					MAX_VIDEO_DCLK_NORMAL,

	input			wire		[11:0]	MAX_VIDEO_DATA_TEST,
	input			wire					MAX_VIDEO_DCLK_TEST,
		
	output		wire					MAX_VIDEO_DCLK,
	output		wire		[11:0]	MAX_VIDEO_DATA
);
//============================Define Parameter and Internal Signals===============//

//=================================Main Code======================================//
assign MAX_VIDEO_DATA = (MAX_TEST_OR_NORMAL_SEL == 1'b1) ? MAX_VIDEO_DATA_NORMAL : MAX_VIDEO_DATA_TEST;
assign MAX_VIDEO_DCLK = (MAX_TEST_OR_NORMAL_SEL == 1'b1) ? MAX_VIDEO_DCLK_NORMAL : MAX_VIDEO_DCLK_TEST;
//================================================================================//

endmodule
//================================================================================//
//The end
//================================================================================//


