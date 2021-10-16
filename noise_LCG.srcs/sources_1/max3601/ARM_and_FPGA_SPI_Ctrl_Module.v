//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2019/01/15
//Module Name		:	ARM_and_FPGA_SPI_Ctrl_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2019.01.15,Initial,Module Definition
//================================================================================//
module ARM_and_FPGA_SPI_Ctrl_Module(

	//input signals
	input			wire					sys_clk_100M,
	input			wire					ARM_and_FPGA_SPI_Ctrl_Module_Rst_n,
	input			wire					ARM_SPI_CLK,
	input			wire					ARM_SPI_CS,
	input			wire					ARM_SPI_MOSI,
	
	input			wire		[15:0]		ARM_RD_FPGA_DATA,

	//output signals
	output			reg						ARM_SPI_MISO,
	output			reg						ARM_WR_and_RD_SELECT_Wire,
	
	output			reg			[15:0]		ARM_WR_FPGA_ADDR,
	output			reg			[15:0]		ARM_WR_FPGA_DATA,
	output			reg						ARM_WR_FPGA_Trigger,
	
	output			reg			[15:0]		ARM_RD_FPGA_ADDR,
	output			reg						ARM_RD_FPGA_Trigger,
	output			reg			[4:0]		Rec_State
);
//============================Define Parameter and Internal Signals===============//
reg		[15:0]  ARM_RD_FPGA_DATA_OUT;
always @(posedge sys_clk_100M)
begin
	ARM_RD_FPGA_DATA_OUT <= ARM_RD_FPGA_DATA;
end

//===============================Main Code========================================//

 //-------------------------capture the sck-----------------------------
					reg 					ARM_SPI_CLK_R0;
					reg						ARM_SPI_CLK_R1;
					wire 					ARM_SPI_CLK_N;
					wire					ARM_SPI_CLK_P;
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
    if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			ARM_SPI_CLK_R0	<= 1'b1;//ARM_SPI_CLK of the idle state is high
			ARM_SPI_CLK_R1	<= 1'b1;
		end
    else
		begin
			ARM_SPI_CLK_R0	<= ARM_SPI_CLK;
			ARM_SPI_CLK_R1	<= ARM_SPI_CLK_R0;
		end
end
assign ARM_SPI_CLK_N = (~ARM_SPI_CLK_R0 & ARM_SPI_CLK_R1) ? 1'b1 : 1'b0;//capture the ARM_SPI_CLK negedge
assign ARM_SPI_CLK_P = (~ARM_SPI_CLK_R1 & ARM_SPI_CLK_R0) ? 1'b1 : 1'b0;//capture the ARM_SPI_CLK posedge

