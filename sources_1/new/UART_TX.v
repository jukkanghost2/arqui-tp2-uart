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
  localparam STATE_IDLE         = 4'b0001;
  localparam STATE_START_BIT    = 4'b0010;
  localparam STATE_TRANSMITTING = 4'b0100;
  localparam STATE_STOP_BIT     = 4'b1000;
   
  //reg           r_Rx_Data_R = 1'b1;
  reg           tx_data   = 1'b1;
   
  reg [7:0]     tick_counter  = 0;
  reg [2:0]     data_index     = 0; //8 bits total
  reg [7:0]     data_byte      = 0;
  reg           done_bit       = 0;
  reg [3:0]     current_state  = 0;
  reg [3:0]     next_state     = 0;

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
            tick_counter <= 0;
            if(tx_data == 1'b0) //Start bit detected
                next_state <= STATE_START_BIT;
            else
                next_state <= STATE_IDLE;
        end
        
        STATE_START_BIT:
        begin
            if(tick_counter == 7)
             begin
                if(tx_data == 1'b0) //Start bit still low
                 begin
                    tick_counter <= 0; //(found middle, reset counter)
                    next_state <= STATE_TRANSMITTING;
                 end
                else
                     tick_counter <= 0;                
                     next_state <= STATE_IDLE;
              end
             else
              begin
                tick_counter <= tick_counter + 1;
                next_state <= STATE_START_BIT;
              end
        end
        
        STATE_TRANSMITTING:
        begin
            if(tick_counter < 15)
             begin
                tick_counter <= tick_counter + 1;
                next_state <= STATE_TRANSMITTING;
             end
            else
             begin
                tick_counter <= 0;
                data_byte[data_index] <= tx_data;
                            
                if(data_index < 7)
                 begin
                        data_index <= data_index + 1;
                        next_state <= STATE_TRANSMITTING;
                 end
                else
                 begin
                        data_index <= 0;
                        next_state <= STATE_STOP_BIT;
                 end
             end
        end
        
        STATE_STOP_BIT:
        begin
            if(tick_counter < 15)
             begin
                tick_counter <= tick_counter + 1;
                next_state <= STATE_STOP_BIT;
             end
            else
             begin
                tick_counter <= 0;
                next_state <= STATE_IDLE;
             end
        end
              
        default:
        begin
            tick_counter <= 0;
            next_state <= STATE_IDLE;
        end
        
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
             done_bit <= 1'b0;
        end
        
        STATE_TRANSMITTING:
        begin
             done_bit <= 1'b0;
        end
        
        STATE_STOP_BIT:
        begin
            done_bit <= 1'b1;
        end
        
        
        default:
            done_bit <= 1'b0;

        
    endcase
        
    end
    
    
endmodule

