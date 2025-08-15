<!---
This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# 8-bit Unsigned Divider

## How it works

This project implements an **8-bit Unsigned Divider** using Verilog.

- The module accepts two 8-bit inputs: **Dividend** and **Divisor**.
- It computes the **Quotient** and **Remainder** using a **Restoring Division Algorithm**.
- The **Dividend** is input through the **ui_in[7:0]** pins.
- The **Divisor** is input through the **uio_in[7:0]** pins.
- The **Quotient** is output on the **uo_out[7:0]** pins.
- The **Remainder** is output on the **uio_out[7:0]** pins.
- The **uio_oe[7:0]** signal is driven high to enable output of the remainder on the uio_out bus.

Special Cases:
- **Divide-by-Zero** detection: If the divisor is 0, both **Quotient** and **Remainder** will output **0xFF**.

This is a purely **combinational design**, so no clock cycles are needed for computation.

---

## How to test

To test this divider project:

### Inputs:
| Signal | Description |
|--------|-------------|
| ui_in[7:0] | 8-bit Dividend |
| uio_in[7:0] | 8-bit Divisor |
| uio_oe[7:0] | Must be set to `0xFF` to enable uio_out for Remainder output |

### Outputs:
| Signal | Description |
|--------|-------------|
| uo_out[7:0] | 8-bit Quotient result |
| uio_out[7:0] | 8-bit Remainder result |

### Test Steps:
1. **Set the Dividend** value on **ui_in[7:0]**.
2. **Set the Divisor** value on **uio_in[7:0]**.
3. Ensure **uio_oe[7:0]** is set to **0xFF** to enable the remainder output.
4. Read **uo_out[7:0]** for the **Quotient**.
5. Read **uio_out[7:0]** for the **Remainder**.
6. For **Divide-by-zero cases**, expect both outputs to be **0xFF**.

### Example Test Case:
- Dividend = 25 (ui_in = 0x19)
- Divisor = 4  (uio_in = 0x04)
- Expected Quotient (uo_out) = 6 (0x06)
- Expected Remainder (uio_out) = 1 (0x01)

---

## External hardware

This project **does not require any external hardware**.

All operations are performed internally, and inputs/outputs are handled via the TinyTapeout’s:
- **ui_in[7:0]** for Dividend
- **uio_in[7:0]** for Divisor
- **uo_out[7:0]** for Quotient
- **uio_out[7:0]** for Remainder

No PMODs, displays, or peripherals are needed.
