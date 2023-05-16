`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/16 16:49:33
// Design Name: 
// Module Name: psi_pow4
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


module psi_pow4(
input     wire                    clk,
input     wire                  start,
input     wire   [63:0]         psi_i,
output    wire           psi_pow4_vld,
output    wire   [63:0]      psi_pow4
);

reg          a_valid_1 = 0;
reg          a_valid_2 = 0;
reg          b_valid_1 = 0;
reg          b_valid_2 = 0;
wire             a_ready_1;
wire             a_ready_2;
wire             a_ready_3;
wire             b_ready_1;
wire             b_ready_2;
wire             b_ready_3;
wire            r_tvalid_1;
wire            r_tvalid_2;
wire   [63:0]    r_tdata_1;
wire   [63:0]    r_tdata_2;

always @ (posedge clk) begin
   if (start) begin
      a_valid_1 <= 1;
      a_valid_2 <= 1;
      b_valid_1 <= 1;
      b_valid_2 <= 1;
   end
   else begin
      a_valid_1 <= 0;
      a_valid_2 <= 0;
      b_valid_1 <= 0;
      b_valid_2 <= 0;
   end
end

floating_point_0  u1(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_1),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(psi_i),
    .s_axis_b_tvalid(b_valid_1),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(psi_i),
    .m_axis_result_tvalid(r_tvalid_1),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_1)
);

floating_point_0  u2(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_2),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(psi_i),
    .s_axis_b_tvalid(b_valid_2),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(psi_i),
    .m_axis_result_tvalid(r_tvalid_2),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_2)
);

floating_point_0  u3(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_1),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(r_tdata_1),
    .s_axis_b_tvalid(r_tvalid_2),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(r_tdata_2),
    .m_axis_result_tvalid(psi_pow4_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(psi_pow4)
);

endmodule