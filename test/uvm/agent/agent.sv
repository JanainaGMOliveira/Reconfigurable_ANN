`ifndef AGENT_SV
`define AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"

class neuron_agent extends uvm_agent;
    `uvm_component_utils(neuron_agent)
    
    neuron_sequencer sequencer;
    neuron_driver    driver;
    neuron_monitor   monitor;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);

        if (is_active == UVM_ACTIVE)
        begin
            sequencer = neuron_sequencer::type_id::create("sequencer", this);
            driver    = neuron_driver::type_id::create("driver", this);
        end
        else
        begin
            `uvm_info("NEURON AGENT", "Building PASSIVE NEURON AGENT: Only Monitor included.", UVM_HIGH)
        end

        monitor = neuron_monitor::type_id::create("monitor", this);

        if (!uvm_config_db#(virtual neuron_bfm)::get(this, "", "bfm", monitor.bfm))
        begin
            `uvm_fatal("NEURON AGENT", "Virtual interface 'bfm' not set for Monitor. Check environment build.")
        end

        if (is_active == UVM_ACTIVE)
        begin
            if (!uvm_config_db#(virtual neuron_bfm)::get(this, "", "bfm", driver.bfm))
            begin
                `uvm_fatal("NEURON AGENT", "Virtual interface 'bfm' not set for Driver. Check environment build.")
            end
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (is_active == UVM_ACTIVE)
        begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction : connect_phase

endclass : neuron_agent
`endif