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
  parameter clk_frec  = 5000000, // 5MHz
  parameter baudrate = 19200,
  parameter width_cont = 16,
  parameter increment = (baudrate<<width_cont)/clk_frec

  )
  (
  //INPUTS
   input        i_clock,
   //OUTPUTS
   output       tick
   );
  
   
  reg [width_cont:0] contador;
  always @(posedge i_clock)
    contador <= contador[width_cont - 1:0] + increment;

   assign tick = contador[width_cont];
   
   
   
endmodule

 