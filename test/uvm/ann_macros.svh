`ifndef MACROS_SVH
`define MACROS_SVH
    localparam CLK_PERIOD = 20ns; // 50 MHz
    localparam CLK_FREQ   = 50_000_000;

    localparam NEURON_DATA_BITS = 8;
    localparam NEURON_MAX_NUMBER = 20;
    
    localparam MAX_TRANSACTIONS = 50;
`endif