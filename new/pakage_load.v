`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/07 18:14:40
// Design Name: 
// Module Name: pakage_load
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pakage_load #(
     res_depth = 9996
)(
input   wire                      clk,
input   wire   [7:0]       wr_ram_cnt,
input   wire   [7:0]       rd_ram_cnt,
input   wire   [511:0]    data_pakage,
output  wire   [511:0]    ddr_wr_data
);


reg  [511:0]  wr_drr_data [res_depth - 1:0];

always @ (posedge clk) begin
    wr_drr_data[wr_ram_cnt] <= data_pakage;
end

assign  ddr_wr_data = wr_drr_data[rd_ram_cnt];

endmodule