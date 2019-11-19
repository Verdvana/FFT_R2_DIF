//------------------------------------------------------------------------------
//
//Module Name:					Shift_Register.v
//Department:					Xidian University
//Function Description:	   2^POW个DATA_WIDTH位宽的点的移位寄存并行输出模块
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-14
//
//-----------------------------------------------------------------------------------

module Shift_Register #(
	parameter	DATA_WIDTH = 16,
					POW = 3									//如果抽取点数为N，POW=log2(N)
)(
		input							clk,
		input							rst_n,
		
		input							valid_in,
		
		input	 signed [DATA_WIDTH-1:0]	sink_r,
		input	 signed [DATA_WIDTH-1:0]	sink_i,
		
		output signed [DATA_WIDTH+8-1:0] source_r [2**POW],
		output signed [DATA_WIDTH+8-1:0] source_i [2**POW]	
		
);

	parameter DATA_NUM = 2**POW;
	
	
	//====================================================
	//状态计数器，一共DATA_NUM个状态
	reg [POW-1:0]	cnt;
	
	always_ff@(posedge clk or negedge rst_n) begin
		
		if(!rst_n)
			cnt <= 0;
			
		else if(valid_in) begin		
			if (cnt == (DATA_NUM-1))
				cnt <= 0;		
			else	
				cnt <= cnt + 1;	
		end
		
		else
			cnt <= 0;

	end
	
	//===================================================
	//数据移位寄存
	reg signed [DATA_WIDTH-1:0]	 in_r [0:DATA_NUM-1];
	reg signed [DATA_WIDTH-1:0]	 in_i [0:DATA_NUM-1];
	
	genvar i;
	generate for(i=0;i<DATA_NUM;i=i+1)
		begin: shitt
		
			always_ff@(posedge clk) begin
				if(valid_in)
					in_r[DATA_NUM-1-i] <= (i==0)? sink_r : in_r[DATA_NUM-i] ;
				else
					in_r[DATA_NUM-1-i] <= 0;
			end
			
			always_ff@(posedge clk) begin
				if(valid_in)
					in_i[DATA_NUM-1-i] <= (i==0)? sink_i : in_i[DATA_NUM-i] ;
				else
					in_i[DATA_NUM-1-i] <= 0;
			end
			
		end
	endgenerate
	
	//===================================================
	//数据输出
	reg signed [DATA_WIDTH-1:0]	 out_r [0:DATA_NUM-1];
	reg signed [DATA_WIDTH-1:0]	 out_i [0:DATA_NUM-1];
	
	genvar j;
	generate for(j=0;j<DATA_NUM;j=j+1)
		begin:out
		
			always_ff@(posedge clk or negedge rst_n) begin
				if(!rst_n)
					out_r[j] <= 0;
				else if(cnt == (0))					//0状态后一个时钟输出并行结果
					out_r[j] <= in_r[j];
				else
					out_r[j] <= out_r[j];
			end
			
			always_ff@(posedge clk or negedge rst_n) begin
				if(!rst_n)
					out_i[j] <= 0;
				else if(cnt == (0))					//0状态后一个时钟输出并行结果
					out_i[j] <= in_i[j];
				else
					out_i[j] <= out_i[j];
			end
			
			assign source_r[j] = out_r[j] << 8;
			assign source_i[j] = out_i[j] << 8;
				
		end
	endgenerate
	
	
endmodule
