//------------------------------------------------------------------------------
//
//Module Name:					FFT_B2_DIF.v
//Department:					Xidian University
//Function Description:	   可定制位宽和点数的基2的FFT变换模块
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-19
//
//-----------------------------------------------------------------------------------

module FFT_B2_DIF #(
	parameter	DATA_WIDTH = 16,									//输入数据位宽，包含符号位
					POW = 4												//如果抽取点数为N，POW=log2(N)
)(
		input							clk,								//时钟			
		input							rst_n,							//异步复位
			
		input							valid_in,						//输入数据有效信号，与第一个数据同时
		
		input	 signed [DATA_WIDTH-1:0]		sink_r,			//输入数据实部
		input	 signed [DATA_WIDTH-1:0]		sink_i,			//输入数据虚部
		
		output										valid_out,		//输出数据有效信号，与第一个数据同时
		
		output signed [DATA_WIDTH+POW-1:0] 	source_r,		//输出数据实部
		output signed [DATA_WIDTH+POW-1:0] 	source_i			//输出数据虚部
);

	parameter DATA_NUM = 2**POW;									//抽取点数N
	
	
	//====================================================
	//移位寄存并行输出模块

	wire signed [DATA_WIDTH+8-1:0] data_shift_r [DATA_NUM];	//实部
	wire signed [DATA_WIDTH+8-1:0] data_shift_i [DATA_NUM];	//虚部
	
	
	Shift_Register #(
		.DATA_WIDTH(DATA_WIDTH),
		.POW(POW)
	) u_Shift_Register (
			.clk(clk),
			.rst_n(rst_n),
			
			.valid_in(valid_in),
			
			.sink_r(sink_r),
			.sink_i(sink_i),
			
			.source_r(connect[0].cn_re),
			.source_i(connect[0].cn_im)	
			
	);
	
	


	//====================================================
	//蝶形变换模块
	
	//----------------------------------------------------
	//连接线

	genvar k;
	generate for (k=0;k<=POW;k++)
		begin:connect
			wire signed [DATA_WIDTH + 8 + k - 1:0] cn_re [DATA_NUM];
			wire signed [DATA_WIDTH + 8 + k - 1:0] cn_im [DATA_NUM];
		end
	endgenerate

/*
	//----------------------------------------------------
	//POW级蝶形变换
	//两层循环一次搞定，但仿真通不过，只能用下面的两层例化
	genvar i,j;	
	generate for (i=0;i<POW;i++)
		begin:series

		
			for (j=0;j<(2**i);j++)
				begin:number
					
					Butterfly #(
						.DATA_WIDTH(DATA_WIDTH),
						.SERIES(i),
						.POW(POW)			
					)u_Butterfly(		
						.sink_r(connect[i].cn_re[(j*2**(POW-i))+:(2**(POW-i))]),
						.sink_i(connect[i].cn_im[(j*2**(POW-i))+:(2**(POW-i))]),
						.source_r(connect[i+1].cn_re[(j*2**(POW-i))+:(2**(POW-i))]),
						.source_i(connect[i+1].cn_im[(j*2**(POW-i))+:(2**(POW-i))])		
					);
				
				end
						
		end
	endgenerate
*/

	//----------------------------------------------------
	//POW级蝶形变换

	genvar i;
	generate for(i=0;i<POW;i++)
		begin:serise

			Butterfly_Series #(
				.DATA_WIDTH(DATA_WIDTH),
				.SERIES(i),
				.POW(POW)			
			)u_Butterfly_Series(		
				.sink_r(connect[i].cn_re),
				.sink_i(connect[i].cn_im),
				.source_r(connect[i+1].cn_re),
				.source_i(connect[i+1].cn_im)		
			);	
		
		end
	endgenerate

	

	//====================================================
	//位码倒读和顺序输出模块
	
	Order_Adjustment #(
	.DATA_WIDTH(DATA_WIDTH),
	.POW(POW)
	)u_Order_Adjustment(
		.clk(clk),
		.rst_n(rst_n),
		
		.valid_in(valid_in),
		
		.sink_r(connect[POW].cn_re),
		.sink_i(connect[POW].cn_im),
	
		
		.valid_out(valid_out),
		
		.source_r(source_r),
		.source_i(source_i)	
	);



	

endmodule
