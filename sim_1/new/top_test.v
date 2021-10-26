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


module top_test;
  //PARAMETERS
  parameter     SIZEDATA = 8;
  parameter     SIZEOP = 6;
  parameter     N_OPS = 8;

    //INPUTS
   reg           i_clock;
   reg           i_reset;
   wire           i_tx;
   reg           i_tx_signal;  
   reg    [SIZEDATA - 1:0]  tx_data_byte;

   //OUTPUTS
   wire           o_rx;
   wire           o_tx_done;
   wire           o_rx_done;
   wire  [SIZEDATA - 1:0]    rx_data_byte;
   
   TOP top_test (
    .i_clock    (i_clock),
    .i_reset    (i_reset),
    .i_tx       (i_tx),
    .o_rx       (o_rx),
    .o_tx_done  (o_tx_done)
   );
   
   UART uart_test (
    .i_clock         (i_clock),
    .i_reset         (i_reset),
    .i_rx_data       (o_rx),
    .o_tx_data       (i_tx),
    .i_tx_signal     (i_tx_signal),
    .i_tx_result     (tx_data_byte),
    .o_rx_done       (o_rx_done),
    .o_rx_data       (rx_data_byte),
    .o_tx_done       (tx_done)
    );
    
    reg [SIZEOP-1:0] OPS[0:N_OPS-1];
    
        // duration for each bit = 10 * timescale = 10 * 1 ns  = 10ns
  localparam                        period = 200;
  localparam                        demora = 104167; //(1/baudrate)
  reg signed    [SIZEDATA - 1:0]                    operando1;
  reg signed    [SIZEDATA - 1:0]                    operando2;
  reg           [SIZEDATA - 1:0]                    opcode;
  reg signed    [SIZEDATA - 1:0]                    result;
  localparam [SIZEOP - 1:0]     ADD = 6'b100000;
  localparam [SIZEOP - 1:0]     SUB = 6'b100010;
  localparam [SIZEOP - 1:0]     OR  = 6'b100101;
  localparam [SIZEOP - 1:0]     XOR = 6'b100110;
  localparam [SIZEOP - 1:0]     AND = 6'b100100;
  localparam [SIZEOP - 1:0]     NOR = 6'b100111;
  localparam [SIZEOP - 1:0]     SRA = 6'b000011;
  localparam [SIZEOP - 1:0]     SRL = 6'b000010;
  integer index = 0;
  integer flag = 1;
  
  initial
    begin        
            OPS[0] <= ADD;
            OPS[1] <= SUB;
            OPS[2] <= OR;
            OPS[3] <= XOR;
            OPS[4] <= AND;
            OPS[5] <= NOR;
            OPS[6] <= SRA;
            OPS[7] <= SRL;
            
            i_clock = 1'b0;
            i_tx_signal = 1'b0;
            i_reset = 1'b1;
		    #20
		    i_reset = 1'b0;
		    #(demora)
		    
            for(index = 0; index <N_OPS; index = index + 1)
            begin
                        tx_data_byte <= $random;           
                        #period operando1 <= tx_data_byte;
                        i_tx_signal = 1'b1;             
                        #10000
                        i_tx_signal = 1'b0; 
            
                        #(demora*10)	
                        #demora
                        
                        tx_data_byte <= $random;  
                        if(index > 5) tx_data_byte <= 3;         
                        #period operando2 <= tx_data_byte;
                        i_tx_signal = 1'b1; 
                        #10000
                        i_tx_signal = 1'b0; 
            
                        #(demora*10)  
                        #demora
                        
                        tx_data_byte <= OPS[index];
                        #period opcode <= tx_data_byte; 
                        i_tx_signal = 1'b1; 
                        #10000
                        i_tx_signal = 1'b0; 
            
                        #(demora*10)
                        #demora
                        
                        case(index)
                              0: 
                                    begin
                                        if((operando1 + operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en suma", operando1, operando2, result, operando1 + operando2);
                                                flag = 0;
                                            end
                                        else $display("SUMA OK");
                                    end
                              1:
                                    begin
                                        if((operando1 - operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en resta", operando1, operando2, result, operando1 - operando2);
                                                flag = 0;
                                            end
                                        else $display("RESTA OK");
                                    end
                              2: 
                                    begin
                                        if((operando1 | operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en or", operando1, operando2, result, operando1 | operando2);
                                                flag = 0;
                                            end
                                        else $display("OR OK");
                                    end
                              3: 
                                    begin
                                        if((operando1 ^ operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en xor", operando1, operando2, result, operando1 ^ operando2);
                                                flag = 0;
                                            end
                                        else $display("XOR OK");
                                    end
                              4:
                                    begin
                                        if((operando1 & operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en and", operando1, operando2, result, operando1 & operando2);
                                                flag = 0;
                                            end
                                        else $display("AND OK");
                                    end
                              5: 
                                    begin
                                        if(~(operando1 | operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en nor", operando1, operando2, result, ~(operando1 | operando2));
                                                flag = 0;
                                            end
                                        else $display("NOR OK");
                                    end
                              6: 
                                    begin
                                        if((operando1 >>> operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en sra", operando1, operando2, result, operando1 >>> operando2);
                                                flag = 0;
                                            end
                                        else $display("SRA OK");
                                    end
                              7: 
                                    begin
                                        if((operando1 >> operando2) != result)
                                            begin
                                                $display("op1 %b op2 %b obtenido %b esperado %b error en srl", operando1, operando2, result, operando1 >> operando2);
                                                flag = 0;
                                            end
                                        else $display("SRL OK");
                                    end
                        endcase
            end                 
            
            if(flag == 1) $display("Todos los test pasados");
            else $display("Fallo algún test");
            
            $finish;
     end

    always@(posedge o_rx_done)
        begin                      
            result <= rx_data_byte;            
        end
             
    always #(period/2) i_clock = ~i_clock;

   
endmodule
