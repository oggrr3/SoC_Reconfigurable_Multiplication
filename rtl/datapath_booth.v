module datapath_booth #(parameter DATA_SIZE = 8)
(
    clk_i               ,
    reset_ni            ,

    multiplicand_i      ,
    multiplier_i        ,

    add_en_i            ,
    sub_en_i            ,
    shift_en_i          ,
    clear_reg_i         ,
    finish_i            ,

    qq1_eq_01_o         ,
    qq1_eq_10_o         ,
    count_eq_0_o        ,

    booth_product_o     ,
    booth_valid_o       
);

    input                           clk_i               ;
    input                           reset_ni            ;

    input   [DATA_SIZE - 1 : 0]     multiplicand_i      ;
    input   [DATA_SIZE - 1 : 0]     multiplier_i        ;
    
    input                           add_en_i            ;
    input                           sub_en_i            ;
    input                           shift_en_i          ;
    input                           clear_reg_i         ;
    input                           finish_i            ;

    output                          qq1_eq_01_o         ;
    output                          qq1_eq_10_o         ;
    output                          count_eq_0_o        ;
    output  [2*DATA_SIZE - 1 : 0]   booth_product_o     ;
    output                          booth_valid_o       ;

    wire    [2*DATA_SIZE - 1 : 0]   booth_product       ;

    //  Decalare register
    reg     [DATA_SIZE - 1 :0 ]     acc                 ;   
    reg     [DATA_SIZE - 1 :0 ]     q                   ;
    reg                             q1                  ;
    reg     [DATA_SIZE - 1 : 0]     count               ;

    //  Handle register
    always @ (posedge clk_i, negedge reset_ni) begin
        if (~reset_ni) begin
            acc     <=  0               ;
            q1      <=  0               ;
            q       <=  0    ;
            count   <=  0   ;
        end
        else begin
          if (clear_reg_i) begin
            acc     <=  0               ;
            q1      <=  0               ;
            q       <=  multiplier_i    ;
            count   <=  DATA_SIZE - 1   ;
          end
          
            if (add_en_i)
                acc <=  acc + multiplicand_i    ;

            if (sub_en_i) 
                acc <=  acc - multiplicand_i    ;

            if (shift_en_i) begin
                {acc, q, q1} <= {acc[DATA_SIZE-1], acc, q}  ;                   //  Before: {acc, q, q1} =  1000_1001_0
                                                                                //  After : {acc, q, q1} =  1100_0100_1
                count       <=  count - 1                   ;
            end
        end
    end

    //Out-put
    assign  qq1_eq_01_o     =   ({q[0], q1} == 2'b01) ? 1 : 0 ;
    assign  qq1_eq_10_o     =   ({q[0], q1} == 2'b10) ? 1 : 0 ;
    assign  count_eq_0_o    =   (count == 0) ? 1 : 0          ;
    assign  booth_product   =   {acc, q}                      ;
    //  if multiplicand = 10 or 100 or 1000 or 1000 or 1000000 ,....
    //  invert product
    assign  booth_product_o =   (multiplicand_i[DATA_SIZE - 1] & (multiplicand_i[DATA_SIZE - 2 : 0] == 0)) ? (-booth_product) : booth_product     ;
    assign  booth_valid_o   =   (finish_i) ? 1 : 0            ;

endmodule