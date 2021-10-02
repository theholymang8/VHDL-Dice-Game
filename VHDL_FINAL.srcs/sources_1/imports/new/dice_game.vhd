----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2021 18:04:12
-- Design Name: 
-- Module Name: dice_game - Behavioral
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

entity dice_game is
  Port (
        roll, newgame, clk  :  in std_logic;
        win, lose  :  out std_logic;
        dice  :  out unsigned(5 downto 0);
        state  :  out std_logic_vector (3 downto 0)
         );
end dice_game;

architecture Structural of dice_game is
signal roll_enable, div_clk : std_logic;
signal tsum  :  unsigned (3 downto 0);
signal dice1, dice2  :  unsigned (2 downto 0);
signal tstate  :  std_logic_vector(3 downto 0);
begin
dice_and_sum: entity work.dice_lfsr(Behavioral)
    port map(div_clk, newgame, roll_enable, dice1, dice2, tsum);
    
clock_div: entity work.freq_div(Behavioral)
    port map(clk, div_clk);    

FSM: entity work.dice_FSM(Behavioral)
    port map(roll, newgame, clk, tsum, roll_enable, win, lose, tstate);
    
dice <= ("00"&tsum) when tstate = "1001" else
        ("00"&tsum) when tstate = "1010" else
        ("00"&tsum) when tstate = "0101" else
        "000000" when tstate = "0001" else
        dice2&dice1;
        
state <= tstate;        
          
end Structural;
