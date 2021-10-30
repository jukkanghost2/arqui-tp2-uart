`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 04:14:34 PM
// Design Name: 
// Module Name: prueba_todo
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


module prueba_todo;
  //INPUTS
   reg           i_clock;
   reg           i_tick;
   reg           i_reset;
   reg           i_tx_signal;
   reg  [7:0]    i_data_byte;

   //OUTPUTS
   wire           o_tick;
   wire           o_done_bit_tx;
   wire           o_tx_data;
   
 
   // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //(1/baudrate)
  integer data_index = 0;
  
  //INPUTS
   reg        i_rx_data_input;
   
   //OUTPUTS
   wire                  o_done_bit_rx;
   wire    [7:0]         o_data_byte;
 
  
   //PARAMETERS
  parameter     SIZEDATA = 8;
  parameter     SIZEOP = 6;
  
  //INPUTS
  reg                             i_rx_done;
  reg  signed  [SIZEDATA - 1:0]   i_rx_data;
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
  wire                      o_tx_signal;
  
  localparam                        operando1 = 8'b00000010;
  localparam                        operando2 = 8'b00000100;
  localparam                        opcode = 8'b00100000;
  
  reg    [7:0]              byte_from_tx = 0; 
  
   ALU alu_test (
    .i_datoa        (i_datoa),
    .i_datob        (i_datob),
    .i_opcode       (i_opcode),
    .o_result       (o_result)
    );
    
      BR_GENERATOR br_test 
  (
    .i_clock           (i_clock),
    .o_tick            (o_tick)    
  );
  
   INTF intf_test (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_done       (i_rx_done),
    .i_rx_data       (i_rx_data),
    .i_alu_result    (i_alu_result),
    .o_alu_datoa     (o_alu_datoa),
    .o_alu_datob     (o_alu_datob),
    .o_alu_opcode    (o_alu_opcode),
    .o_tx_result     (o_tx_result),
    .o_tx_signal     (o_tx_signal)
    );
    
  UART_RX rx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_rx_data_input), 
    .o_done_bit        (o_done_bit_rx), 
    .o_data_byte       (o_data_byte)
  );
  
    UART_TX tx_test (
    .i_clock           (i_clock),
    .i_tick            (i_tick),
    .i_reset           (i_reset),
    .i_data_byte       (i_data_byte),
    .i_tx_signal       (i_tx_signal), 
    .o_done_bit        (o_done_bit_tx), 
    .o_tx_data         (o_tx_data)
  );
  
  always @(*) //BR GENERATOR AL TX Y RX
    i_tick  <=  o_tick;
   
  always @(*) //INTF ALU
    begin
     i_datoa       <=  o_alu_datoa;
     i_datob       <=  o_alu_datob;
     i_opcode      <=  o_alu_opcode;
     i_alu_result  <=  o_result;
    end
    
   always @(*) //RX INTF
    begin
     i_rx_done <= o_done_bit_rx;
     i_rx_data <= o_data_byte;
    end 
    
    
     always @(*) //TX INTF
    begin
     i_tx_signal <= o_tx_signal;
     i_data_byte <= o_tx_result;
    end 
     
    initial
    begin         
            i_clock = 1'b0;
            i_tick  = 1'b0;
            i_rx_data_input = 1'b1;
            i_reset = 1'b1;
		    #20
		    i_reset = 1'b0;
		    #demora
            
            
            ////////////OPERANDO A
            i_rx_data_input = 1'b0; ////START
		    #demora
		    
            for(data_index = 0; data_index <8; data_index = data_index +1)
            begin
                i_rx_data_input <= operando1[data_index];
                $display("mando %d", operando1[data_index]);
                #demora;
            end
            
            i_rx_data_input = 1'b1; ///////////PARITY
		    #demora
             i_rx_data_input = 1'b1; ///////////STOP
		    #demora
		    ////////////OPERANDO B
		    i_rx_data_input = 1'b0; ////START
		    #demora
		    
            for(data_index = 0; data_index <8; data_index = data_index +1)
            begin
                i_rx_data_input <= operando2[data_index];
                $display("mando %d", operando2[data_index]);
                #demora;
            end
            
            i_rx_data_input = 1'b1; ///////////PARITY
		    #demora
             i_rx_data_input = 1'b1; ///////////STOP
		    #demora
		    #demora
		    
		    ////////////OPCODE
		    i_rx_data_input = 1'b0; ////START
		    #demora
		    
            for(data_index = 0; data_index <8; data_index = data_index +1)
            begin
                i_rx_data_input <= opcode[data_index];
                $display("mando %d", opcode[data_index]);
                #demora;
            end
            
            i_rx_data_input = 1'b1; ///////////PARITY
		    #demora
             i_rx_data_input = 1'b1; ///////////STOP
		    #demora
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
            
            if(o_tx_data == 1'b1) //PARITY bit
              $display("parity bit detectado");
		      #demora;
		      
               if(o_tx_data == 1'b1) //STOP bit
              $display("stop bit detectado");
		      #demora;
            end
		    
		    /////////RESULT
		    $display("recibido %b \n", byte_from_tx);
		    if(byte_from_tx == 6)
		      $display("correct");
		    else
		      $display("failed");
		    $finish;
     end
             
     always #(period/2) i_clock = ~i_clock;
      
endmodule
