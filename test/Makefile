TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/../src/tt_um_unsigned_divider.v
TOPLEVEL = tt_um_unsigned_divider
MODULE   = test   # test.py (without extension)

# iverilog with SystemVerilog 2012 just in case
COMPILE_ARGS += -g2012

include $(shell cocotb-config --makefiles)/Makefile.sim
