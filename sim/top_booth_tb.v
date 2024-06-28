`timescale 1ns/1ps

module  top_booth_tb ();

    reg               clk_i           ;
    reg               reset_ni        ;
    reg               enable_i        ;
    reg   [7 : 0]     multiplicand_i  ;
    reg   [7 : 0]     multiplier_i    ;
    wire  [15 : 0]    booth_product_o ;
    wire              booth_valid_o   ;

    //  DUT
    top_booth   DUT (
        .clk_i           (clk_i             ),
        .reset_ni        (reset_ni          ),
        .enable_i        (enable_i          ),
        .multiplicand_i  (multiplicand_i    ),
        .multiplier_i    (multiplier_i      ),
        .booth_product_o (booth_product_o   ),
        .booth_valid_o   (booth_valid_o     )
    );
    
    always #5        clk_i          =   ~clk_i                     ;
    
    initial begin
        clk_i   =   0   ;
        reset_ni    =   0   ;
        enable_i    =   0   ;
        multiplicand_i  =   -128   ;
        multiplier_i    =   3   ;
        #15;

        reset_ni    =   1   ;
        #7;

        enable_i    =   1   ;

        #300;
        if  (booth_product_o == (multiplicand_i * multiplier_i)) 
            $display("CORRECT product = %d == expect = %d", booth_product_o, (multiplicand_i * multiplier_i));
        else
            $display("FAIL product = %d != expect = %d", booth_product_o, (multiplicand_i * multiplier_i));
        
        #5;
        $stop;
    end

endmodule