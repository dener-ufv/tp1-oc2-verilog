module hazardDetectionUnit (
    input id_ex_memRead,
    input [4:0] id_ex_rd,
    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,

    output reg pc_write,
    output reg if_write,
    output reg control_select
);

    initial begin
        pc_write = 0;
        if_write = 0;
        control_select = 0;
    end

    always @(*) begin
        if(id_ex_memRead && (if_id_rs1 == id_ex_rd || if_id_rs2 == id_ex_rd)) begin
            pc_write = 0;
            if_write = 0;
            control_select = 0;
        end else begin
            pc_write = 1;
            if_write = 1;
            control_select = 1;
        end
    end
    
endmodule