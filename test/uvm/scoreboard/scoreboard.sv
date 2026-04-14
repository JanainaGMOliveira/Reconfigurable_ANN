`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../transaction_neuron.sv" 
`include "../ann_macros.svh" 

class neuron_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(neuron_scoreboard)
    
    uvm_analysis_imp #(neuron_transaction, neuron_scoreboard) ap_imp;

    int neuron_transaction_count = 0;
    int neuron_cripto_count = 0;
    int neuron_decripto_count = 0;
    int errors;
    
    bit [NEURON_DATA_BITS-1:0] wordInputCripto;
    bit [NEURON_DATA_BITS-1:0] cipherOutputCripto;
    bit [NEURON_DATA_BITS-1:0] wordOutputDecripto;
    bit [NEURON_DATA_BITS-1:0] cipherInputDecripto;
    bit [NEURON_DATA_BITS-1:0] keyCripto;
    bit [NEURON_DATA_BITS-1:0] keyDecripto;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        ap_imp    = new("ap_imp", this);
    endfunction : new

    function bit [NEURON_DATA_BITS-1:0] calculate_golden_model(neuron_transaction item);
        real z;
        int  i;
        bit [NEURON_DATA_BITS-1:0] expected_out

        z = 0.0;
        for (i = 0; i < item.numberInputs; i = i + 1)
        begin
            z += item.ix[i] * item.iw[i];
        end

        // Aplica a função de ativação (variável conforme o teste)
        case (tr.ctrlAF)
            2'b00:    expected_out = (z >= 0.0) ? 8'b001_00000 : 8'b111_00000;
            2'b01:    expected_out = z[22:15];
            default: `uvm_fatal("SCB", "Ativação desconhecida")
        endcase

        return expected_out;
    endfunction

    function void write(neuron_transaction item);
        neuron_transaction_count++;
        
        // if (item.operation == 1)
        // begin
        //     keyDecripto = item.key;
        //     cipherInputDecripto = item.word;
        //     wordOutputDecripto = item.cipher;
        //     neuron_decripto_count++;
        // end
        // else
        // begin
        //     keyCripto = item.key;
        //     wordInputCripto = item.word;
        //     cipherOutputCripto = item.cipher;
        //     neuron_cripto_count++;
        // end

        // if (item.cipher === 128'h0 && item.word !== 128'h0)
        //     `uvm_error("SCOREBOARD", $sformatf("Cipher is zero to word=%h key=%h op=%0b", item.word, item.key, item.operation))

        `uvm_info("NEURON SCOREBOARD", $sformatf("Receiving NEURON values: 0x%h", item.neuronValue), UVM_MEDIUM)
        check_values();
    endfunction

    function check_values();
        // if (neuron_decripto_count == neuron_cripto_count && neuron_transaction_count != 0)
        // begin
        //     if (keyCripto == keyDecripto && cipherOutputCripto == cipherInputDecripto) // the cripto output is the decripto input
        //     begin
        //         if (wordInputCripto != wordOutputDecripto)
        //         begin
        //             errors++;
        //             `uvm_info("SCOREBOARD", $sformatf("Input cripto: %h | Output decripto: %h", wordInputCripto, wordOutputDecripto), UVM_MEDIUM);
        //         end
        //     end
        // end
        

    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("SCOREBOARD", "===================== Scoreboard Report ====================", UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NEURON criptography:   %0d", neuron_cripto_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NEURON decriptography: %0d", neuron_decripto_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NEURON operations:     %0d", neuron_transaction_count), UVM_LOW)
        `uvm_info("SCOREBOARD", "------------------------------------------------------------", UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Errors:                          %0d              ", errors), UVM_LOW)
        `uvm_info("SCOREBOARD", "============================================================", UVM_LOW)
        
        if(errors > 0)
            `uvm_error("SCOREBOARD", "TEST FAILED: Scoreboard reported mismatches.")
        else
            `uvm_info("SCOREBOARD", "Test completed with NO errors!", UVM_LOW)
    endfunction
endclass
`endif


