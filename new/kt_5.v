`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/19 16:08:50
// Design Name: 
// Module Name: kt_5
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
module kt_5(
input     wire                      clk,
input     wire                    start,
input     wire   [63:0]          pi_m_i,
input     wire   [63:0]         alpha_i,
input     wire   [63:0]           phi_i,
output    wire   [63:0]      kt5_result,
output    wire           kt5_result_vld
);

/*******************************/
reg               a_valid_1 = 0;
reg               b_valid_1 = 0;
reg               a_valid_2 = 0;
reg               b_valid_2 = 0;
reg               a_valid_3 = 0;
reg               b_valid_3 = 0;
/*******************************/
wire                  a_ready_1;
wire                  b_ready_1;
wire                  a_ready_2;
wire                  b_ready_2;
wire                  a_ready_3;
wire                  b_ready_3;
wire                  a_ready_4;
wire                  b_ready_4;
wire                  a_ready_5;
wire                  b_ready_5;
wire                  a_ready_6;
wire                  b_ready_6;
wire                  a_ready_7;
wire                  b_ready_7;
/*******************************/
wire           kt5_result_start;
/*******************************/
wire                 r_tvalid_1;
wire                 r_tvalid_2;
wire                 r_tvalid_3;
wire                 r_tvalid_4;
wire                 r_tvalid_5;
/*******************************/
wire   [63:0]         r_tdata_1;
wire   [63:0]         r_tdata_2;
wire   [63:0]         r_tdata_3;
wire   [63:0]         r_tdata_4;
wire   [63:0]         r_tdata_5;
wire   [63:0]         r_tdata_6;
/*******************************/

always @ (posedge clk) begin
   if (start == 1'b1) begin
      a_valid_1 <= 1'b1;
      b_valid_1 <= 1'b1;
      a_valid_2 <= 1'b1;
      b_valid_2 <= 1'b1;
      a_valid_3 <= 1'b1;
      b_valid_3 <= 1'b1;
   end
   else begin
      a_valid_1 <= 1'b0;
      b_valid_1 <= 1'b0;
      a_valid_2 <= 1'b0;
      b_valid_2 <= 1'b0;
      a_valid_3 <= 1'b0;
      b_valid_3 <= 1'b0;
   end
end

floating_point_0  m1 (
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_1),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(pi_m_i),
    .s_axis_b_tvalid(b_valid_1),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(pi_m_i),
    .m_axis_result_tvalid(r_tvalid_1),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_1)
);

floating_point_0  m2 (
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_2),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(phi_i),
    .s_axis_b_tvalid(b_valid_2),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(phi_i),
    .m_axis_result_tvalid(r_tvalid_2),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_2)
);

floating_point_0  m1_1 (
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_1),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(r_tdata_1),
    .s_axis_b_tvalid(r_tvalid_1),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(64'h4000000000000000),
    .m_axis_result_tvalid(r_tvalid_3),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_3)
);

floating_point_0  m2_1 (
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_2),
    .s_axis_a_tready(a_ready_4),
    .s_axis_a_tdata(r_tdata_2),
    .s_axis_b_tvalid(r_tvalid_2),
    .s_axis_b_tready(b_ready_4),
    .s_axis_b_tdata(64'h4050000000000000),
    .m_axis_result_tvalid(r_tvalid_4),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_4)
);

floating_point_1  minus_1 (
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_3),
    .s_axis_a_tready(a_ready_5),
    .s_axis_a_tdata(r_tdata_3),
    .s_axis_b_tvalid(r_tvalid_4),
    .s_axis_b_tready(b_ready_5),
    .s_axis_b_tdata(r_tdata_4),
    .m_axis_result_tvalid(r_tvalid_5),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_5)
  );

floating_point_0  m3 (
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_5),
    .s_axis_a_tready(a_ready_6),
    .s_axis_a_tdata(alpha_i),
    .s_axis_b_tvalid(r_tvalid_5),
    .s_axis_b_tready(b_ready_6),
    .s_axis_b_tdata(64'h402921FB54442D18),
    .m_axis_result_tvalid(kt5_result_start),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_6)
);

floating_point_0  k5_result (
    .aclk(clk),
    .s_axis_a_tvalid(kt5_result_start),
    .s_axis_a_tready(a_ready_7),
    .s_axis_a_tdata(r_tdata_5),
    .s_axis_b_tvalid(kt5_result_start),
    .s_axis_b_tready(b_ready_7),
    .s_axis_b_tdata(r_tdata_6),
    .m_axis_result_tvalid(kt5_result_vld),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(kt5_result)
);

endmodule