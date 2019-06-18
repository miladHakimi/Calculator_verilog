module datapath (
	input clk,
	input rst,
	input num0_en,
	input num1_en,
	input num2_en,
	input index_cnt,
	input sel,
	input [1:0] mode,
	input operand_push,
	input operand_pop,
	input operator_push,
	input operator_pop,
	input num_clr,
	input result_en,
	input op1_en,
	input op2_en,
	input operator_en,
	output is_operand,
	output is_operator,
	output is_lt,
	output is_empty,
	output is_hash,
	output [7:0] data_out,
	output [7:0] rm,
	output rfd,
	output is_div
);

localparam ADD = 0,
			SUB = 1,
			MULT = 2,
			DIV = 3;

wire [7:0] rom_data;
wire [7:0] converted_operator;
wire [7:0] converted_asci;
wire [7:0] convereted_decimal;
wire [7:0] top_operator;
wire [7:0] top_operand;
wire [7:0] operand_data_in;
wire [7:0] operator_data_in;
wire [7:0] divider_out, fractional;
wire operand_empty;

reg [7:0] num0, num1, num2;
reg [6:0] rom_index;
reg [7:0] result;
reg [7:0] op1, op2;
reg [7:0] operator;
assign rm = op2;
ROM rom(.rst(rst), .index(rom_index), .out(rom_data));
converter_ascii_number ascii_converter(rom_data, converted_asci);
convert_to_number decimal_converter(num0, num1, num2, mode, convereted_decimal);
operator_converter operator_converter(rom_data, converted_operator);

stack operands(.rst(rst), .clk(clk), .data_in(operand_data_in), .push_en(operand_push), .pop_en(operand_pop), .data_out(top_operand), .is_empty(operand_empty));
stack operators(.rst(rst), .clk(clk), .data_in(converted_operator), .push_en(operator_push), .pop_en(operator_pop), .data_out(top_operator), .is_empty(is_empty));

divider divider (
	.clk(clk), // input clk
	.rfd(rfd), // output rfd
	.dividend(op1), // input [7 : 0] dividend
	.divisor(op2), // input [7 : 0] divisor
	.quotient(divider_out), // output [7 : 0] quotient
	.fractional(fractional)
); // output [7 : 0] fractional*/
assign is_div = top_operator == DIV;

assign data_out = top_operand;
assign operand_data_in = sel ? result : convereted_decimal;
assign is_operand = (rom_data >= 0 && rom_data < 10) ? 1 : 0;
assign is_operator = (rom_data >= 20 && rom_data <= 30) ? 1 : 0;
assign is_hash = rom_data == 8'd10;
// assign is_lt = ((converted_operator == 2'd1 && top_operator == 2'd0) || 
// 			(converted_operator == 2'd3 && top_operator == 2'd2) ||
// 			(converted_operator < top_operator)) ? 1 : 0;
assign is_lt = is_empty? 0: (converted_operator==ADD && (top_operator==SUB || top_operator==MULT || top_operator==DIV))
 		|| (converted_operator==SUB && (top_operator==MULT || top_operator==DIV)) ;

always @(posedge clk) begin
	if (rst || num_clr) begin
		num0 = 0;
		num1 = 0;
		num2 = 0;
	end
	else if (num0_en)
		num0 = rom_data;
	else if (num1_en)
		num1 = rom_data;
	else if (num2_en)
		num2 = rom_data;
end

always @(posedge clk) begin
	if (rst) begin
		op1 = 0;
		op2 = 0;
	end
	else if (op1_en)
		op1 = top_operand;
	else if (op2_en)
		op2 = top_operand; 
end

always @(posedge clk) begin
	if (rst)
		operator <= 0;
	else if (operator_en)
		operator <= top_operator;
end

always @(posedge clk) begin
	if (rst)
		rom_index = 0;
	else if (index_cnt)
		rom_index = rom_index + 1;
end

always @(negedge clk) begin
	if (rst)
		result = 0;
	else if (result_en) begin
		if (operator == ADD) result = op1 + op2;
		else if (operator == SUB) result = op1 - op2;
		else if (operator == MULT) result = op1 * op2;
		else if (operator == DIV) result = divider_out;
	end
end
//assign result = (operator==ADD)? op1 + op2: op1 - op2;
endmodule