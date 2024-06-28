module top_booth    #(parameter     DATA_SIZE = 8)
(
    clk_i           ,
    reset_ni        ,
    enable_i        ,
    multiplicand_i  ,
    multiplier_i    ,
    booth_product_o ,
    booth_valid_o
);

    input                           clk_i           ;
    input                           reset_ni        ;
    input                           enable_i        ;
    input   [DATA_SIZE - 1 : 0]     multiplicand_i  ;
    input   [DATA_SIZE - 1 : 0]     multiplier_i    ;
    output  [2*DATA_SIZE - 1 : 0]   booth_product_o ;
    output                          booth_valid_o   ;


    //  Wire
    wire   qq1_eq_01         ;
    wire   qq1_eq_10         ;
    wire   count_eq_0        ;

    wire  add_en            ;
    wire  sub_en            ;
    wire  shift_en          ;
    wire  clear_reg         ;
    wire  finish            ;

    //  Components
    fsm_booth   fsm_booth1 (
        .clk_i          (clk_i      )     ,
        .reset_ni       (reset_ni   )     ,
        .enable_i       (enable_i   )     ,

        .qq1_eq_01_i    (qq1_eq_01  )     ,
        .qq1_eq_10_i    (qq1_eq_10  )     ,
        .count_eq_0_i   (count_eq_0 )     ,

        .add_en_o       (add_en     )     ,
        .sub_en_o       (sub_en     )     ,
        .shift_en_o     (shift_en   )     ,
        .clear_reg_o    (clear_reg  )     ,
        .finish_o       (finish     )
    );

    datapath_booth #(DATA_SIZE)      datapath_booth1 (
        .clk_i          (clk_i      )     ,
        .reset_ni       (reset_ni   )     ,

        .multiplicand_i (multiplicand_i )     ,   
        .multiplier_i   (multiplier_i   )     ,

        .add_en_i       (add_en     )     ,
        .sub_en_i       (sub_en     )     ,
        .shift_en_i     (shift_en   )     ,
        .clear_reg_i    (clear_reg  )     ,
        .finish_i       (finish     )     ,

        .qq1_eq_01_o    (qq1_eq_01  )     ,
        .qq1_eq_10_o    (qq1_eq_10  )     ,
        .count_eq_0_o   (count_eq_0 )     ,

        .booth_product_o    (booth_product_o)     ,
        .booth_valid_o      (booth_valid_o  ) 
    );
    
endmodule