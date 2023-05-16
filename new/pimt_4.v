`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 19:08:30
// Design Name: 
// Module Name: pimt_4
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


module pimt_4(
input      wire                         clk,
input      wire   [63:0]              psi_r,
input      wire                   psi_r_vld,
input      wire   [63:0]              phi_r,
input      wire                   phi_r_vld,
input      wire   [63:0]            powsub5,
input      wire                 powsub5_vld,
input      wire   [63:0]            alpha_i,
output     wire   [63:0]       pimt4_result,
output     wire            pimt4_result_vld
    );
    
wire                   m1_start;
wire                   m3_start;
wire                  m1_finish;
wire     [63:0]       m1_result;
wire                  m2_finish;
wire                  m3_finish;
wire     [63:0]       m2_result;
wire     [63:0]       m3_result;
wire                  a_ready_1;
wire                  b_ready_1;
wire                  a_ready_2;
wire                  b_ready_2;
wire                  a_ready_3;
wire                  b_ready_3;
wire                  a_ready_4;
wire                  b_ready_4;

assign   m1_start = psi_r_vld & phi_r_vld;

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(m1_start),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(psi_r),
    .s_axis_b_tvalid(m1_start),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(phi_r),
    .m_axis_result_tvalid(m1_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m1_result)
);

floating_point_0  m2 (
    .aclk(clk),
    .s_axis_a_tvalid(powsub5_vld),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(powsub5),
    .s_axis_b_tvalid(powsub5_vld),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(alpha_i),
    .m_axis_result_tvalid(m2_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m2_result)
);

assign  m3_start = m1_finish & m2_finish;

floating_point_0  m3 (
    .aclk(clk),
    .s_axis_a_tvalid(m3_start),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(m1_result),
    .s_axis_b_tvalid(m3_start),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(m2_result),
    .m_axis_result_tvalid(m3_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(m3_result)
);

floating_point_0  mr (
    .aclk(clk),
    .s_axis_a_tvalid(m3_finish),
    .s_axis_a_tready(a_ready_4),
    .s_axis_a_tdata(m3_result),
    .s_axis_b_tvalid(m3_finish),
    .s_axis_b_tready(b_ready_4),
    .s_axis_b_tdata(64'h4000000000000000),
    .m_axis_result_tvalid(pimt4_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pimt4_result)
);

endmodule