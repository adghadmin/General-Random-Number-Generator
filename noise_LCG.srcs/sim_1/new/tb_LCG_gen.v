`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module tb_LCG_gen();
    
reg                    					I_sys_clk            ='d0	; //system clock
reg                    					I_sys_rst            ='d1	; //system reset,active high

reg                    					I_seqgen_en          ='d0	; //sequence data generate enable, active high
reg   				[31:00]          	I_seed_value         ='d0	; //seed value, range: [2^31 - 2] 

wire                   					O_seq_dvld           		; //sequence data valid
wire    			[31:00]       		O_seq_data           		;  //sequence data
LCG_gen #(
    .Q                					( 32						) //number of bits used to represent integer random numbers
)LCG_gen
(
	.I_sys_clk            				( I_sys_clk					), //system clock
	.I_sys_rst            				( I_sys_rst					), //system reset,active high

	.I_seqgen_en          				( I_seqgen_en				), //sequence data generate enable, active high
	.I_seed_value         				( I_seed_value				),  //seed value, range: [2^31 - 2] 

	.O_seq_dvld           				( O_seq_dvld				), //sequence data valid
	.O_seq_data           				( O_seq_data				)   //sequence data
);
always #5 I_sys_clk = ~I_sys_clk;

initial begin
	#100
	I_sys_rst = 'd0;
	#100
	I_seed_value = 1;
	#100
	I_seqgen_en = 1;
	
	#1_000
	I_seqgen_en = 0;
    #100
    I_seqgen_en = 1;
	#1_000
    I_seqgen_en = 0;
end

    integer F_noise ;
    initial begin
        F_noise = $fopen("D:/F_noise.txt" ,"w"); // to generate the location of the simulation file
        #(40_000);
        $fclose(F_noise );
        $stop;
    end

    //log noise
    always @(posedge I_sys_clk) begin
        if(O_seq_dvld) begin
            $fdisplay(F_noise, "%d", O_seq_data);
        end
    end

endmodule
