//=================================Module Information=============================//
//Project Name		:	
//Author				:	Wang Fei
//Email				:	wangfei1194938231@126.com
//Creat Time		:	2019/01/15
//Module Name		:	ARM_and_FPGA_SPI_RD_DATA_Module
//Module Function	:
//Called By			:	
//Abstract			:	
//================================================================================//

//==================================Modification History==========================//
//Num.001			:	2019.01.15,Initial,Module Definition
//================================================================================//
module ARM_and_FPGA_SPI_RD_DATA_Module(

	//input signals
	input			wire		[15:0]	ARM_RD_FPGA_ADDR,
	input			wire					ARM_RD_FPGA_Trigger,
	input			wire					sys_clk_100M,
	inout			wire		[15:0]	D15_00,
	
	//output signals
	output		reg					ARM_RD_MAX_SPI_REG_Control_CS,
	output		reg					ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS,
	output		reg					ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS,
	output		reg					ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS,
	output		reg					ARM_RD_MAX_VIDEO_TEST_Module_CS,
	
	output		reg		[15:0]	ARM_RD_FPGA_DATA,
	output		reg					ARM_RD_FPGA_REG_XRD
		
);

//============================Define Parameter and Internal Signals===============//
	reg						[4:0]		WIDTH_OF_XRD  				  	=  	5'D20	;//The default DSP's signal——XRD  active time is 200ns;
	reg						[2:0]		C_State_Generate_XRD 		=		3'D0	;//The default state of producing the singal of XRD is 5'D0;
	
	wire						[3:0]		wire_A14_11 					= 		ARM_RD_FPGA_ADDR[14:11];//Assign tasks based on the encoding of Address[14:11]
	reg						[4:0]		cnt_WIDTH_XRD					= 		5'D0;
//================================================================================//


//===============================Main Code========================================//
//Produce different CS signals
always @(wire_A14_11)
begin
	case(wire_A14_11)
		4'B0000		:	begin//The Address[14:11] default data is 16'D0; Don't choose any signal.
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0001		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b0;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0010		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b0;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0011		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b0;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0100		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b0;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
		4'B0101		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b0;
							end
		default		:	begin
								ARM_RD_MAX_SPI_REG_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS = 1'b1;
								ARM_RD_MAX_VIDEO_TEST_Module_CS = 1'b1;
							end
	endcase	
end


//Produce the XRD signal according the ARM_RD_FPGA_Trigger signal
always @(posedge sys_clk_100M)
begin
	case(C_State_Generate_XRD)
		3'B000		:	begin
								if(ARM_RD_FPGA_Trigger == 1'b1)
									begin
										C_State_Generate_XRD 	<= 3'B001;
										ARM_RD_FPGA_REG_XRD		<= 1'b1;
										cnt_WIDTH_XRD 				<= 5'D0;
										
									end
								else
									begin
										C_State_Generate_XRD 	<= 3'B000;
										ARM_RD_FPGA_REG_XRD		<= 1'b1;
										cnt_WIDTH_XRD 				<= 5'D0;
									end
							end
		3'B001		:	begin
								if(cnt_WIDTH_XRD == 10)
									begin
										C_State_Generate_XRD 	<= 3'B010;
										ARM_RD_FPGA_REG_XRD		<= 1'b0;
										cnt_WIDTH_XRD 				<= 5'D0;
									end
								else
									begin
										cnt_WIDTH_XRD <= cnt_WIDTH_XRD + 1'b1;
									end
							end
		3'B010		:	begin
								if(cnt_WIDTH_XRD == 20)
									begin
										C_State_Generate_XRD 	<= 3'B011;
										ARM_RD_FPGA_REG_XRD		<= 1'b1;
										cnt_WIDTH_XRD 				<= 5'D0;
									end
								else
									begin
										cnt_WIDTH_XRD <= cnt_WIDTH_XRD + 1'b1;
									end
							end
		
		3'B011		:	begin
								if(cnt_WIDTH_XRD == 10)
									begin
										C_State_Generate_XRD 	<= 3'B100;
										ARM_RD_FPGA_REG_XRD		<= 1'b1;
										cnt_WIDTH_XRD 				<= 5'D0;
									end
								else
									begin
										cnt_WIDTH_XRD <= cnt_WIDTH_XRD + 1'b1;
									end
							end
		3'B100		:	begin
									C_State_Generate_XRD 	<= 3'B000;
									ARM_RD_FPGA_REG_XRD		<= 1'b1;
									cnt_WIDTH_XRD 				<= 5'D0;
							end
		default		:	begin
								C_State_Generate_XRD 	<= 3'B000;
								ARM_RD_FPGA_REG_XRD		<= 1'b1;
								cnt_WIDTH_XRD 				<= 5'D0;
							end
	endcase
end


//With the rising edge of ARM_RD_FPGA_REG_XRD, place the ARM_RD_FPGA_ADDR'data on the output signal of ARM_RD_FPGA_DATA.
always @(posedge ARM_RD_FPGA_REG_XRD)
//if(ARM_RD_FPGA_REG_XRD == 0)
begin
	ARM_RD_FPGA_DATA <= D15_00;
end

//================================================================================//
//The end//=======================================================================//
endmodule