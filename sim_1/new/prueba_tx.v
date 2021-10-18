`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2021 11:43:40 PM
// Design Name: 
// Module Name: prueba_tx
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


module prueba_tx;

  //INPUTS
   reg           i_clock;
   reg           i_tick;
   reg           i_reset;
   reg           i_tx_signal;
   reg  [7:0]    i_data_byte;

   //OUTPUTS
   wire           o_tick;
   wire           o_done_bit;
   wire           o_tx_data;
   
 
   // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 52000; //hay que ver el calculo del valor en serio
  reg    [7:0]              byte_from_tx = 0; 
  integer data_index = 0;
  
  BR_GENERATOR br_test (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
  
    UART_TX tx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_data_byte       (i_data_byte),
    .i_tx_signal       (i_tx_signal), 
    .o_done_bit        (o_done_bit), 
    .o_tx_data         (o_tx_data)
  );
   
  always @(posedge i_clock) //Incoming tick
     i_tick  <=  o_tick;
 
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
            i_data_byte <= 8'b10101010;
		    #demora
		    i_tx_signal = 1'b0; 
		    if(o_tx_data == 1'b0) //Start bit
            $display("start bit detectado");
		    begin
		    #demora		    
                for(data_index = 0; data_index <8; data_index = data_index +1)
                begin
                    byte_from_tx[data_index] <= o_tx_data;
                    $display(o_tx_data);
                    #demora;
                end
            
               if(o_tx_data == 1'b1) //STOP bit
              $display("stop bit detectado");
		      #demora;
            end
            
		    $display("transmitido %b \n", byte_from_tx);
		    if(byte_from_tx == 8'b10101010)
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
             
     always #(period/2) i_clock = ~i_clock;

 
endmodule
