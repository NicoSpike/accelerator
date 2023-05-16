`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2019 05:57:23 PM
// Design Name: 
// Module Name: axim_wr_ctrlr
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
module axim_wr_ctrlr #(
	parameter ADDR_WIDTH = 64 ,	//address bitwidth
	parameter DATA_WIDTH = 32 	//data bitwidth
	) (
  	input            		   		 	   	clk_sys,
  	input            		   		 	   	rst_sys,
  	//reg		 	      
  	input                                  	kernel_start      ,
  	input       [ADDR_WIDTH - 1 : 0]       	outbuf_base_addr  ,
    //rd_yuv_ctrl	    
  	output reg                             	wr_dn 		      ,
  	output                                 	wr_idle_sign      ,	
  	output reg                             	w128B_int 		  ,  
  	output reg  [ADDR_WIDTH - 1 : 0]        rece_outbuf_ptr   ,	
    //connect wr_ddr_axi		 	      
    output                         	 		wr_data_ready     ,
    input 	                       			wr_data_vld       ,
    input 	 	[DATA_WIDTH-1: 0]    		wr_axis_data      ,
    input 	                       			wr_data_last      ,	 
    input 	 	[DATA_WIDTH/8- 1 : 0]		wr_data_en        ,    	
    // AXI-MM write interface
    output reg  [ADDR_WIDTH - 1 : 0]       	m_axi_awaddr      ,
    output reg  [  7: 0]                   	m_axi_awlen       ,
    output wire [  2: 0]                   	m_axi_awsize      ,
    output wire [  1: 0]                   	m_axi_awburst     ,
    output wire                            	m_axi_awlock      ,
    output wire [  3: 0]                   	m_axi_awcache     ,
    output wire [  2: 0]                   	m_axi_awprot      ,
    output wire [  3: 0]                   	m_axi_awqos       ,
    output reg                             	m_axi_awvalid     ,
    input  wire                            	m_axi_awready     ,
    output reg  [DATA_WIDTH - 1 : 0]       	m_axi_wdata       ,
    output wire [DATA_WIDTH/8-1: 0]        	m_axi_wstrb       ,
    output wire                            	m_axi_wlast       ,
    output reg                             	m_axi_wvalid      ,
    input  wire                            	m_axi_wready      ,
    input  wire [  1: 0]                   	m_axi_bresp       ,
    input  wire                            	m_axi_bvalid      ,
    output reg                            	m_axi_bready         		 
);

//=============================paramer define============================= 
localparam  [3:0] STATE_IDLE           	= 4'h0;
localparam  [3:0] STATE_READY  	  		= 4'h1;
localparam  [3:0] STATE_ADDR    	  	= 4'h2;
localparam  [3:0] STATE_RESP         	= 4'h3;
localparam  [3:0] STATE_DATA         	= 4'h4;
localparam  [3:0] STATE_WAIT        	= 4'h5;
localparam  [3:0] STATE_DONE           	= 4'h6;
//=============================signal define============================= 
reg  [3:0]                next_state           ;
reg  [3:0]                curr_state        ; 

wire [31:0]  			  axis_wr_data_count;
wire [31:0]  			  axis_rd_data_count;
wire 					  wr_yuvdata_ready;
reg  [1:0]				  data_last_dly;
reg 					  data_last_lock;

reg 					  m_axis_tready;
wire 					  m_axis_tvalid;
wire [DATA_WIDTH-1: 0]    m_axis_tdata; 
wire [DATA_WIDTH/8- 1 : 0]m_axis_tkeep;    
reg  [7:0]				  wr_cnt;
reg  [63:0]               my_yuv_axi_awaddr;
reg                       axi_wrdata_busy;

wire flag_4kb;
wire [12:0]len_4kb;
wire [12:0]send_length;
//=============================module instance============================
//axi_data_fifo u_axi_ydata_fifo(
//  .s_axis_aresetn			(~rst_sys),
//  .s_axis_aclk				(clk_sys),
//  .s_axis_tvalid			(wr_data_vld),
//  .s_axis_tready			(wr_yuvdata_ready),
//  .s_axis_tdata				(wr_axis_data),
//  .s_axis_tkeep				(wr_data_en),
//  .m_axis_tvalid			(m_axis_tvalid),
//  .m_axis_tready			(m_axis_tready),
//  .m_axis_tdata				(m_axis_tdata),
//  .m_axis_tkeep				(m_axis_tkeep),  
//  .axis_wr_data_count		(axis_wr_data_count),
//  .axis_rd_data_count		(axis_rd_data_count)
//  );
 assign wr_data_ready =(axis_wr_data_count>32'd500)?1'b0:1'b1; 
//===================================================================
// lock data last signal
//===================================================================  
always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		data_last_dly <=  0 ;
	end
	else begin
		data_last_dly <=  {data_last_dly[0],wr_data_last} ;
	end
end  
  
always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		data_last_lock <=  0 ;
	end
	else if(curr_state == STATE_DONE)begin
		data_last_lock <=  0 ;
	end 
	else if((data_last_dly[1]==1'b0)&&(data_last_dly[0]==1'b1)&&(axis_rd_data_count!=0))begin
		data_last_lock <=  1'b1 ;
	end	
end   
//===================================================================
// state machine control jump
//===================================================================
always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		curr_state <=  STATE_IDLE ;
	end
	else begin
		curr_state <=  next_state ;
	end
end 

always @ (*) 
begin
	if (rst_sys == 1'b1)begin
		next_state <=  STATE_IDLE ;
	end
	else begin
		case(curr_state)
			STATE_IDLE:begin
					if(kernel_start)
						next_state <=  STATE_READY ;	
					else 
						next_state <=  STATE_IDLE ;
					end 
			STATE_READY:begin
					if((axis_rd_data_count>32'd128)||((data_last_lock==1'b1)&(axis_rd_data_count!=0)))
						next_state <=  STATE_ADDR ;	
					else 
						next_state <=  STATE_READY ;
					end 
			STATE_ADDR:begin
					if (m_axi_awready && m_axi_awvalid)
						next_state <=  STATE_DATA ;	
					else 
						next_state <=  STATE_ADDR ;
					end 								
            STATE_DATA:begin
					if ((m_axi_wready && m_axi_wvalid)&&(wr_cnt==m_axi_awlen))
						next_state <=  STATE_RESP ;	
					else 
						next_state <=  STATE_DATA ;
					end
			STATE_RESP:begin
					if (m_axi_bready && m_axi_bvalid)
						next_state <=  STATE_WAIT ;	
					else 
						next_state <=  STATE_RESP ;
					end										 
			STATE_WAIT:begin
					if (data_last_lock && (axis_rd_data_count==0))
						next_state <=  STATE_DONE ;	
					else 
						next_state <=  STATE_READY ;
					end 
			STATE_DONE:begin
					next_state <=  STATE_IDLE ;
					end
			default:begin
					next_state <=  STATE_IDLE ;
					end
		endcase
	end 
end 
//===================================================================
// state machine control addr signal
//===================================================================
always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		wr_cnt<=0;
		m_axi_awaddr<= 0;
		my_yuv_axi_awaddr<= outbuf_base_addr;
		m_axi_awlen <= 8'h7F;
		m_axi_awvalid <= 0;
		m_axi_bready<= 0;		
	end
	else begin
		case(curr_state)
			STATE_IDLE:begin
					m_axi_awaddr<= 0;
		            m_axi_awlen <= 8'h7F;
					m_axi_awvalid <= 0;
					m_axi_bready<= 0;
					end 
			STATE_READY:begin
					m_axi_awaddr<= my_yuv_axi_awaddr;
					m_axi_bready<= 1'b1;	
					if((axis_rd_data_count>32'd128)||(data_last_lock==1'b1))begin
						m_axi_awvalid <= 1'b1;
					end 
					else begin
						m_axi_awvalid <= 1'b0;
					end 
					if(data_last_lock==1'b1)begin
					   if(flag_4kb) begin
							m_axi_awlen <= send_length[6:0]-1'b1;						
					   end 
					   else if(axis_rd_data_count>32'd128)begin
							m_axi_awlen <= 8'h7F;
						end else begin
							m_axi_awlen <= axis_rd_data_count-1'b1;
					    end						  
					end 
					else begin
					   if(flag_4kb) begin
							m_axi_awlen <= send_length[6:0]-1'b1;						
					   end 
					   else begin
							m_axi_awlen <= 8'h7F;
					   end					   
					end
				end 
			STATE_ADDR:begin
					if (m_axi_awready && m_axi_awvalid) begin
						m_axi_awvalid <= 1'b0;
						my_yuv_axi_awaddr[29:0]<= my_yuv_axi_awaddr[29:0]+((m_axi_awlen+1'b1)<<2);
					end 
					else begin
						m_axi_awvalid <= 1'b1;
					end
				end  
			STATE_DATA:begin
					if (m_axi_wready && m_axi_wvalid) begin
						if(wr_cnt==m_axi_awlen)
							wr_cnt <= 8'd0;
						else 
							wr_cnt <= wr_cnt+1'b1;
					end
				end
			STATE_RESP, 
			STATE_WAIT,
			STATE_DONE:begin
					wr_cnt<=0;	
					end  					
			default:begin
					wr_cnt<=0;
					m_axi_awaddr<= 0;
					my_yuv_axi_awaddr<= 0;
					m_axi_awlen <= 8'h7f;
					m_axi_awvalid <= 0;
					m_axi_bready<= 0;
					end 
		endcase
	end 
end 
//===================================================================
// state machine control data signal
//===================================================================
always @ (*) 
begin
	if (rst_sys == 1'b1)begin
		m_axis_tready= 0;
		m_axi_wvalid = m_axis_tvalid & m_axis_tready;
		m_axi_wdata  = m_axis_tdata;		
	end
	else begin
		case(curr_state)
			STATE_IDLE,
			STATE_READY,
			STATE_ADDR,
			STATE_WAIT,
			STATE_DONE:begin
					m_axis_tready= 0;
					m_axi_wvalid = m_axis_tvalid & m_axis_tready;
					m_axi_wdata  = m_axis_tdata;
					end 
			STATE_DATA:begin
					m_axis_tready= m_axi_wready  ;
					m_axi_wvalid = m_axis_tvalid & m_axis_tready;
					m_axi_wdata  = m_axis_tdata;
					end 
			default:begin
					m_axis_tready= 0;
					m_axi_wvalid = m_axis_tvalid & m_axis_tready;
					m_axi_wdata  = m_axis_tdata;
					end 
		endcase
	end 
end 
assign m_axi_wlast   = m_axi_wready && m_axi_wvalid && (wr_cnt == m_axi_awlen);
assign m_axi_awsize  = 3'd2          ;
assign m_axi_awburst = 2'd1          ;
assign m_axi_awlock  = 1'b0          ;
assign m_axi_awcache = 4'd3          ;
assign m_axi_awprot  = 3'd0          ;
assign m_axi_awqos   = 4'd0          ;
assign m_axi_wstrb   = {4{1'b1}}    ;
//===================================================================
// write  data done
//===================================================================
always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		wr_dn <=  1'b0 ;
	end
	else begin
		if(curr_state==STATE_DONE)
			wr_dn <=  1'b1 ;	 
		else
			wr_dn <=  1'b0 ;	
	end
end 

always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		w128B_int <=  1'b0 ;
	end
	else begin
		if(curr_state==STATE_WAIT)
			w128B_int <=  1'b1 ;	 
		else
			w128B_int <=  1'b0 ;	
	end
end 

always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)begin
		rece_outbuf_ptr <=  0 ;
	end else begin
		if(curr_state==STATE_DATA)begin
			rece_outbuf_ptr <=  my_yuv_axi_awaddr ;
		end	 
	end
end

always @ (posedge clk_sys or posedge rst_sys) 
begin
	if (rst_sys == 1'b1)
	    axi_wrdata_busy <= 1'b0;
	else if(m_axi_bvalid && m_axi_bready)
	    axi_wrdata_busy <= 1'b0;
    else if(m_axi_awvalid && m_axi_awready)
	    axi_wrdata_busy <= 1'b1;	
    else 
	    axi_wrdata_busy <= axi_wrdata_busy;
end	

assign wr_idle_sign = !(axi_wrdata_busy || (m_axi_awvalid && m_axi_awready)); 

wire [12:0]               length_autric;
////4KB write control
assign length_autric=(axis_rd_data_count[11:0]>=8'h80)?12'd512:(axis_rd_data_count[11:0]<<2);
assign len_4kb =my_yuv_axi_awaddr[11:0]+length_autric;
assign flag_4kb=(len_4kb>13'h1000)?1'b1:1'b0;
assign send_length=((~my_yuv_axi_awaddr[11:0])+1'b1)>>2;


////
//axi_ila axi_ila(
//.clk				(clk_sys),

//.probe0				(m_axi_wvalid),
//.probe1				(m_axi_wready),
//.probe2				(m_axi_wdata),
//.probe3				(m_axi_wlast),
//.probe4				(m_axi_wstrb),
//.probe5				(m_axi_awaddr),
//.probe6				(m_axi_awvalid),
//.probe7				(m_axi_awready),
//.probe8				(m_axi_bvalid),
//.probe9				(m_axi_bready),
//.probe10			(wr_cnt),
//.probe11			(m_axi_awlen),
//.probe12			(axis_rd_data_count)
//);








      
endmodule