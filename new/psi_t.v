`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 20:09:34
// Design Name: 
// Module Name: psi_t
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


module psi_t(
input      wire                     clk,
input      wire   [63:0]    alpha_mul_k,
input      wire           alphamulk_vld,
input      wire   [63:0]          psi_i,
output     wire   [63:0]          psi_t,
output     wire               psi_t_vld
    );

wire                a_ready_1;
wire                b_ready_1;
wire                a_ready_2;
wire                b_ready_2;
wire               r_tvalid_1;
wire   [63:0]       r_tdata_1;

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(alphamulk_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_mul_k),
    .s_axis_b_tvalid(alphamulk_vld),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(psi_i),
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
    .s_axis_b_tdata(64'hBFC5555555555555),
    .m_axis_result_tvalid(psi_t_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(psi_t)
);

endmodule