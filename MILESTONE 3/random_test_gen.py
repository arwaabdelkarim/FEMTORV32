# import random
#
# # Function to convert a number to a binary string with fixed length
# def to_binary(n, length):
#     r = bin(n)[2:]  # Convert to binary and remove '0b' prefix
#     return r.zfill(length)  # Pad with leading zeros to match the required length
#
# # Random opcode and function lists
# random_opcode = ["0110111", "0010111", "1101111", "1100111", "1100011", "0000011", "0100011", "0010011", "0110011", "0001111", "1110011"]
# random_funct3B = ["000", "001", "011", "100", "101", "110", "111"]
# random_funct3L = ["000", "001", "010", "100", "101"]
# random_funct3S = ["000", "001", "010"]
# random_funct3I = ["000", "010", "011", "100", "110", "111"]
# random_funct3R = ["000", "001", "010", "011", "100", "101", "110", "111"]
#
# for _ in range(100):
#     opcode = random.choice(random_opcode)
#     U_IMM = to_binary(random.randint(0, 1048575), 20)
#     I_IMM = to_binary(random.randint(0, 4095), 12)
#     B_IMM = to_binary(random.randint(0, 4095), 12)
#     S_IMM = to_binary(random.randint(0, 4095), 12)
#     Rd = to_binary(random.randint(0, 31), 5)
#     rs1 = to_binary(random.randint(0, 31), 5)
#     rs2 = to_binary(random.randint(0, 31), 5)
#     shamt = to_binary(random.randint(0, 31), 5)
#
#     if opcode == "0110111":  # LUI
#         FinalOutput = U_IMM + Rd + opcode
#     elif opcode == "0010111":  # AUIPC
#         FinalOutput = U_IMM + Rd + opcode
#     elif opcode == "1101111":  # JAL
#         FinalOutput = U_IMM + Rd + opcode
#     elif opcode == "1100111":  # JALR
#         FinalOutput = I_IMM + rs1 + "000" + Rd + opcode
#     elif opcode == "1100011":  # Branch
#         FinalOutput = B_IMM[-7:] + rs2 + rs1 + random.choice(random_funct3B) + B_IMM[:5] + opcode
#     elif opcode == "0000011":  # LW
#         FinalOutput = I_IMM + rs1 + random.choice(random_funct3L) + Rd + opcode
#     elif opcode == "0100011":  # Store
#         FinalOutput = S_IMM[:7] + rs2 + rs1 + random.choice(random_funct3S) + S_IMM[7:] + opcode
#     elif opcode == "0010011":  # I-Type
#         funct3 = random.choice(random_funct3I)
#         if funct3 == "001" or funct3 == "101":
#             if funct3 == "101":
#                 FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + shamt + rs1 + "101" + Rd + opcode
#             else:
#                 FinalOutput = "0000000" + shamt + rs1 + "011" + Rd + opcode
#         else:
#             FinalOutput = I_IMM + rs1 + funct3 + Rd + opcode
#     elif opcode == "0110011":  # R-Type
#         funct3 = random.choice(random_funct3R)
#         if funct3 == "000":
#             FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + rs2 + rs1 + "000" + Rd + opcode
#         elif funct3 == "101":
#             FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + rs2 + rs1 + "101" + Rd + opcode
#         else:
#             FinalOutput = "0000000" + rs2 + rs1 + funct3 + Rd + opcode
#     elif opcode == "0001111":  # FENCE
#         FinalOutput = I_IMM + rs1 + "000" + Rd + opcode
#     elif opcode == "1110011":  # ECALL/EBREAK
#         FinalOutput = "00000000000000000000000001110011" if random.randint(0, 1) == 0 else "00000000000100000000000001110011"
#     else:
#         print(f"{opcode} Error")
#         continue
#
#     # Output only if the result is 32 bits
#     if len(FinalOutput) == 32:
#         print(FinalOutput)
import random

