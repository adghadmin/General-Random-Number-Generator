/* Verilog model created from schematic MAX3601_Lattice_Project_SCH.sch -- Feb 28, 2019 15:03 */

module MAX3601_Lattice_Project_SCH( ARM_SPI_CLK, ARM_SPI_CS, ARM_SPI_MISO, ARM_SPI_MOSI,
                                    clk_in, EN_MAIN, MARK, MAX_SPI_CLK,
                                    MAX_SPI_CS, MAX_SPI_DIO, MAX_VIDEO_DATA,
                                    MAX_VIDEO_DCLK, MAX_VIDEO_MEMES_CLK );
 input ARM_SPI_CLK;
 input ARM_SPI_CS;
 inout ARM_SPI_MISO;
 input ARM_SPI_MOSI;
 input clk_in;
output EN_MAIN;
output MARK;
output MAX_SPI_CLK;
output MAX_SPI_CS;
output MAX_SPI_DIO;
output [0:11] MAX_VIDEO_DATA;
output MAX_VIDEO_DCLK;
output MAX_VIDEO_MEMES_CLK;
  wire [15:0] data_bus;
  wire [15:0] ARM_RD_FPGA_ADDR;
  wire [15:0] ARM_WR_FPGA_DATA;
  wire [15:0] ARM_RD_FPGA_DATA;
  wire [7:0] RD_MAX_REG_DATA_Return;
  wire [15:0] MAX_SPI_CLK_Freq_DATA;
  wire [6:0] WR_MAX_REG_ADDR;
  wire [7:0] WR_MAX_REG_DATA;
  wire [6:0] RD_MAX_REG_DATA_ADDR;
  wire [15:0] WR_MAX_VIDEO_MEMS_CLK_Freq_DATA;
  wire [15:0] A15_0;
  wire [11:0] MAX_VIDEO_DATA_NORMAL;
  wire [11:0] MAX_VIDEO_DATA_TEST;
  wire [9:0] RD_MAX_VIDEO_DATA_T_ADDR;
  wire [9:0] RD_MAX_VIDEO_DATA_P_ADDR;
  wire [15:0] MAX_VIDEO_Stripe_Number;
  wire [15:0] MAX_VIDEO_MEMS_CLK_Dealy_Time;
  wire [15:0] WR_MAX_VIDEO_DATA_T_DATA;
  wire [9:0] WR_MAX_VIDEO_DATA_T_ADDR;
  wire [9:0] WR_MAX_VIDEO_DATA_P_ADDR;
  wire [15:0] WR_MAX_VIDEO_DATA_P_DATA;
  wire [15:0] RD_MAX_VIDEO_DATA_P_DATA;
  wire [15:0] RD_MAX_VIDEO_DATA_T_DATA;
  wire [15:0] ARM_WR_FPGA_ADDR;
wire N_86;
wire N_83;
wire N_84;
wire N_85;
wire N_82;
wire N_81;
wire N_80;
wire N_78;
wire N_77;
wire N_76;
wire N_74;
wire N_75;
wire N_73;
wire N_68;
wire N_62;
wire N_61;
wire N_58;
wire N_59;
wire N_52;
wire N_47;
wire N_48;
wire N_49;
wire N_20;
wire N_26;
wire N_29;
wire N_31;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_39;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire XRD;
wire XWE;
wire MAX_VIDEO_TEST_Module_CS;
wire MAX_VIDEO_DPRAM_P_Control_CS;
wire MAX_VIDEO_DPRAM_T_Control_CS;
wire MAX_VIDEO_MEMS_DCLK_Control_CS;
wire MAX_SPI_REG_Control_CS;
wire sys_clk_100M;
wire N_1;
wire N_3;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;



PoweON_ResetFPGA I39 ( .clk_100M(sys_clk_100M), .reset_FPGA(N_86) );
DPRAM_P I31 ( .Data(WR_MAX_VIDEO_DATA_P_DATA[15:0]),
           .Q(RD_MAX_VIDEO_DATA_P_DATA[15:0]),
           .RdAddress(RD_MAX_VIDEO_DATA_P_ADDR[9:0]),
           .RdClock(sys_clk_100M), .RdClockEn(N_76), .Reset(N_83), .WE(N_58),
           .WrAddress(WR_MAX_VIDEO_DATA_P_ADDR[9:0]),
           .WrClock(sys_clk_100M), .WrClockEn(N_76) );
