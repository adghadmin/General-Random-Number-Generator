//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_SPI_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_SPI_Module(

	//system signals
	input			wire					sys_clk_100MHz,

	//FPGA_SPI_Module Interface
	input			wire		[15:0]	MAX_SPI_CLK_Freq_DATA,
	
	input			wire		[6:0]		WR_MAX_REG_ADDR,
	input			wire		[7:0]		WR_MAX_REG_DATA,
	input			wire					WR_MAX_REG_Trigger,
	  
	input			wire		[6:0]		RD_MAX_REG_DATA_ADDR,
	input			wire					RD_MAX_REG_Trigger,
	
	input			wire					SPI_Module_Rst_n,
	
	output		reg		[7:0]		RD_MAX_REG_DATA_Return,
	output		wire					MAX_SPI_CLK,
	output		wire					MAX_SPI_CS,
	inout			wire					MAX_SPI_DIO
);

//============================Define Parameter and Internal Signals===============//
	reg						[15:0]	RD_MAX_REG_DATA_Return_out;
	
	reg									MAX_SPI_SND_CLK;
	reg									MAX_SPI_SND_CS;
	reg									MAX_SPI_SND_DIO;
	reg						[15:0]	MAX_SPI_SYS_SND_cnt;
	reg						[4:0]		c_SPI_Snd_Data_state;
	reg									MAX_SPI_SND_Flag;
	
	reg									MAX_SPI_REC_CLK;
	reg									MAX_SPI_REC_CS;
	reg									MAX_SPI_REC_DIO;
	reg						[15:0]	MAX_SPI_SYS_REC_cnt;
	reg						[4:0]		c_SPI_Rec_Data_state;
	reg									MAX_SPI_REC_Flag;
	
	
	reg						[15:0]	MAX_SPI_CLK_Freq_DATA_half;
	reg flag;

	
	always @(posedge sys_clk_100MHz)
	begin
		MAX_SPI_CLK_Freq_DATA_half[15:0] <= {1'b0,MAX_SPI_CLK_Freq_DATA[15:1]};
	end

//================================================================================//
//accroding the flag select the snd_clk or the rec_clk
assign MAX_SPI_CS  = (MAX_SPI_SND_Flag == 1'b1) ? MAX_SPI_SND_CS  : MAX_SPI_REC_CS;
assign MAX_SPI_CLK = (MAX_SPI_SND_Flag == 1'b1) ? MAX_SPI_SND_CLK : MAX_SPI_REC_CLK;
assign MAX_SPI_DIO = (MAX_SPI_SND_Flag == 1'b1) ? MAX_SPI_SND_DIO : ((MAX_SPI_REC_Flag == 1'b1) ? MAX_SPI_REC_DIO : 1'bz);
//===============================Main Code========================================//
//This Module Write data to MAX3601 by SPI_DIO
always @(posedge sys_clk_100MHz)
begin
	if(!SPI_Module_Rst_n)
		begin
			MAX_SPI_SND_CLK				<= 1'b1;
			MAX_SPI_SND_CS 				<= 1'b0;
			MAX_SPI_SND_DIO				<= 1'b0;
			MAX_SPI_SYS_SND_cnt			<= 16'D0;
			c_SPI_Snd_Data_state 		<= 5'b00000;
			MAX_SPI_SND_Flag				<= 1'b0;
		end
	else begin
		case(c_SPI_Snd_Data_state)
			5'b00000	:	begin//IDEL state
								if(WR_MAX_REG_Trigger == 1'b1)
									begin
										MAX_SPI_SND_CLK				<= 1'b1;
										MAX_SPI_SND_CS 				<= 1'b1;
										MAX_SPI_SND_DIO 				<= 1'b0;
										MAX_SPI_SYS_SND_cnt			<= 16'D0;
										c_SPI_Snd_Data_state 		<= 5'b00001;
										MAX_SPI_SND_Flag				<= 1'b1;
									end
								else
									begin
										MAX_SPI_SND_CLK				<= 1'b1;
										MAX_SPI_SND_CS 				<= 1'b0;
										MAX_SPI_SND_DIO 				<= 1'b0;
										MAX_SPI_SYS_SND_cnt			<= 16'D0;
										c_SPI_Snd_Data_state 		<= 5'b00000;
										MAX_SPI_SND_Flag				<= 1'b0;
									end
							end
							
			5'b00001	:	begin//wait a clock cycle(or change more clock cycles)
							if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK			<= 1'b1;
										MAX_SPI_SND_CS 			<= 1'b1;
										MAX_SPI_SND_DIO 			<= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00010;
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
							
			5'b00010	:	begin//MAX_SPI_SND_DIO = 1'b0; indicate SPI Write Timing
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SND_DIO <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00011;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[6];//send WR_MAX_REG_ADDR[6]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
							
			5'b00011	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00100;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[5];//send WR_MAX_REG_ADDR[5]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b00100	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00101;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[4];//send WR_MAX_REG_ADDR[4]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b00101	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00110;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[3];//send WR_MAX_REG_ADDR[3]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b00110	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b00111;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[2];//send WR_MAX_REG_ADDR[2]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b00111	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01000;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[1];//send WR_MAX_REG_ADDR[1]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01000	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01001;
										MAX_SPI_SND_DIO <= WR_MAX_REG_ADDR[0];//send WR_MAX_REG_ADDR[0]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01001	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01010;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[7];//send WR_MAX_REG_DATA[7]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01010	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
										end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01011;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[6];//send WR_MAX_REG_DATA[6]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01011	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01100;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[5];//send WR_MAX_REG_DATA[5]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01100	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01101;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[4];//send WR_MAX_REG_DATA[4]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01101	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01110;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[3];//send WR_MAX_REG_DATA[3]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01110	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b01111;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[2];//send WR_MAX_REG_DATA[2]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b01111	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b10000;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[1];//send WR_MAX_REG_DATA[1]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b10000	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b10001;
										MAX_SPI_SND_DIO <= WR_MAX_REG_DATA[0];//send WR_MAX_REG_DATA[0]
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b10001	:	begin
								if(MAX_SPI_SYS_SND_cnt == 16'D0)
									begin
										MAX_SPI_SND_CLK <= 1'b0;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SND_CLK <= 1'b1;
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_SND_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_SND_cnt		<= 16'D0;
										c_SPI_Snd_Data_state		<= 5'b10010;
									end
								else
									begin
										MAX_SPI_SYS_SND_cnt 	<= MAX_SPI_SYS_SND_cnt + 1'b1;
									end
							end
			5'b10010	:	begin//finish the sending of ADDR and DATA, return to IDLE state
								MAX_SPI_SND_CLK				<= 1'b1;
								MAX_SPI_SND_CS 				<= 1'b0;
								MAX_SPI_SND_DIO 				<= 1'b0;
								MAX_SPI_SYS_SND_cnt			<= 16'D0;
								c_SPI_Snd_Data_state 		<= 5'b00000;
								MAX_SPI_SND_Flag				<= 1'b0;
							end
			default	:	begin//default state
								MAX_SPI_SND_CLK				<= 1'b1;
								MAX_SPI_SND_CS 				<= 1'b0;
								MAX_SPI_SND_DIO 				<= 1'b0;
								MAX_SPI_SYS_SND_cnt			<= 16'D0;
								c_SPI_Snd_Data_state 		<= 5'b00000;
								MAX_SPI_SND_Flag				<= 1'b0;
							end
		endcase
	end
end
//================================================================================//

//================================================================================//
//This Module Read data to MAX3601 by SPI_DIO
always @(posedge sys_clk_100MHz)
begin
	if(!SPI_Module_Rst_n)
		begin
			MAX_SPI_REC_CLK				<= 1'b1;
			MAX_SPI_REC_CS 				<= 1'b0;
			MAX_SPI_REC_DIO				<= 1'b1;
			MAX_SPI_SYS_REC_cnt			<= 16'D0;
			c_SPI_Rec_Data_state 		<= 5'b00000;
			MAX_SPI_REC_Flag				<= 1'b0;
			flag <= 1'b0;
		end
	else begin
		case(c_SPI_Rec_Data_state)
			5'b00000	:	begin//IDEL state
								if(RD_MAX_REG_Trigger == 1'b1)
									begin
										MAX_SPI_REC_CLK				<= 1'b1;
										MAX_SPI_REC_CS 				<= 1'b1;
										MAX_SPI_REC_DIO 				<= 1'b1;
										MAX_SPI_SYS_REC_cnt			<= 16'D0;
										c_SPI_Rec_Data_state 		<= 5'b00001;
										MAX_SPI_REC_Flag				<= 1'b1;
									end
								else
									begin
										MAX_SPI_REC_CLK				<= 1'b1;
										MAX_SPI_REC_CS 				<= 1'b0;
										MAX_SPI_REC_DIO 				<= 1'b1;
										MAX_SPI_SYS_REC_cnt			<= 16'D0;
										c_SPI_Rec_Data_state 		<= 5'b00000;
										MAX_SPI_REC_Flag				<= 1'b0;
									end
							end
							
			5'b00001	:	begin//wait a clock cycle(or change more clock cycles)
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK			<= 1'b1;
										MAX_SPI_REC_CS 			<= 1'b1;
										MAX_SPI_REC_DIO 			<= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b00010;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
							
			5'b00010	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b00011;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[6];//send RD_MAX_REG_DATA_ADDR[6]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
							
			5'b00011	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b00100;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[5];//send RD_MAX_REG_DATA_ADDR[5]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b00100	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state 	<= 5'b00101;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[4];//send RD_MAX_REG_DATA_ADDR[4]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b00101	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b00110;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[3];//send RD_MAX_REG_DATA_ADDR[3]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b00110	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b00111;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[2];//send RD_MAX_REG_DATA_ADDR[2]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b00111	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state 	<= 5'b01001;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[1];//send RD_MAX_REG_DATA_ADDR[1]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01001	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state 	<= 5'b01010;
										MAX_SPI_REC_DIO <= RD_MAX_REG_DATA_ADDR[0];//send RD_MAX_REG_DATA_ADDR[0]
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01010	:	begin
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b01011;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01011	:	begin//wait a clock cycle(or change more clock cycles)
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK			<= 1'b1;
										MAX_SPI_REC_CS 			<= 1'b1;
										//MAX_SPI_REC_DIO 			<= 1'b0;
										//c_SPI_Rec_Data_state 	<= 5'b01100;
										MAX_SPI_REC_Flag			<= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b01100;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01100	:	begin//read RD_MAX_REG_DATA_Return[7]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[7] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b01101;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01101	:	begin//read RD_MAX_REG_DATA_Return[6]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[6] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b01110;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01110	:	begin//read RD_MAX_REG_DATA_Return[5]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[5] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b01111;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b01111	:	begin//read RD_MAX_REG_DATA_Return[4]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[4] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b10000;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b10000	:	begin//read RD_MAX_REG_DATA_Return[3]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[3] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b10001;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b10001	:	begin//read RD_MAX_REG_DATA_Return[2]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[2] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b10010;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b10010	:	begin//read RD_MAX_REG_DATA_Return[1]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[1] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b10011;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b10011	:	begin//read RD_MAX_REG_DATA_Return[0]
								if(MAX_SPI_SYS_REC_cnt == 16'D0)
									begin
										MAX_SPI_REC_CLK <= 1'b0;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA_half)
									begin
										MAX_SPI_REC_CLK <= 1'b1;
										RD_MAX_REG_DATA_Return[0] <= MAX_SPI_DIO;
										flag <= ~flag;
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
								else if(MAX_SPI_SYS_REC_cnt == MAX_SPI_CLK_Freq_DATA)
									begin
										MAX_SPI_SYS_REC_cnt		<= 16'D0;
										c_SPI_Rec_Data_state		<= 5'b10100;
									end
								else
									begin
										MAX_SPI_SYS_REC_cnt 	<= MAX_SPI_SYS_REC_cnt + 1'b1;
									end
							end
			5'b10100	:	begin//finish the sending of ADDR and the receiving of DATA, return to IDLE state 
								MAX_SPI_REC_CLK				<= 1'b1;
								MAX_SPI_REC_CS 				<= 1'b0;
								MAX_SPI_REC_DIO 				<= 1'b0;
								MAX_SPI_SYS_REC_cnt			<= 16'D0;
								c_SPI_Rec_Data_state			<= 5'b00000;
								MAX_SPI_REC_Flag				<= 1'b0;
							end
			default	:	begin//default state
								MAX_SPI_REC_CLK				<= 1'b1;
								MAX_SPI_REC_CS 				<= 1'b0;
								MAX_SPI_REC_DIO 				<= 1'b0;
								MAX_SPI_SYS_REC_cnt			<= 16'D0;
								c_SPI_Rec_Data_state 		<= 5'b00000;
								MAX_SPI_REC_Flag				<= 1'b0;
							end
		endcase
	end
end
//================================================================================//

endmodule
//================================================================================//
//The end
//================================================================================//
