`timescale 1ns/1ps

module multiply_top_tb ();
     reg signed   [15:0]      multiplicand_i          ;
     reg signed   [15:0]      multiplier_i            ;
     reg               clk_i                   ;
     reg               reset_ni                ;
     reg               enable_i                ;
     reg   [1:0]       cm_i                    ;   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit
    
     reg    signed      [31:0]   expect ; 

     wire   [31:0]      product16x16_o         ;
     wire              data_valid_o            ;

     wire    [15:0]    product_31_16 ;
     wire    [15:0]    product_15_0  ;
     
     integer count_fail;

    assign  product_31_16 =   product16x16_o[31:16]   ;
    assign  product_15_0  =   product16x16_o[15:0]    ;
     //dut
    configurable_multiplication dut (
    .multiplicand_i (multiplicand_i )          ,
    .multiplier_i   (multiplier_i   )           ,
    .clk_i          (clk_i          )         ,
    .reset_ni       (reset_ni       )         ,
    .enable_i       (enable_i       )         ,
    .cm_i           (cm_i           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

    .product16x16_o (product16x16_o )         ,
    .data_valid_o   (data_valid_o   )
    );

    always #5   clk_i = ~clk_i      ;

    initial begin
        clk_i       =   0;
        reset_ni    =   0;
        enable_i    =   0;
        cm_i        =   2'b10;
        count_fail  =   0;
        
            multiplicand_i  =   16'h5527 ;
            multiplier_i    =   16'h8000 ;
            expect = multiplicand_i * multiplier_i;
            #10;
            reset_ni    =   1   ;
            #8;
            enable_i    =   1   ;
            #300;
            reset_ni    =   0;
            enable_i    =   0   ;
            cm_i = 0;
            #3;
            
            multiplicand_i  =   16'h5527 ;
            multiplier_i    =   (-16'h8000) ;
            expect = multiplicand_i * multiplier_i;
            #10;
            reset_ni    =   1   ;
            #8;
            enable_i    =   1   ;
            #300;
            reset_ni    =   0;
            enable_i    =   0   ;
            cm_i = 0;
            #3;
            
//        repeat(800) begin
//            multiplicand_i  =   $random ;
//            multiplier_i    =   ($random % 2*3 + 1) - 3;
//            expect = multiplicand_i * multiplier_i;
//            #10;
//            reset_ni    =   1   ;
//            #8;
//            enable_i    =   1   ;
//            cm_i = 2'b10;
//            #100;
//            @(posedge data_valid_o);
//            #1;
//            if  (product16x16_o == expect) 
//                $display("CORRECT product = %d == expect = %d at time = %d", product16x16_o, expect, $time);
//            else begin
//                $display("FAIL product = %d != expect = %d at time = %d", product16x16_o, expect, $time);
//                count_fail = count_fail + 1;
//            end
//            @(posedge clk_i);
//            #33;
//            reset_ni    =   0;
//            enable_i    =   0   ;
//            cm_i = 0;
//            #3;
//        end
        $display("FINISH count fail = %d", count_fail);
        #100;
        $stop;
    end
endmodule