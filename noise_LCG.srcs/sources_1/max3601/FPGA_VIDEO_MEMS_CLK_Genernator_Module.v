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
	input			wire					WR_MAX_VIDEO_MEMS_CLK_Flag,
	
	output		reg					MAX_VIDEO_MEMS_CLK
);
//============================Define Parameter and Internal Signals===============//
	reg						[31:0]	sys_clk_cnt;
	reg						[31:0]	WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG;
	reg						[31:0]	WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG_CNT;

//=================================Main Code======================================//


//always @(WR_MAX_VIDEO_MEMS_CLK_Freq_DATA)
always @(posedge sys_clk_100MHz)
begin
	if(WR_MAX_VIDEO_MEMS_CLK_Flag == 1'b1)
		begin
			WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG[31:16] <= WR_MAX_VIDEO_MEMS_CLK_Freq_DATA;
		end
	else
		begin
			WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG[15:0] <= WR_MAX_VIDEO_MEMS_CLK_Freq_DATA;
		end
end
always @(posedge sys_clk_100MHz)
begin
	WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG_CNT <= WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG;
end

reg [2:0] cnt_state;

always @(posedge sys_clk_100MHz)
begin
	if(!MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n) 
		begin
			MAX_VIDEO_MEMS_CLK <= 1'b0;
			sys_clk_cnt <= 32'D0;
			cnt_state	<= 3'B000;
		end
	else
		begin
			case(cnt_state)
				3'B000	:	begin
									if(sys_clk_cnt >= WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG_CNT)
										begin
											sys_clk_cnt <= 32'D0;
											cnt_state <= 3'B001;
										end
									else
										begin
											sys_clk_cnt <= sys_clk_cnt + 1'b1;
										end
								end
				
				3'B001	:  begin
									MAX_VIDEO_MEMS_CLK <= ~MAX_VIDEO_MEMS_CLK;
									sys_clk_cnt <= 32'D0;
									cnt_state <= 3'B000;
								end
				
				default	: 	begin
									MAX_VIDEO_MEMS_CLK <= 1'b0;
									sys_clk_cnt <= 32'D0;
									cnt_state	<= 3'B000;
								end
			endcase
		end
end


/*
always @(posedge sys_clk_100MHz) begin
	if(!MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n) 
		begin
			MAX_VIDEO_MEMS_CLK <= 1'b0;
			sys_clk_cnt <= 32'D0;
		end
	else if((sys_clk_cnt != 32'D0) && (sys_clk_cnt == WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG_CNT))
		begin
			MAX_VIDEO_MEMS_CLK <= ~MAX_VIDEO_MEMS_CLK;
			sys_clk_cnt <= 32'D0;
		end
	else if(WR_MAX_VIDEO_MEMS_CLK_Freq_DATA_REG_CNT != 32'D0)
		sys_clk_cnt <= sys_clk_cnt + 1'b1;
end
*/
endmodule
//================================================================================//
//The end
//================================================================================//
