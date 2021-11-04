`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2021 06:49:07 PM
// Design Name: 
// Module Name: prueba_rx
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


module prueba_rx_tb;
	//PARAMETERS
   parameter DATA_WIDTH = 8;
   parameter STOP_WIDTH = 1;
   parameter PARITY_WIDTH = 1;
  //INPUTS
   reg        i_clock;
   reg        i_tick;
   reg        i_reset;
   reg        i_rx_data_input;
   
   //OUTPUTS
   wire                  o_tick;
   wire                  o_done_bit;
   wire    [DATA_WIDTH-1:0]         o_data_byte;
   wire    [PARITY_WIDTH-1:0]         o_parity;
 
   // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //(1/baudrate)
  localparam     [DATA_WIDTH-1:0]              byte_to_rx = 8'b11101010; 
  localparam     [PARITY_WIDTH-1:0]              parity_to_rx = 1'b1; 
  integer data_index = 0;
  integer parity_index = 0;
  integer stop_index = 0;
  
  
  BR_GENERATOR br_test 
  (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
  
    UART_RX rx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_rx_data_input), 
    .o_done_bit        (o_done_bit), 
    .o_data_byte       (o_data_byte),
    .o_parity          (o_parity)
  );
   
  always @(posedge i_clock) //Incoming data
     i_tick  <=  o_tick;
 
  initial
    begin         
            i_clock = 1'b0;
            i_tick  = 1'b0;
            i_rx_data_input = 1'b1;
            i_reset = 1'b1;
		    #20
		    i_reset = 1'b0;
		    #demora

            i_rx_data_input = 1'b0; ////START
		    #demora
		    ////DATA
            for(data_index = 0; data_index <DATA_WIDTH - 1; data_index = data_index +1)
            begin
                i_rx_data_input <= byte_to_rx[data_index];
                $display("data %d", byte_to_rx[data_index]);
                #demora;
            end
            ////PARITY
            for(parity_index = 0; parity_index <PARITY_WIDTH; parity_index = parity_index +1)
            begin
                i_rx_data_input <= parity_to_rx[parity_index];
                $display("parity %d", parity_to_rx[parity_index]);
                #demora;
            end
            
             ////STOP
            for(stop_index = 0; stop_index <STOP_WIDTH; stop_index = stop_index +1)
            begin
                i_rx_data_input = 1'b1; ////STOP
                $display("stop ");
                #demora;
            end
		    #demora

		    $display("data recibido %b \n", o_data_byte);
		    $display("paridad recibido %b \n", o_parity);

		    if((o_data_byte == byte_to_rx) & (o_parity == parity_to_rx))
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
             
     always #(period/2) i_clock = ~i_clock;
endmodule
