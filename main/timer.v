//Timer: Mod-60 downcounter with synchronous load
module timer(
    input clk,
    input rst,
    input en,               //Enables or Disables clock
    input load,             //If load=1, load the counter with "load_value"
    input [5:0] load_value, //Value to load into counter register. Counter will then start counting from this value
    output [5:0] state     //6-bits to represent the highest number 59
);

reg [5:0] count;
assign state = count;

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 0;
    else if (load)
        count <= load_value;
    else if (en) begin
        if (count > 0)
            count <= count - 1;
        else
            count <= 0;
    end
    else
        count <= count;
end

endmodule
