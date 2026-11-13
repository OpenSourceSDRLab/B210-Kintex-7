`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Copyright (c) OpenSourceSDRLab
// https://www.opensourcesdrlab.com
// -----------------------------------------------------------------------------
// File   : pps_switch.v
// Purpose: select the PPS source: onboard GPS first, external PPS otherwise
// -----------------------------------------------------------------------------

module pps_switch (
    input  wire        clk,          // system clock (10 MHz or higher recommended)
    input  wire        rst_n,        // active-low asynchronous reset
    input  wire        gps_pps,      // PPS from the onboard GPS module
    input  wire        ext_pps,      // external PPS input
    output reg         pps_out       // selected PPS output
);

    // currently selected PPS source
    reg active_pps_source;  // 0=GPS, 1=EXT
    
    // edge detectors: one-clock high pulse on each rising edge
    wire gps_posedge;
    wire ext_posedge;

    edge_detect u_gps_edge (
        .clk(clk),
        .rst_n(rst_n),
        .din(gps_pps),
        .dout(gps_posedge)
    );

    edge_detect u_ext_edge (
        .clk(clk),
        .rst_n(rst_n),
        .din(ext_pps),
        .dout(ext_posedge)
    );

    // state machine: 0 = wait for GPS, 1 = wait for EXT
    reg [1:0] state;
    localparam S_GPS = 2'b00;
    localparam S_EXT = 2'b01;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= S_GPS;
            active_pps_source <= 1'b0;  // GPS by default
        end 
        else begin
            case (state)
                S_GPS: begin
                    if (gps_posedge) begin
                        state   <= S_GPS; // GPS keeps priority
                        active_pps_source <= 1'b0;  // select GPS
                    end else if (ext_posedge) begin
                        state   <= S_GPS; // GPS keeps priority, EXT fills in while GPS has no pulse
                        active_pps_source <= 1'b1;  // select EXT
                    end
                end
                default: begin  // simplified; extend the state machine if needed
                    if (ext_posedge) begin
                        state   <= S_GPS; // back to waiting for GPS
                        active_pps_source <= 1'b1;  // select EXT
                    end
                end
            endcase
        end
    end

    // output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pps_out <= 1'b0;
        else 
            pps_out <= active_pps_source ? ext_pps : gps_pps;
    end

endmodule
