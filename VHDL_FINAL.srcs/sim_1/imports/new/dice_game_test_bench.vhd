----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2021 20:44:08
-- Design Name: 
-- Module Name: dice_game_test_bench - Behavioral
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

entity dice_game_test_bench is
--  Port ( );
end dice_game_test_bench;

architecture Behavioral of dice_game_test_bench is
component dice_game
            port (
                  clk       : in std_logic;
                  newgame   : in std_logic;
                  roll      : in std_logic;
                  dice      : out unsigned(5 downto 0);
                  win       : out std_logic;
                  lose      : out std_logic;
                  state     : out std_logic_vector(3 downto 0)
                  );
end component;

signal clk      : std_logic:= '0';
signal newgame  : std_logic:= '0'; 
signal roll     : std_logic:= '0'; 
signal dice     : unsigned(5 downto 0);
signal win      : std_logic:= '0';
signal lose     : std_logic:= '0';
signal state    : std_logic_vector(3 downto 0 );
              
begin

dut: dice_game 
    port map (clk  =>  clk,
              newgame => newgame, 
              roll =>  roll,
              dice =>  dice,
              win  =>  win,
              lose =>  lose,
              state => state
              );
              
clk_gen: process is    
begin   
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
end process clk_gen;

stimuli: process
begin
        newgame <= '0';
        wait for 20 ns;
        newgame <='1';
        wait for 30 ns;
        newgame <= '0';
        
        roll <= '0';
        wait for 10 ns;
        roll <='1';
        wait for 40 ns;
        roll <='0';
        wait for 500ns;
        roll <= '1';
        wait for 40ns;
        roll <= '0';
        wait for 500 ns;
        roll <='1';
        wait for 60 ns;
        roll <='0';
        wait for 10ns;
        wait;
end process;
      

end Behavioral;
