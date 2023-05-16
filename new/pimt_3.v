`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 17:31:24
// Design Name: 
// Module Name: pimt_3
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


module pimt_3(
input      wire                         clk,
input      wire   [63:0]            powsub4,
input      wire                 powsub4_vld,
input      wire   [63:0]            alpha_i,
input      wire   [63:0]             phi_rr,
input      wire                  phi_rr_vld,
output     wire   [63:0]       pimt3_result,
output     wire            pimt3_result_vld
    );

wire                  m1_finish;
wire     [63:0]       m1_result;
wire                  m2_finish;
wire     [63:0]       m2_result;
wire                  a_ready_1;
wire                  b_ready_1;
wire                  a_ready_2;
wire                  b_ready_2;
wire                  a_ready_3;
wire                  b_ready_3;
wire              pimt3_r_start;

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(phi_rr_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(phi_rr),
    .s_axis_b_tvalid(phi_rr_vld),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(64'hBFF0000000000000),
    .m_axis_result_tvalid(m1_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m1_result)
);

floating_point_0  m2 (
    .aclk(clk),
    .s_axis_a_tvalid(powsub4_vld),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(powsub4),
    .s_axis_b_tvalid(powsub4_vld),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(alpha_i),
    .m_axis_result_tvalid(m2_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m2_result)
);

assign  pimt3_r_start = m1_finish & m2_finish;

floating_point_0  m3 (
    .aclk(clk),
    .s_axis_a_tvalid(pimt3_r_start),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(m1_result),
    .s_axis_b_tvalid(pimt3_r_start),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(m2_result),
    .m_axis_result_tvalid(pimt3_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pimt3_result)
);

endmodule