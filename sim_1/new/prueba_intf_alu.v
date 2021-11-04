`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2021 10:05:09 AM
// Design Name: 
// Module Name: prueba_intf_alu
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


module prueba_intf_alu;

  //PARAMETERS
  parameter     SIZEDATA = 8;
  parameter     SIZEOP = 6;
  parameter   PARITY_WIDTH = 1;
  
  //INPUTS
  reg                             i_clock;
  reg                             i_reset;
  reg                             i_rx_done;
  reg  signed  [SIZEDATA - 1:0]   i_rx_data;
  reg          [PARITY_WIDTH-1:0] i_rx_parity;
  reg          [SIZEDATA - 1:0]   i_alu_result;
  reg          [SIZEDATA - 1:0]   i_datoa;
  reg          [SIZEDATA - 1:0]   i_datob;
  reg          [SIZEOP - 1:0]     i_opcode;
  
  //OUTPUTS
  wire   [SIZEDATA - 1:0]   o_result;
  wire   [SIZEDATA - 1:0]   o_alu_datoa;
  wire   [SIZEDATA - 1:0]   o_alu_datob;
  wire   [SIZEDATA - 1:0]   o_alu_opcode;
  wire   [SIZEDATA - 1:0]   o_tx_result;
  wire   [PARITY_WIDTH-1:0] o_tx_parity;
  wire                      o_tx_signal;


  localparam                        period = 200;
  localparam                        demora = 400; 
  localparam                        operando1 = 8'b00000010;
  localparam                        operando2 = 8'b00000100;
  localparam                        opcode = 6'b100000;


    INTF intf_test (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_done       (i_rx_done),
    .i_rx_data       (i_rx_data),
    .i_rx_parity     (i_rx_parity),
    .i_alu_result    (i_alu_result),
    .o_alu_datoa     (o_alu_datoa),
    .o_alu_datob     (o_alu_datob),
    .o_alu_opcode    (o_alu_opcode),
    .o_tx_result     (o_tx_result),
    .o_tx_parity     (o_tx_parity),
    .o_tx_signal     (o_tx_signal)
    );
    
     ALU alu_test (
    .i_datoa        (i_datoa),
    .i_datob        (i_datob),
    .i_opcode       (i_opcode),
    .o_result       (o_result)
    );
    
    always @(*) 
    begin
     i_datoa       <=  o_alu_datoa;
     i_datob       <=  o_alu_datob;
     i_opcode      <=  o_alu_opcode;
     i_alu_result  <=  o_result;
    end
    
    
    initial
    begin         
            i_clock = 1'b0;
            i_reset = 1'b1;
            i_rx_done = 1'b0;
		    #100
		    i_reset = 1'b0;
		    #625
		    ///OPERANDO 1
		    i_rx_data <= operando1;
		    i_rx_parity <= 1'b1;
		    i_rx_done = 1'b1;
		    #demora
		    i_rx_done = 1'b0;
		   
		    #demora
		    
		    ///OPERANDO 2
		    i_rx_data <= operando2;
		    i_rx_parity <= 1'b1;
		    i_rx_done = 1'b1;
			#demora
		    i_rx_done = 1'b0;
		  
		    #demora
		    
		    ///OPCODE
		    i_rx_data <= opcode;
		    i_rx_parity <= 1'b1;
		    i_rx_done = 1'b1;
		   	#demora
		    i_rx_done = 1'b0;
		   
		    #demora

		    $display(o_tx_result);
		    $display(o_tx_parity);
		    if((o_tx_result == 6) & (o_tx_parity == 1))
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
    
    
    always #(period/2) i_clock = ~i_clock;

endmodule
