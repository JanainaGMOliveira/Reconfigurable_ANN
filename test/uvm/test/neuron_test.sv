`ifndef TEST_SV
`define TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../env/environment.sv"
`include "../sequences/sequence.sv"

class neuron_test extends uvm_test;
    `uvm_component_utils(neuron_test)
    
    neuron_env env;
    
    function new(string name = "neuron_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = neuron_env::type_id::create("env", this);
        `uvm_info("NEURON TEST", "End build_fase", UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        neuron_random_seq seq_random = neuron_random_seq::type_id::create("seq_random");
        neuron_corner_seq seq_corner = neuron_corner_seq::type_id::create("seq_corner");

        phase.raise_objection(this);
        
        seq_random.start(env.neuron_agt.sequencer);
        seq_corner.start(env.neuron_agt.sequencer);

        phase.drop_objection(this);
    endtask
endclass : neuron_test
`endif