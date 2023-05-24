module sobel_filter (
  input clk,
  input reset,
  input [7:0] p_data,
  input valid,
  output [7:0] magnitude,
  output [7:0] direction,
  output valid_out
);

  reg [7:0] x_kernel [2:0];
  reg [7:0] y_kernel [2:0];
  reg [15:0] G_x_1, G_y_1;
  reg [31:0] G_x_square, G_y_square;
  reg [7:0] magnitude;
  reg [7:0] direction;
  reg G_valid;
  reg [7:0] convolved_data;
  reg convolved_data_valid;
  
  reg [7:0] p_data_reg [2:0];
  
  reg [2:0] i;
  reg [2:0] j;
  reg [2:0] k;
  
  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      x_kernel[0] <= 8'h02;
      x_kernel[1] <= 8'h01;
      x_kernel[2] <= 8'h00;
      y_kernel[0] <= 8'h02;
      y_kernel[1] <= 8'h01;
      y_kernel[2] <= 8'h00;
      G_x_1 <= 16'h0000;
      G_y_1 <= 16'h0000;
      G_x_square <= 32'h00000000;
      G_y_square <= 32'h00000000;
      magnitude <= 8'h00;
      direction <= 8'h00;
      G_valid <= 1'b0;
      convolved_data <= 8'h00;
      convolved_data_valid <= 1'b0;
      p_data_reg[0] <= 8'h00;
      p_data_reg[1] <= 8'h00;
      p_data_reg[2] <= 8'h00;
    end
    else
    begin
      if (valid)
      begin
        p_data_reg[0] <= p_data_reg[1];
        p_data_reg[1] <= p_data_reg[2];
        p_data_reg[2] <= p_data;
      end
    end
  end
  
  always @(posedge clk)
  begin
    if (valid)
    begin
      G_x_1 <= (p_data_reg[0] * x_kernel[0]) + (p_data_reg[1] * x_kernel[1]) + (p_data_reg[2] * x_kernel[2]);
      G_y_1 <= (p_data_reg[0] * y_kernel[0]) + (p_data_reg[1] * y_kernel[1]) + (p_data_reg[2] * y_kernel[2]);
      G_valid <= 1'b1;
    end
  end

  always @(posedge clk)
  begin
    if (G_valid)
    begin
      G_x_square <= G_x_1 * G_x_1;
      G_y_square <= G_y_1 * G_y_1;
      magnitude <= $sqrt(G_x_square + G_y_square);
      if (G_x_1 >= 0)
      begin
        case(G_x_1[5:0])
          6'h00: direction <= 8'h00;
          6'h01: direction <= 8'h1E;
          6'h02: direction <= 8'h3C;
          6'h03: direction <= 8'h5A;
          6'h04: direction <= 8'h78;
          6'h05: direction <= 8'h96;
          6'h06: direction <= 8'hB4;
          6'h07: direction <= 8'hD2;
          6'h08: direction <= 8'hF0;
          6'h09: direction <= 8'h0E;
          6'h0A: direction <= 8'h2C;
          6'h0B: direction <= 8'h4A;
          6'h0C: direction <= 8'h68;
          6'h0D: direction <= 8'h86;
          6'h0E: direction <= 8'ha4;
          6'h0F: direction <= 8'hc2;
          6'h10: direction <= 8'he0;
          6'h11: direction <= 8'hfe;
          6'h12: direction <= 8'h1C;
          6'h13: direction <= 8'h3A;
          6'h14: direction <= 8'h58;
          6'h15: direction <= 8'h76;
          6'h16: direction <= 8'h94;
          6'h17: direction <= 8'hb2;
          6'h18: direction <= 8'hd0;
          6'h19: direction <= 8'hee;
          6'h1A: direction <= 8'h0C;
          6'h1B: direction <= 8'h2A;
          6'h1C: direction <= 8'h48;
          6'h1D: direction <= 8'h66;
          6'h1E: direction <= 8'h84;
          6'h1F: direction <= 8'ha2;
          default: direction <= 8'hc0;
        endcase
      end
      else
      begin
        case(-G_x_1[5:0])
          6'h00: direction <= 8'h00;
          6'h01: direction <= 8'h22;
          6'h02: direction <= 8'h44;
          6'h03: direction <= 8'h66;
          6'h04: direction <= 8'h88;
          6'h05: direction <= 8'haa;
          6'h06: direction <= 8'hcc;
          6'h07: direction <= 8'hee;
          6'h08: direction <= 8'h10;
          6'h09: direction <= 8'h32;
          6'h0A: direction <= 8'h54;
          6'h0B: direction <= 8'h76;
          6'h0C: direction <= 8'h98;
          6'h0D: direction <= 8'hba;
          6'h0E: direction <= 8'hdc;
          6'h0F: direction <= 8'he;
          6'h10: direction <= 8'h02;
          6'h11: direction <= 8'h24;
          6'h12: direction <= 8'h46;
          6'h13: direction <= 8'h68;
          6'h14: direction <= 8'h8a;
          6'h15: direction <= 8'hac;
          6'h16: direction <= 8'hce;
          6'h17: direction <= 8'hf0;
          6'h18: direction <= 8'h12;
          6'h19: direction <= 8'h34;
          6'h1A: direction <= 8'h56;
          6'h1B: direction <= 8'h78;
          6'h1C: direction <= 8'h9a;
          6'h1D: direction <= 8'hbc;
          6'h1E: direction <= 8'hde;
          6'h1F: direction <= 8'h00;
          default: direction <= 8'h1E;
        endcase
      end
      valid_out <= 1'b1;
    end
    else
    begin
      magnitude <= 8'h00;
      direction <= 8'h00;
      valid_out <= 1'b0;
    end
  end
  
  always @(posedge clk)
  begin
    if (valid)
    begin
      convolved_data <= G_x_1 + G_y_1;
      convolved_data_valid <= 1'b1;
    end
    else
    begin
      convolved_data <= 8'h00;
      convolved_data_valid <= 1'b0;
    end
  end
  
endmodule
