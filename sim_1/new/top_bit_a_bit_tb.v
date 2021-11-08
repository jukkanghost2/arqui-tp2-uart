`timescale 1ns / 100ps
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


module top_bit_a_bit_tb;
   //PARAMETERS
   parameter DATA_WIDTH = 8;
   
   //INPUTS
   reg           i_clock;
   reg           i_reset;
   reg           i_tx;

   //OUTPUTS
   wire           o_rx;
   wire           o_tx_done;
   
   TOP top_test (
    .i_clock    (i_clock),
    .i_reset    (i_reset),
    .i_tx       (i_tx),
    .o_rx       (o_rx),
    .o_tx_done  (o_tx_done)
   );
    
    localparam                        demora = 104167; //(1/baudrate)

    reg [DATA_WIDTH - 1 : 0]  result;

  initial
    begin        
            
            i_clock = 1'b0;
            i_reset = 1'b1;
            i_tx = 1;
            result = 8'b0;
		    #20
		    i_reset = 1'b0;
		    
            //operando 1
            #demora i_tx <= 1'b0;//start
            #demora i_tx <= 1'b1;
            #demora i_tx <= 1'b1;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b1;//parity
            #demora i_tx <= 1'b1;//stop

            //operando 2
            #demora i_tx <= 1'b0;//start
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b1;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b1;
            #demora i_tx <= 1'b1;//parity
            #demora i_tx <= 1'b1;//stop

            //opcode
            #demora i_tx <= 1'b0;//start
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b1;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b0;
            #demora i_tx <= 1'b1;//parity
            #demora i_tx <= 1'b1;//stop

            #(demora/2)//para leer al medio del bit
            #demora  //bit start tx
            #demora result[0] = o_rx;
            #demora result[1] = o_rx;
            #demora result[2] = o_rx;
            #demora result[3] = o_rx;
            #demora result[4] = o_rx;
            #demora result[5] = o_rx;
            #demora result[6] = o_rx;
            #demora result[7] = o_rx;

            #demora
            #demora
            #demora;
     end    
           
    always @(posedge o_tx_done) begin
        if(result == 8'b10000101) $display("OK");
        else $display("PESIMO");
     
        $finish; 
    end
        
    always #(200/2) i_clock = ~i_clock;
   
endmodule