DPRAM_T I32 ( .Data(WR_MAX_VIDEO_DATA_T_DATA[15:0]),
           .Q(RD_MAX_VIDEO_DATA_T_DATA[15:0]),
           .RdAddress(RD_MAX_VIDEO_DATA_T_ADDR[9:0]),
           .RdClock(sys_clk_100M), .RdClockEn(N_74), .Reset(N_85), .WE(N_59),
           .WrAddress(WR_MAX_VIDEO_DATA_T_ADDR[9:0]),
           .WrClock(sys_clk_100M), .WrClockEn(N_74) );
PLL_100MHz I30 ( .CLKI(clk_in), .CLKOP(sys_clk_100M) );
INV I40 ( .A(N_84), .Z(N_83) );
INV I41 ( .A(N_75), .Z(N_85) );
INV I27 ( .A(XWE), .Z(N_49) );
INV I28 ( .A(MAX_VIDEO_TEST_Module_CS), .Z(N_48) );
VHI I36 ( .Z(N_76) );
VHI I35 ( .Z(N_74) );
VHI I33 ( .Z(EN_MAIN) );
VHI I34 ( .Z(MARK) );
AND2 I29 ( .A(N_49), .B(N_48), .Z(N_47) );
FPGA_VIDEO_DCLK_SELECT_Module I25 ( .MAX_TEST_OR_NORMAL_SEL(N_31),
                                 .MAX_VIDEO_DATA({ MAX_VIDEO_DATA[11],MAX_VIDEO_DATA[10],MAX_VIDEO_DATA[9],MAX_VIDEO_DATA[8],MAX_VIDEO_DATA[7],MAX_VIDEO_DATA[6],MAX_VIDEO_DATA[5],MAX_VIDEO_DATA[4],MAX_VIDEO_DATA[3],MAX_VIDEO_DATA[2],MAX_VIDEO_DATA[1],MAX_VIDEO_DATA[0] }),
                                 .MAX_VIDEO_DATA_NORMAL(MAX_VIDEO_DATA_NORMAL[11:0]),
                                 .MAX_VIDEO_DATA_TEST(MAX_VIDEO_DATA_TEST[11:0]),
                                 .MAX_VIDEO_DCLK(MAX_VIDEO_DCLK),
                                 .MAX_VIDEO_DCLK_NORMAL(N_61),
                                 .MAX_VIDEO_DCLK_TEST(N_62) );
FPGA_VIDEO_DATA_Send_Control_Module I26 ( .MAX_VIDEO_DATA(MAX_VIDEO_DATA_NORMAL[11:0]),
                                       .MAX_VIDEO_DATA_Send_Control_Module_Rst_n(N_36),
                                       .MAX_VIDEO_DATA_Send_Trigger(N_34),
                                       .MAX_VIDEO_DCLK(N_61),
                                       .MAX_VIDEO_MEMS_CLK(N_77),
                                       .MAX_VIDEO_MEMS_CLK_Dealy_Time(MAX_VIDEO_MEMS_CLK_Dealy_Time[15:0]),
                                       .MAX_VIDEO_MEMS_CLK_Dealy_Time_CS(N_26),
                                       .MAX_VIDEO_MEMS_CLK_Dealy_Time_Flag(N_68),
                                       .MAX_VIDEO_MEMS_DCLK_Trigger(N_73),
                                       .MAX_VIDEO_Stripe_Number(MAX_VIDEO_Stripe_Number[15:0]),
                                       .RD_MAX_VIDEO_DATA_P_ADDR(RD_MAX_VIDEO_DATA_P_ADDR[9:0]),
                                       .RD_MAX_VIDEO_DATA_P_DATA(RD_MAX_VIDEO_DATA_P_DATA[15:0]),
                                       .RD_MAX_VIDEO_DATA_T_ADDR(RD_MAX_VIDEO_DATA_T_ADDR[9:0]),
                                       .RD_MAX_VIDEO_DATA_T_DATA(RD_MAX_VIDEO_DATA_T_DATA[15:0]),
                                       .sys_clk_100MHz(sys_clk_100M) );
