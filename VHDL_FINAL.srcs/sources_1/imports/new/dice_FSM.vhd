----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2021 17:12:29
-- Design Name: 
-- Module Name: dice_FSM - Behavioral
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

entity dice_FSM is
  Port (
        roll, newgame, clk  :  in std_logic;
        sum  :  in  unsigned (3 downto 0);
        roll_enable, win, lose :  out std_logic;
        state :  out std_logic_vector(3 downto 0)        
         );
end dice_FSM;

architecture Behavioral of dice_FSM is

type state_type is (phase1,rolling1,stoprolling1,result1,phase2,rolling2,stoprolling2,result2,fwin,flose);

signal current_state, next_state  :  state_type;
signal saved_sum : unsigned (3 downto 0);
signal sum_flag  :  std_logic;
signal roll_counter, result_counter : unsigned (3 downto 0);
signal div_clk  :  std_logic;
begin

state_init:process(clk, newgame)
begin
    if newgame = '1' then
        current_state <= phase1;
        saved_sum <= "0000";    
    elsif clk'event and clk='1' then
        current_state <= next_state;
        if sum_flag ='1' then
            saved_sum <= sum;
        end if;
    end if;
end process; 

state_transition:process(roll, current_state, sum, roll_counter, result_counter, saved_sum)
begin 
    sum_flag <= '0'; 
    next_state <= current_state;
    case current_state is
        when phase1 =>
            if roll = '1' then 
                next_state <= rolling1;
            end if;
        when rolling1 =>
            if roll = '0' then
                next_state <= stoprolling1;
             end if;
        when stoprolling1 =>
            if roll_counter = 0 then
                next_state <= result1;
            end if;
        when result1 =>
            if result_counter = 0 then
                if sum = 7 or sum = 11 then 
                    next_state <= fwin;
                elsif sum = 2 or sum = 3 or sum = 12 then
                    next_state <= flose;
                else
                    sum_flag <= '1';
                    next_state <= phase2;
                end if;
             end if;               
        when phase2 =>
              if roll = '1' then
                next_state <= rolling2;
              end if;
        when rolling2 =>
              if roll = '0' then
                next_state <= stoprolling2;
              end if;
        when stoprolling2 =>
              if roll_counter = 0 then
                next_state <= result2;
            end if;
        when result2 =>
              if result_counter = 0 then
                if sum = 12 or sum = saved_sum then
                    next_state <= fwin;
                elsif sum = 7 or sum = 11 then
                    next_state <= flose;
                else 
                    sum_flag <= '1';
                    next_state <= phase2;
                end if;            
              end if;
        when fwin =>
        when flose =>
        end case;                                                            
end process;

state_outputs:process (current_state, roll_counter)
begin
    case current_state is
        when phase1 => 
            win <= '0';
            lose <= '0';
            roll_enable <= '0';
            state <= "0001";           
        when rolling1 => 
            win <= '0';
            lose <= '0';
            roll_enable <= '1';
            state <= "0010";
        when stoprolling1 =>
            roll_enable <= '1';
            if roll_counter = 0 then
                roll_enable <= '0';              
            end if;        
            win <= '0';
            lose <= '0';
            state <= "0011";
        when result1 =>
            win <= '0';
            lose <= '0';
            roll_enable <= '0';
            state <= "0100";
        when phase2 =>
            win <= '0';
            lose <= '0';
            roll_enable <= '0';
            state <= "0101";
        when rolling2 =>
            win <= '0';
            lose <= '0';
            roll_enable <= '1';
            state <= "0110";            
        when stoprolling2 =>
            roll_enable <= '1';
            if roll_counter = 0 then
                roll_enable <= '0';
            end if; 
            win <= '0';
            lose <= '0';
            state <= "0111";
        when result2 =>
            win <= '0';
            lose <= '0';
            roll_enable <= '0';
            state <= "1000";
        when fwin =>
            win <= '1';     
            lose <= '0';   
            roll_enable <= '0';
            state <= "1001";           
        when flose =>
            win <= '0';     
            lose <= '1';   
            roll_enable <= '0';
            state <= "1010";     
    end case;
end process;

counter1: process (div_clk, newgame)
begin
    if newgame = '1' then
        roll_counter <= "1000";
    elsif div_clk'event and div_clk = '1' then
        if current_state = stoprolling1 or current_state = stoprolling2 then
            roll_counter <= roll_counter - 1;
        else
            roll_counter <= "1000";    
        end if;
    end if;            
end process; 

counter2: process (div_clk, newgame)
begin
    if newgame = '1' then
        result_counter <= "1100";
    elsif div_clk'event and div_clk = '1' then
        if current_state = result1 or current_state = result2 then
            result_counter <= result_counter - 1;
        else 
            result_counter <= "1100";    
        end if;
    end if;      
end process;

clock_div: entity work.freq_div(Behavioral)
port map(clk, div_clk);               

end Behavioral;
