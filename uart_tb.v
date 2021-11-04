`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2021 06:53:50 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;
   //PARAMETERS
   parameter DATA_WIDTH = 8;
   parameter STOP_WIDTH = 1;
   parameter PARITY_WIDTH = 1;
   
  //INPUTS
   reg                      i_clock;
   reg                      i_tick;
   reg                      i_reset;
   reg                      i_tx_signal;
   reg  [DATA_WIDTH-1:0]    i_data_byte;
   reg  [PARITY_WIDTH-1:0]  i_parity;   
   reg                      i_rx_data_input;
   
   
   //OUTPUTS
   wire                     o_tick;
   wire                     o_done_bit_tx;
   wire                     o_done_bit_rx;
   wire                     o_tx_data;
   wire  [DATA_WIDTH-1:0]   o_data_byte;
   wire  [PARITY_WIDTH-1:0] o_parity;
   
   
  BR_GENERATOR br_test (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
   
  UART_RX rx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_rx_data_input), 
    .o_done_bit     (o_done_bit_rx), 
    .o_data_byte       (o_data_byte),
    .o_parity          (o_parity)
  );
    
   UART_TX tx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_data_byte       (i_data_byte),
    .i_tx_signal       (i_tx_signal), 
    .i_parity          (i_parity),
    .o_done_bit     (o_done_bit_tx), 
    .o_tx_data         (o_tx_data)   
  );
  
    // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //hay que ver el calculo del valor en serio
  localparam     [DATA_WIDTH-1:0]   data_byte = 8'b01011011;
  localparam     [PARITY_WIDTH-1:0]   parity = 1'b1;

  integer data_index = 0;
  integer parity_index = 0;
  integer stop_index = 0;

  
  
    always @(posedge i_clock) //Incoming tick
    begin
     i_tick  <=  o_tick;
     i_rx_data_input <= o_tx_data;
    end
   
  initial
    begin         
            i_clock = 1'b0;
            i_tick  = 1'b0;
            i_tx_signal = 1'b0;
            i_reset = 1'b1;
		    #20
		    i_reset = 1'b0;
		    #demora

            i_tx_signal = 1'b1; 
            i_data_byte <= data_byte;
            i_parity <= parity;
		    #10000
		    i_tx_signal = 1'b0; 

		    #demora //START
		    //DATA		    
                for(data_index = 0; data_index <DATA_WIDTH; data_index = data_index +1)
                begin
                    #demora;
                end
            //PARITY
                for(parity_index = 0; parity_index <PARITY_WIDTH; parity_index = parity_index +1)
                begin
                    #demora;
                end
            //STOP
                for(stop_index = 0; stop_index <STOP_WIDTH; stop_index = stop_index +1)
                begin
                    #demora;
                end
            #demora
            $display("%b\n", o_data_byte);          
		    if((o_data_byte == data_byte) & (o_parity == parity))
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
             
     always #(period/2) i_clock = ~i_clock;


endmodule