ffd I24 ( .clk_100M(sys_clk_100M), .DATA_IN(N_77), .DATA_OUT(N_39) );
ffd I23 ( .clk_100M(sys_clk_100M), .DATA_IN(N_39), .DATA_OUT(N_37) );
ffd I22 ( .clk_100M(sys_clk_100M), .DATA_IN(N_37),
       .DATA_OUT(MAX_VIDEO_MEMES_CLK) );
FPGA_VIDEO_MEMS_CLK_Genernator_Module I21 ( .MAX_VIDEO_MEMS_CLK(N_77),
                                         .MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n(N_82),
                                         .sys_clk_100MHz(sys_clk_100M),
                                         .WR_MAX_VIDEO_MEMS_CLK_Flag(N_35),
                                         .WR_MAX_VIDEO_MEMS_CLK_Freq_DATA(WR_MAX_VIDEO_MEMS_CLK_Freq_DATA[15:0]) );
one_short I17 ( .clk_100M(sys_clk_100M), .data_in(N_77), .data_out(N_73) );
one_short I19 ( .clk_100M(sys_clk_100M), .data_in(N_52), .data_out(N_59) );
one_short I18 ( .clk_100M(sys_clk_100M), .data_in(N_20), .data_out(N_58) );
one_short I14 ( .clk_100M(sys_clk_100M), .data_in(N_47), .data_out(N_62) );
one_short I11 ( .clk_100M(sys_clk_100M), .data_in(N_45), .data_out(N_44) );
one_short I12 ( .clk_100M(sys_clk_100M), .data_in(N_43), .data_out(N_42) );
FPGA_SPI_Module I10 ( .MAX_SPI_CLK(MAX_SPI_CLK),
                   .MAX_SPI_CLK_Freq_DATA(MAX_SPI_CLK_Freq_DATA[15:0]),
                   .MAX_SPI_CS(MAX_SPI_CS), .MAX_SPI_DIO(MAX_SPI_DIO),
                   .RD_MAX_REG_DATA_ADDR(RD_MAX_REG_DATA_ADDR[6:0]),
                   .RD_MAX_REG_DATA_Return(RD_MAX_REG_DATA_Return[7:0]),
                   .RD_MAX_REG_Trigger(N_42), .SPI_Module_Rst_n(N_41),
                   .sys_clk_100MHz(sys_clk_100M),
                   .WR_MAX_REG_ADDR(WR_MAX_REG_ADDR[6:0]),
                   .WR_MAX_REG_DATA(WR_MAX_REG_DATA[7:0]),
                   .WR_MAX_REG_Trigger(N_44) );
FPGA_VIDEO_TEST_Module I5 ( .D15_00(data_bus[15:0]),
                         .MAX_VIDEO_DATA_TEST(MAX_VIDEO_DATA_TEST[11:0]),
                         .MAX_VIDEO_TEST_Module_CS(MAX_VIDEO_TEST_Module_CS),
                         .sys_clk_100MHz(sys_clk_100M), .XWE(XWE) );
FPGA_VIDEO_DPRAM_P_Control_Module I6 ( .A16(A15_0[9]), .A8_0(A15_0[8:0]),
                                    .D15_00(data_bus[15:0]),
                                    .MAX_VIDEO_DPRAM_P_Control_CS(MAX_VIDEO_DPRAM_P_Control_CS),
                                    .WR_MAX_VIDEO_DATA_P_ADDR(WR_MAX_VIDEO_DATA_P_ADDR[9:0]),
                                    .WR_MAX_VIDEO_DATA_P_DATA(WR_MAX_VIDEO_DATA_P_DATA[15:0]),
                                    .WR_MAX_VIDEO_DATA_P_EN(N_20),
                                    .XWE(XWE) );
