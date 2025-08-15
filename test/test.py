import cocotb
from cocotb.triggers import RisingEdge, Timer

def pack_input(dividend, divisor):
    # [7:4]=dividend, [3:0]=divisor
    return ((dividend & 0xF) << 4) | (divisor & 0xF)

def extract_output(val):
    return (val >> 4) & 0xF, val & 0xF  # (quotient, remainder)

@cocotb.test()
async def divider_test(dut):
    dut._log.info("Starting Cocotb TB...")

    # Clock generator (100 MHz)
    async def clk_gen():
        while True:
            dut.clk.value = 0
            await Timer(5, units="ns")
            dut.clk.value = 1
            await Timer(5, units="ns")
    cocotb.start_soon(clk_gen())

    # Init + reset
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.ena.value = 1
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Main sweep (skip divisor=0)
    for dividend in range(16):
        for divisor in range(1, 16):
            dut.ui_in.value = pack_input(dividend, divisor)
            await RisingEdge(dut.clk)  # input latch
            await RisingEdge(dut.clk)  # output available
            await Timer(1, units="ns")

            q, r = extract_output(dut.uo_out.value.integer)
            assert q == dividend // divisor, f"{dividend}/{divisor}: Q {q} != {dividend // divisor}"
            assert r == dividend % divisor, f"{dividend}/{divisor}: R {r} != {dividend % divisor}"

    # Divide-by-zero behavior (expect 0xFF)
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await Timer(1, units="ns")
    assert dut.uo_out.value.integer == 0xFF, "Divide-by-zero expected 0xFF"

    dut._log.info("✅ All tests passed!")
