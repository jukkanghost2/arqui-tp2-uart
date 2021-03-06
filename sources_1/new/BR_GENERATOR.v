`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2021 05:01:08 PM
// Design Name: 
// Module Name: BR_GENERATOR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BR_GENERATOR
#(
  //PARAMETERS
  parameter clk_frec  = 5.0, // 5MHz
  parameter baudrate = 9600

  )
  (
  //INPUTS
   input        i_clock,
   //OUTPUTS
   output     reg o_tick
   );
  localparam integer modulo = (clk_frec*1000000) / (baudrate * 16);
  reg [ $clog2 (modulo) - 1:0] contador;
  
  
  always @(posedge i_clock)
  begin
    if(contador < modulo)
        begin
            o_tick <= 0;
            contador <= contador + 1;
        end
    else
        begin
            o_tick <= 1;
            contador <= 0;
        end
  end      
        

   
endmodule












 