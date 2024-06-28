module fsm_booth (
    clk_i               ,
    reset_ni            ,
    enable_i            ,

    qq1_eq_01_i         ,
    qq1_eq_10_i         ,
    count_eq_0_i        ,

    add_en_o            ,
    sub_en_o            ,
    shift_en_o          ,
    clear_reg_o         ,
    finish_o
);
    input   clk_i               ;
    input   reset_ni            ;
    input   enable_i            ;
    
    input   qq1_eq_01_i         ;
    input   qq1_eq_10_i         ;
    input   count_eq_0_i        ;

    output  add_en_o            ;
    output  sub_en_o            ;
    output  shift_en_o          ;
    output  clear_reg_o         ;
    output  finish_o            ;

    //  Decalare state
    localparam      IDLE    =     3'b000 ;
    localparam      START   =     3'b001 ;
    localparam      ADD     =     3'b010 ;
    localparam      SUB     =     3'b011 ;
    localparam      SHIFT   =     3'b100 ;
    localparam      FINISH  =     3'b101 ;  

    reg     [3:0]   current_state   ;
    reg     [3:0]   next_state      ;

    //  Current-state
    always @(posedge clk_i, negedge reset_ni) begin
        if (~reset_ni)
            current_state   <=  IDLE        ;
        else
            current_state   <=  next_state  ;
    end

    //  Next_state
    always @(*) begin
        case (current_state)
            IDLE    :   begin
                if (enable_i)
                    next_state  =   START   ;
                else
                    next_state  =   IDLE    ;
            end

            START   :   begin
                if (qq1_eq_01_i)
                    next_state  =   ADD     ;
                else if (qq1_eq_10_i)
                    next_state  =   SUB     ;
                else
                    next_state  =   SHIFT   ; 
            end

            ADD     :   begin
                next_state  =   SHIFT   ;
            end

            SUB     :   begin
                next_state  =   SHIFT   ;
            end

            SHIFT   :   begin
                if (count_eq_0_i)
                    next_state  =  FINISH   ;
                else
                    next_state  =  START    ;
            end

            FINISH  :   begin
                if (~enable_i)
                    next_state = IDLE       ;
                else
                    next_state = FINISH     ;
            end

            default :   next_state = IDLE   ;
        endcase
    end

    //  Out-put
    assign  add_en_o    =   (current_state == ADD  ) ? 1 : 0    ;
    assign  sub_en_o    =   (current_state == SUB  ) ? 1 : 0    ;
    assign  shift_en_o  =   (current_state == SHIFT) ? 1 : 0    ;
    assign  clear_reg_o  =   (current_state == IDLE) ? 1 : 0    ;
    assign  finish_o    =   (current_state  == FINISH) ? 1 : 0  ;

endmodule