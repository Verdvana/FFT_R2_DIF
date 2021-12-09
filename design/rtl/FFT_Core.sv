//=============================================================================
// Module Name:				FFT_Core
// Function Description:	FFT Core
// Department:				Qualcomm (Shanghai) Co., Ltd.
// Author:					Verdvana
// Email:					verdvana@outlook.com
//-----------------------------------------------------------------------------
// Version	Design		Coding		Simulate    Review      Rel date
// V1.0		Verdvana	Verdvana	Verdvana				2019-11-19
// V2.0		Verdvana	Verdvana	Verdvana				2021-11-21
// V2.1		Verdvana	Verdvana	Verdvana				2021-12-03
//-----------------------------------------------------------------------------
// Version	Modified History
// V1.0		DIF Radix 2 FFT Core;
//			Data width is configurable;
//			The number of sampling points is configurable.
// V2.0 	FFT butterfly transformation is update to pipeline.
// V2.1		FFT butterfly transformation is update to 2 series pipeline.
//=============================================================================

// Include

// Define
//`define			FPGA_EMU

//Module
module FFT_Core #(
    parameter   DATA_WIDTH	= 11,											// Data width
				POW			= 3												// The sampling points is N，POW=log2(N)
)(	
	input	wire									clk,					// Clock
	input	wire									rst_n,					// Async reset

	input  	wire	signed [DATA_WIDTH-1:0]			sink_r [2**POW],		// The real part of the input data
	input  	wire	signed [DATA_WIDTH-1:0]			sink_i [2**POW],		// The imaginary part of input data
	output 	logic	signed [DATA_WIDTH+2*POW-1:0]	source_r [2**POW],		// The real part of the output data
	output 	logic	signed [DATA_WIDTH+2*POW-1:0]	source_i [2**POW],		// The imaginary part of output data

	input	wire									en,						// Input data Enable
	output	logic									valid					// Output data valid
);

	//=========================================================
	//The time unit and precision of the internal declaration
	timeunit        	1ns;
	timeprecision   	1ps;

	//=========================================================
	// Function of binary code inversion
    function	bit [POW-1:0] bitinv;
    input 		bit [POW-1:0] bincode;
        for(int p=0;p<POW;p++)
            bitinv[p] = bincode[POW-1-p];
    endfunction

	localparam 	DATA_NUM 	= 2**POW,			// Data number
				TCO			= 2;				// Simulate the delay of the register

	
	//=========================================================
	// Butterfly transformation
	//---------------------------------------------------------
	// declaration of connected wire
	genvar k;
	generate for(k=0;k<=POW;k++)
	begin:connect
		wire signed [DATA_WIDTH+2*k-1:0] cn_re [DATA_NUM];
		wire signed [DATA_WIDTH+2*k-1:0] cn_im [DATA_NUM];
	end
	endgenerate
	//---------------------------------------------------------
	// Connect the butterfly transform module
	genvar i,j;	
	generate for(i=0;i<POW;i++)
	begin:series
		for(j=0;j<(2**i);j++)
		begin:number
			Butterfly #(
				.DATA_WIDTH(DATA_WIDTH),
				.SERIES(i),
				.POW(POW)			
			)u_Butterfly(	
				.clk(clk),
				.rst_n(rst_n),	
				.sink_r(connect[i].cn_re[(j*2**(POW-i)):((j*2**(POW-i))+(2**(POW-i))-1)]),
				.sink_i(connect[i].cn_im[(j*2**(POW-i)):((j*2**(POW-i))+(2**(POW-i))-1)]),
				.source_r(connect[i+1].cn_re[(j*2**(POW-i)):((j*2**(POW-i))+(2**(POW-i))-1)]),
				.source_i(connect[i+1].cn_im[(j*2**(POW-i)):((j*2**(POW-i))+(2**(POW-i))-1)])	
			);
		end
	end
	endgenerate

	//=========================================================
	// Input and Output
	genvar m;
	generate for(m=0;m<DATA_NUM;m++)
	begin:in
		assign	connect[0].cn_re[m]	= sink_r[m];
		assign	connect[0].cn_im[m]	= sink_i[m];
	end
	endgenerate

	genvar n;
	generate for(n=0;n<DATA_NUM;n++)
	begin:out    
		assign	source_r[n] = connect[POW].cn_re[bitinv(n)];
		assign	source_i[n] = connect[POW].cn_im[bitinv(n)];
	end
	endgenerate

	//=========================================================
	// Enable and valid
	logic [POW*2-1:0]	en_ff;
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			en_ff	<= #TCO '0;
		else
			en_ff	<= #TCO {en_ff[POW*2-2:0],en};
	end
	assign	valid	= en_ff[POW*2-1];

endmodule
