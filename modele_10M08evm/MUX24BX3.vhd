-- megafunction wizard: %LPM_MUX%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: lpm_mux 

-- ============================================================
-- File Name: MUX24BX3.vhd
-- Megafunction Name(s):
-- 			lpm_mux
--
-- Simulation Library Files(s):
-- 			lpm
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 9.1 Build 350 03/24/2010 SP 2 SJ Web Edition
-- ************************************************************


--Copyright (C) 1991-2010 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.lpm_components.all;

ENTITY MUX24BX3 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data0x		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		sel		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END MUX24BX3;


ARCHITECTURE SYN OF mux24bx3 IS

--	type STD_LOGIC_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (23 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (23 DOWNTO 0);
	SIGNAL sub_wire2	: STD_LOGIC_2D (2 DOWNTO 0, 23 DOWNTO 0);
	SIGNAL sub_wire3	: STD_LOGIC_VECTOR (23 DOWNTO 0);
	SIGNAL sub_wire4	: STD_LOGIC_VECTOR (23 DOWNTO 0);

BEGIN
	sub_wire4    <= data0x(23 DOWNTO 0);
	sub_wire3    <= data1x(23 DOWNTO 0);
	result    <= sub_wire0(23 DOWNTO 0);
	sub_wire1    <= data2x(23 DOWNTO 0);
	sub_wire2(2, 0)    <= sub_wire1(0);
	sub_wire2(2, 1)    <= sub_wire1(1);
	sub_wire2(2, 2)    <= sub_wire1(2);
	sub_wire2(2, 3)    <= sub_wire1(3);
	sub_wire2(2, 4)    <= sub_wire1(4);
	sub_wire2(2, 5)    <= sub_wire1(5);
	sub_wire2(2, 6)    <= sub_wire1(6);
	sub_wire2(2, 7)    <= sub_wire1(7);
	sub_wire2(2, 8)    <= sub_wire1(8);
	sub_wire2(2, 9)    <= sub_wire1(9);
	sub_wire2(2, 10)    <= sub_wire1(10);
	sub_wire2(2, 11)    <= sub_wire1(11);
	sub_wire2(2, 12)    <= sub_wire1(12);
	sub_wire2(2, 13)    <= sub_wire1(13);
	sub_wire2(2, 14)    <= sub_wire1(14);
	sub_wire2(2, 15)    <= sub_wire1(15);
	sub_wire2(2, 16)    <= sub_wire1(16);
	sub_wire2(2, 17)    <= sub_wire1(17);
	sub_wire2(2, 18)    <= sub_wire1(18);
	sub_wire2(2, 19)    <= sub_wire1(19);
	sub_wire2(2, 20)    <= sub_wire1(20);
	sub_wire2(2, 21)    <= sub_wire1(21);
	sub_wire2(2, 22)    <= sub_wire1(22);
	sub_wire2(2, 23)    <= sub_wire1(23);
	sub_wire2(1, 0)    <= sub_wire3(0);
	sub_wire2(1, 1)    <= sub_wire3(1);
	sub_wire2(1, 2)    <= sub_wire3(2);
	sub_wire2(1, 3)    <= sub_wire3(3);
	sub_wire2(1, 4)    <= sub_wire3(4);
	sub_wire2(1, 5)    <= sub_wire3(5);
	sub_wire2(1, 6)    <= sub_wire3(6);
	sub_wire2(1, 7)    <= sub_wire3(7);
	sub_wire2(1, 8)    <= sub_wire3(8);
	sub_wire2(1, 9)    <= sub_wire3(9);
	sub_wire2(1, 10)    <= sub_wire3(10);
	sub_wire2(1, 11)    <= sub_wire3(11);
	sub_wire2(1, 12)    <= sub_wire3(12);
	sub_wire2(1, 13)    <= sub_wire3(13);
	sub_wire2(1, 14)    <= sub_wire3(14);
	sub_wire2(1, 15)    <= sub_wire3(15);
	sub_wire2(1, 16)    <= sub_wire3(16);
	sub_wire2(1, 17)    <= sub_wire3(17);
	sub_wire2(1, 18)    <= sub_wire3(18);
	sub_wire2(1, 19)    <= sub_wire3(19);
	sub_wire2(1, 20)    <= sub_wire3(20);
	sub_wire2(1, 21)    <= sub_wire3(21);
	sub_wire2(1, 22)    <= sub_wire3(22);
	sub_wire2(1, 23)    <= sub_wire3(23);
	sub_wire2(0, 0)    <= sub_wire4(0);
	sub_wire2(0, 1)    <= sub_wire4(1);
	sub_wire2(0, 2)    <= sub_wire4(2);
	sub_wire2(0, 3)    <= sub_wire4(3);
	sub_wire2(0, 4)    <= sub_wire4(4);
	sub_wire2(0, 5)    <= sub_wire4(5);
	sub_wire2(0, 6)    <= sub_wire4(6);
	sub_wire2(0, 7)    <= sub_wire4(7);
	sub_wire2(0, 8)    <= sub_wire4(8);
	sub_wire2(0, 9)    <= sub_wire4(9);
	sub_wire2(0, 10)    <= sub_wire4(10);
	sub_wire2(0, 11)    <= sub_wire4(11);
	sub_wire2(0, 12)    <= sub_wire4(12);
	sub_wire2(0, 13)    <= sub_wire4(13);
	sub_wire2(0, 14)    <= sub_wire4(14);
	sub_wire2(0, 15)    <= sub_wire4(15);
	sub_wire2(0, 16)    <= sub_wire4(16);
	sub_wire2(0, 17)    <= sub_wire4(17);
	sub_wire2(0, 18)    <= sub_wire4(18);
	sub_wire2(0, 19)    <= sub_wire4(19);
	sub_wire2(0, 20)    <= sub_wire4(20);
	sub_wire2(0, 21)    <= sub_wire4(21);
	sub_wire2(0, 22)    <= sub_wire4(22);
	sub_wire2(0, 23)    <= sub_wire4(23);

	lpm_mux_component : lpm_mux
	GENERIC MAP (
		lpm_pipeline => 1,
		lpm_size => 3,
		lpm_type => "LPM_MUX",
		lpm_width => 24,
		lpm_widths => 2
	)
	PORT MAP (
		sel => sel,
		clock => clock,
		data => sub_wire2,
		result => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX II"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "1"
-- Retrieval info: CONSTANT: LPM_SIZE NUMERIC "3"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
-- Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "24"
-- Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "2"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
-- Retrieval info: USED_PORT: data0x 0 0 24 0 INPUT NODEFVAL data0x[23..0]
-- Retrieval info: USED_PORT: data1x 0 0 24 0 INPUT NODEFVAL data1x[23..0]
-- Retrieval info: USED_PORT: data2x 0 0 24 0 INPUT NODEFVAL data2x[23..0]
-- Retrieval info: USED_PORT: result 0 0 24 0 OUTPUT NODEFVAL result[23..0]
-- Retrieval info: USED_PORT: sel 0 0 2 0 INPUT NODEFVAL sel[1..0]
-- Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: result 0 0 24 0 @result 0 0 24 0
-- Retrieval info: CONNECT: @data 1 2 24 0 data2x 0 0 24 0
-- Retrieval info: CONNECT: @data 1 1 24 0 data1x 0 0 24 0
-- Retrieval info: CONNECT: @data 1 0 24 0 data0x 0 0 24 0
-- Retrieval info: CONNECT: @sel 0 0 2 0 sel 0 0 2 0
-- Retrieval info: LIBRARY: lpm lpm.lpm_components.all
-- Retrieval info: GEN_FILE: TYPE_NORMAL MUX24BX3.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL MUX24BX3.inc TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL MUX24BX3.cmp FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL MUX24BX3.bsf TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL MUX24BX3_inst.vhd FALSE
-- Retrieval info: LIB_FILE: lpm