import cocotb
from cocotb.triggers import RisingEdge


# Helper to set inputs
def pack_input(dividend, divisor):
    # First 8 bits: dividend, next 8 bits: divisor
    return (dividend << 8) | (divisor & 0xFF)


# Helper to get outputs
def extract_output(value):
    # First 8 bits: quotient, next 8 bits: remainder
    quotient = (value >> 8) & 0xFF
    remainder = value & 0xFF
    return quotient, remainder


@cocotb.test()
async def divider_test(dut):
    """Test unsigned 8-bit divider"""

    # Reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Test cases: (dividend, divisor)
    test_vectors = [
        (10, 2),
        (100, 5),
        (255, 1),
        (200, 10),
        (50, 7),
        (0, 5),
        (123, 123)
    ]

    for dividend, divisor in test_vectors:
        dut.ui_in.value = pack_input(dividend, divisor)

        # Wait a few cycles for the DUT to process
        for _ in range(3):
            await RisingEdge(dut.clk)

        quotient, remainder = extract_output(int(dut.uo_out.value))

        # Expected results
        expected_quotient = dividend // divisor if divisor != 0 else 0
        expected_remainder = dividend % divisor if divisor != 0 else dividend

        assert quotient == expected_quotient, (
            f"Quotient mismatch: {quotient} != {expected_quotient} "
            f"for {dividend}/{divisor}"
        )
        assert remainder == expected_remainder, (
            f"Remainder mismatch: {remainder} != {expected_remainder} "
            f"for {dividend}/{divisor}"
        )
