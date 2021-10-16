//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_VIDEO_DDATA_Send_Control_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_VIDEO_DATA_Send_Control_Module(

	input			wire		[15:0]		MAX_VIDEO_Stripe_Number,
	//system signals
	input			wire					sys_clk_100MHz,
	

	
	//FPGA_VIDEO_DDATA_Send_Control_Module Interface
	input			wire					MAX_VIDEO_DATA_Send_Trigger,
	input			wire					MAX_VIDEO_DATA_Send_Control_Module_Rst_n,
	input			wire					MAX_VIDEO_MEMS_CLK,
	
	input			wire		[15:0]		RD_MAX_VIDEO_DATA_T_DATA,
	output			reg			[9:0]		RD_MAX_VIDEO_DATA_T_ADDR,


	input			wire		[15:0]		RD_MAX_VIDEO_DATA_P_DATA,
	output			reg			[9:0]		RD_MAX_VIDEO_DATA_P_ADDR,
	input			wire		[15:0]		MAX_VIDEO_MEMS_CLK_Dealy_Time,
	input			wire					MAX_VIDEO_MEMS_CLK_Dealy_Time_Flag,
	input			wire					MAX_VIDEO_MEMS_DCLK_Trigger,
	input			wire					MAX_VIDEO_MEMS_CLK_Dealy_Time_CS,
	
	output			reg			[11:0]		MAX_VIDEO_DATA,	
	output			reg						MAX_VIDEO_DCLK
	//output		wire					One_Per_Twice_Trigger_rst
	
);

//============================Define Parameter and Internal Signals===============//
	
	
	reg						[15:0]		VIDEO_DATA_T_cnt;
	reg									MAX_VIDEO_DCLK_REG;
	reg									SEND_FLAG = 0;
	wire								One_Per_Twice_Trigger_rst;
	reg									One_Per_Twice_Trigger;
	reg						[3:0]		c_Snd_Data_state;
	reg						[15:0]		RD_MAX_VIDEO_DATA_T_DATA_REG;
	reg						[31:0]		MAX_VIDEO_MEMS_CLK_Dealy_Time_reg;
	reg									Start_Send_Flag;
	
