//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_VIDEO_MEMS_CLK_Genernator_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_MEMS_CLK_Genernator_Module(

	//system signals
	input			wire					sys_clk_100MHz,
	
	//FPGA_VIDEO_MEMS_CLK_Genernator_Module Interface
	input			wire		[15:0]	WR_MAX_VIDEO_MEMS_CLK_Freq_DATA,
	input			wire					MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n,
	
	output		reg					MAX_VIDEO_DCLK
);
//============================Define Parameter and Internal Signals===============//
	reg						[15:0]	sys_clk_cnt;

//=================================Main Code======================================//

always @(posedge sys_clk_100MHz) begin
	if(!MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n) 
		begin
			MAX_VIDEO_DCLK <= 1'b0;
			sys_clk_cnt <= 16'D0;
		end
	else if(sys_clk_cnt == WR_MAX_VIDEO_MEMS_CLK_Freq_DATA)
		MAX_VIDEO_DCLK <= ~MAX_VIDEO_DCLK;
	else
		sys_clk_cnt <= sys_clk_cnt + 1'b1;
end

endmodule
//================================================================================//
//The end
//================================================================================//
