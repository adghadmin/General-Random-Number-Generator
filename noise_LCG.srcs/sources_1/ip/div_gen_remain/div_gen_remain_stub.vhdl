-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Mon Sep 27 23:18:40 2021
-- Host        : LAPTOP-H3OQ0T62 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               f:/1.work_user/1.noise_gen/noise_LCG/noise_LCG.srcs/sources_1/ip/div_gen_remain/div_gen_remain_stub.vhdl
-- Design      : div_gen_remain
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku085-flva1517-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_gen_remain is
  Port ( 
    aclk : in STD_LOGIC;
    s_axis_divisor_tvalid : in STD_LOGIC;
    s_axis_divisor_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_dividend_tvalid : in STD_LOGIC;
    s_axis_dividend_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axis_dout_tvalid : out STD_LOGIC;
    m_axis_dout_tdata : out STD_LOGIC_VECTOR ( 95 downto 0 )
  );

end div_gen_remain;

architecture stub of div_gen_remain is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,s_axis_divisor_tvalid,s_axis_divisor_tdata[31:0],s_axis_dividend_tvalid,s_axis_dividend_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tdata[95:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "div_gen_v5_1_12,Vivado 2017.4";
begin
end;
