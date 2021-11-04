`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2021 11:19:33 AM
// Design Name: 
// Module Name: TOP2
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


module TOP2
 #(
   //PARAMETERS
   parameter     SIZEDATA = 8,
   parameter      SIZEOP = 6,
   parameter DATA_WIDTH = 8,
   parameter STOP_WIDTH = 1,
   parameter PARITY_WIDTH = 1
   )
  (
  //INPUTS
   input        i_clock,
   input        i_reset,
   input        i_tx_signal,
   input [DATA_WIDTH - 1:0]  i_tx_data_byte,
   input [PARITY_WIDTH - 1:0]  i_tx_parity,
   //OUTPUTS
   output  [DATA_WIDTH - 1:0]  o_rx_data_byte,
   output   [PARITY_WIDTH - 1:0]    o_rx_parity,
   output  o_rx_done
   );

   //OUTPUTS
   wire           o_rx;
   wire           i_tx;

   TOP u_top (
    .i_clock    (i_clock),
    .i_reset    (i_reset),
    .i_tx       (i_tx),
    .o_rx       (o_rx),
    .o_tx_done  (o_tx_done)
   );
   
   UART u_uart (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_data       (o_rx),
    .o_tx_data       (i_tx),
    .i_tx_signal     (i_tx_signal),
    .i_tx_result     (i_tx_data_byte),
    .i_parity        (i_tx_parity),
    .o_rx_done       (o_rx_done),
    .o_rx_data       (o_rx_data_byte),
    .o_parity        (o_rx_parity),
    .o_tx_done       (tx_done)
    );

   
endmodule
