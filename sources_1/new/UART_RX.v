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
  localparam STATE_IDLE         = 4'b0001;
  localparam STATE_START_BIT    = 4'b0010;
  localparam STATE_RECEIVING    = 4'b0100;
  localparam STATE_STOP_BIT     = 4'b1000;
   
  //reg           r_Rx_Data_R = 1'b1;
  reg           rx_data   = 1'b1;
   
  reg [7:0]     tick_counter  = 0;
  reg [2:0]     data_index     = 0; //8 bits total
  reg [7:0]     data_byte      = 0;
  reg           done_bit       = 0;
  reg [3:0]     current_state  = 0;
  reg [3:0]     next_state     = 0;
  

   assign  o_done_bit  =  done_bit;
   assign  o_data_byte = data_byte;
   
   always @(posedge i_clock) //Incoming data
     rx_data  <=  i_rx_data_input;

   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) current_state <= STATE_IDLE; //ESTADO INICIAL
    else         current_state <= next_state; 
   
   
   always @(*) begin: next_state_logic
    case (current_state)
        STATE_IDLE:
        begin        
            data_index <= 0;    
            tick_counter <= 0;
            if(rx_data == 1'b0) //Start bit detected
             begin
                data_index <= 0;
                next_state <= STATE_START_BIT;
             end
            else
             begin
                data_index <= 0;
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
                    data_index <= 0;
                    next_state <= STATE_RECEIVING;
                end
                else
                begin
                    tick_counter <= 0;
                    data_index <= 0;
                    next_state <= STATE_IDLE;
                end
             end
            else
             begin
                tick_counter <= tick_counter + 1;
                data_index <= 0;
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
                tick_counter <= 0;
                data_index <= 0;
                next_state <= STATE_IDLE;
             end
           end
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
            done_bit <= 1'b1;
        end
        
        
        default:
        begin
             done_bit <= 1'b0;
        end
    endcase
        
    end
    
    
endmodule
