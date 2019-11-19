//------------------------------------------------------------------------------
//
//Module Name:					Butterfly.v
//Department:					Xidian University
//Function Description:	   蝶形变换模块
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-14
//
//-----------------------------------------------------------------------------------



module Butterfly #(
	parameter	DATA_WIDTH = 16,		//输入数据位宽，包含符号位
					SERIES = 0,				//级数
					POW = 4					//如果抽取点数为N，POW=log2(N)
)(		
		input  signed [DATA_WIDTH+8+SERIES-1:0]	sink_r [(2)**(POW-SERIES)],		//15位有效信号左移8位放大再加1位符号位:15+8+1=24位（以第一个蝶形变化模块为例）
		input  signed [DATA_WIDTH+8+SERIES-1:0]	sink_i [(2)**(POW-SERIES)],		//15位有效信号左移8位放大再加1位符号位:15+8+1=24位（以第一个蝶形变化模块为例）
		output signed [DATA_WIDTH+8+SERIES+1-1:0] source_r [(2)**(POW-SERIES)],		//23+位有效输入信号乘最大256也就是最多左移8位再加1个相同的数再右移8位复原再加1位信号：23+8+1-8+1=25位（以第一个蝶形变化模块为例）
		output signed [DATA_WIDTH+8+SERIES+1-1:0] source_i [(2)**(POW-SERIES)]		//23+位有效输入信号乘最大256也就是最多左移8位再加1个相同的数再右移8位复原再加1位信号：23+8+1-8+1=25位（以第一个蝶形变化模块为例）
);

	parameter DATA_NUM = 2**(POW-SERIES); 		//数据个数
	
	`include "W_Para_N16.sv"						//旋转因子
	

	
	//====================================================
	//前半部分
	
	genvar m;
	generate for(m=0;m<(DATA_NUM/2);m++)
		begin: even
			assign source_r[m] = ( sink_r[m] + sink_r[m+DATA_NUM/2] ) ;
			assign source_i[m] = ( sink_i[m] + sink_i[m+DATA_NUM/2] ) ;
		end
	endgenerate
	
	//====================================================
	//后半部分
	wire signed [DATA_WIDTH+8+8+SERIES+1-1:0] temporary_r_1 [DATA_NUM/2];	//实数部分乘积结果
	wire signed [DATA_WIDTH+8+8+SERIES+1-1:0] temporary_r_2 [DATA_NUM/2];
	wire signed [DATA_WIDTH+8+8+SERIES+1-1:0] temporary_i_1 [DATA_NUM/2];	//虚数部分乘积结果
	wire signed [DATA_WIDTH+8+8+SERIES+1-1:0] temporary_i_2 [DATA_NUM/2];
	
	genvar n;
	generate for(n=(DATA_NUM/2);n<DATA_NUM;n++)		
		begin: odd
			assign temporary_r_1[n-DATA_NUM/2] = ( sink_r[n-DATA_NUM/2] - sink_r[n] ) * w_r[(n-DATA_NUM/2)*((2**POW)/DATA_NUM)];
			assign temporary_r_2[n-DATA_NUM/2] = ( sink_i[n-DATA_NUM/2] - sink_i[n] ) * w_i[(n-DATA_NUM/2)*((2**POW)/DATA_NUM)];
			assign source_r[n] = ( temporary_r_1[n-DATA_NUM/2] - temporary_r_2[n-DATA_NUM/2] ) >> 8;
			
			assign temporary_i_1[n-DATA_NUM/2] = ( sink_r[n-DATA_NUM/2] - sink_r[n] ) * w_i[(n-DATA_NUM/2)*((2**POW)/DATA_NUM)];
			assign temporary_i_2[n-DATA_NUM/2] = ( sink_i[n-DATA_NUM/2] - sink_i[n] ) * w_r[(n-DATA_NUM/2)*((2**POW)/DATA_NUM)];
			assign source_i[n] = ( temporary_i_1[n-DATA_NUM/2] + temporary_i_2[n-DATA_NUM/2] ) >> 8;
			
		end
	endgenerate
	
	


endmodule

