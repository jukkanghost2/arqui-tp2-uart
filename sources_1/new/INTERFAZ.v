`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 01:25:03 PM
// Design Name: 
// Module Name: INTERFAZ
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


module INTERFAZ
#(
  //PARAMETERS
  parameter     SIZEDATA = 8,
                SIZEOP = 6
  )
  (
  //INPUTS
  input signed  [SIZEDATA - 1:0]   i_rx_datoa,
  input signed  [SIZEDATA - 1:0]   i_rx_datob,
  input         [SIZEOP - 1:0]     i_rx_opcode,
  input         [SIZEDATA - 1:0]   i_alu_result,

  //OUTPUTS
  output reg    [SIZEDATA - 1:0]   o_alu_datoa,
  output reg    [SIZEDATA - 1:0]   o_alu_datob,
  output reg    [SIZEDATA - 1:0]   o_alu_opcode,
  output reg    [SIZEDATA - 1:0]   o_tx_result
  );
  
endmodule