FPGA_VIDEO_DPRAM_T_Control_Module I7 ( .A16(A15_0[9]), .A8_0(A15_0[8:0]),
                                    .D15_00(data_bus[15:0]),
                                    .MAX_VIDEO_DPRAM_T_Control_CS(MAX_VIDEO_DPRAM_T_Control_CS),
                                    .WR_MAX_VIDEO_DATA_T_ADDR(WR_MAX_VIDEO_DATA_T_ADDR[9:0]),
                                    .WR_MAX_VIDEO_DATA_T_DATA(WR_MAX_VIDEO_DATA_T_DATA[15:0]),
                                    .WR_MAX_VIDEO_DATA_T_EN(N_52),
                                    .XWE(XWE) );
FPGA_VIDEO_MEMS_CLK_Control_Module I8 ( .A3_0(A15_0[3:0]),
                                     .D15_00(data_bus[15:0]),
                                     .MAX_DATA_SEND_RD_EN(N_29),
                                     .MAX_DPRAM_P_Rst_n(N_84),
                                     .MAX_DPRAM_T_Rst_n(N_75),
                                     .MAX_TEST_OR_NORMAL_SEL(N_31),
                                     .MAX_VIDEO_DATA_Send_Control_Module_Rst_n(N_34),
                                     .MAX_VIDEO_DATA_Send_Trigger(N_36),
                                     .MAX_VIDEO_MEMS_CLK_Control_CS(MAX_VIDEO_MEMS_DCLK_Control_CS),
                                     .MAX_VIDEO_MEMS_CLK_Dealy_Time(MAX_VIDEO_MEMS_CLK_Dealy_Time[15:0]),
                                     .MAX_VIDEO_MEMS_CLK_Dealy_Time_CS(N_26),
                                     .MAX_VIDEO_MEMS_CLK_Dealy_Time_Flag(N_68),
                                     .MAX_VIDEO_MEMS_CLK_Generator_Module_Rst_n(N_82),
                                     .MAX_VIDEO_Stripe_Number(MAX_VIDEO_Stripe_Number[15:0]),
                                     .WR_MAX_VIDEO_MEMS_CLK_Flag(N_35),
                                     .WR_MAX_VIDEO_MEMS_CLK_Freq_DATA(WR_MAX_VIDEO_MEMS_CLK_Freq_DATA[15:0]),
                                     .XRD(XRD), .XWE(XWE) );
FPGA_SPI_REG_Control_Module I9 ( .A3_0(A15_0[3:0]), .D15_00(data_bus[15:0]),
                              .MAX_SPI_CLK_Freq_DATA(MAX_SPI_CLK_Freq_DATA[15:0]),
                              .MAX_SPI_REG_Control_CS(MAX_SPI_REG_Control_CS),
                              .RD_MAX_REG_DATA_ADDR(RD_MAX_REG_DATA_ADDR[6:0]),
                              .RD_MAX_REG_Return_DATA(RD_MAX_REG_DATA_Return[7:0]),
                              .RD_MAX_REG_Trigger_CS(N_43),
                              .SPI_Module_Rst_n(N_41),
                              .WR_MAX_REG_ADDR(WR_MAX_REG_ADDR[6:0]),
                              .WR_MAX_REG_DATA(WR_MAX_REG_DATA[7:0]),
                              .WR_MAX_REG_Trigger_CS(N_45), .XRD(XRD),
                              .XWE(XWE) );
