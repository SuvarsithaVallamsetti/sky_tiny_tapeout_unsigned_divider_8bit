import cocotb
from cocotb.triggers import RisingEdge, Timer


def pack_input(dividend, divisor):
    """Pack 4-bit dividend and divisor into ui_in[7:0].
       [7:4] = divisor, [3:0] = dividend
    """
    return ((divisor & 0xF) << 4) | (dividend & 0xF)


def extract_output(value):
    """Extract quotient and remainder from uo_out[7:0].
       [7:4] = quotient, [3:0] = remainder
    """
    quotient = (value >> 4) & 0xF
    remainder = value & 0xF
    return quotient, remainder


@cocotb.test()
async def run_divider_test(dut):
    dut._log.info("Starting Divider Testbench...")

    # Initialize all inputs
    dut.ui_in.value = 0
    dut.uio_in.value = 0  # Must drive even if unused
    dut.ena.value = 1
    dut.clk.value = 0
    dut.rst_n.value = 0

    # Apply reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Loop through test cases (skip divisor=0 except special test)
    for dividend in range(0, 16):
        for divisor in range(1, 16):
            dut.ui_in.value = pack_input(dividend, divisor)

            await RisingEdge(dut.clk)  # Latch input
            await RisingEdge(dut.clk)  # Wait for output
            await Timer(1, units="ns") # Settle

            value = dut.uo_out.value.integer
            quotient, remainder = extract_output(value)

            expected_q = dividend // divisor
            expected_r = dividend % divisor

            assert quotient == expected_q, \
                f"{dividend}/{divisor}: Expected quotient {expected_q}, got {quotient}"
            assert remainder == expected_r, \
                f"{dividend}/{divisor}: Expected remainder {expected_r}, got {remainder}"

    # Divide-by-zero special case
    dut.ui_in.value = pack_input(5, 0)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await Timer(1, units="ns")

    value = dut.uo_out.value.integer
    assert value == 0xFF, \
        f"Divide-by-zero failed: Expected 0xFF, got 0x{value:02X}"

    dut._log.info("✅ All tests passed successfully!")
