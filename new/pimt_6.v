`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 19:45:21
// Design Name: 
// Module Name: pimt_6
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


module pimt_6(
input      wire                         clk,
input      wire                       start,
input      wire   [63:0]            alpha_i,
input      wire   [63:0]              phi_i,
output     wire   [63:0]       pimt6_result,
output     wire            pimt6_result_vld
    );
    
reg             a_valid_1 = 0;
reg             b_valid_1 = 0;
wire                a_ready_1;
wire                b_ready_1;
wire                a_ready_2;
wire                b_ready_2;
wire               r_tvalid_1;
wire   [63:0]       r_tdata_1;

always @ (posedge clk) begin
   if (start) begin
      a_valid_1 <= 1'b1;
      b_valid_1 <= 1'b1;
   end
   else begin
      a_valid_1 <= 1'b0;
      b_valid_1 <= 1'b0;
   end
end

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_1),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_i),
    .s_axis_b_tvalid(b_valid_1),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(phi_i),
    .m_axis_result_tvalid(r_tvalid_1),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_1)
);

floating_point_0  m2 (
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_1),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(r_tdata_1),
    .s_axis_b_tvalid(r_tvalid_1),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(64'h4050000000000000),
    .m_axis_result_tvalid(pimt6_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pimt6_result)
);

endmodule