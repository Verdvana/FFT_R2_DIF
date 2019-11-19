//------------------------------------------------------------------------------
//
//Module Name:					Order_Adjustment.v
//Department:					Xidian University
//Function Description:	   位码倒读和串行输出
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-18
//
//-----------------------------------------------------------------------------------

module Order_Adjustment #(
	parameter	DATA_WIDTH = 16,
					POW = 3					//如果抽取点数为N，POW=log2(N)
)(
		input												clk,
		input												rst_n,
		
		input 											valid_in,
		
		input  signed [DATA_WIDTH+8+POW-1:0]	sink_r [2**POW],
		input  signed [DATA_WIDTH+8+POW-1:0]	sink_i [2**POW],
		
		output reg										valid_out,
		
		output reg signed [DATA_WIDTH+POW-1:0] source_r,
		output reg signed [DATA_WIDTH+POW-1:0] source_i
);


	parameter DATA_NUM = 2**POW;
	
	
	
	//====================================================
	//输出数据存储
	
	reg [DATA_WIDTH+POW-1:0] result_r [0:DATA_NUM-1];
	reg [DATA_WIDTH+POW-1:0] result_i [0:DATA_NUM-1];
	
	genvar i;
	generate for(i=0;i<DATA_NUM;i++)
		begin:store
		
			always_ff@(posedge clk or negedge rst_n) begin
			
				if(!rst_n) begin
					result_r[i] <= '0;
					result_i[i] <= '0;
				end
				
				else begin
					result_r[i] <= sink_r[i] >> 8;	
					result_i[i] <= sink_i[i] >> 8;
				end
			
			end
		
		end
	endgenerate
	
	//====================================================
	//状态计数器，一共DATA_NUM个状态
	
	reg valid_in_r,valid_in_rr;
	reg [POW-1:0]	cnt;
	
	
	//----------------------------------------------------
	//使能信号延迟两拍
	
	always_ff@(posedge clk or negedge rst_n) begin

		if(!rst_n) begin
			valid_in_r  <= 1'b0;
			valid_in_rr <= 1'b0;
		end
		
		else begin
			valid_in_r  <= valid_in;
			valid_in_rr <= valid_in_r;
		end
		
	end
	
	
	//----------------------------------------------------
	//状态计数器计数
	always_ff@(posedge clk or negedge rst_n) begin
		
		if(!rst_n)
			cnt <= 0;
			
		else if(valid_in_rr) begin		
			if (cnt == (DATA_NUM-1))
				cnt <= 0;		
			else	
				cnt <= cnt + 1;	
		end
		
		else
			cnt <= 0;

	end
	
	
	
	
	//====================================================
	//位码倒读
	wire [POW-1:0] addr;					//正读地址
	wire [POW-1:0] addr_rev;			//倒读地址
	
	assign addr = cnt;
		
	//----------------------------------------------------
	//倒读
	BitRev #(
		.WIDTH(POW))
	u_BitRev(
		.x(addr),
		.y(addr_rev)
	);
				
	
	//====================================================
	//串行输出
	
	always_ff@(posedge clk or negedge rst_n) begin
	
		if(!rst_n) begin
			source_r <= '0;
			source_i <= '0;
		end
		
		else begin	
			source_r <= result_r[addr_rev];
			source_i <= result_i[addr_rev];
		end
			
	end
			
	//====================================================
	//输出有效信号
	
	reg valid_out_r;
	
	always_ff@(posedge clk or negedge rst_n) begin
		
		if(!rst_n)
			valid_out_r <= 0;
		
		else if(cnt==(2**POW-1))
			valid_out_r <= 1;
			
		else	
			valid_out_r <= valid_out_r;
		
	end
	
	//---------------------------------------------------
	//延时一拍
	
	always_ff@(posedge clk or negedge rst_n) begin
		
		if(!rst_n)
			valid_out <= 0;
		
		else 
			valid_out <= valid_out_r;
		
	end
						
			
endmodule
