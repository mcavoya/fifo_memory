// - - -
// 64x8 FIFO
// Because of FIFO Full limitation, this is really a 63x8 FIFO

module FIFO (

    input clk,
    input reset,

    // data-in
    input we,                   // active-high write enable
    input [7:0] din,            // data in

    // data-out
    input  rd,                  // active-high read strobe
    output [7:0] dout,          // data out
    output empty,               // active-high FIFO empty flag
    output full                 // active-high FIFO full flag
);

    reg [7:0] ram [63:0];       // dual-port ram
    reg [5:0] addra;            // write-port address counter
    reg [5:0] addrb;            // read-port address counter

    // write-port
    always @(posedge clk) begin
        if (reset) addra <= 6'd0;
        else if (!full && we) begin
            ram[addra] <= din;
            addra <= addra + 1'd1;
        end
    end

    // read-port
    always @(posedge clk) begin
        if (reset) addrb <= 6'd0;
        else if (!empty && rd) addrb <= addrb + 1'd1;
    end

    assign dout = ram[addrb];
    assign empty = (addrb==addra) ? 1'b1 : 1'b0;
    assign full = ((addra+1'b1)==addrb) ? 1'b1 : 1'b0;

endmodule
