--------------------------------------------------------------------------------
-- Adapted from clk_div.vhd, the clock divider provided with the course by
-- Rami Abielmona. The original file is kept unchanged alongside this one as
-- clk_div.vhd. Three changes were made, and only three:
--
--   1. The entity is renamed so that both files can sit in the same project.
--   2. Every counter and every internal clock signal is given an initial
--      value. The original relies on the FPGA loading registers at
--      configuration time, which is true on the board but not in a simulator,
--      where the counters stay at U and no output ever moves.
--   3. The first stage divide ratio becomes the constant firstStage, so that
--      it can be shrunk for simulation as section 5.5 of the laboratory asks,
--      without editing the entity.
--
-- The original copyright notice below applies to the code itself.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Title         : Clock Divider Circuit
-- Project       : VHDL Example Programs
-------------------------------------------------------------------------------
-- File          : clk_div.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2004/10/07
-- Last modified : 2007/09/26
-------------------------------------------------------------------------------
-- Description : This file creates a clock divider circuit using a behavioral approach.
--		 		 The code is extracted from "Rapid Prototyping Of Digital Systems" 
--				 by James Hamblen et Michael Furman.
-------------------------------------------------------------------------------
-- Modification history :
-- 2004.10.07 	R. Abielmona		Creation
-- 2007.09.26 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY clockDivider IS

	PORT
	(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC;
		clock_100KHz				: OUT	STD_LOGIC;
		clock_10KHz				: OUT	STD_LOGIC;
		clock_1KHz				: OUT	STD_LOGIC;
		clock_100Hz				: OUT	STD_LOGIC;
		clock_10Hz				: OUT	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC);
	
END clockDivider;

ARCHITECTURE a OF clockDivider IS

	-- First stage divide ratio. 25 is the value in the provided file, which
	-- together with the six divide by ten stages below gives 25,000,000.
	-- Set it to 1 for simulation so that a tick arrives in microseconds
	-- instead of in a tenth of a second.
	CONSTANT firstStage : INTEGER := 100;  -- 100 for the board, 2 for simulation

	-- Each of the six stages below divides by two times (rippleTop + 1).
	-- 4 gives the divide by ten of the provided file. 0 gives divide by two,
	-- which shrinks the six stages from a million down to sixty four and
	-- makes a top level simulation finish in microseconds.
	CONSTANT rippleTop : INTEGER := 4;     -- 4 for the board, 0 for simulation

	SIGNAL	count_1Mhz: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"; 
	SIGNAL	count_100Khz, count_10Khz, count_1Khz : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL	count_100hz, count_10hz, count_1hz : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL  clock_1Mhz_int, clock_100Khz_int, clock_10Khz_int, clock_1Khz_int: STD_LOGIC := '0'; 
	SIGNAL	clock_100hz_int, clock_10Hz_int, clock_1Hz_int : STD_LOGIC := '0';
BEGIN
	PROCESS 
	BEGIN
-- Divide by 25
		WAIT UNTIL clock_25Mhz'EVENT and clock_25Mhz = '1';
			IF count_1Mhz < (firstStage - 1) THEN
				count_1Mhz <= count_1Mhz + 1;
			ELSE
				count_1Mhz <= "0000000";
			END IF;
			IF count_1Mhz < (firstStage / 2) THEN
				clock_1Mhz_int <= '0';
			ELSE
				clock_1Mhz_int <= '1';
			END IF;	

-- Ripple clocks are used in this code to save prescalar hardware
-- Sync all clock prescalar outputs back to master clock signal
			clock_1Mhz <= clock_1Mhz_int;
			clock_100Khz <= clock_100Khz_int;
			clock_10Khz <= clock_10Khz_int;
			clock_1Khz <= clock_1Khz_int;
			clock_100hz <= clock_100hz_int;
			clock_10hz <= clock_10hz_int;
			clock_1hz <= clock_1hz_int;
	END PROCESS;	

-- Divide by 10
	PROCESS 
	BEGIN
		WAIT UNTIL clock_1Mhz_int'EVENT and clock_1Mhz_int = '1';
			IF count_100Khz /= rippleTop THEN
				count_100Khz <= count_100Khz + 1;
			ELSE
				count_100khz <= "000";
				clock_100Khz_int <= NOT clock_100Khz_int;
			END IF;
	END PROCESS;	

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_100Khz_int'EVENT and clock_100Khz_int = '1';
			IF count_10Khz /= rippleTop THEN
				count_10Khz <= count_10Khz + 1;
			ELSE
				count_10khz <= "000";
				clock_10Khz_int <= NOT clock_10Khz_int;
			END IF;
	END PROCESS;	

-- Divide by 10
	PROCESS 
	BEGIN
		WAIT UNTIL clock_10Khz_int'EVENT and clock_10Khz_int = '1';
			IF count_1Khz /= rippleTop THEN
				count_1Khz <= count_1Khz + 1;
			ELSE
				count_1khz <= "000";
				clock_1Khz_int <= NOT clock_1Khz_int;
			END IF;
	END PROCESS;	

-- Divide by 10
	PROCESS 
	BEGIN
		WAIT UNTIL clock_1Khz_int'EVENT and clock_1Khz_int = '1';
			IF count_100hz /= rippleTop THEN
				count_100hz <= count_100hz + 1;
			ELSE
				count_100hz <= "000";
				clock_100hz_int <= NOT clock_100hz_int;
			END IF;
	END PROCESS;	

-- Divide by 10
	PROCESS 
	BEGIN
		WAIT UNTIL clock_100hz_int'EVENT and clock_100hz_int = '1';
			IF count_10hz /= rippleTop THEN
				count_10hz <= count_10hz + 1;
			ELSE
				count_10hz <= "000";
				clock_10hz_int <= NOT clock_10hz_int;
			END IF;
	END PROCESS;	

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_10hz_int'EVENT and clock_10hz_int = '1';
			IF count_1hz /= rippleTop THEN
				count_1hz <= count_1hz + 1;
			ELSE
				count_1hz <= "000";
				clock_1hz_int <= NOT clock_1hz_int;
			END IF;
	END PROCESS;	

END a;

