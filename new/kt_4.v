`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/19 16:05:38
// Design Name: 
// Module Name: kt_4
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

module kt_4(
input     wire                      clk,
input     wire   [63:0]     alpha_mul_k,
input     wire            alphamulk_vld,
input     wire   [63:0]             K_i,
output    wire   [63:0]      kt4_result,
output    wire           kt4_result_vld
);

wire                  a_ready_1;
wire                  b_ready_1;
wire                  a_ready_2;
wire                  b_ready_2;
wire            k4_result_start;
wire   [63:0]         r_tdata_1;


floating_point_0  K_mul1_3 (
    .aclk(clk),
    .s_axis_a_tvalid(alphamulk_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_mul_k),
    .s_axis_b_tvalid(alphamulk_vld),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(64'h3FD5555555555555),
    .m_axis_result_tvalid(k4_result_start),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_1)
);

floating_point_0  k4result (
    .aclk(clk),
    .s_axis_a_tvalid(k4_result_start),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(r_tdata_1),
    .s_axis_b_tvalid(k4_result_start),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(K_i),
    .m_axis_result_tvalid(kt4_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(kt4_result)
);


endmodule