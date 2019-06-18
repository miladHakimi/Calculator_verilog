module controller(
	input clk,
	input rst,
	input start,
	input is_operand,
	input is_operator,
	input is_lt,
	input is_empty,
	input is_hash,
	input is_div,
	input op_is_empty,
	output reg num0_en,
	output reg num1_en,
	output reg num2_en,
	output reg index_cnt,
	output reg sel,
	output reg operand_push,
	output reg operator_push,
	output reg operand_pop,
	output reg operator_pop,
	output reg num_clr,
	output reg result_en,
	output reg op1_en,
	output reg op2_en,
	output reg operator_en,
	output reg [1:0] mode,
	output reg done,
	output reg [4:0] ps
);

reg [4:0] ns, div_count;
reg [1:0] count;
always @(ps, start, is_operand, is_operator, is_empty, is_hash, is_lt, is_div) begin
	ns = 5'd0;

	case (ps)

		5'd0: if(start) ns = 1;
			else ns = 0;
		5'd1: if(is_operand) ns = 2;
			  else if(is_hash) ns = 9;
		5'd3: if(is_operator && is_lt==0) ns = 8;
				else if(is_operator && is_lt) ns = 17;
				else if (is_operand) ns=2;
			  else if(is_hash) ns = 9;
		5'd8: ns = 1;
		5'd10: if(op_is_empty) ns = 16;
				else ns = 11;
		5'd14: if(is_div &&  div_count<15 ) ns = 5'd14;
				else ns = 5'd15;
		5'd15: if(op_is_empty) ns = 16;
				else ns = 10;
		5'd16: ns = 16;
		5'd22: if(div_count<15 && is_div) ns = 5'd22;
				else ns = 5'd23;
		5'd24: ns = 1;
		default: ns = ps + 1;
	endcase
end

always @(posedge clk) begin
	if (rst) begin
		ps <= 5'd0;
		div_count <= 0;
	end
	else begin
		ps <= ns;
		if (ps==10)
			div_count <= 0;

		if (is_div && ps>10)
			div_count <= div_count + 1;

		if (ps==2)
			count <= count + 1;
		if (ps==1) begin
			count <= 0;
		end
	end
end

always @(ps) begin
	num0_en = 0;
	num1_en = 0;
	num2_en = 0;
	index_cnt = 0;
	sel = 0;
	operand_push = 0;
	operator_push = 0;
	operand_pop = 0;
	operator_pop = 0;
	num_clr = 0;
	result_en = 0;
	op1_en = 0;
	op2_en = 0;
	operator_en = 0;
	done = 0;

	case (ps)
		5'd1:begin
			num_clr = 1;
		end
		5'd2: begin
			if (count==0)
				num0_en = 1;
			else if(count==1)
				num1_en = 1;
			else if (count==2)
				num2_en = 1;
			index_cnt = 1;
		end

		5'd3: begin
			mode = count-1;
		end

		5'd8: begin
			operand_push = 1;
			operator_push = 1;
			index_cnt = 1;
		end

		5'd9: begin
			operand_push = 1;
		end
		5'd10: begin
			op2_en = 1;
			operator_en = 1;
		end
		5'd11: begin
			operand_pop = 1;
		end
		5'd12: begin
			op1_en = 1;
		end
		5'd13: begin
			operand_pop = 1;
		end
		5'd15: begin
			result_en = 1;
			operator_pop = 1;
			sel = 1;
			operand_push = 1;
		end
		5'd16: begin
			done = 1;
		end
		5'd17: begin
			operand_push = 1;
		end
		5'd18: begin
			op2_en = 1;
			operator_en = 1;
		end
		5'd19: begin
			operand_pop = 1;
		end
		5'd20: begin
			op1_en = 1;
		end
		5'd21: begin
			operand_pop = 1;
		end
		5'd23: begin
			operator_pop = 1;
			result_en = 1;
		end
		5'd24: begin
			sel = 1;
			operand_push = 1;
			operator_push = 1;
			index_cnt = 1;
		end

		default:
			sel = 0;

	endcase
end

endmodule
