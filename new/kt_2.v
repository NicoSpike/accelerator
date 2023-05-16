`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/18 09:34:14
// Design Name: 
// Module Name: kt_2
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


module kt_2(
input     wire                     clk,
input     wire    [63:0]         psi_i,
input     wire    [63:0]      psi_pow4,
input     wire             psipow4_vld,   
input     wire    [63:0]       alpha_r,
input     wire             alpha_r_vld,
input     wire    [63:0]         psi_r,
input     wire               psi_r_vld,
output    wire    [63:0]    kt2_result,
output    wire          kt2_result_vld,
output    wire    [63:0]       powsub4,
output    wire    [63:0]       powsub5,
output    wire             powsub4_vld,
output    wire             powsub5_vld
    );

/*******************************/
wire                  a_ready_1;
wire                  a_ready_2;
wire                  a_ready_3;
wire                  a_ready_4;
wire                  a_ready_5;
wire                  a_ready_6;
/*******************************/
wire                  b_ready_1;
wire                  b_ready_2;
wire                  b_ready_3;
wire                  b_ready_4;
/*******************************/
wire   [63:0]           powsub1;
wire   [63:0]       alphamulpsi;
wire   [63:0]   alphamulpsisub2;
/*******************************/
wire                powsub1_vld;
wire            alphamulpsi_vld;
wire        alphamulpsisub2_vld;
wire              powsub5_start;
wire           kt2_result_start;

floating_point_4  pow_1(
    .aclk(clk),
    .s_axis_a_tvalid(psipow4_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(psi_i),
    .m_axis_result_tvalid(powsub1_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(powsub1)
);

floating_point_4  pow_4(
    .aclk(clk),
    .s_axis_a_tvalid(psipow4_vld),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(psi_pow4),
    .m_axis_result_tvalid(powsub4_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(powsub4)
);

assign powsub5_start = powsub1_vld & powsub4_vld;

floating_point_0  m_psi_sub14(
    .aclk(clk),
    .s_axis_a_tvalid(powsub5_start),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(powsub1),
    .s_axis_b_tvalid(powsub5_start),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(powsub4),
    .m_axis_result_tvalid(powsub5_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(powsub5)
);

floating_point_0  m_psi_alpha_r(
    .aclk(clk),
    .s_axis_a_tvalid(alpha_r_vld),
    .s_axis_a_tready(a_ready_4),
    .s_axis_a_tdata(alpha_r),
    .s_axis_b_tvalid(psi_r_vld),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(psi_r),
    .m_axis_result_tvalid(alphamulpsi_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(alphamulpsi)
);

floating_point_0  alphamulpsi_sub2(
    .aclk(clk),
    .s_axis_a_tvalid(alphamulpsi_vld),
    .s_axis_a_tready(a_ready_5),
    .s_axis_a_tdata(alphamulpsi),
    .s_axis_b_tvalid(alphamulpsi_vld),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(64'h4000000000000000),
    .m_axis_result_tvalid(alphamulpsisub2_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(alphamulpsisub2)
);

assign  kt2_result_start = powsub5_vld  & alphamulpsisub2_vld;

floating_point_0  mul_result(
    .aclk(clk),
    .s_axis_a_tvalid(kt2_result_start),
    .s_axis_a_tready(a_ready_6),
    .s_axis_a_tdata(alphamulpsisub2),
    .s_axis_b_tvalid(kt2_result_start),
    .s_axis_b_tready(b_ready_4),
    .s_axis_b_tdata(powsub5),
    .m_axis_result_tvalid(kt2_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(kt2_result)
);

endmodule