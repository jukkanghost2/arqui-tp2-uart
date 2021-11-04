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
 //PARAMETERS
   parameter DATA_WIDTH = 8;
   parameter STOP_WIDTH = 1;
   parameter PARITY_WIDTH = 1;
  //INPUTS
   reg           i_clock;
   reg           i_tick;
   reg           i_reset;
   reg           i_tx_signal;
   reg  [DATA_WIDTH-1:0]    i_data_byte;
   reg  [PARITY_WIDTH -1 :0] i_parity;

   //OUTPUTS
   wire           o_tick;
   wire           o_done_bit;
   wire           o_tx_data;
   
 
   // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //(1/baudrate)
  reg    [DATA_WIDTH-1:0]           byte_from_tx = 0; 
  reg    [PARITY_WIDTH-1:0]         parity_from_tx = 0; 
  integer data_index = 0;
  integer parity_index = 0;
  integer stop_index = 0;
  
  BR_GENERATOR br_test (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
  
    UART_TX tx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_data_byte       (i_data_byte),
    .i_parity          (i_parity),
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
            i_data_byte <= 8'b11110101;
            i_parity <= 1'b1;
		    #(demora/2)
		    i_tx_signal = 1'b0;
		    ///START
		    if(o_tx_data == 1'b0) //Start bit
		    begin
		    #demora
            $display("start bit detectado at time %t", $time);
		    begin
		       
		    
		    ///DATA
                for(data_index = 0; data_index <DATA_WIDTH ; data_index = data_index +1)
                begin
                    byte_from_tx[data_index] <= o_tx_data;
                    $display("data %d", o_tx_data);
                   #demora;
                end
                
             ///PARITY
              for(parity_index = 0; parity_index <PARITY_WIDTH; parity_index = parity_index +1)
                begin
                    parity_from_tx[parity_index] <= o_tx_data;
                     $display("parity %d", o_tx_data);
                  #demora;
                end
            	
            ///STOP
               for(stop_index = 0; stop_index <STOP_WIDTH; stop_index = stop_index +1)
                begin
                    if(o_tx_data == 1'b1) //Stop bit
                    begin
                         $display("stop %d", o_tx_data);
                        #demora;
                    end
                    else
                    begin
                        $display("stop no recibido %d ", o_tx_data);
                    end
                end
            end
            end
            #demora
		    $display("transmitido %b \n", byte_from_tx);
		    if((byte_from_tx == i_data_byte) & (parity_from_tx == i_parity))
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
             
     always #(period/2) i_clock = ~i_clock;

 
endmodule
