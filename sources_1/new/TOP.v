`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 05:44:19 PM
// Design Name: 
// Module Name: TOP
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


module TOP
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
   input        i_tx,
   //OUTPUTS
   output       o_rx,
   output       o_tx_done
   );
    
    // Wires.
    wire [SIZEDATA - 1 : 0]    operando_a;
    wire [SIZEDATA - 1 : 0]    operando_b;
    wire [SIZEOP - 1 : 0]      opcode;
    wire [SIZEDATA - 1 : 0]    result;
    wire [DATA_WIDTH - 1 : 0]    rx_data_byte;
    wire [DATA_WIDTH - 1 : 0]    tx_data_byte;
    wire                       rx_done;
    wire                       tx_signal;    
    wire                       ticks;
    wire [PARITY_WIDTH -1:0]    rx_parity;
    wire [PARITY_WIDTH -1:0]    tx_parity;

   ALU u_alu (
    .i_datoa        (operando_a),
    .i_datob        (operando_b),
    .i_opcode       (opcode),
    .o_result       (result)
    );
    
  
   INTF u_intf (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_done       (rx_done),
    .i_rx_data       (rx_data_byte),
    .i_rx_parity     (rx_parity),
    .i_alu_result    (result),
    .o_alu_datoa     (operando_a),
    .o_alu_datob     (operando_b),
    .o_alu_opcode    (opcode),
    .o_tx_result     (tx_data_byte),
    .o_tx_signal     (tx_signal),
    .o_tx_parity     (tx_parity)
    );
    
    UART u_uart (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_data       (i_tx),
    .o_tx_data       (o_rx),
    .i_tx_signal     (tx_signal),
    .i_tx_result     (tx_data_byte),
    .i_parity        (tx_parity),
    .o_rx_done       (rx_done),
    .o_rx_data       (rx_data_byte),
    .o_parity        (rx_parity),
    .o_tx_done       (o_tx_done)
    );
   
    
endmodule
