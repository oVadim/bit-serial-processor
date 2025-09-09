# bit-serial-processor
A modular, distributed bit-serial processor core. Its independent modules perform mathematical operations directly on a serial bitstream using local clocks, synchronized by a Bit Clock (TX fall/RX rise) and Frame Sync. The modules can be chained into pipelines and distributed across FPGAs. Designed for I2S but works with any serial data protocol.
