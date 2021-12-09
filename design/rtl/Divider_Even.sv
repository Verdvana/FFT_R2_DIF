//=============================================================================
// Module Name:						Divider_Even
// Function Description:			Even Divider
// Department:						Qualcomm (Shanghai) Co., Ltd.
// Author:							Verdvana
// Email:							verdvana@outlook.com
//-----------------------------------------------------------------------------
// Version 	Design		Coding		Simulate	Review		Rel date
// V1.0		Verdvana    Verdvana    Verdvana				Verdvana
//-----------------------------------------------------------------------------
// Version	Modified History
// V1.0		Even Divider
//=============================================================================

// Include

// Define
//`define			FPGA_EMU

//Module
module Divider_Even#(
	parameter		DIV_COEFF	= 8

)(
	// Clock and reset
	input	wire							clk,			// Clock
	input	wire							rst_n,			// Async reset
	//input	wire							en,				//

	output	logic							clk_div			// Divided clock
);

	// The time unit and precision of the internal declaration
	timeunit        1ns;
	timeprecision   1ps;


	//=========================================================================
	// Parameter
	localparam		TCO			= 1.6;

	//=========================================================================
	// Signal
	logic [$clog2(DIV_COEFF/2-1)-1:0]		cnt;			// Counter

	//=========================================================================
	// Divided Counter
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			cnt		<= #TCO '0;
		else if(cnt >= (DIV_COEFF/2))
			cnt		<= #TCO '0;
		else
			cnt		<= #TCO cnt + 1'b1;
	end

	//=========================================================================
	// Divided clock output
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			clk_div	<= #TCO '0;
		else if(cnt == (DIV_COEFF/2-1))
			clk_div	<= #TCO ~clk_div;
		else
			clk_div	<= #TCO clk_div;
	end

endmodule