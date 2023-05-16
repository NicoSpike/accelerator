`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 16:52:17
// Design Name: 
// Module Name: pimt_1
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


module pimt_1 (
input      wire                         clk,
input      wire   [63:0]        alpha_mul_k,
input      wire               alphamulk_vld,
input      wire   [63:0]             pi_m_i,
output     wire   [63:0]       pimt1_result,
output     wire            pimt1_result_vld
    );

wire                  a_ready_1;
wire                  b_ready_1;

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(alphamulk_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_mul_k),
    .s_axis_b_tvalid(alphamulk_vld),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(pi_m_i),
    .m_axis_result_tvalid(pimt1_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pimt1_result)
);


endmodule