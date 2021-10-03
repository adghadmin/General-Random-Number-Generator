module ffd (
				DATA_IN , 
				DATA_OUT , 
				clk_100M
				);
input clk_100M;
input DATA_IN ;
output DATA_OUT ;


reg DATA_OUT_TEMP;

	always @(posedge clk_100M )
	begin
				DATA_OUT_TEMP = DATA_IN ;
	end

	assign DATA_OUT = DATA_OUT_TEMP;

endmodule