//-----------------------spi_slaver read data-------------------------------
					reg						Rec_ADDR_or_DATA;
					//reg			[4:0]		Rec_State;
					reg			[15:0]		rxd_addr;
					reg			[15:0]		rxd_data;
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
    if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			rxd_data		<= 16'b0;
			rxd_addr		<= 16'b0;
			Rec_State		<= 5'b0;
			Rec_ADDR_or_DATA <= 1'b0;//reset Rec_ADDR_or_DATA(0:rececive addr, 1: receive data)
		end
    else if(ARM_SPI_CLK_P && !ARM_SPI_CS)
		begin
			case(Rec_State)
				5'd0	:	begin//receive ARM_WR_FPGA_ADDR[15] or ARM_WR_FPGA_DATA[15] or ARM_RD_FPGA_ADDR[15] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[15] 		<= ARM_SPI_MOSI;
										//rxd_WR_FPGA_flag 	<= 1'b0;//reset rxd_WR_FPGA_flag
										//rxd_RD_ADDR_flag 	<= 1'b0;//reset rxd_RD_ADDR_flag
										Rec_State			<= 5'd1;
									end
								else
									begin
										rxd_data[15] 		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd1;
									end
							end
							
				5'd1	:	begin//receive ARM_WR_FPGA_ADDR[14] or ARM_WR_FPGA_DATA[14] or ARM_RD_FPGA_ADDR[14] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[14]	 	<= ARM_SPI_MOSI;
										Rec_State			<= 5'd2;
									end
								else
									begin
										rxd_data[14]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd2;
									end
							end
							
				5'd2	:	begin//receive ARM_WR_FPGA_ADDR[13] or ARM_WR_FPGA_DATA[13] or ARM_RD_FPGA_ADDR[13] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[13]	 	<= ARM_SPI_MOSI;
										Rec_State			<= 5'd3;
									end
								else
									begin
										rxd_data[13]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd3;
									end
							end
							
				5'd3	:	begin//receive ARM_WR_FPGA_ADDR[12] or ARM_WR_FPGA_DATA[12] or ARM_RD_FPGA_ADDR[12] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[12]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd4;
									end
								else
									begin
										rxd_data[12]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd4;
									end
							end
							
				5'd4	:	begin//receive ARM_WR_FPGA_ADDR[11] or ARM_WR_FPGA_DATA[11] or ARM_RD_FPGA_ADDR[11] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[11]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd5;
									end
								else
									begin
										rxd_data[11]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd5;
									end
							end
							
				5'd5	:	begin//receive ARM_WR_FPGA_ADDR[10] or ARM_WR_FPGA_DATA[10] or ARM_RD_FPGA_ADDR[10] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[10]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd6;
									end
								else
									begin
										rxd_data[10]		<= ARM_SPI_MOSI;
										Rec_State			<= 5'd6;
									end
							end
							
				5'd6	:	begin//receive ARM_WR_FPGA_ADDR[9] or ARM_WR_FPGA_DATA[9] or ARM_RD_FPGA_ADDR[9] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[9]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd7;
									end
								else
									begin
										rxd_data[9]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd7;
									end
							end
							
				5'd7	:	begin//receive ARM_WR_FPGA_ADDR[8] or ARM_WR_FPGA_DATA[8] or ARM_RD_FPGA_ADDR[8] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[8]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd8;
									end
								else
									begin
										rxd_data[8]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd8;
									end
							end
							
				5'd8	:	begin//receive ARM_WR_FPGA_ADDR[7] or ARM_WR_FPGA_DATA[7] or ARM_RD_FPGA_ADDR[7] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[7]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd9;
									end
								else
									begin
										rxd_data[7]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd9;
									end
							end
							
				5'd9	:	begin//receive ARM_WR_FPGA_ADDR[6] or ARM_WR_FPGA_DATA[6] or ARM_RD_FPGA_ADDR[6] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[6]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd10;
									end
								else
									begin
										rxd_data[6]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd10;
									end
							end
							
				5'd10	:	begin//receive ARM_WR_FPGA_ADDR[5] or ARM_WR_FPGA_DATA[5] or ARM_RD_FPGA_ADDR[5] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[5]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd11;
									end
								else
									begin	
										rxd_data[5]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd11;
									end
							end
							
				5'd11	:	begin//receive ARM_WR_FPGA_ADDR[4] or ARM_WR_FPGA_DATA[4] or ARM_RD_FPGA_ADDR[4] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[4]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd12;
									end	
								else
									begin
										rxd_data[4]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd12;
									end									
							end
							
				5'd12	:	begin//receive ARM_WR_FPGA_ADDR[3] or ARM_WR_FPGA_DATA[3] or ARM_RD_FPGA_ADDR[3] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[3]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd13;
									end
								else
									begin
										rxd_data[3]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd13;
									end
							end
							
				5'd13	:	begin//receive ARM_WR_FPGA_ADDR[2] or ARM_WR_FPGA_DATA[2] or ARM_RD_FPGA_ADDR[2] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[2]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd14;
									end
								else
									begin
										rxd_data[2]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd14;
									end
							end
							
				5'd14	:	begin//receive ARM_WR_FPGA_ADDR[1] or ARM_WR_FPGA_DATA[1] or ARM_RD_FPGA_ADDR[1] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[1]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd15;
									end
								else
									begin
										rxd_data[1]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd15;
									end
							end
							
				5'd15	:	begin//receive ARM_WR_FPGA_ADDR[0] or ARM_WR_FPGA_DATA[0] or ARM_RD_FPGA_ADDR[0] from ARM
								if(Rec_ADDR_or_DATA == 1'b0)
									begin
										rxd_addr[0]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd0;
										Rec_ADDR_or_DATA	<= 1'b1;//switch to receive DATA
									end
								else
									begin
										rxd_data[0]			<= ARM_SPI_MOSI;
										Rec_State			<= 5'd0;
										Rec_ADDR_or_DATA	<= 1'b0;//switch to receive ADDR
									end
							end
							
				default:	begin
								rxd_data		<=	16'b0;
								Rec_State	<= 5'd0;
								//rxd_WR_FPGA_flag <= 1'b0;//reset rxd_WR_FPGA_flag
								//rxd_RD_ADDR_flag <= 1'b0;//reset rxd_RD_ADDR_flag
								Rec_ADDR_or_DATA <= 1'b0;//reset Rec_ADDR_or_DATA(0:rececive addr, 1: receive data)
							end
			endcase
		end
end

//--------------------capture Rec_ADDR_or_DATA posedge--------------------------------
					reg 					Rec_ADDR_or_DATA_r0;
					reg						Rec_ADDR_or_DATA_r1;
					wire					Rec_ADDR_or_DATA_N;
					wire					Rec_ADDR_or_DATA_P;
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
   if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			Rec_ADDR_or_DATA_r0 <= 1'b0;
			Rec_ADDR_or_DATA_r1 <= 1'b0;
		end
   else
		begin
			Rec_ADDR_or_DATA_r0	<= Rec_ADDR_or_DATA;
			Rec_ADDR_or_DATA_r1	<= Rec_ADDR_or_DATA_r0;
		end
end
assign Rec_ADDR_or_DATA_N = (~Rec_ADDR_or_DATA_r0 & Rec_ADDR_or_DATA_r1) ? 1'b1 : 1'b0;//capture the Rec_ADDR_or_DATA negedge
assign Rec_ADDR_or_DATA_P = (~Rec_ADDR_or_DATA_r1 & Rec_ADDR_or_DATA_r0) ? 1'b1 : 1'b0;//capture the Rec_ADDR_or_DATA posedge


//-------------------
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
	if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			ARM_RD_FPGA_ADDR 		<= 16'd0;
			ARM_RD_FPGA_Trigger		<= 1'b0;
			ARM_WR_FPGA_ADDR 		<= 16'd0;
			ARM_WR_FPGA_DATA 		<= 16'd0;
			ARM_WR_FPGA_Trigger 	<= 1'b0;
			ARM_WR_and_RD_SELECT_Wire <= 1'b0;
		end
	else if((Rec_ADDR_or_DATA_P == 1'b1) && (rxd_addr[15] == 1'b1))
		begin
			ARM_RD_FPGA_ADDR 		<= rxd_addr;
			ARM_RD_FPGA_Trigger		<= 1'b1;
			ARM_WR_and_RD_SELECT_Wire <= 1'b1;
		end
	else if((Rec_ADDR_or_DATA_N == 1'b1) && (rxd_addr[15]  == 1'b0))
		begin
			ARM_WR_FPGA_ADDR 		<= rxd_addr;
			ARM_WR_FPGA_DATA 		<= rxd_data;
			ARM_WR_FPGA_Trigger 	<= 1'b1;
			ARM_WR_and_RD_SELECT_Wire <= 1'b0;
		end
	else
		begin
			ARM_RD_FPGA_Trigger		<= 1'b0;
			ARM_WR_FPGA_Trigger 	<= 1'b0;
		end
end



/*					reg					rxd_WR_FPGA_flag_r1;
//--------------------produce ARM_WR_FPGA_Trigger-----------------------------
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
	if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			rxd_WR_FPGA_flag_r1 <= 1'b0;
		end
	else
		begin
			rxd_WR_FPGA_flag_r1 <= rxd_WR_FPGA_flag;
		end
end
assign ARM_WR_FPGA_Trigger = (~rxd_WR_FPGA_flag_r1) & (rxd_WR_FPGA_flag);
*/

//---------------------spi_slaver send data---------------------------
					reg		[4:0]		txd_state;
always@(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
   if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			txd_state	<= 5'b0;
		end
   else if(ARM_SPI_CLK_N && !ARM_SPI_CS)
		begin
			case(txd_state)
				5'd0	:	begin//send the ARM_RD_FPGA_DATA_OUT[15] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[15];
								txd_state		<= 5'd1;
							end
							
				5'd1	:	begin//send the ARM_RD_FPGA_DATA_OUT[14] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[14];
								txd_state		<= 5'd2;
							end
							
				5'd2	:	begin//send the ARM_RD_FPGA_DATA_OUT[13] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[13];
								txd_state		<= 5'd3;
							end
							
				5'd3	:	begin//send the ARM_RD_FPGA_DATA_OUT[12] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[12];
								txd_state		<= 5'd4;
							end
							
				5'd4	:	begin//send the ARM_RD_FPGA_DATA_OUT[11] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[11];
								txd_state		<= 5'd5;
							end
							
				5'd5	:	begin//send the ARM_RD_FPGA_DATA_OUT[10] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[10];
								txd_state		<= 5'd6;
							end
							
				5'd6	:	begin//send the ARM_RD_FPGA_DATA_OUT[9] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[9];
								txd_state		<= 5'd7;
							end
							
				5'd7	:	begin//send the ARM_RD_FPGA_DATA_OUT[8] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[8];
								txd_state		<= 5'd8;
							end
				5'd8	:	begin//send the ARM_RD_FPGA_DATA_OUT[7] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[7];
								txd_state		<= 5'd9;
							end
							
				5'd9	:	begin//send the ARM_RD_FPGA_DATA_OUT[6] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[6];
								txd_state		<= 5'd10;
							end
							
				5'd10	:	begin//send the ARM_RD_FPGA_DATA_OUT[5] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[5];
								txd_state		<= 5'd11;
							end
							
				5'd11	:	begin//send the ARM_RD_FPGA_DATA_OUT[4] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[4];
								txd_state		<= 5'd12;
							end
							
				5'd12	:	begin//send the ARM_RD_FPGA_DATA_OUT[3] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[3];
								txd_state		<= 5'd13;
							end
							
				5'd13	:	begin//send the ARM_RD_FPGA_DATA_OUT[2] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[2];
								txd_state		<= 5'd14;
							end
							
				5'd14	:	begin//send the ARM_RD_FPGA_DATA_OUT[1] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[1];
								txd_state		<= 5'd15;
							end
							
				5'd15	:	begin//send the ARM_RD_FPGA_DATA_OUT[0] to ARM_SPI_MISO
								ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[0];
								txd_state		<= 5'd0;
							end
							
				default:	begin
								ARM_SPI_MISO	<= 1'b0;
								txd_state		<= 5'd0;
								
							end
			endcase
		end
end







/*
//--------------------capture spi_flag posedge--------------------------------
					reg 					rxd_flag_r0;
					reg					rxd_flag_r1;
always @(posedge sys_clk_100M or negedge ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
begin
   if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			rxd_flag_r0 <= 1'b0;
			rxd_flag_r1 <= 1'b0;
		end
   else
		begin
			rxd_flag_r0	<= rxd_flag_r;
			rxd_flag_r1	<= rxd_flag_r0;
		end
end
assign rxd_flag = (~rxd_flag_r1 & rxd_flag_r0) ? 1'b1 : 1'b0;
*/

/*
//============================Define Parameter and Internal Signals===============//
					reg					Flag_Rec					=		1'b1;//The Flag_Rec is the flag of starting State_machaine_1 or closing State_machaine_1.
					reg					Flag_Rec_Trigger		=		1'b0;
					reg					Flag_Rec_Trigger_Deleay_One_T	= 1'b0;
					reg					Flag_Snd					=		1'b0;//The Flag_Snd is the flag of starting State_machaine_2 or closing State_machaine_2.
					reg					Flag_Snd_Trigger		=		1'b0;
					reg					Flag_Snd_Deleay_One_T=		1'b0;

					reg		[3:0]		C_State_Receive_Data	= 		4'B0000;//接收数据状态寄存器
					reg		[3:0]		C_State_Send_Data		= 		4'B0000;//发送数据状态寄存器
					reg		[3:0]		Rec_ADDR_CNT			=		4'd15;
					reg		[3:0]		Rec_DATA_CNT			=		4'd15;
					reg		[3:0]		Snd_DATA_CNT			=		4'd15;
					
					reg		[15:0]	ARM_SND_FPGA_ADDR		= 		16'd0;
					reg		[15:0]	ARM_SND_FPGA_DATA		= 		16'd0;
//================================================================================//
always @(negedge	ARM_SPI_CLK)
begin
	if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			Rec_ADDR_CNT <= 4'd15;
			Rec_DATA_CNT <= 4'd15;
		end
	else
		begin
			Rec_ADDR_CNT <= Rec_ADDR_CNT + 1'b1;
			Rec_DATA_CNT <= Rec_DATA_CNT + 1'd1;
		end
end

always @(posedge sys_clk_100M)
begin
	Flag_Snd_Deleay_One_T <= Flag_Snd_Trigger;
end
assign ARM_RD_FPGA_Trigger = (~Flag_Snd_Deleay_One_T) & (Flag_Snd);

always @(posedge sys_clk_100M)
begin
	Flag_Rec_Trigger_Deleay_One_T <= Flag_Rec_Trigger;
end
assign ARM_WR_FPGA_Trigger = (~Flag_Rec_Trigger_Deleay_One_T) & (Flag_Rec_Trigger);
//===============================Main Code========================================//
//The State_machaine_1 is responsible for receiving addresses and data from ARM_SPI_ARM_SPI_MOSI.
//Received the address, if A[15] = 1'b0, the data reception is continued.
//If A[15] = 1'b1, start the State_Machine_2, and the State_Machine_1 is turned off in the start of State_Machine_2.
always @(posedge ARM_SPI_CLK)
begin
	if(Flag_Snd == 1'b1)
		begin
			Flag_Rec					<= 1'b0;
			Flag_Rec_Trigger 		<= 1'b0;
			Flag_Snd_Trigger     <= 1'b0;
		end
	else
		begin
			Flag_Rec					<= 1'b1;
			Flag_Rec_Trigger 		<= 1'b0;
			Flag_Snd_Trigger     <= 1'b0;
		end
	// If ARM_SPI_CS and Flag_Rec is Low-level, receive ADDR from the wire ARM_SPI_ARM_SPI_MOSI.
	if((ARM_SPI_CS == 1'b0) && (Flag_Rec == 1'b0))
		begin
			case(C_State_Receive_Data)
				4'B0000		:	begin
										ARM_SND_FPGA_ADDR[Rec_ADDR_CNT] = ARM_SPI_ARM_SPI_MOSI;
										if((Rec_ADDR_CNT == 4'd15) && (ARM_SND_FPGA_ADDR[15] == 1'b0))
											begin
												ARM_WR_and_RD_SELECT_Wire 	<= 1'b0;
												ARM_WR_FPGA_ADDR	 	<= ARM_SND_FPGA_ADDR;
												ARM_RD_FPGA_ADDR 		<= 16'd0;
												Flag_Rec					<= 1'b0;
												C_State_Receive_Data	<= 4'B0001;//Continue to wait the data.
											end
										else if((Rec_ADDR_CNT == 4'd15) && (ARM_SND_FPGA_ADDR[15] == 1'b1))
											begin
												ARM_WR_and_RD_SELECT_Wire 	<= 1'b1;
												ARM_RD_FPGA_ADDR 		<= ARM_SND_FPGA_ADDR;
												ARM_WR_FPGA_ADDR 		<= 16'd0;
												Flag_Snd_Trigger     <= 1'b1;
												Flag_Rec					<= 1'b1;//start the State_Machine_2.
												C_State_Receive_Data	<= 4'B0000;
											end
									end

				4'B0001		:	begin
										ARM_SND_FPGA_DATA[Rec_DATA_CNT] = ARM_SPI_ARM_SPI_MOSI;
										if((Rec_DATA_CNT == 4'd15))
											begin
												Flag_Rec_Trigger <= 1'b1;
												ARM_WR_FPGA_DATA <= ARM_SND_FPGA_DATA;
												C_State_Receive_Data	<= 4'B0000;//Continue to wait the next address.
											end
									end
									
				default		:	begin
										ARM_SND_FPGA_ADDR				<= 16'd0;
										ARM_SND_FPGA_DATA				<= 16'd0;
										ARM_WR_FPGA_ADDR				<= 16'd0;
										ARM_RD_FPGA_ADDR				<= 16'd0;
										ARM_WR_FPGA_DATA				<= 16'd0;
										ARM_WR_and_RD_SELECT_Wire 	<= 1'b0;
										Flag_Rec							<= 1'b0;
										Flag_Rec_Trigger				<= 1'b0;
										Flag_Snd_Trigger    			<= 1'b0;
										C_State_Receive_Data			<= 4'B0000;
										Rec_DATA_CNT <= 4'd0;
									end
			endcase
		end
	else
		begin
			C_State_Receive_Data <= 4'B0000;
		end
end


always @(posedge	ARM_SPI_CLK)
begin
	if(!ARM_and_FPGA_SPI_Ctrl_Module_Rst_n)
		begin
			Snd_DATA_CNT <= 4'd15;
		end
	else
		begin
			Snd_DATA_CNT <= Snd_DATA_CNT + 1'b1;
		end
end
//The State_machaine_2 is responsible for sendging data returned from FPGA(ARM_RD_FPGA_DATA_OUT).
//When the State_machaine_2 is starting, close the State_machaine_1 until the ARM_RD_FPGA_DATA_OUT is completely sent out.
always @(negedge ARM_SPI_CLK)
begin
	if(Flag_Rec == 1'b1)
		begin
			Flag_Snd					<= 1'b0;
		end
	else
		begin
			Flag_Snd					<= 1'b1;
		end
	// If ARM_SPI_CS and Flag_Snd is Low-level, send ARM_RD_FPGA_DATA_OUT to the wire ARM_SPI_MISO.
	if((ARM_SPI_CS == 1'b0) && (Flag_Snd == 1'b0))
		case(C_State_Send_Data)
				4'B0000		:	begin
										ARM_SPI_MISO	<= ARM_RD_FPGA_DATA_OUT[Snd_DATA_CNT];
										if(Snd_DATA_CNT == 4'd15)
											begin
												Flag_Snd 				<= 1'b1;
												C_State_Send_Data		<= 4'B0000;
											end
									end
									
				default		:	begin
										ARM_SPI_MISO			<= 1'b0;
										C_State_Send_Data		<= 4'B0000;
									end
		endcase
	else
		begin
			ARM_SPI_MISO			<= 1'b0;
			C_State_Send_Data <= 4'B0000;
		end
end
//================================================================================//
*/


//The end//=======================================================================//
endmodule