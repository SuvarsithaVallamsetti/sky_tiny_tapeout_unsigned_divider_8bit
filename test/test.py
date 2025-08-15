import cocotb
from cocotb.triggers import RisingEdge, Timer


def pack_input(dividend, divisor):
    """Pack dividend in [7:4] and divisor in [3:0]."""
    return ((dividend & 0xF) << 4) | (divisor & 0xF)


def extract_output(value):
    """Extract quotient [7:4] and remainder [3:0]."""
    quotient = (value >> 4) & 0xF
    remainder = value & 0xF
    return quotient, remainder


@cocotb.test()
async def divider_test(dut):
    dut._log.info("Starting Cocotb Testbench...")

    # Clock generator
    async def clk_gen():
        while True:
            dut.clk.value = 0
            await Timer(5, units="ns")
            dut.clk.value = 1
            await Timer(5, units="ns")

    cocotb.start_soon(clk_gen())

    # Initialize
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.ena.value = 1
    dut.rst_n.value = 0

    # Reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Normal division tests
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            dut.ui_in.value = pack_input(dividend, divisor)
            await RisingEdge(dut.clk)
            await Timer(1, units="ns")

            value = dut.uo_out.value.integer
            q, r = extract_output(value)

            assert q == dividend // divisor, \
                f"FAIL: {dividend}/{divisor} → got Q={q}, expected {dividend // divisor}"
            assert r == dividend % divisor, \
                f"FAIL: {dividend}/{divisor} → got R={r}, expected {dividend % divisor}"

    # Divide-by-zero test
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await Timer(1, units="ns")
    assert dut.uo_out.value.integer == 0xFF, \
        f"FAIL: Divide-by-zero → got {dut.uo_out.value.integer:#04x}, expected 0xFF"

    dut._log.info("✅ All tests passed!")
