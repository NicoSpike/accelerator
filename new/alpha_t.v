`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/14 17:12:48
// Design Name: 
// Module Name: alpha_t
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


module alpha_t(
input    wire                     clk,
input    wire                   start,
input    wire   [63:0]        alpha_i,
input    wire   [63:0]            K_i,
output   wire   [63:0]        alpha_t,
output   wire   [63:0]    alpha_mul_k,
output   wire           alphamulk_vld,
output   wire             alpha_t_vld
    );
    
reg            a_valid_1 = 0;
reg            b_valid_1 = 0;
wire               a_ready_1;
wire               a_ready_2;
wire               b_ready_1;
wire               b_ready_2;

always @ (posedge clk) begin
   if (start) begin
      a_valid_1 <= 1'b1;
      b_valid_1 <= 1'b1;
   end
   else begin
      a_valid_1 <= 1'b0;
      b_valid_1 <= 1'b0;
   end
end

floating_point_0  iadd_1_m8(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_1),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(alpha_i),
    .s_axis_b_tvalid(b_valid_1),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(K_i),
    .m_axis_result_tvalid(alphamulk_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(alpha_mul_k)
);

floating_point_0  m2(
    .aclk(clk),
    .s_axis_a_tvalid(alphamulk_vld),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(alpha_mul_k),
    .s_axis_b_tvalid(alphamulk_vld),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(64'hC000000000000000),
    .m_axis_result_tvalid(alpha_t_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(alpha_t)
);

endmodule