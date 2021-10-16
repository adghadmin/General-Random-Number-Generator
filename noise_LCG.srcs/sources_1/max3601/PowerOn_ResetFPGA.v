module PoweON_ResetFPGA(
           input 		wire		clk_100M,
           output 		reg			reset_FPGA
       );


parameter 	state_idle=2'b00,
			state_start=2'b01,
			state_start1=2'b10;
reg [1:0] 	state=state_idle;
reg [31:0] 	delay_count=32'h0;  //1us


always@(posedge clk_100M)
    begin
        case(state)
            state_idle:
                begin
                    reset_FPGA <= 1'b1;
                    //if(delay_count==32'h17D7840)   //0.25s
					if(delay_count==32'd30)   //30us
                        begin
                            state <= state_start;
                            delay_count <= 32'h0;
                        end
                    else
                        begin
                            delay_count<=delay_count+1;
                        end
                end

            state_start:
                begin
                    reset_FPGA <= 1'b0;
                    if(delay_count==32'd30000)  //30ns
                        begin
                            state <= state_start1;
                        end
                    else
                        begin
                            delay_count<=delay_count+1;
                        end
                end

            state_start1:
                begin
                    reset_FPGA <= 1'b1;
                end
        endcase
    end
endmodule
