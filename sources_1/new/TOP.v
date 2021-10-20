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
                SIZEOP = 6
   )
  (
  //INPUTS
   input        i_clock,
   input        i_reset,
   input        i_tx,
   //OUTPUTS
   output       o_rx
   );
    
    // Wires.
    wire [SIZEDATA - 1 : 0]    operando_a;
    wire [SIZEDATA - 1 : 0]    operando_b;
    wire [SIZEOP - 1 : 0]      opcode;
    wire [SIZEDATA - 1 : 0]    result;
    wire [SIZEDATA - 1 : 0]    rx_data_byte;
    wire [SIZEDATA - 1 : 0]    tx_data_byte;
    wire                       tx_done;
    wire                       rx_done;
    wire                       tx_signal;    
    wire                       ticks;

   ALU u_alu (
    .i_datoa        (operando_a),
    .i_datob        (operando_b),
    .i_opcode       (opcode),
    .o_result       (result)
    );
    
      BR_GENERATOR u_br_gen 
  (
    .i_clock           (i_clock),
    .o_tick            (ticks)    
  );
  
   INTF u_intf (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_done       (rx_done),
    .i_rx_data       (rx_data_byte),
    .i_alu_result    (result),
    .o_alu_datoa     (operando_a),
    .o_alu_datob     (operando_b),
    .o_alu_opcode    (opcode),
    .o_tx_result     (tx_data_byte),
    .o_tx_signal     (tx_signal)
    );
    
  UART_RX u_rx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_tx), 
    .o_done_bit        (rx_done), 
    .o_data_byte       (rx_data_byte)
  );
  
    UART_TX u_tx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_data_byte       (tx_data_byte),
    .i_tx_signal       (tx_signal), 
    .o_done_bit        (tx_done), 
    .o_tx_data         (o_rx)
  );

    
endmodule
