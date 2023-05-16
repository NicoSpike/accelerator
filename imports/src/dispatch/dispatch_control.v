`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 09:39:08 AM
// Design Name: 
// Module Name: dispatch_control
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
module dispatch_control(
  // System Signals
  input  wire                                    clk_sys ,
  input  wire                                    rst_sys ,

  input  wire                                    ddr_initdone ,
  //read send statue
  input wire [6:0]                               rece_qune            ,           
  input wire [6:0]                               send_statue          , 

  //send to other interface
  output reg [6:0]                               send_start           ,  
  input wire [448-1:0]                           sfp_rd_data          ,  

  //frome other interface
  output reg  [6:0]                              sfp_wr_en            ,
  output wire [448-1:0]                          sfp_wr_data          , 
  
  output wire                                    rd_yuv_start         ,  
  output wire [31:0]                             rd_yuv_addr          , 

  input wire                                     rd_yuv_data_vld      ,
  input wire  [7:0]                              rd_yuv_data          
);
//=============================paramer define============================= 
parameter state_idle =4'd0;
parameter state_start=4'd1;
parameter state_poll =4'd2;
parameter state_wait =4'd3;
parameter state_inqu =4'd4;
parameter state_send =4'd5;
//=============================signal define============================= 
reg [  3: 0]        curr_state;
reg [  3: 0]        next_state;

reg [3:0]           cnt;
wire                poll_en;
reg [15:0]          match_en;
wire[8 :0]          tx_send_statue;    
reg [63 :0]         send_buff;
wire[63 :0]         sfp_rd_data_reg[6:0];
wire[63 :0]         rd_yuv_addr_reg; 
wire                send_vaild;
reg                 disp_yuv_flag;
reg [15:0]          rd_time_cnt;
reg                 rd_time_out; 
reg [6:0]           sfp_wr_en_reg;       
//=============================module instance============================
generate
  genvar k;
  for(k=0;k<7;k=k+1)begin:spit_array
    assign sfp_rd_data_reg[k]=sfp_rd_data[((k+1)<<6)-1'b1:k<<6];
  end
endgenerate
 //===================================================================
// state Read-Write Data
//=================================================================== 
always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    curr_state <=  state_idle ;
  end else begin
    curr_state <=  next_state ;
  end
end  
 
always @ (*) begin
  if (rst_sys == 1'b1)begin
    next_state <=  state_idle ;
  end else begin
    case(curr_state)
      state_idle:begin next_state<=(ddr_initdone==1'b1)?state_start:state_idle;end
      state_start:begin next_state<=(rece_qune[cnt]==1'b1)?state_wait:state_poll;end
      state_poll:begin next_state<=state_start;end      
      state_wait:begin next_state<=(rd_yuv_data_vld | rd_time_out)?state_inqu:state_wait;end
      state_inqu:begin next_state<=state_send;end
      state_send:begin next_state<=state_poll;end
      default:begin    next_state <=  state_idle ;end
    endcase
  end
end
//===================================================================
assign poll_en =(curr_state==state_poll)?1'b1:1'b0;

always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    cnt <=  0 ;
  end else begin
    if((cnt==4'd6)&&(poll_en==1'b1))begin
      cnt <=  0 ;        
    end else if(poll_en==1'b1) begin
      cnt <=  cnt+1'b1 ;
    end
  end
end    
//===================================================================
reg [1:0]rd_yuv_start_syn;
reg      rd_yuv_start_reg;
always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    rd_yuv_start_reg <=  0 ;
  end else begin
    if(next_state==state_wait)begin
      rd_yuv_start_reg <=  1'b1;        
    end else  begin
      rd_yuv_start_reg <=  1'b0; 
    end
  end
end  

always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    rd_yuv_start_syn <=  0 ;
  end else begin
    rd_yuv_start_syn<={rd_yuv_start_syn[0],rd_yuv_start_reg};
  end
end  

assign rd_yuv_start=rd_yuv_start_syn[0] & (~rd_yuv_start_syn[1]);
//assign rd_yuv_start =((curr_state==state_poll)&&(rece_qune[cnt]==1'b1))?1'b1:1'b0;
assign rd_yuv_addr_reg  =sfp_rd_data_reg[cnt];
assign rd_yuv_addr =rd_yuv_addr_reg[63:32];

always @ (*) begin
  if (rst_sys == 1'b1)begin
    match_en <=  0 ;
  end else begin
      match_en<=rd_yuv_data;
  end
end

generate
  genvar i;
  for(i=0;i<7;i=i+1)begin:tx_statue
    assign tx_send_statue[i]=(match_en[i])?send_statue[i]:1'b1;
  end
endgenerate
assign send_vaild= rd_yuv_data_vld & tx_send_statue[0] & tx_send_statue[1]
                   & tx_send_statue[2] & tx_send_statue[3] & tx_send_statue[4]
                   & tx_send_statue[5] & tx_send_statue[6];
 
 
 
always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    send_start <=  0 ;
  end else if(send_vaild==1'b1)begin
    case(cnt[3:0])
      4'd0:begin send_start<={8'h0,1'b1};end
      4'd1:begin send_start<={7'h0,1'b1,1'h0};end
      4'd2:begin send_start<={6'h0,1'b1,2'h0};end
      4'd3:begin send_start<={5'h0,1'b1,3'h0};end
      4'd4:begin send_start<={4'h0,1'b1,4'h0};end
      4'd5:begin send_start<={3'h0,1'b1,5'h0};end
      4'd6:begin send_start<={2'h0,1'b1,6'h0};end
      default:begin send_start <=  0 ;end 
    endcase
  end else begin
    send_start <=  0 ;
  end    
end                                                                   
//===================================================================
always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    send_buff <=  0 ;
  end else begin
    case(cnt)
       4'd0:begin send_buff<=sfp_rd_data_reg[0];end
       4'd1:begin send_buff<=sfp_rd_data_reg[1];end
       4'd2:begin send_buff<=sfp_rd_data_reg[2];end
       4'd3:begin send_buff<=sfp_rd_data_reg[3];end
       4'd4:begin send_buff<=sfp_rd_data_reg[4];end
       4'd5:begin send_buff<=sfp_rd_data_reg[5];end
       4'd6:begin send_buff<=sfp_rd_data_reg[6];end
      default:begin send_buff<=0;end
    endcase
  end
end

generate
  genvar j;
  for(j=0;j<7;j=j+1)begin:wr_en
    always @ (posedge clk_sys or posedge rst_sys) begin
      if (rst_sys == 1'b1)begin
        sfp_wr_en_reg[j] <=  1'b0 ;
      end else if((send_vaild==1'b1)&&(match_en[j]==1'b1)) begin
        sfp_wr_en_reg[j] <=  1'b1 ;
      end else begin
        sfp_wr_en_reg[j] <=  1'b0 ;          
      end
    end
  end
endgenerate

always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    sfp_wr_en <=  0 ;
  end else begin
    sfp_wr_en <=  sfp_wr_en_reg ;
  end
end 


assign sfp_wr_data={send_buff,send_buff,send_buff,
                    send_buff,send_buff,send_buff,send_buff};
//test disp
always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    disp_yuv_flag <=  0 ;
  end else begin
    if(rd_yuv_data_vld | rd_time_out)begin
      disp_yuv_flag <=  1'b0 ;        
    end else if(rd_yuv_start==1'b1) begin
      disp_yuv_flag <=  1'b1 ;  
    end
  end
end 

always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    rd_time_cnt <=  0 ;
  end else begin
    if(disp_yuv_flag==1'b1)begin
      rd_time_cnt <=  rd_time_cnt+1'b1 ;        
    end else  begin
      rd_time_cnt <=  0 ;
    end
  end
end 


always @ (posedge clk_sys or posedge rst_sys) begin
  if (rst_sys == 1'b1)begin
    rd_time_out <=  0 ;
  end else begin
    if(rd_time_cnt>=16'd1000)begin
      rd_time_out <=  1'b1 ;        
    end else  begin
      rd_time_out <=  1'b0 ;
    end
  end
end

endmodule