----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.07.2021 13:47:28
-- Design Name: 
-- Module Name: dice_lfsr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dice_lfsr is
Port ( clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       dice1, dice2 : out unsigned (2 downto 0);
       sum : out unsigned(3 downto 0)
       );

end dice_lfsr;

architecture Behavioral of dice_lfsr is

     signal Currstate, Nextstate, Q: unsigned (7 DOWNTO 0);
     signal feedback: std_logic;
     signal tdice1, tdice2, pdice1, pdice2 :  unsigned (2 downto 0);

begin

StateReg: process (clock,reset)
begin
if (reset = '1') then
  Currstate <= (0 => '1', others =>'0');
elsif clock = '1' and clock'event then
    if en = '1' then
        Currstate <= Nextstate;
    end if;    
end if;
end process;


feedback <= Currstate(4) xor Currstate(3) xor Currstate(2) xor Currstate(0);
Nextstate <= feedback & Currstate(7 downto 1);
Q <= Currstate;
tdice1<=Q(5)&(Q(2) xor Q(6))&Q(0);
tdice2<=Q(6)&(Q(4)xor Q(7))&Q(1);


pdice1<="001" when (tdice1="000") else
       "110" when (tdice1="111") else 
       tdice1;
 

pdice2<="001" when (tdice2="000") else
       "110" when (tdice2="111") else 
       tdice2;

dice1 <= pdice1; 
dice2 <= pdice2;

sum <= ('0'&pdice1) +  ('0'&pdice2);

end Behavioral;
