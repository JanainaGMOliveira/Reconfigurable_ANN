## Reconfigurable ANN
Project created for my master degree in 2017. In this repository I'm revisiting the code to do some improvements and creating an UVM test.

---

## Architecture

```
src/
├── 2017code/
│   ├── unidadeCamada/
│   │   ├── FAs.v
│   │   ├── MAC.v
│   │   └── Neuronio.v
│   ├── iris_TB.v
│   ├── mackey_TB.v
│   ├── sinc_TB.v
│   ├── redeGeral.v
│   ├── unidadeCamada.v
│   ├── unidadeClock.v
│   ├── unidadeInstrucao.v
│   └── unidadeMemoria.v
└── 2025code/
    ├── FAs.v
    ├── MAC.v
    ├── multiplier.v
    └── twos_complement.v

test/
├── tb/
│   ├── iris_TB.v
│   ├── mac_TB.v
│   ├── mackey_TB.v
│   └── sinc_TB.v
└── uvm/
    ├── agent/
    ├── coverage/
    ├── env/
    ├── scoreboard/
    ├── sequence/
    └── test/
```

### Component Roles

TODO: describe each component

---