always @(MAX_VIDEO_MEMS_CLK_Dealy_Time)
begin
	if(MAX_VIDEO_MEMS_CLK_Dealy_Time_Flag == 1'b1)
		begin
			MAX_VIDEO_MEMS_CLK_Dealy_Time_reg[31:16] = MAX_VIDEO_MEMS_CLK_Dealy_Time;
		end
	else
		begin
			MAX_VIDEO_MEMS_CLK_Dealy_Time_reg[15:0] = MAX_VIDEO_MEMS_CLK_Dealy_Time;
		end
end

	
	
//=================================Main Code======================================//
always @(posedge MAX_VIDEO_MEMS_CLK)
begin
	SEND_FLAG <= ~SEND_FLAG;
end
//assign One_Per_Twice_Trigger_rst = Start_Send_Flag & SEND_FLAG;
assign One_Per_Twice_Trigger_rst = Start_Send_Flag;

always @(posedge sys_clk_100MHz )
	begin
		One_Per_Twice_Trigger <= One_Per_Twice_Trigger_rst ;
	end
	/*
//==============capture the MAX_VIDEO_MEMS_CLK posedge==================
					reg 					MAX_VIDEO_MEMS_DCLK_Trigger_r0;
					reg					MAX_VIDEO_MEMS_DCLK_Trigger_r1;
					reg					MAX_VIDEO_MEMS_DCLK_Trigger_r2;
					//wire					MAX_VIDEO_MEMS_DCLK_Trigger_N;
					wire					MAX_VIDEO_MEMS_DCLK_Trigger_P;
always @(posedge sys_clk_100MHz)
begin
	if(!MAX_VIDEO_DATA_Send_Control_Module_Rst_n)
		begin
			MAX_VIDEO_MEMS_DCLK_Trigger_r0	<= 1'b0;
			MAX_VIDEO_MEMS_DCLK_Trigger_r1	<= 1'b0;
		end	
	else
		begin
			MAX_VIDEO_MEMS_DCLK_Trigger_r0	<= MAX_VIDEO_MEMS_CLK;
			MAX_VIDEO_MEMS_DCLK_Trigger_r1	<= MAX_VIDEO_MEMS_DCLK_Trigger_r0;
			MAX_VIDEO_MEMS_DCLK_Trigger_r2   <= MAX_VIDEO_MEMS_DCLK_Trigger_r1;
		end
end
assign MAX_VIDEO_MEMS_DCLK_Trigger_P = (~MAX_VIDEO_MEMS_DCLK_Trigger_r2 & MAX_VIDEO_MEMS_DCLK_Trigger_r0) ? 1'b1 : 1'b0;//capture the MAX_VIDEO_MEMS_CLK posedge
reg MAX_VIDEO_MEMS_DCLK_Trigger_P_REG;
always @(posedge sys_clk_100MHz)
begin
	MAX_VIDEO_MEMS_DCLK_Trigger_P_REG <= MAX_VIDEO_MEMS_DCLK_Trigger_P;
end
*/
//===============================================================================//
//delay the signal——MAX_VIDEO_MEMS_DCLK_Trigger
reg				[31:0]		delay_cnt;


/*
always @(posedge sys_clk_100MHz)
begin
	if(!MAX_VIDEO_DATA_Send_Control_Module_Rst_n)
		begin
			delay_cnt <= 32'd0;
			Start_Send_Flag <= 1'b0;
		end
	else if(delay_cnt == MAX_VIDEO_MEMS_CLK_Dealy_Time_reg)
		begin
			delay_cnt <= 32'd0;
			Start_Send_Flag <= 1'b1;
		end
	else if(MAX_VIDEO_MEMS_DCLK_Trigger_P_REG)
		begin
			delay_cnt <= delay_cnt + 1'b1;
		end
	else if(delay_cnt != 32'd0)
		begin
			delay_cnt <= delay_cnt + 1'b1;
		end
	else
		begin
			delay_cnt <= 16'd0;
			Start_Send_Flag <= 1'b0;
		end
end*/

reg		[2:0]	cnt_state;
always @(posedge sys_clk_100MHz)
begin
	if(!MAX_VIDEO_DATA_Send_Control_Module_Rst_n)
		begin
			delay_cnt <= 32'd0;
			cnt_state <= 3'b000;
			Start_Send_Flag <= 1'b0;
		end
	else
		case(cnt_state)
		3'b000	:	begin
							if(MAX_VIDEO_MEMS_DCLK_Trigger == 1'b1 && MAX_VIDEO_MEMS_CLK_Dealy_Time_CS == 1'b1)
								begin
									delay_cnt <= 32'd0;
									cnt_state <= 3'b001;
									Start_Send_Flag <= 1'b0;
								end
							else
								begin
									delay_cnt <= 32'd0;
									cnt_state <= 3'b000;
								end
						end
	
		3'b001	:	begin
							if(delay_cnt >= MAX_VIDEO_MEMS_CLK_Dealy_Time_reg)
								begin
									delay_cnt <= 32'd0;
									cnt_state <= 3'b010;
									Start_Send_Flag <= 1'b1;
								end
							else
								begin
									delay_cnt <= delay_cnt + 1'b1;
								end
						end
						
		3'b010	:	begin
							Start_Send_Flag <= 1'b0;
							delay_cnt <= 32'd0;
							cnt_state <= 3'b000;
						end
		default	:	
						begin
							delay_cnt <= 32'd0;
							cnt_state <= 3'b000;
							Start_Send_Flag <= 1'b0;
						end
		endcase
		

end




//fetch data from DPRAM_P, and send the data to MAX_VIDEO_DATA[11:0]
always @(posedge	sys_clk_100MHz) begin
	if((!MAX_VIDEO_DATA_Send_Control_Module_Rst_n) || (One_Per_Twice_Trigger_rst == 1'b1))
		begin
			RD_MAX_VIDEO_DATA_T_ADDR <= 10'D0;
			RD_MAX_VIDEO_DATA_P_ADDR <= 10'D0;
			VIDEO_DATA_T_cnt <= 16'D0;
			c_Snd_Data_state <= 4'B0000;
			MAX_VIDEO_DATA <= 11'D0;
		end
	else
		begin
			case(c_Snd_Data_state)
				4'B0000	:	begin
									if((MAX_VIDEO_DATA_Send_Trigger == 1'b1) && (One_Per_Twice_Trigger == 1'b1))
										begin
											RD_MAX_VIDEO_DATA_T_ADDR <= 10'D0;
											RD_MAX_VIDEO_DATA_P_ADDR <= 10'D0;
											VIDEO_DATA_T_cnt <= 16'D0;
											c_Snd_Data_state <= 4'B0010;
											MAX_VIDEO_DATA <= 11'D0;
											MAX_VIDEO_DCLK <= 1'b0;
										end
									else
										begin
											RD_MAX_VIDEO_DATA_T_ADDR <= 10'D0;
											RD_MAX_VIDEO_DATA_P_ADDR <= 10'D0;
											VIDEO_DATA_T_cnt <= 16'D0;
											c_Snd_Data_state <= 4'B0000;
											MAX_VIDEO_DATA <= 11'D0;
											MAX_VIDEO_DCLK <= 1'b0;
										end
								end
								
				4'B0010	:  begin
									MAX_VIDEO_DATA <= RD_MAX_VIDEO_DATA_P_DATA[11:0];
									RD_MAX_VIDEO_DATA_T_DATA_REG <= RD_MAX_VIDEO_DATA_T_DATA;
									
									//给下一个地址
									RD_MAX_VIDEO_DATA_T_ADDR <= RD_MAX_VIDEO_DATA_T_ADDR + 1'b1;
									RD_MAX_VIDEO_DATA_P_ADDR <= RD_MAX_VIDEO_DATA_P_ADDR + 1'b1;
									MAX_VIDEO_DCLK <= 1'b0;
									c_Snd_Data_state <= 4'B0001;
									VIDEO_DATA_T_cnt <= 16'D0;
								end
	
				4'B0001	:	begin
									MAX_VIDEO_DCLK <= 1'b1;
									if(VIDEO_DATA_T_cnt == RD_MAX_VIDEO_DATA_T_DATA_REG - 2'b10)
										begin
											VIDEO_DATA_T_cnt <= 16'D0;
											MAX_VIDEO_DCLK <= 1'b0;
											c_Snd_Data_state <= 4'B0010;
											if(RD_MAX_VIDEO_DATA_P_ADDR == MAX_VIDEO_Stripe_Number)
												begin
													RD_MAX_VIDEO_DATA_T_ADDR <= 10'D0;
													RD_MAX_VIDEO_DATA_P_ADDR <= 10'D0;
													VIDEO_DATA_T_cnt <= 16'D0;
													MAX_VIDEO_DCLK <= 1'b0;
													c_Snd_Data_state <= 4'B0000;
												end
										end
									else
										begin
											VIDEO_DATA_T_cnt = VIDEO_DATA_T_cnt + 1'b1;
										end
								end
				default	:	begin
									RD_MAX_VIDEO_DATA_T_ADDR <= 10'D0;
									RD_MAX_VIDEO_DATA_P_ADDR <= 10'D0;
									VIDEO_DATA_T_cnt <= 16'D0;
									c_Snd_Data_state <= 4'B0000;
									MAX_VIDEO_DATA <= 11'D0;
									MAX_VIDEO_DCLK <= 1'b0;
								end
			endcase
		end
end


endmodule
//================================================================================//
//The end
//================================================================================//