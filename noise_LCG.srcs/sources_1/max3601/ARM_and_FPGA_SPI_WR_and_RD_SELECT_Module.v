//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2019/01/15
//Module Name		:	ARM_and_FPGA_SPI_WR_and_RD_SELECT_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2019.01.15,Initial,Module Definition
//================================================================================//
module ARM_and_FPGA_SPI_WR_and_RD_SELECT_Module(

	//input signals
	input			wire					ARM_WR_and_RD_SELECT_Wire,
	
	input			wire		[15:0]	ARM_WR_FPGA_ADDR,
	input			wire					ARM_WR_MAX_SPI_REG_Control_CS,
	input			wire					ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS,
	input			wire					ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS,
	input			wire					ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS,
	input			wire					ARM_WR_MAX_VIDEO_TEST_Module_CS,
	
	input			wire		[15:0]	ARM_RD_FPGA_ADDR,
	input			wire					ARM_RD_MAX_SPI_REG_Control_CS,
	input			wire					ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS,
	input			wire					ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS,
	input			wire					ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS,
	input			wire					ARM_RD_MAX_VIDEO_TEST_Module_CS,

	//output signals
	output		wire		[15:0]	FPGA_ADDR_BUS,
	output		wire					MAX_SPI_REG_Control_CS,
	output		wire					MAX_VIDEO_MEMS_DCLK_Control_CS,
	output		wire					MAX_VIDEO_DPRAM_T_Control_CS,
	output		wire					MAX_VIDEO_DPRAM_P_Control_CS,
	output		wire					MAX_VIDEO_TEST_Module_CS
	
);

//============================Define Parameter and Internal Signals===============//

//================================================================================//

//===============================Main Code========================================//
assign FPGA_ADDR_BUS							= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_FPGA_ADDR 							: ARM_RD_FPGA_ADDR;
assign MAX_SPI_REG_Control_CS 			= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_MAX_SPI_REG_Control_CS 			: ARM_RD_MAX_SPI_REG_Control_CS;
assign MAX_VIDEO_MEMS_DCLK_Control_CS 	= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS : ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS;
assign MAX_VIDEO_DPRAM_T_Control_CS 	= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS 	: ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS;
assign MAX_VIDEO_DPRAM_P_Control_CS		= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS 	: ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS;
assign MAX_VIDEO_TEST_Module_CS 			= (ARM_WR_and_RD_SELECT_Wire == 1'b0) ? ARM_WR_MAX_VIDEO_TEST_Module_CS 		: ARM_RD_MAX_VIDEO_TEST_Module_CS;
//================================================================================//

//The end//=======================================================================//
endmodule