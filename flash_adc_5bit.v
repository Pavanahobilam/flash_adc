`timescale 1ns / 1ps
// --------------------------------------------------------
// Top-Tier Quality 5-bit Flash ADC with Gray Code Output
// Designed for Synthesis, Simulation, and Industry Review
// --------------------------------------------------------

module flash_adc_5bit(
    input  wire [7:0] vin_p,      // Positive analog input (8-bit)
    input  wire [7:0] vin_n,      // Negative analog input (8-bit)
    output reg  [4:0] gray_out    // 5-bit Gray code output
);

    // -----------------------------------------------
    // Internal Registers
    // -----------------------------------------------
    reg   [7:0] diff;             // Differential voltage
    reg  [30:0] comp_out;         // Thermometer code output
    reg   [4:0] binary_out;       // Binary encoded output
    integer i;

    // -----------------------------------------------
    // Reference Voltage Ladder (Static)
    // Uniform step of 8 across 31 comparators
    // -----------------------------------------------
    wire [7:0] vref [0:30];
    assign vref[ 0] =  8'd8;   assign vref[ 1] =  8'd16;  assign vref[ 2] =  8'd24;  assign vref[ 3] =  8'd32;
    assign vref[ 4] =  8'd40;  assign vref[ 5] =  8'd48;  assign vref[ 6] =  8'd56;  assign vref[ 7] =  8'd64;
    assign vref[ 8] =  8'd72;  assign vref[ 9] =  8'd80;  assign vref[10] =  8'd88;  assign vref[11] =  8'd96;
    assign vref[12] = 8'd104;  assign vref[13] = 8'd112; assign vref[14] = 8'd120; assign vref[15] = 8'd128;
    assign vref[16] = 8'd136;  assign vref[17] = 8'd144; assign vref[18] = 8'd152; assign vref[19] = 8'd160;
    assign vref[20] = 8'd168;  assign vref[21] = 8'd176; assign vref[22] = 8'd184; assign vref[23] = 8'd192;
    assign vref[24] = 8'd200;  assign vref[25] = 8'd208; assign vref[26] = 8'd216; assign vref[27] = 8'd224;
    assign vref[28] = 8'd232;  assign vref[29] = 8'd240; assign vref[30] = 8'd248;

    // -----------------------------------------------
    // Core Logic: Comparator Ladder + Encoding
    // -----------------------------------------------
    always @(*) begin
        // Step 1: Compute differential input
        diff = vin_p - vin_n;

        // Step 2: Comparator ladder: Generate thermometer code
        for (i = 0; i < 31; i = i + 1) begin
            comp_out[i] = (diff > vref[i]) ? 1'b1 : 1'b0;
        end

        // Step 3: Thermometer to binary conversion
        binary_out = 5'd0;
        for (i = 0; i < 31; i = i + 1) begin
            if (comp_out[i])
                binary_out = binary_out + 1;
        end

        // Step 4: Binary to Gray code conversion
        gray_out[4] = binary_out[4];
        gray_out[3] = binary_out[4] ^ binary_out[3];
        gray_out[2] = binary_out[3] ^ binary_out[2];
        gray_out[1] = binary_out[2] ^ binary_out[1];
        gray_out[0] = binary_out[1] ^ binary_out[0];
    end

endmodule
module tb_flash_adc_5bit;

    reg [7:0] vin_p, vin_n;
    wire [4:0] gray_out;

    flash_adc_5bit_top uut (
        .vin_p(vin_p),
        .vin_n(vin_n),
        .gray_out(gray_out)
    );

    initial begin
        $display("Time\tVin_p - Vin_n\tGray Output");
        $monitor("%0t\t%d\t\t%05b", $time, vin_p - vin_n, gray_out);

        vin_p = 8'd128; vin_n = 8'd128; #10;  // 0 diff
        vin_p = 8'd160; vin_n = 8'd128; #10;  // +32 diff
        vin_p = 8'd200; vin_n = 8'd100; #10;  // +100 diff
        vin_p = 8'd255; vin_n = 8'd0;   #10;  // max diff
        vin_p = 8'd100; vin_n = 8'd120; #10;  // -20 diff
        vin_p = 8'd50;  vin_n = 8'd200; #10;  // -150 diff
        vin_p = 8'd180; vin_n = 8'd100; #10;  // +80 diff

        $finish;
    end

endmodule
