import sys
import binascii


hex_strings = sys.argv[1:]

for hex_string in hex_strings:

    bin_filename = "BINFOLDER/input_{}.bin".format(hex_string)
    with open(bin_filename, "wb") as bin_file:

        bin_file.write(binascii.unhexlify(hex_string))
    print("Bin File Generated: {}".format(bin_filename))

