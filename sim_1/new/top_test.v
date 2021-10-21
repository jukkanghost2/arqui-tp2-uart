`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2021 04:28:08 PM
// Design Name: 
// Module Name: top_test
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


module top_test;

    //INPUTS
   reg           i_clock;
   reg           i_reset;
   wire           i_tx;
   reg           i_tx_signal;  
   reg    [7:0]  tx_data_byte;

   //OUTPUTS
   wire           o_rx;
   wire           o_tx_done;
   wire           o_rx_done;
   wire  [7:0]    rx_data_byte;
   
   TOP top_test (
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
    .i_tx_result     (tx_data_byte),
    .o_rx_done       (o_rx_done),
    .o_rx_data       (rx_data_byte),
    .o_tx_done       (tx_done)
    );
    
        // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //hay que ver el calculo del valor en serio
  integer data_index = 0;
   
  initial
    begin         
            i_clock = 1'b0;
            i_tx_signal = 1'b0;
            i_reset = 1'b1;
		    #20
		    i_reset = 1'b0;
		    #demora

            i_tx_signal = 1'b1; 
            tx_data_byte <= 8'b0000100;
		    #10000
		    i_tx_signal = 1'b0; 

		    #(demora*10)		    
//                for(data_index = 0; data_index <8; data_index = data_index +1)
//                begin
//                    #demora;
//                end
            #demora
            i_tx_signal = 1'b1; 
            tx_data_byte <= 8'b00000100;
		    #10000
		    i_tx_signal = 1'b0; 

		    #(demora*10)	    
//                for(data_index = 0; data_index <8; data_index = data_index +1)
//                begin
//                    #demora;
//                end
//            #demora
            #demora
            i_tx_signal = 1'b1; 
            tx_data_byte <= 8'b00100000;
		    #10000
		    i_tx_signal = 1'b0; 

		    #(demora*10)	    
//#demora		    
//                for(data_index = 0; data_index <8; data_index = data_index +1)
//                begin
//                    #demora;
//                end
//            #demora
            #(demora*50)	;    
//            #demora		    
//                for(data_index = 0; data_index <8; data_index = data_index +1)
//                begin
//                    #demora;
//                end
//            #demora
//            #demora
//            #demora

		    
		 
     end
     
     always@(posedge o_rx_done)
     begin
   
      $display("%b\n", rx_data_byte);          
		    if(rx_data_byte == 8)
		      $display("correct");
		    else
		      $display("failed");
		      $finish;
    
     end
             
    always #(period/2) i_clock = ~i_clock;

   
endmodule
