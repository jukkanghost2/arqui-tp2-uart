`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC - FCEFyN
// Engineer: Daniele Francisco; Gonzalez Julian
// 
// Create Date: 09.09.2021 08:34:19
// Design Name: 
// Module Name: ALU
// Project Name: TP_ALU
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

module ALU
#(
  //PARAMETERS
  parameter     SIZEDATA = 8,
                SIZEOP = 6
)
(
  //INPUTS
  input signed  [SIZEDATA - 1:0]   i_datoa,
  input signed  [SIZEDATA - 1:0]   i_datob,
  input         [SIZEOP - 1:0]     i_opcode,
  //OUTPUTS
  output reg    [SIZEDATA - 1:0]   o_result
);
  
  //OPERATIONS
  localparam [SIZEOP - 1:0]     ADD = 6'b100000;
  localparam [SIZEOP - 1:0]     SUB = 6'b100010;
  localparam [SIZEOP - 1:0]     OR  = 6'b100101;
  localparam [SIZEOP - 1:0]     XOR = 6'b100110;
  localparam [SIZEOP - 1:0]     AND = 6'b100100;
  localparam [SIZEOP - 1:0]     NOR = 6'b100111;
  localparam [SIZEOP - 1:0]     SRA = 6'b000011;
  localparam [SIZEOP - 1:0]     SRL = 6'b000010;
  
  always@(*)
    begin
      case(i_opcode)
        ADD: o_result = i_datoa + i_datob;
        SUB: o_result = i_datoa - i_datob;
        OR:  o_result = i_datoa | i_datob;
        XOR: o_result = i_datoa ^ i_datob;
        AND: o_result = i_datoa & i_datob;
        NOR: o_result = ~(i_datoa | i_datob);
        SRA: o_result = i_datoa >>> i_datob;
        SRL: o_result = i_datoa >> i_datob;
        default: o_result = 0;
      endcase
    end
endmodule
