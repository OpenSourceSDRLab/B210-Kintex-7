`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Copyright (c) OpenSourceSDRLab
// https://www.opensourcesdrlab.com
// -----------------------------------------------------------------------------
// File   : edge_detect.v
// Purpose: one-clock pulse on the rising edge of din
// -----------------------------------------------------------------------------

// Rising-edge detector
    module edge_detect (
        input  wire clk,
        input  wire rst_n,
        input  wire din,
        output wire  dout
    );
        reg din_d1, din_d2;
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                din_d1 <= 1'b0;
                din_d2 <= 1'b0;
            end else begin
                din_d1 <= din;
                din_d2 <= din_d1;
            end
        end
        assign dout = din_d1 & ~din_d2; // rising edge
    endmodule


