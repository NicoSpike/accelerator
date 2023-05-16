`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/14 09:08:55
// Design Name: 
// Module Name: second_derivative
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


module second_derivative(
input      wire                   clk,
input      wire                 start,
input      wire    [63:0]      isub_1,
input      wire    [63:0]      isub_2,
input      wire    [63:0]           i,
input      wire    [63:0]      iadd_1,
input      wire    [63:0]      iadd_2,
output     wire    [63:0]    second_d,
output     wire        second_d_valid
    );

/******************************/
reg               a_valid_1 = 0;
reg               a_valid_2 = 0;
reg               a_valid_3 = 0;
/******************************/
reg               b_valid_1 = 0;
reg               b_valid_2 = 0;
reg               b_valid_3 = 0;
/******************************/
wire                 a_ready_1;
wire                 a_ready_2;
wire                 a_ready_3;
wire                 a_ready_4;
wire                 a_ready_5;
wire                 a_ready_6;
wire                 a_ready_7;
wire                 a_ready_8;
/******************************/
wire                 b_ready_1;
wire                 b_ready_2;
wire                 b_ready_3;
wire                 b_ready_4;
wire                 b_ready_5;
wire                 b_ready_6;
wire                 b_ready_7;
wire                 b_ready_8;
/******************************/
wire                r_tvalid_1;
wire                r_tvalid_2;
wire                r_tvalid_3;
wire                r_tvalid_4;
wire                r_tvalid_5;
wire                r_tvalid_6;
wire                r_tvalid_7;
/******************************/
wire    [63:0]       r_tdata_1;
wire    [63:0]       r_tdata_2;
wire    [63:0]       r_tdata_3;
wire    [63:0]       r_tdata_4;
wire    [63:0]       r_tdata_5;
wire    [63:0]       r_tdata_6;
wire    [63:0]       r_tdata_7;


always @ (posedge clk) begin
    if (start) begin
       a_valid_1 <= 1'b1;
       a_valid_2 <= 1'b1;
       a_valid_3 <= 1'b1;
       b_valid_1 <= 1'b1;
       b_valid_2 <= 1'b1;
       b_valid_3 <= 1'b1;
    end
    else begin
       a_valid_1 <= 1'b0;
       a_valid_2 <= 1'b0;
       a_valid_3 <= 1'b0;
       b_valid_1 <= 1'b0;
       b_valid_2 <= 1'b0;
       b_valid_3 <= 1'b0;
    end
end

floating_point_0  iadd_1_m16(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_1),
    .s_axis_a_tready(a_ready_1),
    .s_axis_a_tdata(iadd_1),
    .s_axis_b_tvalid(b_valid_1),
    .s_axis_b_tready(b_ready_1),
    .s_axis_b_tdata(64'h4030000000000000),
    .m_axis_result_tvalid(r_tvalid_1),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_1)
);

floating_point_0  isub_1_m16(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_2),
    .s_axis_a_tready(a_ready_2),
    .s_axis_a_tdata(isub_1),
    .s_axis_b_tvalid(b_valid_2),
    .s_axis_b_tready(b_ready_2),
    .s_axis_b_tdata(64'h4030000000000000),
    .m_axis_result_tvalid(r_tvalid_2),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_2)
);

floating_point_0   i_m30(
    .aclk(clk),
    .s_axis_a_tvalid(a_valid_3),
    .s_axis_a_tready(a_ready_3),
    .s_axis_a_tdata(i),
    .s_axis_b_tvalid(b_valid_3),
    .s_axis_b_tready(b_ready_3),
    .s_axis_b_tdata(64'h403E000000000000),
    .m_axis_result_tvalid(r_tvalid_3),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_3)
);

floating_point_2  add(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_1),
    .s_axis_a_tready(a_ready_4),
    .s_axis_a_tdata(r_tdata_1),
    .s_axis_b_tvalid(r_tvalid_1),
    .s_axis_b_tready(b_ready_4),
    .s_axis_b_tdata({~iadd_2[63],iadd_2[62:0]}),
    .m_axis_result_tvalid(r_tvalid_4),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_4)
);//-y[i+2]+16*y[i+1]


floating_point_2  add_1(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_4),
    .s_axis_a_tready(a_ready_5),
    .s_axis_a_tdata(r_tdata_4),
    .s_axis_b_tvalid(r_tvalid_4),
    .s_axis_b_tready(b_ready_5),
    .s_axis_b_tdata({~r_tdata_3[63],r_tdata_3[62:0]}),
    .m_axis_result_tvalid(r_tvalid_5),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_5)
);//-y[i+2]+16*y[i+1]-30*y[i]

floating_point_2  add_2(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_5),
    .s_axis_a_tready(a_ready_6),
    .s_axis_a_tdata(r_tdata_5),
    .s_axis_b_tvalid(r_tvalid_5),
    .s_axis_b_tready(b_ready_6),
    .s_axis_b_tdata(r_tdata_2),
    .m_axis_result_tvalid(r_tvalid_6),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_6)
);  //-y[i+2]+16*y[i+1]-30*y[i]+16*y[i-1]


floating_point_1  minus(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_6),
    .s_axis_a_tready(a_ready_7),
    .s_axis_a_tdata(r_tdata_6),
    .s_axis_b_tvalid(r_tvalid_6),
    .s_axis_b_tready(b_ready_7),
    .s_axis_b_tdata(isub_2),
    .m_axis_result_tvalid(r_tvalid_7),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(r_tdata_7)
  );

floating_point_3  divide_1(
    .aclk(clk),
    .s_axis_a_tvalid(r_tvalid_7),
    .s_axis_a_tready(a_ready_8),
    .s_axis_a_tdata(r_tdata_7),
    .s_axis_b_tvalid(r_tvalid_7),
    .s_axis_b_tready(b_ready_8),
    .s_axis_b_tdata(64'h3FBEB851EB851EBA),
    .m_axis_result_tvalid(second_d_valid),
    .m_axis_result_tready(1'b1),
    .m_axis_result_tdata(second_d)
  );

endmodule