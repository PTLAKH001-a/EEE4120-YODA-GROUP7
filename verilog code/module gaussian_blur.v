module gaussian_blur(
    input clk,
    input [71:0] pixel_data,
    input pixel_data_valid,
    output reg [7:0] convolved_data,
    output reg convolved_data_valid
);

    integer i;
    reg [7:0] gaussian_kernel [8:0];
    reg [15:0] multiplied_data [8:0];
    reg [15:0] sum_data_1;
    reg [15:0] sum_data_2;
    reg sum_data_valid, multiplied_data_valid, convolved_data_valid;
    
    initial begin
       gaussian_kernel[0] = 1;
       gaussian_kernel[1] = 2;
       gaussian_kernel[2] = 1;
       gaussian_kernel[3] = 2;
       gaussian_kernel[4] = 4;
       gaussian_kernel[5] = 2;
       gaussian_kernel[6] = 1;
       gaussian_kernel[7] = 2;
       gaussian_kernel[8] = 1;
    end
    
    always @(posedge clk) begin
        for (i = 0; i < 9; i = i + 1) begin
            multiplied_data[i] <= gaussian_kernel[i] * pixel_data[i * 8 +: 8];
        end
        multiplied_data_valid <= pixel_data_valid;
    end


   always @(*) begin
        sum_data_1 = 0;
        for (i = 0; i < 9; i = i + 1) begin
            sum_data_1 = sum_data_1 + multiplied_data[i];
        end
   end

   always @(posedge clk) begin
        sum_data_2 <= sum_data_1;
        sum_data_valid <= multiplied_data_valid;
   end
    
   always @(posedge clk) begin
        convolved_data <= sum_data_2 / 16;
        convolved_data_valid <= sum_data_valid;
   end

endmodule
