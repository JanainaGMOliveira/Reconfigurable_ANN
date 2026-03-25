`ifndef TRANSACTIONS_SV
`define TRANSACTIONS_SV

import uvm_pkg::*;    
    `include "uvm_macros.svh"

`include "ann_macros.svh"

class neuron_transaction extends uvm_sequence_item;
    rand bit [NEURON_DATA_BITS - 1:0]     ix [0:NEURON_MAX_NUMBER - 1];
    rand bit [2 * NEURON_DATA_BITS - 1:0] iw [0:NEURON_MAX_NUMBER - 1];
    rand bit [2 * NEURON_DATA_BITS - 1:0] bias;
    rand bit                              enable;
    rand bit                              start;
    rand bit                              enableBias;
    rand bit [1:0]                        ctrlAF;
	rand bit [4:0]                        numberInputs;

    bit [NEURON_DATA_BITS - 1:0]          neuronValue;
	bit                                   readyNeuron;
    
    `uvm_object_utils_begin(neuron_transaction)
        `uvm_field_int(ix, UVM_ALL_ON)
        `uvm_field_int(iw, UVM_ALL_ON)
        `uvm_field_int(bias, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
        `uvm_field_int(start, UVM_ALL_ON)
        `uvm_field_int(enableBias, UVM_ALL_ON)
        `uvm_field_int(ctrlAF, UVM_ALL_ON)
        `uvm_field_int(numberInputs, UVM_ALL_ON)
        `uvm_field_int(neuronValue, UVM_ALL_ON)
        `uvm_field_int(readyNeuron, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "neuron_transaction");
        super.new(name);
    endfunction
endclass : neuron_transaction

`endif