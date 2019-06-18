module calculator
(	
	input clk, 
	input rst,
	input start,
	output done,
	output [6:0] seg_out,
	output [4:0] seg_sel,
	output LED1,
	output LED2,
	output LED3
);

wire is_operand, is_operator, is_lt, is_empty, is_hash,
	num0_en, num1_en, num2_en, index_cnt, sel, operand_push, operator_push,
	operand_pop, operator_pop, num_clr, result_en, op1_en, op2_en, operator_en;
wire [1:0] mode;
wire [7:0] data_out, inx;
wire [4:0] seg_sel12, ps;
assign LED1 = done;
assign LED2 = rst;
assign LED3 = start;
wire [35:0] CONTROL0;
debug2 YourInstanceName (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .DATA({data_out,sel, is_operand, is_operator, is_hash, operator_push, operand_push, num0_en,num1_en}), // IN BUS [8:0]
    //.DATA({data_out, inx}),
	 .TRIG0({start, 1'b0}) // IN BUS [1:0]
);
debug1 YourInstanceName1 (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

controller ctrl(clk, rst, start, is_operand, is_operator, is_lt, is_empty, is_hash,
				num0_en, num1_en, num2_en, index_cnt, sel, operand_push, operator_push,
				operand_pop, operator_pop, num_clr, result_en, op1_en, op2_en,
				operator_en, mode, done, ps);
datapath dp(clk, rst, num0_en, num1_en, num2_en, index_cnt, sel, mode, operand_push,
			operand_pop, operator_push, operator_pop, num_clr, result_en, op1_en,
			op2_en, operator_en, is_operand, is_operator, is_lt, is_empty, is_hash, data_out, inx);
seg_display sd(rst, clk, done, data_out, seg_out, seg_sel);
//assign seg_out = data_out[6:0];
//sassign seg_sel = 5'b00001;

endmodule