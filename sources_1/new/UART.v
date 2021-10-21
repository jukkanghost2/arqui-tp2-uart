`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2021 04:41:47 PM
// Design Name: 
// Module Name: UART
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


module UART
#(
   //PARAMETERS
   parameter     SIZEDATA = 8
   )
   (
    //INPUTS
   input                        i_clock,
   input                        i_reset,
   input                        i_rx_data,
   input                        i_tx_signal,
   input  [SIZEDATA - 1:0]      i_tx_result,
   //OUTPUT
   output                       o_rx_done,
   output [SIZEDATA - 1:0]      o_rx_data,
   output                       o_tx_data,
   output                       o_tx_done

 );
  

  BR_GENERATOR u_br_gen 
  (
    .i_clock           (i_clock),
    .o_tick            (ticks)    
  );
  
  
   UART_RX u_rx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_rx_data), 
    .o_done_bit        (o_rx_done), 
    .o_data_byte       (o_rx_data)
  );
  
    UART_TX u_tx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_data_byte       (i_tx_result),
    .i_tx_signal       (i_tx_signal), 
    .o_done_bit        (o_tx_done), 
    .o_tx_data         (o_tx_data)
  );

   
endmodule
