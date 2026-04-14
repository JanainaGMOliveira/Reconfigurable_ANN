`ifndef SEQUENCES_SV
`define SEQUENCES_SV

`include "../ann_macros.svh"
`include "../transaction_neuron.sv"

class neuron_random_seq extends uvm_sequence #(neuron_transaction);
    `uvm_object_utils(neuron_random_seq)

    int unsigned max_transactions = MAX_TRANSACTIONS;

    function new(string name = "neuron_random_seq");
        super.new(name);
    endfunction

    task body();
        neuron_transaction item;
        integer i;

        if (starting_phase != null)
        begin
            starting_phase.raise_objection(this);
        end

        `uvm_info("NEURON SEQUENCE", $sformatf("Starting %0d random NEURON commands", max_transactions), UVM_LOW)

        repeat (max_transactions)
        begin
            item = neuron_transaction::type_id::create("item");

            start_item(item);

            assert(item.randomize());
            item.enable = 1;
            item.enableBias = 0;
            item.ctrlAF = 1;
            item.numberInputs = item.numberInputs > 20 ? 20 : item.numberInputs;

            `uvm_info("NEURON SEQUENCE", $sformatf("Sending NEURON values"), UVM_MEDIUM)
            `uvm_info("NEURON SEQUENCE", $sformatf("Input number: %d", item.numberInputs), UVM_MEDIUM);
            for (i = 0; i < NEURON_MAX_NUMBER; i = i + 1)
            begin
                `uvm_info("NEURON SEQUENCE", $sformatf("Sending NEURON values: x=0x%h, w=0x%h", item.ix[i], item.iw[i]), UVM_MEDIUM);
            end

            finish_item(item);
        end

        if (starting_phase != null)
        begin
            starting_phase.drop_objection(this);
        end
    endtask

endclass : neuron_random_seq

// class neuron_corner_seq extends uvm_sequence #(neuron_transaction);
//     `uvm_object_utils(neuron_corner_seq)

//     int unsigned max_transactions = MAX_TRANSACTIONS;

//     function new(string name = "neuron_corner_seq");
//         super.new(name);
//     endfunction

//     task body();
        
//         if (starting_phase != null)
//         begin
//             starting_phase.raise_objection(this);
//         end

//         send(128'h0,    128'h0,    1);
//         send(128'h0,    128'h0,    0);
//         send('1,        '1,        1);
//         send('1,        '1,        0);
//         send(128'hAAAA, 128'hAAAA, 1);
//         send(128'hAAAA, 128'hAAAA, 0);
//         send(128'h0,    128'h0,    1);
//         send(128'h0,    '1,        1);
//         send(128'h0,    '1,        0);
//         send('1,        128'h0,    1);
//         send('1,        128'h0,    0);

//         if (starting_phase != null)
//         begin
//             starting_phase.drop_objection(this);
//         end
//     endtask

//     task send(logic [127:0] w, logic [127:0] k, logic op);
//         neuron_transaction item = neuron_transaction::type_id::create("item");

//         start_item(item);

//         item.word      = w;
//         item.key       = k;
//         item.operation = op;

//         finish_item(item);
//     endtask
// endclass : neuron_corner_seq
`endif