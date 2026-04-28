//StopWatch: Modulo-60 Counter
module stopwatch(
    input clk,
    input rst,
    input en,
    output [5:0] state,   //6-bits to represent the highest number 59
    output out
);

    wire at_count, outlogic;
    wire [5:0] next_state;
    wire [5:0] carry;
    wire [5:0] adder_out;

    assign outlogic = at_count^out; //at_count xor out
    //at_count resets from 59 to 0
    assign at_count = (state[5] & state[4] & state[3] & state[1] & state[0]) & (~state[2]); //111011
    //If not enabled, keep state[5:0] else if enabled and at count 59, reset to 0. Otherwise next val
    assign next_state[5:0] = (~en) ? state[5:0] : (at_count) ? 6'b000000 : adder_out[5:0];

    d_ff dff_out(
        .Q(out),
        .clk(clk),
        .rst(rst),
        .data(outlogic)
    );

    d_ff dff_one(
        .clk(clk),
        .rst(rst),
        .data(next_state[0]),
        .Q(state[0])
    );

    d_ff dff_two(
        .clk(clk),
        .rst(rst),
        .data(next_state[1]),
        .Q(state[1])
    );

    d_ff dff_three(
        .clk(clk),
        .rst(rst),
        .data(next_state[2]),
        .Q(state[2])
    );

    //adding state 3 for modulo 60 tens place
    d_ff dff_four(
        .clk(clk),
        .rst(rst),
        .data(next_state[3]),
        .Q(state[3])
    );
    //adding state 4 for modulo 60 tens place
    d_ff dff_five(
        .clk(clk),
        .rst(rst),
        .data(next_state[4]),
        .Q(state[4])
    );

    //adding state 5 for modulo 60 tens place
    d_ff dff_six(
        .clk(clk),
        .rst(rst),
        .data(next_state[5]),
        .Q(state[5])
    );

    //full adder logic
    full_adder modulo_one (
        .A(state[0]),
        .B(1'b0),
        .Y(adder_out[0]),
        //enabled = nextstate+1, or pause=nextstate+0
        .Cin(en),
        .Cout(carry[0])
    );

    full_adder modulo_two (
        .A(state[1]),
        .B(1'b0),
        .Y(adder_out[1]),
        .Cin(carry[0]),
        .Cout(carry[1])
    );

    full_adder modulo_three (
        .A(state[2]),
        .B(1'b0),
        .Y(adder_out[2]),
        .Cout(carry[2]),
        .Cin(carry[1])
    );

    full_adder modulo_four (
        .A(state[3]),
        .B(1'b0),
        .Y(adder_out[3]),
        .Cout(carry[3]),
        .Cin(carry[2])
    );

    full_adder modulo_five (
        .A(state[4]),
        .B(1'b0),
        .Y(adder_out[4]),
        .Cout(carry[4]),
        .Cin(carry[3])
    );

    full_adder modulo_six (
        .A(state[5]),
        .B(1'b0),
        .Y(adder_out[5]),
        .Cout(carry[5]),
        .Cin(carry[4])
    );

endmodule
