`ifndef DRIVER_SV
`define DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../ann_macros.svh"
`include "../transaction_neuron.sv"

class neuron_driver extends uvm_driver #(neuron_transaction);
    `uvm_component_utils(neuron_driver)

    virtual neuron_bfm bfm;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual neuron_bfm)::get(this, "", "bfm", bfm))
        begin
            `uvm_fatal("NEURON DRIVER", "Virtual interface 'bfm' not set.")
        end
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        neuron_transaction item;

        forever
        begin
            seq_item_port.get_next_item(item);

            send_command(item);

            seq_item_port.item_done();
        end
    endtask : run_phase

    task send_command(neuron_transaction item);
        integer i;

        bfm.start        <= 1;

        bfm.enable       <= item.enable;
        bfm.ctrlAF       <= item.ctrlAF;
        bfm.numberInputs <= item.numberInputs;

        bfm.bias        <= item.bias;
        bfm.enableBias   <= item.enableBias;

        for (i = 0; i < NEURON_MAX_NUMBER; i = i + 1)
		begin
			bfm.ix[(i*NEURON_DATA_BITS + NEURON_DATA_BITS-1) -: NEURON_DATA_BITS] <= item.ix[i];
		end

        for (i = 0; i < NEURON_MAX_NUMBER; i = i + 1)
		begin
			bfm.iw[(i*2*NEURON_DATA_BITS + 2*NEURON_DATA_BITS-1) -:2*NEURON_DATA_BITS] <= item.iw[i];
		end

        @(posedge bfm.clk)
        bfm.start        <= 0;

        @(posedge bfm.readyNeuron);
        @(posedge bfm.clk);
    endtask
endclass : neuron_driver
`endif