//=============================================================================
// Module Name:						Serializer
// Function Description:			Serializer
// Department:						Qualcomm (Shanghai) Co., Ltd.
// Author:							Verdvana
// Email:							verdvana@outlook.com
//-----------------------------------------------------------------------------
// Version 	Design		Coding		Simulate	Review		Rel date
// V1.0		Verdvana    Verdvana    Verdvana				Verdvana
//-----------------------------------------------------------------------------
// Version	Modified History
// V1.0		Multi-bit serialize.
//=============================================================================

// Include

// Define
//`define			FPGA_EMU

//Module
module Serializer #(
	parameter	DATA_WIDTH	= 8,								// Data width
				PARL_WIDTH	= 4									// Parallel width

)(
	// Clock and reset
	input	wire							clk,				// Clock
	input	wire							rst_n,				// Async reset

	input	wire							en,					// Enable
	input	wire							dir,				// Serial direction
	output	logic							valid,				// Serial data valid

	input	wire    [DATA_WIDTH-1:0]		par	[PARL_WIDTH],	// Parallel data input
	output	logic	[DATA_WIDTH-1:0]		ser					// Serial data output
);

	//=========================================================================
    // The time unit and precision of the internal declaration
    timeunit        1ns;
    timeprecision   1ps;


	//=========================================================================
	// Parameter
	localparam		TCO			= 0.6;

	//=========================================================================
	// Signal
	logic	[$clog2(PARL_WIDTH-1)-1:0]		cnt;				// Counter
	logic	[DATA_WIDTH-1:0]				data [PARL_WIDTH];	// Parallel data store


	//=========================================================================
	// Valid
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			valid   <= #TCO '0;
		else if(!(|cnt))
			valid	<= #TCO en;
    end

	//=========================================================================
	// Counter
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			cnt		<= #TCO '0;
		else if(!(|cnt))
			if(en)
				cnt		<= #TCO cnt + 1'b1;
			else
				cnt		<= #TCO '0;
		else if(cnt == PARL_WIDTH-1)
			cnt		<= #TCO '0;
		else
			cnt		<= #TCO cnt + 1'b1;
	end

	//=========================================================================
	// Parallel data store
	always_ff@(posedge clk, negedge rst_n)begin
		if(!rst_n)
			for(int i=0;i<PARL_WIDTH;i++)begin
				data[i]	<= #TCO '0;
			end
		else if(en && !(|cnt))
			if(dir)
				for(int i=0;i<PARL_WIDTH;i++)begin
					data[i]	<= #TCO par[PARL_WIDTH-1-i];
				end
			else
				for(int i=0;i<PARL_WIDTH;i++)begin
					data[i]	<= #TCO par[i];
				end
		else
			for(int i=0;i<PARL_WIDTH-1;i++)begin
				data[i]	<= #TCO data[i+1];
			end
	end

	//=========================================================================
	// Serial data output
	assign ser	= data[0];


endmodule


