`timescale 1ns/10ps

module fft_fifo_top_tb;

    parameter DATA_WIDTH = 16;
    logic clk, rst;

    // ============== DUT Interface ===================
    logic write_en_external, read_en_external;
    logic signed [DATA_WIDTH-1:0] data_in_external;
    logic signed [DATA_WIDTH-1:0] data_out_external;

    // ================ Clock Generation ===============
    always #7.5 clk = ~clk;

    // ================ Instantiate DUT =================
    fft_fifo_top #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .write_en_external(write_en_external),
        .read_en_external(read_en_external),
        .data_in_external(data_in_external),
        .data_out_external(data_out_external)
    );


    // ============= Test Procedure ==============
    initial begin
        $display("==== FFT FIFO Top Testbench ====");
        clk = 0;
        rst = 0;
        write_en_external = 0;
        read_en_external = 0;
        data_in_external = 0;

        #15;
        rst = 1;
        #45;
	write_en_external = 1;
      	#30;
        // ============= Step 1: Feed 1st 8 real samples =============
        for (int i = 0; i < 8; i++) begin
			@(posedge clk);
			write_en_external = 1;
			data_in_external = (i+1); // real part: 1 to 8
			$display("Test bench val bef: %0.2f", data_in_external);
    	    data_in_external = data_in_external <<< 8;
        end

        // ============== Step 2: Feed 1st 8 imaginary samples ===============
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            write_en_external = 1;
            data_in_external = 0; // imag part: 0
        end

        // ============== Step 3: Feed 2nd 8 real samples ===============
        for (int i = 0; i < 8; i++) begin
			@(posedge clk);
			write_en_external = 1;
			data_in_external = (i+2); // real part: 1 to 8
			$display("Test bench val bef: %0.2f", data_in_external);
    	    data_in_external = data_in_external <<< 8;
        end

        // ============== Step 4: Feed 2nd 8 imaginary samples =================
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            write_en_external = 1;
            data_in_external = 0; // imag part: 0
        end


        // ============= Finish write ==================
        @(posedge clk);
        write_en_external = 0;
        data_in_external = 0;

        // ============ Step 3: Wait and read output ===============
        wait_for_fft_output();
        $display("==== FFT Output from Output FIFO ====");

      	
        read_en_external = 1;
      #30;
    
      	for (int i = 0; i < 32; i++) begin
          @(posedge clk);
            #1.5; 
          $display("FFT Output [%0d] = %0.2f", i, $itor(data_out_external) / 256.0);
        end
#15;
        read_en_external = 0;
        $display("==== Test Completed ====");
        #30 $finish;
    end

    task wait_for_fft_output();
        $display("Waiting for FFT to complete and output to become available...");
       
	wait (dut.current_state == 3'b110);
        @(posedge clk); // wait for at least one valid sample
    	#30;
    endtask

endmodule
