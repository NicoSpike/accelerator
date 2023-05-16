`timescale 1ns/1ps

module  cal_top #( 
   parameter  cal_depth = 100
)( 
   input                     clk,
   input                     rst,
   input             avm_wr_done,
   //rd
   input                rd_ready,//ddr_top
   output  [31:0]  pe_rd_address,
   output            pe_rd_ready,
   input             pe_rd_valid,
   input   [511:0]    pe_rd_data,
   //wr
   input             pe_wr_ready,
   output            pe_wr_valid,
   output  [511:0]    pe_wr_data,
   output  [31:0]  pe_wr_address,
   output  reg      pe_wr_finish
);

localparam   IDLE       = 3'b000;
localparam   PE_RD_ADDR = 3'b001;
localparam   PE_RD_DATA = 3'b010;
localparam   CAL_OP     = 3'b011;
localparam   PE_WR      = 3'b100;

reg [2:0]  current_state   = IDLE;
reg [2:0]  next_state      = IDLE;

/***************************************/
reg                         pe_rd_finish;
reg                            wait_done;
reg                             rd_start;
reg       [8:0]                 pe_r_len;
reg       [8:0]                 pe_w_len;
wire                            rd_valid;
reg                            pe_read_i;
wire                          pe_write_i;
reg       [31:0]               address_r;
reg       [31:0]               address_w;
reg       [7:0]             address_ram6;
reg                        cal_start_dly;
reg       [511:0]          cal_in_data_r;
wire      [511:0]            cal_in_data;
reg       [511:0]           pe_wr_data_i;
wire                      pe_waitrequest;
reg                   pe_waitrequest_dly;
/***************************************/
wire      [511:0]            ddr_wr_data;
wire      [511:0]            data_pakage;
reg       [7:0]                   rd_cnt;
wire      [7:0]               wr_ram_cnt;
reg                            cal_start;
wire                          cal_finish;
wire                           start_ena;
wire                            cal_done;
reg       [7:0]               rd_ram_cnt;
/***************************************/
wire      [63:0]                     r_i;
wire      [63:0]                     K_i;
wire      [63:0]                  pi_m_i; 
wire      [63:0]             alphaisub_1;   
wire      [63:0]             alphaisub_2;    
wire      [63:0]                 alpha_i;
wire      [63:0]             alphaiadd_1;
wire      [63:0]             alphaiadd_2;
wire      [63:0]               phiisub_1;
wire      [63:0]               phiisub_2;
wire      [63:0]                   phi_i;
wire      [63:0]               phiiadd_1;
wire      [63:0]               phiiadd_2;
wire      [63:0]               psiisub_1;
wire      [63:0]               psiisub_2;
wire      [63:0]                   psi_i;
wire      [63:0]               psiiadd_1;
wire      [63:0]               psiiadd_2;
/***************************************/
wire      [63:0]                 alpha_t;
wire      [63:0]                     K_t;
wire      [63:0]                   phi_t;
wire      [63:0]                  pi_m_t;
wire      [63:0]                   psi_t;
/***************************************/

always @ (posedge clk) begin
   if (rst == 1'b0) begin
      rd_start <= 1'b0;
	  wait_done <= 1'b0;
   end
   else begin
      rd_start <= avm_wr_done;
	  wait_done <= 1'b1;
   end
end

always @ (posedge clk) begin
   if (rst == 1'b0) begin
     address_r <= 'b0;
     address_w <= 'b0;
   end
   else begin
      if (rd_ready) begin
         address_r <= address_r + 'd8;
      end
      else if (pe_write_i) begin
         address_w <= address_w + 'd8;
      end
      else if (current_state == IDLE) begin
         address_r <= 'b0;
         address_w <= 'b0;
      end
   end
end

always @ (posedge clk) begin
   if (rst == 0) begin
      address_ram6 <= 'd0;
   end
   else if(pe_rd_valid) begin
      address_ram6 <= address_ram6 + 'd1;
   end
   else begin
      address_ram6 <= address_ram6;
   end
end

always @ (posedge clk) begin
   if (rst == 0) begin 
     rd_ram_cnt <= 'd0;
   end
   else if (pe_write_i) begin
     rd_ram_cnt <= rd_ram_cnt + 'd1;
   end
   else begin 
     rd_ram_cnt <= rd_ram_cnt;
   end
end

assign pe_rd_address = address_r;
assign pe_wr_address = address_w;

//rd logic
assign     rd_valid = pe_rd_ready & pe_rd_valid;
assign  pe_rd_ready = pe_read_i;

always @ (posedge clk) begin
   if (rst == 1'b0) begin
      pe_read_i <= 1'b0;
   end
   else begin
     if (next_state == PE_RD_DATA && rd_valid && pe_r_len == 1) begin
       pe_read_i <= 1'b0;
     end
     else if (next_state == PE_RD_DATA && pe_r_len > 0) begin
       pe_read_i <= 1'b1;
     end
   end
end

always @ (posedge clk) begin
   if (rst == 1'b0) begin
      pe_rd_finish <= 1'b0;
   end
   else begin
      if (next_state == PE_RD_DATA && rd_valid && pe_r_len == 1)
         pe_rd_finish <= 1'b1;
      else 
         pe_rd_finish <= 1'b0;
   end
end

always @ (posedge clk) begin
   if (rst == 0) begin
       pe_r_len <= 'b0;
   end
   else begin
     if (next_state == PE_RD_DATA) begin
        if (pe_r_len > 0 && pe_rd_valid == 1'b1) begin
            pe_r_len <= pe_r_len - 1'b1;
        end
     end
     else begin
        pe_r_len <= cal_depth;
     end
   end
end

always @ (posedge clk) begin
   if (rst == 0) begin
      cal_in_data_r <= 0;
   end
   else begin
      cal_in_data_r <= pe_rd_data;
   end
end

assign cal_in_data = cal_in_data_r;

//wr
assign pe_write_i = (next_state == PE_WR) ? 1'b1 : 1'b0;

always @ (posedge clk) begin
   if (rst == 0) begin
     pe_w_len <= 0;
   end
   else begin
     if (current_state == PE_WR) begin
        if ((pe_wr_valid == 1'b1) && (pe_w_len > 0 )) begin
           pe_w_len <= pe_w_len - 1'b1;
        end
     end
     else begin
        pe_w_len <= cal_depth - 'd5;
     end
   end
end

always @ (posedge clk) begin
   if (rst == 1'b0) begin
      pe_wr_finish <= 1'b0;
   end
   else begin
      if (current_state == PE_WR && pe_w_len == 0)
         pe_wr_finish <= 1'b1;
      else 
         pe_wr_finish <= 1'b0;
   end
end

always @ (posedge clk) begin
   pe_wr_data_i <= ddr_wr_data;
end

always @ (posedge clk) begin
   if (rst == 0) begin
       pe_waitrequest_dly <= 1'b0;
   end
   else begin
       pe_waitrequest_dly <= pe_waitrequest;
   end
end

assign pe_waitrequest = ~pe_wr_ready;
assign   pe_wr_valid  = ~pe_waitrequest & pe_write_i;
assign   pe_wr_data   = pe_wr_data_i;

// cal_module
always @ (posedge clk) begin
    if (rst == 0) begin
      cal_start <= 1'b0;
    end
    else if (next_state == CAL_OP) begin
       if (start_ena == 1'b0 && rd_cnt <= cal_depth - 'd3) 
           cal_start <= 1'b1;
       else if (cal_finish == 1'b1)
           cal_start <= 1'b0;
    end
    else begin
      cal_start <= 1'b0;
    end 
end

always @ (posedge clk) begin
    if (rst == 0) begin
      rd_cnt <= 'd2;
    end
    else if (cal_start && cal_finish) begin
      rd_cnt <= rd_cnt + 'd1;
    end
    else if ((rd_cnt > cal_depth - 'd3) && (address_ram6 != 0)) begin
      rd_cnt <= 'd2;
    end
    else begin
      rd_cnt <= rd_cnt;
    end
end

always @ (posedge clk) begin
   if (rst == 0) begin
     cal_start_dly <= 1'b0;
   end
   else begin
     cal_start_dly <= cal_start;
   end
end

assign cal_done = (rd_cnt > cal_depth - 'd3 && cal_start_dly) ? 1'b1 : 1'b0;
assign wr_ram_cnt = rd_cnt - 'd2;
assign data_pakage = {alpha_t,K_t,phi_t,pi_m_t,psi_t,192'b0};

inidata_down # (
     .mem_depth(cal_depth)
) ram6 (
     .clk(clk),
     .cal_in_data(cal_in_data),
     .wr_cnt(address_ram6),
     .rd_cnt(rd_cnt),
     .r_i(r_i),
     .K_i(K_i),
     .pi_m_i(pi_m_i),
     .alphaisub_1(alphaisub_1),
     .alphaisub_2(alphaisub_2),
     .alpha_i(alpha_i),
     .alphaiadd_1(alphaiadd_1),
     .alphaiadd_2(alphaiadd_2),
     .phiisub_1(phiisub_1),
     .phiisub_2(phiisub_2),
     .phi_i(phi_i),
     .phiiadd_1(phiiadd_1),
     .phiiadd_2(phiiadd_2),
     .psiisub_1(psiisub_1),
     .psiisub_2(psiisub_2),
     .psi_i(psi_i),
     .psiiadd_1(psiiadd_1),
     .psiiadd_2(psiiadd_2)
);

calculation_core  calculationcore (
      .clk(clk),
      .start(cal_start),
      .r_i(r_i),
      .K_i(K_i),
      .pi_m_i(pi_m_i),
      .alphaisub_1(alphaisub_1),
      .alphaisub_2(alphaisub_2),
      .alpha_i(alpha_i),
      .alphaiadd_1(alphaiadd_1),
      .alphaiadd_2(alphaiadd_2),
      .phiisub_1(phiisub_1),
      .phiisub_2(phiisub_2),
      .phi_i(phi_i),
      .phiiadd_1(phiiadd_1),
      .phiiadd_2(phiiadd_2),
      .psiisub_1(psiisub_1),
      .psiisub_2(psiisub_2),
      .psi_i(psi_i),
      .psiiadd_1(psiiadd_1),
      .psiiadd_2(psiiadd_2),
      .alpha_t(alpha_t),
      .K_t(K_t),
      .phi_t(phi_t),
      .pi_m_t(pi_m_t),
      .psi_t(psi_t),
      .finish(cal_finish),
      .start_flag(start_ena)
);

pakage_load #(
     .res_depth(cal_depth - 4)
) ram1 (
     .clk(clk),
     .wr_ram_cnt(wr_ram_cnt),
     .rd_ram_cnt(rd_ram_cnt),
     .data_pakage(data_pakage),
     .ddr_wr_data(ddr_wr_data)
);

//state
always @ (posedge clk) begin
   current_state <= next_state;
end

always @ (*) begin
   case (current_state) 
        IDLE: begin
		   if (rd_start) begin
		      next_state <= PE_RD_ADDR;
		   end
		   else begin
		      next_state <= IDLE;
		   end
		end
		PE_RD_ADDR: begin
		   if (wait_done == 1'b1) begin
		      next_state <= PE_RD_DATA;
		   end
		   else begin
		      next_state <= PE_RD_ADDR;
		   end
		end
		PE_RD_DATA: begin
		   if (pe_rd_finish) begin
		      next_state <= CAL_OP;
		   end
		   else begin
		      next_state <= PE_RD_DATA;
		   end
		end
		CAL_OP: begin
		   if (cal_done) begin
		      next_state <= PE_WR;
		   end
		   else begin
		      next_state <= CAL_OP;
		   end
		end
		PE_WR : begin
		   if (pe_wr_finish) begin
		      next_state <= IDLE;
		   end
		   else begin
		      next_state <= PE_WR;
		   end
		end
		default : begin next_state <= IDLE; end
    endcase
end

endmodule