# Function to convert a number to a binary string with fixed length
def to_binary(n, length):
    r = bin(n)[2:]  # Convert to binary and remove '0b' prefix
    return r.zfill(length)  # Pad with leading zeros to match the required length

# Random opcode and function lists
random_opcode = ["0110111", "0010111", "1101111", "1100111", "1100011", "0000011", "0100011", "0010011", "0110011", "0001111", "1110011"]
random_funct3B = ["000", "001", "011", "100", "101", "110", "111"]
random_funct3L = ["000", "001", "010", "100", "101"]
random_funct3S = ["000", "001", "010"]
random_funct3I = ["000", "010", "011", "100", "110", "111"]
random_funct3R = ["000", "001", "010", "011", "100", "101", "110", "111"]

# Open a file to write the hexadecimal output
with open("testgen.hex", "w") as file:
    for _ in range(100):
        opcode = random.choice(random_opcode)
        U_IMM = to_binary(random.randint(0, 1048575), 20)
        I_IMM = to_binary(random.randint(0, 4095), 12)
        B_IMM = to_binary(random.randint(0, 4095), 12)
        S_IMM = to_binary(random.randint(0, 4095), 12)
        Rd = to_binary(random.randint(0, 31), 5)
        rs1 = to_binary(random.randint(0, 31), 5)
        rs2 = to_binary(random.randint(0, 31), 5)
        shamt = to_binary(random.randint(0, 31), 5)

        # Generate FinalOutput based on the opcode and specific conditions
        if opcode == "0110111":  # LUI
            FinalOutput = U_IMM + Rd + opcode
        elif opcode == "0010111":  # AUIPC
            FinalOutput = U_IMM + Rd + opcode
        elif opcode == "1101111":  # JAL
            FinalOutput = U_IMM + Rd + opcode
        elif opcode == "1100111":  # JALR
            FinalOutput = I_IMM + rs1 + "000" + Rd + opcode
        elif opcode == "1100011":  # Branch
            FinalOutput = B_IMM[-7:] + rs2 + rs1 + random.choice(random_funct3B) + B_IMM[:5] + opcode
        elif opcode == "0000011":  # LW
            FinalOutput = I_IMM + rs1 + random.choice(random_funct3L) + Rd + opcode
        elif opcode == "0100011":  # Store
            FinalOutput = S_IMM[:7] + rs2 + rs1 + random.choice(random_funct3S) + S_IMM[7:] + opcode
        elif opcode == "0010011":  # I-Type
            funct3 = random.choice(random_funct3I)
            if funct3 == "001" or funct3 == "101":
                if funct3 == "101":
                    FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + shamt + rs1 + "101" + Rd + opcode
                else:
                    FinalOutput = "0000000" + shamt + rs1 + "011" + Rd + opcode
            else:
                FinalOutput = I_IMM + rs1 + funct3 + Rd + opcode
        elif opcode == "0110011":  # R-Type
            funct3 = random.choice(random_funct3R)
            if funct3 == "000":
                FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + rs2 + rs1 + "000" + Rd + opcode
            elif funct3 == "101":
                FinalOutput = ("0000000" if random.randint(0, 1) == 0 else "0100000") + rs2 + rs1 + "101" + Rd + opcode
            else:
                FinalOutput = "0000000" + rs2 + rs1 + funct3 + Rd + opcode
        elif opcode == "0001111":  # FENCE
            FinalOutput = I_IMM + rs1 + "000" + Rd + opcode
        elif opcode == "1110011":  # ECALL/EBREAK
            FinalOutput = "00000000000000000000000001110011" if random.randint(0, 1) == 0 else "00000000000100000000000001110011"
        else:
            print(f"{opcode} Error")
            continue

        # Check if the output length is 32 bits, then convert and save to file
        if len(FinalOutput) == 32:
            hex_output = hex(int(FinalOutput, 2))[2:].zfill(8)  # Convert to hex and pad to 8 characters
            file.write(hex_output + "\n")  # Write hex value to file