ARM_and_FPGA_SPI_WR_and_RD_SELECT_Module I3 ( .ARM_RD_FPGA_ADDR(ARM_RD_FPGA_ADDR[15:0]),
                                           .ARM_RD_MAX_SPI_REG_Control_CS(N_9),
                                           .ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS(N_6),
                                           .ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS(N_7),
                                           .ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS(N_8),
                                           .ARM_RD_MAX_VIDEO_TEST_Module_CS(N_5),
                                           .ARM_WR_and_RD_SELECT_Wire(N_78),
                                           .ARM_WR_FPGA_ADDR(ARM_WR_FPGA_ADDR[15:0]),
                                           .ARM_WR_MAX_SPI_REG_Control_CS(N_3),
                                           .ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS(N_11),
                                           .ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS(N_12),
                                           .ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS(N_1),
                                           .ARM_WR_MAX_VIDEO_TEST_Module_CS(N_10),
                                           .FPGA_ADDR_BUS(A15_0[15:0]),
                                           .MAX_SPI_REG_Control_CS(MAX_SPI_REG_Control_CS),
                                           .MAX_VIDEO_DPRAM_P_Control_CS(MAX_VIDEO_DPRAM_P_Control_CS),
                                           .MAX_VIDEO_DPRAM_T_Control_CS(MAX_VIDEO_DPRAM_T_Control_CS),
                                           .MAX_VIDEO_MEMS_DCLK_Control_CS(MAX_VIDEO_MEMS_DCLK_Control_CS),
                                           .MAX_VIDEO_TEST_Module_CS(MAX_VIDEO_TEST_Module_CS) );
ARM_and_FPGA_SPI_RD_DATA_Module I4 ( .ARM_RD_FPGA_ADDR(ARM_RD_FPGA_ADDR[15:0]),
                                  .ARM_RD_FPGA_DATA(ARM_RD_FPGA_DATA[15:0]),
                                  .ARM_RD_FPGA_REG_XRD(XRD),
                                  .ARM_RD_FPGA_Trigger(N_81),
                                  .ARM_RD_MAX_SPI_REG_Control_CS(N_9),
                                  .ARM_RD_MAX_VIDEO_DPRAM_P_Control_CS(N_6),
                                  .ARM_RD_MAX_VIDEO_DPRAM_T_Control_CS(N_7),
                                  .ARM_RD_MAX_VIDEO_MEMS_DCLK_Control_CS(N_8),
                                  .ARM_RD_MAX_VIDEO_TEST_Module_CS(N_5),
                                  .D15_00(data_bus[15:0]),
                                  .sys_clk_100M(sys_clk_100M) );
ARM_and_FPGA_SPI_WR_DATA_Module I2 ( .ARM_WR_FPGA_ADDR(ARM_WR_FPGA_ADDR[15:0]),
                                  .ARM_WR_FPGA_DATA(ARM_WR_FPGA_DATA[15:0]),
                                  .ARM_WR_FPGA_DATA_OUT(data_bus[15:0]),
                                  .ARM_WR_FPGA_REG_XWE(XWE),
                                  .ARM_WR_FPGA_Trigger(N_80),
                                  .ARM_WR_MAX_SPI_REG_Control_CS(N_3),
                                  .ARM_WR_MAX_VIDEO_DPRAM_P_Control_CS(N_11),
                                  .ARM_WR_MAX_VIDEO_DPRAM_T_Control_CS(N_12),
                                  .ARM_WR_MAX_VIDEO_MEMS_DCLK_Control_CS(N_1),
                                  .ARM_WR_MAX_VIDEO_TEST_Module_CS(N_10),
                                  .sys_clk_100M(sys_clk_100M) );
ARM_and_FPGA_SPI_Ctrl_Module I38 ( .ARM_and_FPGA_SPI_Ctrl_Module_Rst_n(N_86),
                                .ARM_RD_FPGA_ADDR(ARM_RD_FPGA_ADDR[15:0]),
                                .ARM_RD_FPGA_DATA(ARM_RD_FPGA_DATA[15:0]),
                                .ARM_RD_FPGA_Trigger(N_81),
                                .ARM_SPI_CLK(ARM_SPI_CLK),
                                .ARM_SPI_CS(ARM_SPI_CS),
                                .ARM_SPI_MISO(ARM_SPI_MISO),
                                .ARM_SPI_MOSI(ARM_SPI_MOSI),
                                .ARM_WR_and_RD_SELECT_Wire(N_78),
                                .ARM_WR_FPGA_ADDR(ARM_WR_FPGA_ADDR[15:0]),
                                .ARM_WR_FPGA_DATA(ARM_WR_FPGA_DATA[15:0]),
                                .ARM_WR_FPGA_Trigger(N_80),
                                .sys_clk_100M(sys_clk_100M) );

endmodule // MAX3601_Lattice_Project_SCH
