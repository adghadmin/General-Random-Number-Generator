//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/25
//Module Name		:	FPGA_VIDEO_Control_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.25,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_Control_Module(

	//system signals
	input			wire					sys_clk_100MHz,
	input			wire					FPGA_VIDEO_Control_Module_Rset,
	
	//FPGA_VIDEO_Control_Module Interface
	input			wire					XRD,
	input			wire					XWE,
	input			wire					WR_MAX_VIDEO_DCLK_XWE,
	input			wire					WR_MAX_VIDEO_DCLK_XRD,
	
	input			wire		[15:0]	WR_MAX_VIDEO_DATA_T_ADDR,
	input			wire		[15:0]	WR_MAX_VIDEO_DATA_T_DATA,
	input			wire					WR_MAX_VIDEO_DATA_T_EN,
	input			wire		[15:0]	WR_MAX_VIDEO_DATA_V_ADDR,
	input			wire		[15:0]	WR_MAX_VIDEO_DATA_V_DATA,
	input			wire					WR_MAX_VIDEO_DATA_V_EN,
	input			wire					WR_MAX_VIDEO_DATA_Snd_Trigger,
	
	inout			wire		[15:0]	DATA,
	output		reg					VIDEO_DATA_CLK,
	output		reg		[11:0]	VIDEO_DATA
);

//============================Define Parameter and Internal Signals===============//
//
//================================================================================//
	reg						[15:0]	Hold_Time_of_Stripe;
	reg						[15:0]	MAX_VIDEO_DCLK_Freq;
	reg						[15:0]	VIDEO_DCLK_Counter;
	reg									DATA_Snd_Trigger;
	reg						[15:0]	MAX_VIDEO_DCLK_Freq_out;

//================================================================================//
//Dual Port RAM instance--DPRAM_T_instance_1: save the hold time of the stripe of data 
DPRAM_T	DPRAM_T_instance_1 (
	
	.clock						( sys_clk_100MHz ),
	.data							( WR_MAX_VIDEO_DATA_T_DATA ),
	.rdaddress					( rdaddress_sig ),
	.rden							( rden_sig ),
	.wraddress					( WR_MAX_VIDEO_DATA_T_ADDR[9:0] ),
	.wren							( WR_MAX_VIDEO_DATA_T_EN ),
	.q 							( Hold_Time_of_Stripe )
);
//================================================================================//


//================================================================================//
//Dual Port RAM instance--DPRAM_V_instance_1: save the stripe of data 
DPRAM_V	DPRAM_V_instance_1 (
	.clock						( sys_clk_100MHz ),
	.data							( WR_MAX_VIDEO_DATA_V_DATA ),
	.rdaddress					( rdaddress_sig ),
	.rden							( rden_sig ),
	.wraddress					( WR_MAX_VIDEO_DATA_V_ADDR[9:0] ),
	.wren							( WR_MAX_VIDEO_DATA_V_EN ),
	.q								( VIDEO_DATA )
	);
//================================================================================//



//=================================Main Code======================================//
//
//================================================================================//
//DSP or RAM Read MAX3601 MAX_REG_SPI_CLK_Freq[15:0] REG
always @(WR_MAX_VIDEO_DCLK_XRD or XRD)
begin
	if((WR_MAX_VIDEO_DCLK_XRD == 1'b0) && (XRD == 1'b0))
		MAX_VIDEO_DCLK_Freq_out = MAX_VIDEO_DCLK_Freq;
end
//DSP or RAM Write MAX3601 MAX_REG_SPI_CLK_Freq[15:0] REG
always @(WR_MAX_VIDEO_DCLK_XWE or XWE)
begin
	if((WR_MAX_VIDEO_DCLK_XWE == 1'b0) && (XWE == 1'b0))
		MAX_VIDEO_DCLK_Freq = DATA;
end
assign DATA = ((XRD == 1'b0)&&(WR_MAX_VIDEO_DCLK_XRD == 1'b0)) ? MAX_VIDEO_DCLK_Freq_out:16'bzz;
//================================================================================//

//================================================================================//
//Produce the VIDEO_DATA_CLK(if the singal of DATA_Snd_Trigger is the high level)
always @(posedge sys_clk_100MHz)
begin
	if(!FPGA_VIDEO_Control_Module_Rset)
		begin
			VIDEO_DATA_CLK <= 1'b0;
			VIDEO_DCLK_Counter <= 16'D0;
		end
	else if((VIDEO_DCLK_Counter != 16'D0) && (VIDEO_DCLK_Counter == MAX_VIDEO_DCLK_Freq))
		VIDEO_DATA_CLK <= ~VIDEO_DATA_CLK;
	else if(DATA_Snd_Trigger)
		VIDEO_DCLK_Counter <= VIDEO_DCLK_Counter + 1'b1;
end
//Produce the DATA_Snd_Trigger(if the singal of WR_MAX_VIDEO_DATA_Snd_Trigger appear low level pulse)
always @(WR_MAX_VIDEO_DATA_Snd_Trigger)
begin
	if(WR_MAX_VIDEO_DATA_Snd_Trigger == 1'b0)
		DATA_Snd_Trigger = 1'b1;
	else
		DATA_Snd_Trigger = 1'b0;
end
//================================================================================//


endmodule
//================================================================================//
//The end
//================================================================================//
