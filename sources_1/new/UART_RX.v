`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2021 03:29:33 PM
// Design Name: 
// Module Name: UART_RX
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


module UART_RX
#(
   //PARAMETERS
   )
  (
  //INPUTS
   input        i_clock,
   input        i_tick,
   input        i_reset,
   input        i_rx_data_input,
   //OUTPUTS
   output       o_done_bit,
   output [7:0] o_data_byte
   );
   
  // One-Hot, One-Cold  
  localparam STATE_IDLE         = 5'b00001;
  localparam STATE_START_BIT    = 5'b00010;
  localparam STATE_RECEIVING    = 5'b00100;
  localparam STATE_STOP_BIT     = 5'b01000;
  localparam STATE_DONE         = 5'b10000;
  
  reg           rx_data   = 1'b1; 
  reg [7:0]     tick_counter  = 0;
  reg [2:0]     data_index     = 0; //8 bits total
  reg [7:0]     data_byte      = 0;
  reg           done_bit       = 0;
  reg [4:0]     current_state  = 0;
  reg [4:0]     next_state     = 0;

   assign  o_done_bit  =  done_bit;
   assign  o_data_byte = data_byte;
   
   always @(posedge i_clock) //Incoming data
     rx_data  <=  i_rx_data_input;
   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) current_state <= STATE_IDLE; //ESTADO INICIAL
    else         current_state <= next_state; 
   
   always @(posedge i_clock) begin: next_state_logic
    case (current_state)
        STATE_IDLE:
        begin      
            data_index <= 0;    
            tick_counter <= 0;
            if(rx_data == 1'b0) //Start bit detected
             begin
                next_state <= STATE_START_BIT;
             end
            else
             begin
                next_state <= STATE_IDLE;
             end
        end
        
        STATE_START_BIT:
        begin
          if(i_tick)
          begin
            if(tick_counter == 7)
             begin
                if(rx_data == 1'b0) //Start bit still low
                begin
                    tick_counter <= 0; //(found middle, reset counter)
                    next_state <= STATE_RECEIVING;
                end
                else
                begin
                    tick_counter <= 0;
                    next_state <= STATE_IDLE;
                end
             end
            else
             begin
                tick_counter <= tick_counter + 1;
                next_state <= STATE_START_BIT;
             end
           end
        end
        
        STATE_RECEIVING:
        begin
          if(i_tick)
           begin
            if(tick_counter < 15)
             begin
                tick_counter <= tick_counter + 1;
                next_state <= STATE_RECEIVING;
             end
            else
             begin
                tick_counter <= 0;
                data_byte[data_index] <= rx_data;
                if(data_index < 7)
                 begin  
                        data_index <= data_index + 1;
                        next_state <= STATE_RECEIVING;
                 end
                else
                 begin
                    data_index <= 0;
                    next_state <= STATE_STOP_BIT;
                 end
             end
            end
        end
        
        STATE_STOP_BIT:
        begin
          if(i_tick)
           begin
            if(tick_counter < 15)
             begin
                tick_counter <= tick_counter + 1;
                data_index <= 0;
                next_state <= STATE_STOP_BIT;
             end
            else
             begin
                if(rx_data == 1'b1) //Stop bit 
                begin
                    tick_counter <= 0;
                    data_index <= 0;
                    next_state <= STATE_DONE;
                end
                else
                begin
                    tick_counter <= 0;
                    data_index <= 0;
                    next_state <= STATE_IDLE;
                end
             end
           end
        end
        
        STATE_DONE:
        begin
           tick_counter <= 0;
           data_index <= 0;
           next_state <= STATE_IDLE;
        end
        
        default:
        begin
            tick_counter <= 0;
            data_index <= 0;
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
        
        STATE_RECEIVING:
        begin
             done_bit <= 1'b0;
        end
        
        STATE_STOP_BIT:
        begin
            done_bit <= 1'b0;
        end
        
        STATE_DONE:
        begin
            done_bit <= 1'b1;        
        end
        
        default:
        begin
             done_bit <= 1'b0;
        end
        endcase
    end
endmodule
