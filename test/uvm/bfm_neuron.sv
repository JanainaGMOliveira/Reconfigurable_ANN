`ifndef BFM_SV
`define BFM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

interface neuron_bfm;
    bit clk;

    // Inputs
	bit enable; // sets if neuron is activated
	bit start; // starts neuron
	bit [(NEURON_MAX_NUMBER * NEURON_DATA_BITS) - 1:0] ix;
	bit [(NEURON_MAX_NUMBER * NEURON_DATA_BITS * 2)-1:0] iw;
	bit [2 * NEURON_DATA_BITS - 1:0] iBias;
	bit enableBias;
	bit [1:0] ctrlAF; // AF control: 00 bipolar, 01 rampa, 10 sig, 11 tanh.
	bit [4:0] numberInputs;
    
    // Outputs
    bit [NEURON_DATA_BITS - 1:0] neuronValue;
	bit readyNeuron;

    // task to generate clock signal
    task generate_clock(input real period = 20, bit clk_pol = 0, real delay = 0);
        clk = ~clk_pol;
        #(delay);

        forever
		begin
            clk = ~clk;
            #(period/2);
        end

    endtask : generate_clock
endinterface

`endif