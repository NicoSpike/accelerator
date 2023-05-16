`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/07 09:12:49
// Design Name: 
// Module Name: calculation core
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


module calculation_core (
input   wire                    clk,
input   wire                  start,
input   wire   [63:0]           r_i,
input   wire   [63:0]           K_i,
input   wire   [63:0]        pi_m_i,
input   wire   [63:0]   alphaisub_1,
input   wire   [63:0]   alphaisub_2,
input   wire   [63:0]       alpha_i,
input   wire   [63:0]   alphaiadd_1,
input   wire   [63:0]   alphaiadd_2,
input   wire   [63:0]     phiisub_1,
input   wire   [63:0]     phiisub_2,
input   wire   [63:0]         phi_i,
input   wire   [63:0]     phiiadd_1,
input   wire   [63:0]     phiiadd_2,
input   wire   [63:0]     psiisub_1,
input   wire   [63:0]     psiisub_2,
input   wire   [63:0]         psi_i,
input   wire   [63:0]     psiiadd_1,
input   wire   [63:0]     psiiadd_2,
output  wire   [63:0]       alpha_t,
output  wire   [63:0]           K_t,
output  wire   [63:0]         phi_t,
output  wire   [63:0]        pi_m_t,
output  wire   [63:0]         psi_t,
output  wire                 finish,
output  wire             start_flag
    );

/******************************/
wire   [63:0]           alpha_r;
wire   [63:0]             phi_r;
wire   [63:0]             psi_r;
wire   [63:0]          alpha_rr;
wire   [63:0]            phi_rr;
wire                alpha_r_vld;
wire                  phi_r_vld;
wire                  psi_r_vld;
wire               alpha_rr_vld;
wire                 phi_rr_vld;
/******************************/
wire   [63:0]       alpha_mul_k;
wire   [63:0]          psi_pow4;
wire               psi_pow4_vld;
wire                alpha_t_vld;
wire              alphamulk_vld;
wire   [63:0]           powsub4;
wire   [63:0]           powsub5;
wire   [63:0]          rrmulpow;
wire                powsub4_vld;
wire                powsub5_vld;
wire              r_rmulpow_vld;
wire                    K_t_vld;
wire                  phi_t_vld;
wire                 pi_m_t_vld;
wire                  psi_t_vld;



first_derivative  alphar (
     .clk(clk),
     .start(start),
     .isub_1(alphaisub_1),
     .isub_2(alphaisub_2),
     .iadd_1(alphaiadd_1),
     .iadd_2(alphaiadd_2),
     .first_d(alpha_r),
     .first_d_valid(alpha_r_vld)
);

first_derivative  phir (
     .clk(clk),
     .start(start),
     .isub_1(phiisub_1),
     .isub_2(phiisub_2),
     .iadd_1(phiiadd_1),
     .iadd_2(phiiadd_2),
     .first_d(phi_r),
     .first_d_valid(phi_r_vld)
);

first_derivative  psir (
     .clk(clk),
     .start(start),
     .isub_1(psiisub_1),
     .isub_2(psiisub_2),
     .iadd_1(psiiadd_1),
     .iadd_2(psiiadd_2),
     .first_d(psi_r),
     .first_d_valid(psi_r_vld)
);

second_derivative  alpharr (
      .clk(clk),
      .start(start),
      .isub_1(alphaisub_1),
      .isub_2(alphaisub_2),
      .i(alpha_i),
      .iadd_1(alphaiadd_1),
      .iadd_2(alphaiadd_2),
      .second_d(alpha_rr),
      .second_d_valid(alpha_rr_vld)
);

second_derivative  phirr (
      .clk(clk),
      .start(start),
      .isub_1(phiisub_1),
      .isub_2(phiisub_2),
      .i(phi_i),
      .iadd_1(phiiadd_1),
      .iadd_2(phiiadd_2),
      .second_d(phi_rr),
      .second_d_valid(phi_rr_vld)
);

psi_pow4 psipow4 (
      .clk(clk),
      .start(start),
      .psi_i(psi_i),
      .psi_pow4(psi_pow4),
      .psi_pow4_vld(psi_pow4_vld)
);

alpha_t  alphat (
      .clk(clk),
      .start(start),
      .alpha_i(alpha_i),
      .K_i(K_i),
      .alpha_t(alpha_t),
      .alpha_t_vld(alpha_t_vld),
      .alpha_mul_k(alpha_mul_k),
      .alphamulk_vld(alphamulk_vld)
);
    
K_t kt (
      .clk(clk),
      .start(start),
      .alpha_r(alpha_r),
      .alpha_r_vld(alpha_r_vld),
      .psi_r(psi_r),
      .psi_r_vld(psi_r_vld),
      .alpha_rr(alpha_rr),
      .alpha_rr_vld(alpha_rr_vld),
      .psi_i(psi_i),
      .r_i(r_i),
      .alpha_i(alpha_i),
      .K_i(K_i),
      .pi_m_i(pi_m_i),
      .phi_i(phi_i),
      .alpha_mul_k(alpha_mul_k),
      .alphamulk_vld(alphamulk_vld),
      .psi_pow4(psi_pow4),
      .psipow4_vld(psi_pow4_vld),
      .powsub4(powsub4),
      .powsub5(powsub5),
      .rrmulpow(rrmulpow),
      .powsub4_vld(powsub4_vld),
      .powsub5_vld(powsub5_vld),
      .r_rmulpow_vld(r_rmulpow_vld),
      .K_t(K_t),
      .K_t_vld(K_t_vld)
);

phi_t phit (
      .clk(clk),
      .start(start),
      .alpha_i(alpha_i),
      .pi_m_i(pi_m_i),
      .phi_t(phi_t),
      .phi_t_vld(phi_t_vld)
);

pi_m_t  pimt (
      .clk(clk),
      .start(start),
      .alpha_r(alpha_r),
      .alpha_r_vld(alpha_r_vld),
      .psi_r(psi_r),
      .psi_r_vld(psi_r_vld),
      .phi_r(phi_r),
      .phi_r_vld(phi_r_vld),
      .phi_rr(phi_rr),
      .phi_rr_vld(phi_rr_vld),
      .psi_i(psi_i),
      .r_i(r_i),
      .alpha_i(alpha_i),
      .K_i(K_i),
      .pi_m_i(pi_m_i),
      .phi_i(phi_i),
      .alpha_mul_k(alpha_mul_k),
      .alphamulk_vld(alphamulk_vld),
      .powsub4(powsub4),
      .powsub5(powsub5),
      .rrmulpow(rrmulpow),
      .powsub4_vld(powsub4_vld),
      .powsub5_vld(powsub5_vld),
      .r_rmulpow_vld(r_rmulpow_vld),
      .pi_m_t(pi_m_t),
      .pi_m_t_vld(pi_m_t_vld)
);

psi_t   psit (
      .clk(clk),
      .alpha_mul_k(alpha_mul_k),
      .alphamulk_vld(alphamulk_vld),
      .psi_i(psi_i),
      .psi_t(psi_t),
      .psi_t_vld(psi_t_vld)
);

assign  finish = alpha_t_vld & K_t_vld & phi_t_vld & pi_m_t_vld & psi_t_vld;
assign  start_flag = alpha_t_vld | K_t_vld | phi_t_vld | pi_m_t_vld | psi_t_vld;

endmodule