//=============================================================================
// Module Name:						FFT_R2_DIF
// Function Description:			DIF Radix2 FFT
// Department:						Qualcomm (Shanghai) Co., Ltd.
// Author:							Verdvana
// Email:							verdvana@outlook.com
//-----------------------------------------------------------------------------
// Version 	Design		Coding		Simulate    Review		Rel date
// V1.0		Verdvana    Verdvana    Verdvana    Verdvana    2019-11-19
// V2.0		Verdvana    Verdvana    Verdvana    Verdvana    2021-12-06
//-----------------------------------------------------------------------------
// Version	Modified History
// V1.0		DIF Radix2 FFT;
//			Data width is configurable;
//			The number of sampling points is configurable.
// V2.0		Data stream.
//=============================================================================


// Define
//`define			FPGA_EMU

//Module
module  FFT_R2_DIF#(
    parameter   DATA_WIDTH	= 11,											// Data width
				POW			= 3												// The sampling points is N，POW=log2(N)
)(
	// Clock and reset
	input	wire									clk,			        // Clock
	input	wire									rst_n,                  // Async reset

	output  logic                                   clk_samp,				// Sampling clock

	input	wire	signed  [DATA_WIDTH-1:0]		sink_r,					// The real part of the input data in clk_samp domain
	input	wire	signed  [DATA_WIDTH-1:0]		sink_i,					// The imaginary part of input data in clk_samp domain
	output	logic	signed  [DATA_WIDTH+2*POW-1:0]	source_r,		        // The real part of the output data in clk domain
	output	logic	signed  [DATA_WIDTH+2*POW-1:0]	source_i,		        // The imaginary part of output data in clk domain

	input	wire									en,						// Input data Enable
	output	logic									valid					// Output data valid
);

    // The time unit and precision of the internal declaration
    timeunit        1ns;
    timeprecision   1ps;


	//=========================================================================
	// Parameter
	localparam		TCO			= 1.6;

	//=========================================================================
	// Signal
	logic signed [DATA_WIDTH-1:0]		cn_sink_r	[2**POW];
	logic signed [DATA_WIDTH-1:0]		cn_sink_i	[2**POW];
	logic signed [DATA_WIDTH+2*POW-1:0]	cn_source_r	[2**POW];
	logic signed [DATA_WIDTH+2*POW-1:0]	cn_source_i	[2**POW];
	logic								des_ready_r,des_ready_i;
	logic								fft_ready;
	logic								ser_ready_r,ser_ready_i;
	//=========================================================================
	// 	

	//=========================================================================
	// 	
    Divider_Even#(
		.DIV_COEFF(2**POW)
    )(
		.clk(clk),
		.rst_n(rst_n),	
		.clk_div(clk_samp)
);
    Deserializer #(
        .DATA_WIDTH(DATA_WIDTH),
        .PARL_WIDTH(2**POW)
    )u_Deserializer_r(
        .clk(clk_samp),
        .rst_n(rst_n),

        .dir(1'b0),
        .en(en),
        .valid(),
        .valid_str(des_ready_r),

        .ser(sink_r),
        .par(cn_sink_r)
    );

    Deserializer #(
        .DATA_WIDTH(DATA_WIDTH),
        .PARL_WIDTH(2**POW)
    )u_Deserializer_i(
        .clk(clk_samp),
        .rst_n(rst_n),

        .dir(1'b0),
        .en(en),
        .valid(),
        .valid_str(des_ready_i),

        .ser(sink_i),
        .par(cn_sink_i)
    );


    FFT_Core #(
		.DATA_WIDTH(DATA_WIDTH),
		.POW(POW)
    )u_FFT_Core(
        .clk(clk_samp),
        .rst_n(rst_n),

        .sink_r(cn_sink_r),
        .sink_i(cn_sink_i),
        .source_r(cn_source_r),
        .source_i(cn_source_i),

        .en(des_ready_r&des_ready_i),
        .valid(fft_ready)
    );

	Serializer #(
		.DATA_WIDTH(DATA_WIDTH+2*POW),
		.PARL_WIDTH(2**POW)
	)u_Serializer_r(
		.clk(clk),
		.rst_n(rst_n),	
		.en(fft_ready),
		.dir(1'b0),
		.valid(ser_ready_r),
		.par(cn_source_r),
		.ser(source_r)
	);

	Serializer #(
		.DATA_WIDTH(DATA_WIDTH+2*POW),
		.PARL_WIDTH(2**POW)
	)u_Serializer_i(
		.clk(clk),
		.rst_n(rst_n),	
		.en(fft_ready),
		.dir(1'b0),
		.valid(ser_ready_i),
		.par(cn_source_i),
		.ser(source_i)
	);

	assign valid = ser_ready_r&ser_ready_i;

endmodule
