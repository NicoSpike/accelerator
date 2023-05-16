`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 16:25:55
// Design Name: 
// Module Name: pi_m_t
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


module pi_m_t (
input      wire                     clk,
input      wire                   start,
input      wire   [63:0]        alpha_r,
input      wire             alpha_r_vld,
input      wire   [63:0]          psi_r,
input      wire               psi_r_vld,
input      wire   [63:0]          phi_r,
input      wire               phi_r_vld,
input      wire   [63:0]         phi_rr,
input      wire              phi_rr_vld,
input      wire   [63:0]          psi_i,
input      wire   [63:0]            r_i,
input      wire   [63:0]        alpha_i,
input      wire   [63:0]            K_i,
input      wire   [63:0]         pi_m_i,
input      wire   [63:0]          phi_i,
input      wire   [63:0]    alpha_mul_k,
input      wire           alphamulk_vld,
input      wire   [63:0]        powsub4,
input      wire   [63:0]        powsub5,
input      wire   [63:0]       rrmulpow,
input      wire             powsub4_vld,
input      wire             powsub5_vld,
input      wire           r_rmulpow_vld,
output     wire   [63:0]         pi_m_t,
output     wire              pi_m_t_vld
    );

wire   [63:0]       pimt1_result;
wire   [63:0]       pimt2_result;
wire   [63:0]       pimt3_result;
wire   [63:0]       pimt4_result;
wire   [63:0]       pimt5_result;
wire   [63:0]       pimt6_result;
wire            pimt1_result_vld;
wire            pimt2_result_vld;
wire            pimt3_result_vld;
wire            pimt4_result_vld;
wire            pimt5_result_vld;
wire            pimt6_result_vld;

pimt_1  pimt1 (
       .clk(clk),
       .alpha_mul_k(alpha_mul_k),
       .alphamulk_vld(alphamulk_vld),
       .pi_m_i(pi_m_i),
       .pimt1_result(pimt1_result),
       .pimt1_result_vld(pimt1_result_vld)
);

pimt_2  pimt2 ( 
       .clk(clk),
       .powsub4(powsub4),
       .powsub4_vld(powsub4_vld),
       .alpha_r(alpha_r),
       .alpha_r_vld(alpha_r_vld),
       .phi_r(phi_r),
       .phi_r_vld(phi_r_vld),
       .pimt2_result(pimt2_result),
       .pimt2_result_vld(pimt2_result_vld)
    );
    
pimt_3  pimt3 (
       .clk(clk),
       .powsub4(powsub4),
       .powsub4_vld(powsub4_vld),
       .alpha_i(alpha_i),
       .phi_rr(phi_rr),
       .phi_rr_vld(phi_rr_vld),
       .pimt3_result(pimt3_result),
       .pimt3_result_vld(pimt3_result_vld)
    );
    
pimt_4  pimt4 (
       .clk(clk),
       .psi_r(psi_r),
       .psi_r_vld(psi_r_vld),
       .phi_r(phi_r),
       .phi_r_vld(phi_r_vld),
       .powsub5(powsub5),
       .powsub5_vld(powsub5_vld),
       .alpha_i(alpha_i),
       .pimt4_result(pimt4_result),
       .pimt4_result_vld(pimt4_result_vld)
    );

pimt_5  pimt5 (
       .clk(clk),
       .phi_r(phi_r),
       .phi_r_vld(phi_r_vld),
       .rrmulpow(rrmulpow),
       .r_rmulpow_vld(r_rmulpow_vld),
       .alpha_i(alpha_i),
       .pimt5_result(pimt5_result),
       .pimt5_result_vld(pimt5_result_vld)
    );
    
pimt_6  pimt6 (
       .clk(clk),
       .start(start),
       .alpha_i(alpha_i),
       .phi_i(phi_i),
       .pimt6_result(pimt6_result),
       .pimt6_result_vld(pimt6_result_vld)
    );

wire               step1_start;
wire               step2_start;
wire               step3_start;
wire               step4_start;
wire              step1_finish;
wire              step2_finish;
wire              step3_finish;
wire              step4_finish;
wire    [63:0]    step1_result;
wire    [63:0]    step2_result;
wire    [63:0]    step3_result;
wire    [63:0]    step4_result;
wire               step1_a_rdy;
wire               step1_b_rdy;
wire               step2_a_rdy;
wire               step2_b_rdy;
wire               step3_a_rdy;
wire               step3_b_rdy;
wire               step4_a_rdy;
wire               step4_b_rdy;
wire               step5_a_rdy;
wire               step5_b_rdy;
wire         pimt_result_start;


assign   step1_start  = pimt1_result_vld & pimt2_result_vld;
assign   step2_start  = pimt3_result_vld & pimt4_result_vld;
assign   step3_start  = pimt5_result_vld & pimt6_result_vld;
assign   step4_start  = step1_finish & step2_finish;

floating_point_1  minus_1(
    .aclk(clk),
    .s_axis_a_tvalid(step1_start),
    .s_axis_a_tready(step1_a_rdy),
    .s_axis_a_tdata(pimt1_result),
    .s_axis_b_tvalid(step1_start),
    .s_axis_b_tready(step1_b_rdy),
    .s_axis_b_tdata(pimt2_result),
    .m_axis_result_tvalid(step1_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step1_result)
);

floating_point_1  minus_2(
    .aclk(clk),
    .s_axis_a_tvalid(step2_start),
    .s_axis_a_tready(step2_a_rdy),
    .s_axis_a_tdata(pimt3_result),
    .s_axis_b_tvalid(step2_start),
    .s_axis_b_tready(step2_b_rdy),
    .s_axis_b_tdata(pimt4_result),
    .m_axis_result_tvalid(step2_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step2_result)
);

floating_point_2  add_1(
    .aclk(clk),
    .s_axis_a_tvalid(step3_start),
    .s_axis_a_tready(step3_a_rdy),
    .s_axis_a_tdata(pimt5_result),
    .s_axis_b_tvalid(step3_start),
    .s_axis_b_tready(step3_b_rdy),
    .s_axis_b_tdata(pimt6_result),
    .m_axis_result_tvalid(step3_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step3_result)
  );

floating_point_2  add_2(
    .aclk(clk),
    .s_axis_a_tvalid(step4_start),
    .s_axis_a_tready(step4_a_rdy),
    .s_axis_a_tdata(step1_result),
    .s_axis_b_tvalid(step4_start),
    .s_axis_b_tready(step4_b_rdy),
    .s_axis_b_tdata(step2_result),
    .m_axis_result_tvalid(step4_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step4_result)
  );

assign pimt_result_start = step3_finish & step4_finish;

floating_point_2  pimt_r (
    .aclk(clk),
    .s_axis_a_tvalid(pimt_result_start),
    .s_axis_a_tready(step5_a_rdy),
    .s_axis_a_tdata(step3_result),
    .s_axis_b_tvalid(pimt_result_start),
    .s_axis_b_tready(step5_b_rdy),
    .s_axis_b_tdata(step4_result),
    .m_axis_result_tvalid(pi_m_t_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(pi_m_t)
  );

endmodule