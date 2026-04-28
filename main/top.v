module top 
(
    input clk,           // 100 MHz
    input btnC,          // reset
    input [15:0] sw,     // switches
    output [15:0] led,    //LEDs
    output [3:0] an,     //Outputs for 7-segment display
    output [6:0] seg     //Outputs for 7-segment display
);

/******** DO NOT MODIFY ********/
wire clk_1Hz;       //Generate Internal 1Hz Clock
wire btnC_1Hz;     //Stretch load signal

//If running simulation, output clock frequency is 100MHz, else 1Hz
`ifndef SYNTHESIS
    assign clk_1Hz = clk;
`else
    clk_div #(.INPUT_FREQ(100_000_000), .OUTPUT_FREQ(1)) clk_div_1Hz 
    (.iclk(clk) , .rst(btnC) , .oclk(clk_1Hz));
`endif

// Check stopwatch/timer frequency
initial begin
`ifndef SYNTHESIS
    $display("Stopwatch/Timer Frequency set to 100MHz");
`else
    $display("Stopwatch/Timer Frequency set to 1Hz");
`endif
end

//Seven Segment Display Interface
seven_segment_inf seven_segment_inf_inst (.clk(clk), .rst(btnC), .count(count) , .anode(an), .segs(seg));
/********************************/

/******** UNCOMMENT & UPDATE THIS SECTION ********/
//wire "count" feeds in count value to seven segment display. This should be a 6-bit value
//This will decide if seven segment display shows stopwatch count or timer count
wire [5:0] stopwatch_count;
wire [5:0] timer_count;
wire [5:0] count = mode ? timer_count : stopwatch_count;

/******** UPDATE THIS SECTION ********/
/******* INITIALIZE STOPWATCH AND TIMER MODULE ***********/
// Control signals
wire mode   = sw[0];        // 0 = stopwatch, 1= timer
wire run    = sw[1];        // 0 = pause (circuit holds it state), 1 = run (counter increments/decrements)
wire load   = sw[2];        // 1 = load value from load_value into timer counter, 0 = do nothing
wire [5:0] load_value = sw[15:10];      //Set Timer Value (Value to load in timer)

//Stopwatch Module Instance
//Use "clk_1Hz" as clock signal to stopwatch and timer modules
    stopwatch stopwatch_inst(
    .clk(clk_1Hz),
    .rst(btnC),
    .en(~mode & run),
    .state(stopwatch_count)
);


//Timer Module Instance
//Use "clk_1Hz" as clock signal to stopwatch and timer modules

    timer timer_inst(
    .clk(clk_1Hz),
    .rst(btnC),
    .en(mode & run),
    .load(mode & load),
    .load_value(load_value),
    .state(timer_count)
);

assign led[8:3] = stopwatch_count;
assign led[15:10] = timer_count;
assign led[2:0] = 3'b000;
assign led[9] = 1'b0;
    
endmodule
