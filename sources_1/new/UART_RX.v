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
   parameter DATA_WIDTH = 8,
   parameter STOP_WIDTH = 1,
   parameter PARITY_WIDTH = 1
   )
  (
  //INPUTS
   input        i_clock,
   input        i_tick,
   input        i_reset,
   input        i_rx_data_input,
   //OUTPUTS
   output                    o_done_bit,
   output [DATA_WIDTH - 1:0] o_data_byte
   );
   
  // One-Hot, One-Cold  
  localparam STATE_IDLE         = 6'b000001;
  localparam STATE_START_BIT    = 6'b000010;
  localparam STATE_RECEIVING    = 6'b000100;
  localparam STATE_PARITY_BIT   = 6'b001000;
  localparam STATE_STOP_BIT     = 6'b010000;
  localparam STATE_DONE         = 6'b100000;
  
  reg                       rx_data   = 1'b1; 
  reg [7:0]                 tick_counter  = 0;
  reg [2:0]                 data_index     = 0; //8 bits total
  reg [1:0]                 stop_index     = 0; //1 o 2 stop bits
  reg [1:0]                 parity_index   = 0; //1 o 2 parity bits
  reg [DATA_WIDTH - 1:0]    data_byte      = 0;
  reg                       done_bit       = 0;
  reg [5:0]                 current_state  = 0;
  reg [5:0]                 next_state     = 0;

   assign  o_done_bit  =  done_bit;
   assign  o_data_byte = data_byte;
   
   always @(posedge i_clock) //Incoming data
     rx_data  <=  i_rx_data_input;
     
   always @(posedge i_clock) //Incoming tick
   if (i_tick)
            tick_counter <= tick_counter + 1;
   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) current_state <= STATE_IDLE; //ESTADO INICIAL
    else         current_state <= next_state; 
   
   always @(posedge i_clock) begin: next_state_logic
    case (current_state)
        STATE_IDLE:
        begin      
            data_index <= 0;    
            tick_counter <= 0;
            stop_index <= 0;
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
        end
        
        STATE_RECEIVING:
        begin
            if(tick_counter == 15)
            begin
                tick_counter <= 0;
                data_byte[data_index] <= rx_data;
                if(data_index < DATA_WIDTH - 1)
                 begin  
                        data_index <= data_index + 1;
                        next_state <= STATE_RECEIVING;
                 end
                else
                 begin
                    data_index <= 0;
                    parity_index <= 0;
                    next_state <= STATE_PARITY_BIT;
                 end
            end
        end
        
        
        STATE_PARITY_BIT:
        begin
            if(tick_counter == 15)
            begin
                tick_counter <= 0;
                if(parity_index < PARITY_WIDTH - 1)
                 begin  
                        parity_index <= parity_index + 1;
                        next_state <= STATE_PARITY_BIT;
                 end
                else
                 begin
                    parity_index <= 0;
                    stop_index <= 0;
                    next_state <= STATE_STOP_BIT;
                 end
            end
        end
        
        
        STATE_STOP_BIT:
        begin
            if(tick_counter == 15)
            begin
                if(rx_data == 1'b1) //Stop bit 
                begin
                    if(stop_index < STOP_WIDTH)
                    begin
                        stop_index <= stop_index + 1;
                        next_state <= STATE_STOP_BIT;
                    end
                    else
                    begin
                        tick_counter <= 0;
                        data_index <= 0;
                        stop_index <= 0;
                        next_state <= STATE_DONE;
                    end
                end
                else
                begin
                    tick_counter <= 0;
                    data_index <= 0;
                    next_state <= STATE_IDLE;
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
            stop_index <= 0;
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
        
        STATE_PARITY_BIT:
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
