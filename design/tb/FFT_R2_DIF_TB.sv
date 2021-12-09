//=============================================================================
//
// Module Name:					FFT_R2_DIF_TB
// Department:					Qualcomm (Shanghai) Co., Ltd.
// Function Description:	    FFT_R2_DIF TestBench
//
//------------------------------------------------------------------------------
//
// Version 	Design		Coding		Simulata	  Review		Rel data
// V1.0		Verdvana	Verdvana	Verdvana		  			2021-12-03
//
//------------------------------------------------------------------------------
//
// Version	Modified History
// V1.0		FFT_R2_DIF Test
//
//=============================================================================

//=========================================================
// The time unit and precision
`timescale  1ns/1ps
//=========================================================
// Include

//=========================================================
// Define

//=========================================================
// Module
module FFT_R2_DIF_TB;
    //=========================================================
    //Parameter
    parameter   DATA_WIDTH	= 11,
				POW			= 3;

    parameter       TIN     = 0.6,
                    PERIOD_0   = 50;

    //=========================================================
    // Signal
    logic    									clk;
    logic    									clk_samp;
    logic                                        rst_n;
    logic        signed  [DATA_WIDTH-1:0]        sink_r;
    logic        signed  [DATA_WIDTH-1:0]        sink_i;
    logic  		signed  [DATA_WIDTH+2*POW-1:0]	source_r;
    logic  		signed  [DATA_WIDTH+2*POW-1:0]	source_i;
    logic 										en;
    logic 										valid;


    //=========================================================
    // Instantiate
    FFT_R2_DIF #(
        .DATA_WIDTH(DATA_WIDTH),
        .POW(POW)
    ) u_FFT_R2_DIF(
        .*
    );


    //=========================================================
    // Clock drive
    initial begin
        clk = '0;
        forever #(PERIOD_0/2) clk = ~clk;
    end


    //=========================================================
    // Task init
    task task_init;
        sink_r    = '0;
        sink_i  = '0;
        en    = '0;
        #TIN;
    endtask


    //=========================================================
    // Task reset
    task task_rst;
        rst_n    = '0;
        #50;
        rst_n    = '1;
        #50;
    endtask
/*
    shortint i;
    logic signed [DATA_WIDTH-1:0]   sin_1;
    initial begin
        forever begin
        #PERIOD_0;

        sin_1 = $sin(2*3.14*i/16)*512;
        i = i+1;
    end
    end

    shortint j;
    logic signed [DATA_WIDTH-1:0]   sin_2;
    initial begin
        forever begin
        #PERIOD_0;

        sin_2 = $sin(2*3.14*j/2)*512;
        j = j+1;
    end
    end

    shortint l;
    initial begin
        forever begin
        #PERIOD_0;

        sink_r = sin_1+sin_2;
        l = l+1;
    end
    end
*/

    //=========================================================
    // Simulation
    initial begin
        //Reset&Init
        task_init;
        task_rst;
        
        //sink_r = sin_1 + sin_2;

        // Simulation behavior
        en = 1;
        sink_r = 16'd12;
        #(PERIOD_0*8);
        sink_r = 16'd49;
        #(PERIOD_0*8);
        sink_r = 16'd2;
        #(PERIOD_0*8);
        sink_r = 16'd48;
        #(PERIOD_0*8);
        sink_r = 16'd70;
        #(PERIOD_0*8);
        sink_r = 16'd13;
        #(PERIOD_0*8);
        sink_r = 16'd5;
        #(PERIOD_0*8);
        sink_r = 16'd6;
        #(PERIOD_0*8);
        
        sink_r = 16'd476;
        #(PERIOD_0*8);
        sink_r = 16'd452;
        #(PERIOD_0*8);
        sink_r = 16'd54;
        #(PERIOD_0*8);
        sink_r = 16'd732;
        #(PERIOD_0*8);
        sink_r = 16'd43;
        #(PERIOD_0*8);
        sink_r = 16'd457;
        #(PERIOD_0*8);
        sink_r = 16'd543;
        #(PERIOD_0*8);
        sink_r = 16'd900;
        #(PERIOD_0*8);
        en =0;
        sink_r = 16'd0;


        #(PERIOD_0*200);

        #400;
        $display("\033[31;5m 仿真完成! \033[0m",`__FILE__,`__LINE__);
        $finish;
    end
	//=========================================================
	//VCS仿真
	`ifdef VCS_SIM
		//VCS系统函数
		initial begin
			$vcdpluson();                       //打开VCD+文件记录
			$fsdbDumpfile("./../sim/FFT_R2_DIF.fsdb");   //生成fsdb
			$fsdbDumpvars("+all");
			$vcdplusmemon();                    //查看多维数组
		end

		//后仿真
		`ifdef POST_SIM
		//=========================================================
		//back annotate the SDF file
		initial begin
			$sdf_annotate(	"../../synthesis/mapped/FFT_R2_DIF.sdf",
							FFT_R2_DIF_TB.u_FFT_R2_DIF,,,
							"TYPICAL",
							"1:1:1",
							"FROM_MTM");
			$display(\033[31;5m back annotate \033[0m",`__FILE__,`__LINE__);
		end
		`endif
	`endif
endmodule
