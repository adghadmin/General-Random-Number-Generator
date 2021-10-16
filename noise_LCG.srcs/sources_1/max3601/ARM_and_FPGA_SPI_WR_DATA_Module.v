//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2019/01/15
//Module Name		:	ARM_and_FPGA_SPI_WR_DATA_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2019.01.15,Initial,Module Definition
//================================================================================//
module ARM_and_FPGA_SPI_WR_DATA_Module(

	//input signals
	input			wire					sys_clk_100M,
	input			wire		[15:0]	ARM_WR_FPGA_ADDR,
	input			wire		[15:0]	ARM_WR_FPGA_DATA,
	input			wire					ARM_WR_FPGA_Trigger,
	
	//output signals
	output		reg					ARM_WR_FPGA_REG_XWE,
	inout			wire		[15:0]	ARM_WR_FPGA_DATA_OUT,
	
	output		reg					ARM_WR_MAX_SPI_REG_Control_CS,
	output		reg					ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS,
	output		reg					ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS,
	output		reg					ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS,
	output		reg					ARM_WR_MAX_VIDEO_TEST_Module_CS
	
);

//============================Define Parameter and Internal Signals===============//
	reg						[4:0]		WIDTH_OF_XWE  				  	=  	20;//The default DSP's signal——XRD  active time is 200ns;
	reg						[2:0]		C_State_Generate_XWE 		=		3'B000;//The default state of producing the singal of XRD is 5'D0;
	
	wire						[3:0]		wire_A14_11 					= 		ARM_WR_FPGA_ADDR[14:11];//Assign tasks based on the encoding of Address[14:11]
	reg						[4:0]		cnt_WIDTH_XWE					= 		0;
//================================================================================//


//===============================Main Code========================================//
//Produce different CS signals
always @(wire_A14_11)
begin
	case(wire_A14_11)
		4'B0000		:	begin//The Address[14:11] default data is 16'D0; Don't choose any signal.
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0001		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b0;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0010		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b0;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0011		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b0;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0100		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b0;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0101		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b0;
							end
		default		:	begin
								ARM_WR_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_WR_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
	endcase	
end

reg		data_valid_flag;
//Produce the XWE signal according the ARM_WR_FPGA_Trigger signal
always @(posedge sys_clk_100M)
begin
	case(C_State_Generate_XWE)
		3'B000		:	begin
								if(ARM_WR_FPGA_Trigger == 1'b1)
									begin
										C_State_Generate_XWE 	<= 3'B001;
										ARM_WR_FPGA_REG_XWE		<= 1'b1;
										cnt_WIDTH_XWE 				<= 5'D0;
										data_valid_flag			<= 1'B0;
									end
								else
									begin
										C_State_Generate_XWE 	<= 3'B000;
										ARM_WR_FPGA_REG_XWE		<= 1'b1;
										cnt_WIDTH_XWE 				<= 5'D0;
										data_valid_flag			<= 1'B1;
									end
							end
		3'B001		:	begin
								if(cnt_WIDTH_XWE == 10)
									begin
										C_State_Generate_XWE 	<= 3'B010;
										ARM_WR_FPGA_REG_XWE		<= 1'b0;
										cnt_WIDTH_XWE 				<= 5'D0;
									end
								else
									begin
										cnt_WIDTH_XWE <= cnt_WIDTH_XWE + 1'b1;
									end
							end
		3'B010		:	begin
								if(cnt_WIDTH_XWE == 20)
									begin
										C_State_Generate_XWE 	<= 3'B011;
										ARM_WR_FPGA_REG_XWE		<= 1'b1;
										cnt_WIDTH_XWE 				<= 5'D0;
									end
								else
									begin
										cnt_WIDTH_XWE <= cnt_WIDTH_XWE + 1'b1;
									end
							end
		3'B011		:	begin
								if(cnt_WIDTH_XWE == 10)
									begin
										C_State_Generate_XWE 	<= 3'B100;
										ARM_WR_FPGA_REG_XWE		<= 1'b1;
										cnt_WIDTH_XWE 				<= 5'D0;
										data_valid_flag			<= 1'B1;
									end
								else
									begin
										cnt_WIDTH_XWE <= cnt_WIDTH_XWE + 1'b1;
									end
							end
							
		3'b100	:	begin
								C_State_Generate_XWE 	<= 3'B000;
								ARM_WR_FPGA_REG_XWE		<= 1'b1;
								cnt_WIDTH_XWE 				<= 5'D0;
								data_valid_flag			<= 1'B1;
							end
		default		:	begin
								C_State_Generate_XWE 	<= 3'B000;
								ARM_WR_FPGA_REG_XWE		<= 1'b1;
								cnt_WIDTH_XWE 				<= 5'D0;
								data_valid_flag			<= 1'B1;
							end
	endcase
end


//With the falling edge of ARM_WR_FPGA_REG_XWE, place the ARM_WR_FPGA_DATA'data on the output signal of ARM_WR_FPGA_DATA_OUT.
/*
always @(negedge ARM_WR_FPGA_REG_XWE)
begin
	ARM_WR_FPGA_DATA_OUT <= ARM_WR_FPGA_DATA;
end
*/
//================================================================================//


assign ARM_WR_FPGA_DATA_OUT = (data_valid_flag == 1'b0) ? ARM_WR_FPGA_DATA : 16'bz;
//The end//=======================================================================//
endmodule