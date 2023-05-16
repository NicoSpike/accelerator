`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 10:41:14
// Design Name: 
// Module Name: kt_1
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


module kt_1(
input     wire                     clk,
input     wire    [63:0]      psi_pow4,
input     wire             psipow4_vld,   
input     wire    [63:0]      alpha_rr,
input     wire            alpha_rr_vld,
output    wire    [63:0]    kt1_result,
output    wire          kt1_result_vld
    );

/*************************/
wire             a_ready_1;
wire             a_ready_2;
/*************************/
wire             b_ready_1;
/*************************/
wire   [63:0]      powsub4;
wire           powsub4_vld;
wire      kt1_result_start;

assign  kt1_result_start = powsub4_vld & alpha_rr_vld;

floating_point_4  pow_4(
    .aclk(clk),
    .s_axis_a_tvalid(psipow4_vld),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(psi_pow4),
    .m_axis_result_tvalid(powsub4_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(powsub4)
  );

floating_point_0  m(
    .aclk(clk),
    .s_axis_a_tvalid(kt1_result_start),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(powsub4),
    .s_axis_b_tvalid(kt1_result_start),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(alpha_rr),
    .m_axis_result_tvalid(kt1_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(kt1_result)
);

endmodule