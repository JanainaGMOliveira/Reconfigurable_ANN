`timescale 1ns/10ps
import ann_pkg::*;
`include "ann_pkg.sv"
`include "test/neuron_test.sv"
`include "ann_macros.svh"

module uvm_tb_top;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   import ann_pkg::*;
   
    neuron_bfm  bfm();

    neuron #(.neurons(NEURON_MAX_NUMBER), .N(NEURON_DATA_BITS)) 
            DUT(
                .oNeuron      (bfm.neuronValue  ),
                .oReadyNeuron (bfm.readyNeuron  ),
                .clk          (bfm.clk          ),
                .iEnable      (bfm.enable       ),
                .iStart       (bfm.start        ),
                .ix           (bfm.ix           ),
                .iw           (bfm.iw           ),
                .iBias        (bfm.bias         ),
                .enableBias   (bfm.enableBias   ),
                .iCtrlAF      (bfm.ctrlAF       ),
                .iNumberInputs(bfm.numberInputs )
            );

    initial
    begin
        `uvm_info("TOP", "TOP UVM", UVM_MEDIUM)
        uvm_config_db #(virtual neuron_bfm)::set(null, "*", "bfm", bfm);

        $dumpfile("uvm_tb_top.vcd");
        $dumpvars(0, uvm_tb_top);

        run_test();
    end

    initial
    begin
        fork
            bfm.generate_clock(CLK_PERIOD);
        join_none
    end
    
endmodule : uvm_tb_top
