//StopWatch: Modulo-60 Counter
module stopwatch(
    input clk,
    input rst,
    input en,
    output [5:0] state     //6-bits to represent the highest number 59
);
    
reg [5:0] count;
assign state = count;

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 0;
    else if (en) begin
        if (count == 59)
            count <= 0;
        else
            count <= count + 1;
    end
    else
        count <= count;
end
    
   
endmodule
