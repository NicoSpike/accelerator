//========================================================================================================
//ģ�鹦��˵���� ���ݲ���USE_LOCAL_TIMESTAMP�������ʱ�����ʱ������ⲿ�����ͬ��ʱ�ӵ�ʱ���
//
//========================================================================================================
//������Ա�� 
//����ʱ�䣺 xxxx-xx-xx
//������Ա��
//����ʱ�䣺
//��    ���� V1.00(�½��ļ��汾��V1.00;�����޸�,�汾��Ӧ����)
//========================================================================================================

module read_dna(
  input   wire            ap_clk,
  input   wire            areset,
  output  reg             read_done, 
  output  wire [95:0]     device_dna
	);
//========================================================
//�������
//========================================================


//========================================================
//�����źźͼĴ���
//========================================================
reg           areset_done=0;  
reg           start_dna=0;
reg           dna_shift_en=0;
wire          dna_dout;
reg  [95:0]   dna_reg_c=0;
reg  [6:0]    dna_shift_cnt=0;
reg           dna_read_d=0;
reg           dna_shift_d=0;
reg           start_dna_dly1=0;
wire          start_dna_posedge;
reg [1:0]     clk_cnt=0;
wire          clk_625m;
wire          clk_625m_in;
//========================================================
//ʱ�ӽ�Ƶ��Ĭ��ԭʼʱ��Ϊ250MHz,��ƵΪ62.5M
//========================================================
//always @(posedge ap_clk) begin 
//      clk_cnt <= clk_cnt+1'b1;
//end


//assign clk_625m_in =clk_cnt[1];
//   BUFG BUFG_inst (
//   .O(clk_625m), // 1-bit output: Clock output
//   .I(clk_625m_in)  // 1-bit input: Clock input
//);
//========================================================
//��ȡDNA����
//========================================================
//DNA_PORTE2 #(
//      .SIM_DNA_VALUE(96'h4002000001167bc804206405)  // Specifies a sample 96-bit DNA value for simulation
//   ) dna_port_inst
//       (.DOUT(dna_dout),
//        .CLK(ap_clk),
//        .DIN(1'b0),
//        .READ(start_dna_posedge),
//        .SHIFT(dna_shift_en));  
        
        
    DNA_PORT #(
           .SIM_DNA_VALUE(57'h000000000000000)  // Specifies a sample 57-bit DNA value for simulation
        )
        DNA_PORT_inst (
           .DOUT(dna_dout),   // 1-bit output: DNA output data.
           .CLK(ap_clk),     // 1-bit input: Clock input.
           .DIN(1'b0),     // 1-bit input: User data input pin.
           .READ(start_dna_posedge),   // 1-bit input: Active high load DNA, active low read input.
           .SHIFT(dna_shift_en)  // 1-bit input: Active high shift enable input.
        );       
//========================================================
//�ϵ�ȴ�125��tickt��ʱ��������ȡDNA
//========================================================
always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
      areset_done <= 1'b0;
  end
  else begin
      areset_done <= 1'b1;
  end
end

always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
    start_dna <= 1'b0;
  end
  else if (areset_done==1'b1) begin
      start_dna <= 1'b1;
  end
end

always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
    start_dna_dly1 <= 1'b0;
  end
  else begin
    start_dna_dly1 <= start_dna;
  end
end

assign start_dna_posedge = start_dna && (~start_dna_dly1);

always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
    dna_shift_en <= 1'b0;
 end
 else if (dna_shift_cnt==56) begin
    dna_shift_en <= 1'b0;
 end
 else if (start_dna_posedge) begin
    dna_shift_en <= 1'b1;
 end
end
always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
    read_done <= 1'b0;
 end
 else if (dna_shift_cnt==56) begin
    read_done <= 1'b1;
 end
end

always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
    dna_shift_cnt <= 1'b0;
 end
 else if (dna_shift_en) begin
    dna_shift_cnt <= dna_shift_cnt + 1'b1;
 end
end

always @(posedge ap_clk) begin 
  if (areset == 1'b1) begin
      dna_reg_c <= 0;
   end
   else if (dna_shift_en) begin
      dna_reg_c <= {dna_dout,dna_reg_c[56:1]};
   end
end
assign device_dna = dna_reg_c;
endmodule