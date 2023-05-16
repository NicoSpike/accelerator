`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/02 15:39:25
// Design Name: 
// Module Name: inidata_down
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


module inidata_down # (
     parameter mem_depth = 10000
)(
input    wire                                 clk,
input    wire      [511:0]            cal_in_data,
input    wire      [7:0]                   wr_cnt,
input    wire      [7:0]                   rd_cnt,
output   wire      [63:0]                     r_i,
output   wire      [63:0]                     K_i,
output   wire      [63:0]                  pi_m_i,
output   wire      [63:0]             alphaisub_1,
output   wire      [63:0]             alphaisub_2,
output   wire      [63:0]                 alpha_i,
output   wire      [63:0]             alphaiadd_1,
output   wire      [63:0]             alphaiadd_2,
output   wire      [63:0]               phiisub_1,
output   wire      [63:0]               phiisub_2,
output   wire      [63:0]                   phi_i,
output   wire      [63:0]               phiiadd_1,
output   wire      [63:0]               phiiadd_2,
output   wire      [63:0]               psiisub_1,
output   wire      [63:0]               psiisub_2,
output   wire      [63:0]                   psi_i,
output   wire      [63:0]               psiiadd_1,
output   wire      [63:0]               psiiadd_2
);

reg   [63:0]  r       [mem_depth - 1:0];
reg   [63:0]  alpha   [mem_depth - 1:0];
reg   [63:0]  K       [mem_depth - 1:0];
reg   [63:0]  phi     [mem_depth - 1:0];
reg   [63:0]  pi_m    [mem_depth - 1:0];
reg   [63:0]  psi     [mem_depth - 1:0];

always @ (posedge clk) begin
      r[wr_cnt] <= cal_in_data[511:448];
end

always @ (posedge clk) begin
      alpha[wr_cnt] <= cal_in_data[447:384];
end

always @ (posedge clk) begin
      K[wr_cnt] <= cal_in_data[383:320];
end

always @ (posedge clk) begin
      phi[wr_cnt] <= cal_in_data[319:256];
end

always @ (posedge clk) begin
      pi_m[wr_cnt] <= cal_in_data[255:192];
end

always @ (posedge clk) begin
      psi[wr_cnt] <= cal_in_data[191:128];
end

assign  r_i = r[rd_cnt];
assign  K_i = K[rd_cnt];
assign  pi_m_i = pi_m[rd_cnt];
assign  alphaisub_1 = alpha[rd_cnt - 'd1];
assign  alphaisub_2 = alpha[rd_cnt - 'd2];
assign  alpha_i = alpha[rd_cnt];
assign  alphaiadd_1 = alpha[rd_cnt + 'd1];
assign  alphaiadd_2 = alpha[rd_cnt + 'd2];
assign  phiisub_1 = phi[rd_cnt - 'd1];
assign  phiisub_2 = phi[rd_cnt - 'd2];
assign  phi_i = phi[rd_cnt];
assign  phiiadd_1 = phi[rd_cnt + 'd1];
assign  phiiadd_2 = phi[rd_cnt + 'd2];
assign  psiisub_1 = psi[rd_cnt - 'd1];
assign  psiisub_2 = psi[rd_cnt - 'd2];
assign  psi_i = psi[rd_cnt];
assign  psiiadd_1 = psi[rd_cnt + 'd1];
assign  psiiadd_2 = psi[rd_cnt + 'd2];

endmodule