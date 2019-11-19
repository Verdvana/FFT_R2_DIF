//------------------------------------------------------------------------------
//
//Module Name:					BitRev.v
//Department:					Xidian University
//Function Description:	   位码倒读
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		  			2019-11-14
//
//-----------------------------------------------------------------------------------

module BitRev #(
	parameter WIDTH = 3				//地址位数
)(
		input  [WIDTH-1:0]	x,		//正序
		output [WIDTH-1:0] 	y		//倒序
);	

	genvar i;
	generate
	
		for (i=0;i<WIDTH;i=i+1) 
		begin:gen
	
			assign y[WIDTH-1-i] = x[i];
	
		end

	endgenerate

endmodule
