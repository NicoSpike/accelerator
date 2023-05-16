`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 17:03:30
// Design Name: 
// Module Name: pimt_2
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


module pimt_2(
input      wire                         clk,
input      wire   [63:0]            powsub4,
input      wire                 powsub4_vld,
input      wire   [63:0]            alpha_r,
input      wire                 alpha_r_vld,
input      wire   [63:0]              phi_r,
input      wire                   phi_r_vld,
output     wire   [63:0]       pimt2_result,
output     wire            pimt2_result_vld
    );

wire                   m1_start;
wire                   m2_start;
wire                  m1_finish;
wire     [63:0]       m1_result;
wire                  a_ready_1;
wire                  b_ready_1;
wire                  a_ready_2;
wire                  b_ready_2;

assign   m1_start = alpha_r_vld & phi_r_vld;

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(m1_start),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_r),
    .s_axis_b_tvalid(m1_start),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(phi_r),
    .m_axis_result_tvalid(m1_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m1_result)
);

assign    m2_start = m1_finish & powsub4_vld;

floating_point_0  m2 (
    .aclk(clk),
    .s_axis_a_tvalid(m2_start),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(m1_result),
    .s_axis_b_tvalid(m2_start),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(powsub4),
    .m_axis_result_tvalid(pimt2_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pimt2_result)
);

endmodule