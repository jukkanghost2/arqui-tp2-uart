`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2021 06:49:07 PM
// Design Name: 
// Module Name: prueba_brgenerator
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


module prueba_brgenerator_tb;
	
  //INPUTS
   reg        i_clock;
   reg        i_tick;
   //OUTPUTS
   wire                  o_tick;

 
   // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;

  
  BR_GENERATOR br_test (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
   
  always @(posedge i_clock) //Incoming data
     i_tick  <=  o_tick;
 
  initial
    begin         
            i_clock = 1'b0;
            i_tick  = 1'b0;
		    #20
		    #10000;  
     end
             
     always #(period/2) i_clock = ~i_clock;
endmodule
