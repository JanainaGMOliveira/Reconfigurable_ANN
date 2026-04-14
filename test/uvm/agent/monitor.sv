`ifndef MONITOR_SV
`define MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../ann_macros.svh"
`include "../transaction_neuron.sv"

class neuron_monitor extends uvm_monitor;
    `uvm_component_utils(neuron_monitor)
    
    virtual neuron_bfm bfm;
    uvm_analysis_port #(neuron_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        ap = new("ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual neuron_bfm)::get(this, "", "bfm", bfm))
            `uvm_fatal("NEURON MONITOR", "Virtual interface 'bfm' not set.")
    endfunction
    
    task run_phase(uvm_phase phase);
        monitor_neuron();
    endtask

    task monitor_neuron();
        neuron_transaction transaction;
        integer i;

        forever
        begin
            @(posedge bfm.readyNeuron)
            @(posedge bfm.clk)
            
            transaction = neuron_transaction::type_id::create("transaction");
            transaction.enable       = bfm.enable;
            transaction.ctrlAF       = bfm.ctrlAF;
            transaction.numberInputs = bfm.numberInputs;

            transaction.bias         = bfm.bias;
            transaction.enableBias   = bfm.enableBias;

            for (i = 0; i < NEURON_MAX_NUMBER; i = i + 1)
            begin
                transaction.ix[i] = bfm.ix[(i*NEURON_DATA_BITS + NEURON_DATA_BITS-1) -: NEURON_DATA_BITS];
            end

            for (i = 0; i < NEURON_MAX_NUMBER; i = i + 1)
            begin
                transaction.iw[i] = bfm.iw[(i*2*NEURON_DATA_BITS + 2*NEURON_DATA_BITS-1) -:2*NEURON_DATA_BITS];
            end

            transaction.neuronValue = bfm.neuronValue;
            transaction.readyNeuron = bfm.readyNeuron;
            ap.write(transaction);
        end
    endtask
endclass : neuron_monitor
`endif 