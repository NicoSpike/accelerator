`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/18 15:17:24
// Design Name: 
// Module Name: kt_3
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


module kt_3(
input     wire                     clk,
input     wire    [63:0]      psi_pow4,
input     wire             psipow4_vld,
input     wire    [63:0]           r_i,
input     wire    [63:0]       alpha_r,
input     wire             alpha_r_vld,
output    wire    [63:0]    kt3_result,
output    wire          kt3_result_vld,
output    wire    [63:0]      rrmulpow,
output    wire           r_rmulpow_vld
    );

/*******************************/
wire                  a_ready_1;
wire                  a_ready_2;
wire                  a_ready_3;
wire                  a_ready_4;
/*******************************/
wire                  b_ready_1;
wire                  b_ready_2;
wire                  b_ready_3;
/*******************************/
wire   [63:0]         r_mul_pow;
wire   [63:0]         alphamul2;
/*******************************/
wire              r_mul_pow_vld;
wire              alphamul2_vld;
wire           kt3_result_start;

floating_point_0  rmulpow(
    .aclk(clk),
    .s_axis_a_tvalid(psipow4_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(psi_pow4),
    .s_axis_b_tvalid(psipow4_vld),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(r_i),
    .m_axis_result_tvalid(r_mul_pow_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_mul_pow)
);

floating_point_4  r_rmulpow(
    .aclk(clk),
    .s_axis_a_tvalid(r_mul_pow_vld),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(r_mul_pow),
    .m_axis_result_tvalid(r_rmulpow_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(rrmulpow)
);

floating_point_0  alpha_mul_2(
    .aclk(clk),
    .s_axis_a_tvalid(alpha_r_vld),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(alpha_r),
    .s_axis_b_tvalid(alpha_r_vld),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(64'h4000000000000000),
    .m_axis_result_tvalid(alphamul2_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(alphamul2)
);

assign  kt3_result_start = alphamul2_vld & r_rmulpow_vld;

floating_point_0  mul_result(
    .aclk(clk),
    .s_axis_a_tvalid(kt3_result_start),
    .s_axis_a_tready(a_ready_4),
    .s_axis_a_tdata(alphamul2),
    .s_axis_b_tvalid(kt3_result_start),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(rrmulpow),
    .m_axis_result_tvalid(kt3_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(kt3_result)
);

endmodule