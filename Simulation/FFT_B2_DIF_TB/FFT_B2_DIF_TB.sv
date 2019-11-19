//------------------------------------------------------------------------------
//
//Module Name:					FFT_2_DIF_TB.v
//Department:					Xidian University
//Function Description:	   基2的频率抽取FFT变化实现
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana				        			2019-11-15
//
//-----------------------------------------------------------------------------------

`timescale 1ns/1ns

module FFT_B2_DIF_TB;

reg clk;
reg rst_n;

reg valid_in;

reg [15:0] sink_r;
reg [15:0] sink_i;

wire [15:0] source_r;
wire [15:0] source_i;

FFT_B2_DIF #(
	.DATA_WIDTH(16),
	.POW(4)
)u_FFT_B2_DIF(

		.clk(clk),
		.rst_n(rst_n),
		
		.valid_in(valid_in),
		
		.sink_r(sink_r),
		.sink_i(sink_i),
		.source_r(source_r),
		.source_i(source_i)
);

initial begin

	clk = 0;
	forever #(10) 
	clk = ~clk;
	
end

task task_rst;
begin
	rst_n <= 0;
	repeat(2)@(negedge clk);
	rst_n <= 1;
end
endtask

task task_sysinit;
begin
	valid_in <= 0;
	sink_r <= 0;
	sink_i <= 0;
end
endtask

initial
begin
	task_sysinit;
	task_rst;
	#10;
	
	valid_in <= 1;
	
	sink_r <= 15'd12;
	
	#20;
	
	sink_r <= 15'd49;
	
	#20;
	
	sink_r <= 15'd2;
	
	#20;
	
	sink_r <= 15'd48;
	
	#20;
	
	sink_r <= 15'd70;
	
	#20;
	
	sink_r <= 15'd13;
	
	#20;
	
	sink_r <= 15'd5;
	
	#20;
	
	sink_r <= 15'd6;
	
	#20;
	
	sink_r <= 15'd0;
	
	#100;


	
	
	
	
	
	
end

endmodule