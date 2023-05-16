`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/16 10:03:41
// Design Name: 
// Module Name: K_t
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


module K_t(
input      wire                     clk,
input      wire                   start,
input      wire   [63:0]        alpha_r,
input      wire             alpha_r_vld,
input      wire   [63:0]          psi_r,
input      wire               psi_r_vld,
input      wire   [63:0]       alpha_rr,
input      wire            alpha_rr_vld,
input      wire   [63:0]          psi_i,
input      wire   [63:0]            r_i,
input      wire   [63:0]        alpha_i,
input      wire   [63:0]            K_i,
input      wire   [63:0]         pi_m_i,
input      wire   [63:0]          phi_i,
input      wire   [63:0]    alpha_mul_k,
input      wire           alphamulk_vld,
input      wire   [63:0]       psi_pow4,
input      wire             psipow4_vld,
output     wire   [63:0]        powsub4,
output     wire   [63:0]        powsub5,
output     wire   [63:0]       rrmulpow,
output     wire             powsub4_vld,
output     wire             powsub5_vld,
output     wire           r_rmulpow_vld,
output     wire   [63:0]            K_t,
output     wire                 K_t_vld
);



wire  [63:0]   kt1_result;
wire  [63:0]   kt2_result;
wire  [63:0]   kt3_result;
wire  [63:0]   kt4_result;
wire  [63:0]   kt5_result;
wire       kt1_result_vld;
wire       kt2_result_vld;
wire       kt3_result_vld;
wire       kt4_result_vld;
wire       kt5_result_vld;

kt_1  kt1 (
     .clk(clk),
     .psi_pow4(psi_pow4),
     .psipow4_vld(psipow4_vld),    
     .alpha_rr(alpha_rr),
     .alpha_rr_vld(alpha_rr_vld),
     .kt1_result(kt1_result),
     .kt1_result_vld(kt1_result_vld)
);

kt_2  kt2 (
     .clk(clk),
     .psi_i(psi_i),
     .psi_pow4(psi_pow4),
     .psipow4_vld(psipow4_vld),   
     .alpha_r(alpha_r),
     .alpha_r_vld(alpha_r_vld),
     .psi_r(psi_r),
     .psi_r_vld(psi_r_vld),
     .kt2_result(kt2_result),
     .kt2_result_vld(kt2_result_vld),
     .powsub4(powsub4),
     .powsub5(powsub5),
     .powsub4_vld(powsub4_vld),
     .powsub5_vld(powsub5_vld)
);

kt_3  kt3 (
     .clk(clk),
     .psi_pow4(psi_pow4),
     .psipow4_vld(psipow4_vld),
     .r_i(r_i),
     .alpha_r(alpha_r),
     .alpha_r_vld(alpha_r_vld),
     .kt3_result(kt3_result),
     .kt3_result_vld(kt3_result_vld),
     .rrmulpow(rrmulpow),
     .r_rmulpow_vld(r_rmulpow_vld)
);

kt_4  kt4 (
     .clk(clk),
     .alpha_mul_k(alpha_mul_k),
     .alphamulk_vld(alphamulk_vld),
     .K_i(K_i),
     .kt4_result(kt4_result),
     .kt4_result_vld(kt4_result_vld)
);

kt_5 kt5 (
     .clk(clk),
     .start(start),
     .pi_m_i(pi_m_i),
     .alpha_i(alpha_i),
     .phi_i(phi_i),
     .kt5_result(kt5_result),
     .kt5_result_vld(kt5_result_vld)
);

wire               step1_start;
wire               step2_start;
wire               step3_start;
wire              step1_finish;
wire              step2_finish;
wire              step3_finish;
wire    [63:0]    step1_result;
wire    [63:0]    step2_result;
wire    [63:0]    step3_result;
wire               step1_a_rdy;
wire               step1_b_rdy;
wire               step2_a_rdy;
wire               step2_b_rdy;
wire               step3_a_rdy;
wire               step3_b_rdy;
wire               step4_a_rdy;
wire               step4_b_rdy;
wire           kt_result_start;


assign   step1_start  = kt1_result_vld & kt2_result_vld;
//assign   step2_start  = kt3_result_vld & kt4_result_vld;

//floating_point_1  minus_1(
//    .aclk(clk),
//    .s_axis_a_tvalid(step1_start),
//    .s_axis_a_tready(step1_a_rdy),
//    .s_axis_a_tdata(kt1_result[63]),
//    .s_axis_b_tvalid(step1_start),
//    .s_axis_b_tready(step1_b_rdy),
//    .s_axis_b_tdata(kt2_result), //kt2 0xc0000000000
//    .m_axis_result_tvalid(step1_finish),
//    .m_axis_result_tready(1'b1),
//    .m_axis_result_tdata(step1_result)
//);


floating_point_1  minus_1(
    .aclk(clk),
    .s_axis_a_tvalid(step1_start),
    .s_axis_a_tready(step1_a_rdy),
    .s_axis_a_tdata({~kt1_result[63],kt1_result[62:0]}),
    .s_axis_b_tvalid(step1_start),
    .s_axis_b_tready(step1_b_rdy),
    .s_axis_b_tdata(kt2_result),
    .m_axis_result_tvalid(step1_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step1_result)
);

//floating_point_1  minus_2(
//    .aclk(clk),
//    .s_axis_a_tvalid(step2_start),
//    .s_axis_a_tready(step2_a_rdy),
//    .s_axis_a_tdata(kt4_result),
//    .s_axis_b_tvalid(step2_start),
//    .s_axis_b_tready(step2_b_rdy),
//    .s_axis_b_tdata(kt3_result),
//    .m_axis_result_tvalid(step2_finish),
//    .m_axis_result_tready(1'b1),
//    .m_axis_result_tdata(step2_result)
//);

assign step2_start  = kt3_result_vld & step1_finish;

floating_point_1  minus_2(
    .aclk(clk),
    .s_axis_a_tvalid(step2_start),
    .s_axis_a_tready(step2_a_rdy),
    .s_axis_a_tdata(step1_result),
    .s_axis_b_tvalid(step2_start),
    .s_axis_b_tready(step2_b_rdy),
    .s_axis_b_tdata(kt3_result),
    .m_axis_result_tvalid(step2_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step2_result)
);

//assign step3_start = step1_finish & step2_finish;

//floating_point_2  add_1(
//    .aclk(clk),
//    .s_axis_a_tvalid(step3_start),
//    .s_axis_a_tready(step3_a_rdy),
//    .s_axis_a_tdata(step1_result),
//    .s_axis_b_tvalid(step3_start),
//    .s_axis_b_tready(step3_b_rdy),
//    .s_axis_b_tdata(step2_result),
//    .m_axis_result_tvalid(step3_finish),
//    .m_axis_result_tready(1'b1),
//    .m_axis_result_tdata(step3_result)
//  );
assign step3_start = step2_finish & kt4_result_vld;

floating_point_2  add_1(
    .aclk(clk),
    .s_axis_a_tvalid(step3_start),
    .s_axis_a_tready(step3_a_rdy),
    .s_axis_a_tdata(step2_result),
    .s_axis_b_tvalid(step3_start),
    .s_axis_b_tready(step3_b_rdy),
    .s_axis_b_tdata(kt4_result),
    .m_axis_result_tvalid(step3_finish),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(step3_result)
  );


assign kt_result_start = step3_finish & kt5_result_vld;

floating_point_2  add_2(
    .aclk(clk),
    .s_axis_a_tvalid(kt_result_start),
    .s_axis_a_tready(step4_a_rdy),
    .s_axis_a_tdata(step3_result),
    .s_axis_b_tvalid(kt_result_start),
    .s_axis_b_tready(step4_b_rdy),
    .s_axis_b_tdata(kt5_result),
    .m_axis_result_tvalid(K_t_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(K_t)
  );

endmodule