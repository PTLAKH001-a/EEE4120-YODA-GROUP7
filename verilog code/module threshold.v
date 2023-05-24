module double_threshold(
    input clk,
    input [7:0] data_in,
    input data_in_valid,
    output reg [7:0] data_out,
    output data_out_valid);
    
    localparam UPPER_THRESHOLD = 220;
    localparam LOWER_THRESHOLD = 85;    //255/3 = 85
    
    assign data_out_valid = data_in_valid;
    always @ (posedge clk) begin
        if (data_in_valid) begin
            if (data_in > UPPER_THRESHOLD)
                data_out <= 8'hFF;    //strong pixels
            else if (data_in < LOWER_THRESHOLD) 
                data_out <= 8'h00;    //weak pixels
            else
                data_out <= data_in;     
        end
    end
endmodule
