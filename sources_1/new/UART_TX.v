`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 07:02:07 PM
// Design Name: 
// Module Name: UART_TX
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


module UART_TX
#(
      //PARAMETERS
   )
  (
  //INPUTS
   input        i_clock,
   input        i_reset,
   input        i_tx_data_input,
   //OUTPUTS
   output       o_done_bit,
   output [7:0] o_data_byte
   );
   
  // One-Hot, One-Cold  
  parameter STATE_IDLE         = 4'b0001;
  parameter STATE_START_BIT    = 4'b0010;
  parameter STATE_TRANSMITTING = 4'b0100;
  parameter STATE_STOP_BIT     = 4'b1000;
   
  //reg           r_Rx_Data_R = 1'b1;
  reg           tx_data   = 1'b1;
   
  reg [7:0]     r_clock_count  = 0;
  reg [2:0]     data_index     = 0; //8 bits total
  reg [7:0]     data_byte      = 0;
  reg           done_bit       = 0;
  reg [1:0]     current_state  = 0;
  reg [1:0]     next_state     = 0;

   assign  o_done_bit  =  done_bit;
   
   always @(posedge i_clock) //Incoming data
     tx_data  <=  i_tx_data_input;

   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) current_state <= STATE_IDLE; //ESTADO INICIAL
    else         current_state <= next_state; 
   
   
   always @(*) begin: next_state_logic
    case (current_state)
        STATE_IDLE:
        begin
            data_index <= 0;
            if(tx_data == 1'b0) //Start bit detected
                next_state <= STATE_START_BIT;
            else
                next_state <= STATE_IDLE;
        end
        
        STATE_START_BIT:
        begin
            if(tx_data == 1'b0) //Start bit still low
                next_state <= STATE_TRANSMITTING;
            else
                next_state <= STATE_IDLE;
        end
        
        STATE_TRANSMITTING:
        begin
            if(data_index < 7)
                begin
                    data_byte[data_index] <= tx_data;
                    data_index <= data_index + 1;
                    next_state <= STATE_TRANSMITTING;
                end
            else
                begin
                    data_index <= 0;
                    next_state <= STATE_STOP_BIT;
                end
        end
        
        STATE_STOP_BIT:
        begin
                next_state <= STATE_IDLE;
        end
              
        default:
            next_state <= STATE_IDLE;
        
    endcase
    end
    
    
    always @(*) begin: output_logic
        case (current_state)
        STATE_IDLE:
        begin
            done_bit <= 1'b0;
        end
        
        STATE_START_BIT:
        begin
            
        end
        
        STATE_TRANSMITTING:
        begin
            
        end
        
        STATE_STOP_BIT:
        begin
            done_bit <= 1'b1;
        end
        
        
        default:
            next_state <= STATE_IDLE;
        
    endcase
        
    end
    
    
endmodule

