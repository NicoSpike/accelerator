`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2020 09:39:08 AM
// Design Name: 
// Module Name: send_frame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/*----------------------------------------------------------------------------
|   AAAA5555
|   NUM+LENGTH(BYTE)
|   data vaild
|
|   chesum
|   cccc3333 
|   length = NUM+LENGTH(BYTE)+datavaild+chesum+cccc3333
----------------------------------------------------------------------------*/
// page HEDA AAAA5555
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module send_frame(
  // System Signals
  input                                      ap_rst,
  input                                      tx_clk,
  //send the rx qune statue to contralateral 
  input                                      send_buff_vaild      ,
  input   [31:0]                             send_buff_statue     ,   
  //frome tx_buf
  input                                      tx_allow,
  output    reg                              tx_rden,  
  input     [64-1:0]                         tx_rddata,  
  //to gtp
  output    reg[31:0]                        gtp_txdata,
  output    reg[ 3:0]                        gtp_txctl,
  
  input wire                                 send_back_flag,
  input wire  [15:0]                         send_back_data,  
  input wire                                 send_info_vaild,
  input wire  [15:0]                         send_info  
  );
//=============================paramer define============================= 
parameter state_idle =4'd0;
parameter state_start_back =4'd1;
parameter state_start_buff =4'd2;
parameter state_start_head =4'd3;
parameter state_start_data=4'd4;
parameter state_data_read=4'd5;
parameter state_data_send=4'd6;
parameter state_data_wait=4'd7;
parameter state_done=4'd8;
//=============================signal define=============================
reg [  3: 0]        curr_state;
reg [  3: 0]        next_state;

reg [7:0]  tx_cnt;
reg [31:0] txdata_reg;
reg [3:0]  txctl_reg;
reg        send_buff_vaild_lock;
reg [31:0] send_data_lock;

reg        send_back_vaild_lock;
reg [31:0] send_back_data_lock;



reg        tx_statue_ok;
reg        tx_back_ok;
reg [63:0] send_data;
reg        tx_statue_ok_dly1;
reg        tx_statue_ok_dly2;
wire       tx_statue_en;

wire[7:0] pack_sum;
reg [7:0] pack_cnt;
reg [7:0] send_cnt;
wire      time_out_flag;
reg       wait_back_succe;
//=============================module instance============================
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_buff_vaild_lock <=  1'b0;
  end else begin
      if(tx_statue_ok)begin
        send_buff_vaild_lock <=  1'b0;
      end else if(send_buff_vaild)begin
        send_buff_vaild_lock <=  1'b1;
      end              
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_data_lock <=  0;
  end else begin
      if(send_buff_vaild==1'b1)begin
        send_data_lock <=  {send_buff_statue[15:0],16'h0};
      end              
  end
end 


always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_back_vaild_lock <=  1'b0;
  end else begin
      if(tx_back_ok==1'b1)begin
        send_back_vaild_lock <=  1'b0;
      end else if(send_back_flag)begin
        send_back_vaild_lock <=  1'b1;
      end              
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_back_data_lock <=  0;
  end else begin
      if(send_back_flag==1'b1)begin
        send_back_data_lock <=  {send_buff_statue[15:0],send_back_data[15:4],4'h1};
      end              
  end
end 

//=============================instance============================
//send mach
//=================================================================
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      curr_state <=  0;
  end else begin
      curr_state <=  next_state;           
  end
end

always @ (*) begin
  if (ap_rst == 1'b1)begin
    next_state <=  state_idle ;
  end else begin
    case(curr_state)
      state_idle:begin next_state<=(send_back_vaild_lock==1'b1)?state_start_back:(send_buff_vaild_lock==1'b1)?state_start_buff:(tx_allow==1'b1)?state_start_data:state_idle;end
      state_start_back:begin next_state<=(tx_cnt==8'd1)?state_start_head:state_start_back;end
      state_start_buff:begin next_state<=(tx_cnt==8'd1)?state_start_head:state_start_buff;end     
      state_start_head:begin next_state<=(tx_cnt==8'd1)?state_done:state_start_head;end
      state_start_data:begin next_state<=(tx_cnt==8'd3)?state_data_read:state_start_data;end
      state_data_read:begin next_state<= (tx_cnt==8'd1)?state_data_wait:state_data_read;end
      state_data_wait:begin next_state<=(send_info_vaild | time_out_flag)?state_idle:state_data_wait;end
      state_done:begin next_state<=state_idle;end      
      default:begin    next_state <=  state_idle ;end
    endcase
  end
end

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        tx_cnt <=  8'h0;      
  end else begin
        if(curr_state==next_state)begin
            tx_cnt <=  tx_cnt+1'b1;
        end else begin
            tx_cnt <=  0;
        end                                             
  end
end 
//=============================instance============================
//control signal
//=================================================================
assign time_out_flag=((curr_state==state_data_wait)&(tx_cnt>=8'hF0))?1'b1:1'b0;
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        wait_back_succe <=  1'b0;      
  end else begin
        if((send_info[15:8]==send_cnt)&(send_info[6]==1'b1)& (send_info_vaild==1'b1))begin
            wait_back_succe <=  1'b0;       
        end else if(time_out_flag | ((send_info[15:8]==send_cnt)&(send_info[6]==1'b0)& (send_info_vaild==1'b1)))begin
            wait_back_succe <=  1'b1;
        end                                             
  end
end 


// send data
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        tx_rden <=  1'b0;      
  end else begin
        if((curr_state==state_start_data)&(tx_cnt==0)& (wait_back_succe==1'b0))begin
            tx_rden <=  1'b1;
        end else begin
            tx_rden <=  1'b0;
        end                                             
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_cnt <=  1'b0;      
  end else begin
        if((curr_state==state_start_data)&(tx_cnt==0)& (wait_back_succe==1'b0))begin
            send_cnt <=  send_cnt+1'b1;
        end                                             
  end
end 


always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        pack_cnt <=  0;      
  end else begin
        if((tx_cnt==0)&((curr_state==state_start_back)||(curr_state==state_start_buff)))begin
            pack_cnt <=  pack_cnt+1'b1;
        end                                             
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        send_data <=  0;      
  end else begin
        if(curr_state==state_start_back)begin
            send_data <= {send_back_data_lock,pack_cnt,send_back_data_lock[23:16]+send_back_data_lock[7:0],16'haabc};
        end else if(curr_state==state_start_buff)begin
            send_data <= {send_data_lock,pack_cnt,send_data_lock[23:16]+send_data_lock[7:0],16'haabc};
        end else if(curr_state==state_start_data)begin
            send_data <= {tx_rddata[63:32],send_cnt,tx_rddata[55:48]+tx_rddata[39:32],16'h55bc};
        end                                             
  end
end 
//=============================instance============================
//define signal
//=================================================================
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        tx_back_ok <=  0;      
  end else begin
        if(curr_state==state_start_back)begin
			tx_back_ok <=  1'b1;
		end else begin	
			tx_back_ok <=  1'b0;
		end
  end
end 

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
        tx_statue_ok <=  0;      
  end else begin
        if(next_state==state_done)begin
			tx_statue_ok <=  1'b1;
		end else begin	
			tx_statue_ok <=  1'b0;
		end
  end
end 

//=============================instance============================
//gtx signal
//=================================================================
always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      txdata_reg <=  32'd0 ;
      txctl_reg <=  4'd0 ;	  
  end else begin
      case(curr_state)
		state_start_head,
		state_data_read	:begin 
							if(tx_cnt==0)begin	
								txdata_reg<=send_data[31:0];
								txctl_reg <=  4'b0001 ;
							end else begin	
								txdata_reg<=send_data[63:32];
								txctl_reg <=  4'd0 ;	 
							end
						end
		default:begin txdata_reg<=0;txctl_reg <=  4'd0 ;	 end
	  endcase
  end
end

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      gtp_txdata<=0;
  end else begin
      gtp_txdata<=txdata_reg;                              
  end
end

always @ (posedge tx_clk )begin
  if (ap_rst == 1'b1)begin
      gtp_txctl<=0;
  end else begin
      gtp_txctl<=txctl_reg;                              
  end
end


//ila_grx ila_grx(
//.clk 	    (tx_clk),
//.probe0    (txctl_reg),
//.probe1    (txdata_reg),
//.probe2  (wait_back_succe),
//.probe3  (tx_cnt),
//.probe4  (tx_statue_ok),
//.probe5  (send_buff_vaild),
//.probe6  (send_back_flag),
//.probe7  (send_data_lock)
//);




endmodule
