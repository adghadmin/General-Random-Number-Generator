//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2018/12/27
//Module Name		:	FPGA_SPI_REG_Control_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2018.12.27,Initial,Module Definition
//================================================================================//
module FPGA_SPI_REG_Control_Module(

	//system signals
	
	//FPGA_SPI_REG_Control_Module Interface
	input			wire					MAX_SPI_REG_Control_CS,
	input			wire					XRD,
	input			wire					XWE,
	input 		wire		[3:0]		A3_0,
	input			wire		[7:0]		RD_MAX_REG_Return_DATA,
	
	inout			wire		[15:0]	D15_00,
	
	output		reg		[15:0]	MAX_SPI_CLK_Freq_DATA,
	
	output		reg		[6:0]		WR_MAX_REG_ADDR,
	output		reg		[7:0]		WR_MAX_REG_DATA,
	output		wire					WR_MAX_REG_Trigger_CS,
	
	output		reg		[6:0]		RD_MAX_REG_DATA_ADDR,
	output		wire					RD_MAX_REG_Trigger_CS,
	
	output		wire					SPI_Module_Rst_n
);

//============================Define Parameter and Internal Signals===============//
	reg									WR_MAX_SPI_CLK_Freq_DATA_CS;
	reg									WR_MAX_REG_ADDR_CS;
	reg									WR_MAX_REG_DATA_CS;
	reg									RD_MAX_REG_DATA_ADDR_CS;
	reg									RD_MAX_REG_Return_DATA_CS;
	reg									MAX_SPI_Trigger_Ctrl_REG_CS;
	
	reg						[15:0]	MAX_SPI_Trigger_Ctrl_REG;
	reg						[15:0]	MAX_SPI_Trigger_Ctrl_REG_OUT;

	wire						[4:0]		MAX_SPI_REG_Control_CS_ADDR3_0 = {MAX_SPI_REG_Control_CS,A3_0};
	reg						[7:0]		RD_MAX_REG_Return_DATA_OUT_REG;
//================================================================================//
//=================================Main Code======================================//

//================================================================================//
always @ (MAX_SPI_REG_Control_CS_ADDR3_0) begin
	case(MAX_SPI_REG_Control_CS_ADDR3_0)
		5'B0_0000	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B0;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0001	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B0;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0010	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B0;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0011	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B0;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0100	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B0;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
		5'B0_0101	:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B0;
							end
		default		:	begin
								WR_MAX_SPI_CLK_Freq_DATA_CS = 1'B1;
								WR_MAX_REG_ADDR_CS = 1'B1;
								WR_MAX_REG_DATA_CS = 1'B1;
								RD_MAX_REG_DATA_ADDR_CS = 1'B1;
								RD_MAX_REG_Return_DATA_CS = 1'B1;
								MAX_SPI_Trigger_Ctrl_REG_CS = 1'B1;
							end
	endcase
end


//================================================================================//
//DSP or RAM Write MAX3601 MAX_SPI_CLK_Freq REG
always @(posedge XWE) begin
	if(WR_MAX_SPI_CLK_Freq_DATA_CS == 1'b0)
		begin
			MAX_SPI_CLK_Freq_DATA = D15_00;
		end
end


//================================================================================//
//DSP or RAM Write MAX3601 MAX_REG_ADDR wire
always @(posedge XWE) begin
	if(WR_MAX_REG_ADDR_CS == 1'b0)
		begin
			WR_MAX_REG_ADDR = D15_00[6:0];
		end
end


//================================================================================//
//DSP or RAM Write MAX3601 MAX_REG_DATA wire
always @(posedge XWE) begin
	if(WR_MAX_REG_DATA_CS == 1'b0)
		begin
			WR_MAX_REG_DATA = D15_00[7:0];
		end
end


//================================================================================//
//DSP or RAM Read MAX3601 REG(Write the read REG ADDR)
always @(posedge XWE) begin
	if(RD_MAX_REG_DATA_ADDR_CS == 1'b0)
		begin
			RD_MAX_REG_DATA_ADDR = D15_00[6:0];
		end
end

reg   [6:0]		RD_MAX_REG_DATA_ADDR_OUT_REG;

always @(RD_MAX_REG_DATA_ADDR_CS or XRD) begin
	if((XRD == 1'b0)&&(RD_MAX_REG_DATA_ADDR_CS == 1'b0))
		begin
			RD_MAX_REG_DATA_ADDR_OUT_REG = RD_MAX_REG_DATA_ADDR;
		end
end
assign D15_00 = ((XRD == 1'b0)&&(RD_MAX_REG_DATA_ADDR_CS == 1'b0)) ? {9'b0000_0000_0,RD_MAX_REG_DATA_ADDR_OUT_REG}:16'bz;

//DSP or RAM Read MAX3601 REG(Read the read REG DATA)
always @(RD_MAX_REG_Return_DATA_CS or XRD) begin
	if((XRD == 1'b0)&&(RD_MAX_REG_Return_DATA_CS == 1'b0))
		begin
			RD_MAX_REG_Return_DATA_OUT_REG = RD_MAX_REG_Return_DATA;
		end
end
assign D15_00 = ((XRD == 1'b0)&&(RD_MAX_REG_Return_DATA_CS == 1'b0)) ? {8'H00,RD_MAX_REG_Return_DATA_OUT_REG}:16'bz;


//================================================================================//
//DSP or RAM Write MAX3601 MAX_SPI_Trigger_Ctrl_REG
always @(posedge XWE) begin
	if(MAX_SPI_Trigger_Ctrl_REG_CS == 1'b0)
		begin
			MAX_SPI_Trigger_Ctrl_REG = D15_00[7:0];
		end
end
assign WR_MAX_REG_Trigger_CS = MAX_SPI_Trigger_Ctrl_REG[0];
assign RD_MAX_REG_Trigger_CS = MAX_SPI_Trigger_Ctrl_REG[1];
assign SPI_Module_Rst_n = MAX_SPI_Trigger_Ctrl_REG[2];
	
//DSP or RAM Read MAX3601 MAX_SPI_Trigger_Ctrl_REG
always@(XRD or MAX_SPI_Trigger_Ctrl_REG_CS)
begin
	if((XRD == 1'b0)&&(MAX_SPI_Trigger_Ctrl_REG_CS == 1'b0))
		begin
			MAX_SPI_Trigger_Ctrl_REG_OUT = MAX_SPI_Trigger_Ctrl_REG;	
		end
end
assign D15_00 = ((XRD == 1'b0)&&(MAX_SPI_Trigger_Ctrl_REG_CS == 1'b0)) ? MAX_SPI_Trigger_Ctrl_REG_OUT : 16'bz;
endmodule
//================================================================================//
//The end
//================================================================================//
