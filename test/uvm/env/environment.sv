`ifndef ENV_SV
`define ENV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../agent/agent.sv"
`include "../scoreboard/scoreboard.sv" 
`include "../coverage/coverage.sv"

class neuron_env extends uvm_env;
    `uvm_component_utils(neuron_env)
    
    neuron_agent      neuron_agt;
    neuron_scoreboard scoreboard;
    neuron_coverage   neuron_cvg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        neuron_agt = neuron_agent::type_id::create("neuron_agt", this);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "neuron_agt", "is_active", UVM_ACTIVE);

        scoreboard = neuron_scoreboard::type_id::create("scoreboard", this);
        neuron_cvg = neuron_coverage::type_id::create("neuron_cvg", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        neuron_agt.monitor.ap.connect(scoreboard.ap_imp);
        neuron_agt.monitor.ap.connect(neuron_cvg.analysis_export);
    endfunction
endclass : neuron_env

`endif
