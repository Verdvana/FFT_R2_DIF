//------------------------------------------------------------------------------
//
//Module Name:					Butterfly_Series.v
//Department:					Xidian University
//Function Description:	   蝶形变换顶层模块
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-18
//
//-----------------------------------------------------------------------------------

module Butterfly_Series #(
	parameter	DATA_WIDTH = 16,		//输入数据位宽，包含符号位
					SERIES = 0,				//级数
					POW = 3					//如果抽取点数为N，POW=log2(N)
)(	
		input  signed [DATA_WIDTH+8+SERIES-1:0]	sink_r [2**POW],		
		input  signed [DATA_WIDTH+8+SERIES-1:0]	sink_i [2**POW],		
		output signed [DATA_WIDTH+8+SERIES+1-1:0] source_r [2**POW],	
		output signed [DATA_WIDTH+8+SERIES+1-1:0] source_i [2**POW]		
);


	parameter DATA_NUM = 2**(POW-SERIES); 	//数据个数

	
	//====================================================
	//蝶形变换
	genvar i;
	generate for(i=0;i<(2**SERIES);i++)
		begin:number
		
			Butterfly #(
				.DATA_WIDTH(DATA_WIDTH),
				.SERIES(SERIES),
				.POW(POW)			
			)u_Butterfly(		
				.sink_r(sink_r[(i*DATA_NUM)+:DATA_NUM]),
				.sink_i(sink_i[(i*DATA_NUM)+:DATA_NUM]),
				.source_r(source_r[(i*DATA_NUM)+:DATA_NUM]),
				.source_i(source_i[(i*DATA_NUM)+:DATA_NUM])		
			);
			
		end
	endgenerate


endmodule
