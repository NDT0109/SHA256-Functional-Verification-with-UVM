PYTHON = python
RECOVER_SCRIPT = recover_message.py
HEX_TO_BIN_SCRIPT = hex_to_bin.py
HEX_STRINGS_FILE = message_output.txt
BIN_FILE_PREFIX = BINFOLDER/input
LOG_FILE = sha256_output.log


HEX_STRINGS := $(shell tr '\n' ' ' < $(HEX_STRINGS_FILE))

all: $(LOG_FILE)


$(HEX_STRINGS_FILE): $(RECOVER_SCRIPT) message.log
	@echo "Recovering original messages..."
	$(PYTHON) $(RECOVER_SCRIPT)

$(BIN_FILE_PREFIX)_%.bin: $(HEX_STRINGS_FILE)
	@echo "Converting hex to binary..."
	$(PYTHON) $(HEX_TO_BIN_SCRIPT) $(HEX_STRINGS)

$(LOG_FILE): $(HEX_STRINGS_FILE) $(BIN_FILE_PREFIX)_%.bin
	@echo "Calculating SHA-256 hash and saving to log file..."
	@rm -f $(LOG_FILE)
	@for hex in $(HEX_STRINGS); do \
		echo "Processing hash for $$hex..."; \
		openssl dgst -sha256 $(BIN_FILE_PREFIX)_$$hex.bin | sed 's/^.*= //' >> $(LOG_FILE); \
		echo "Hash for $$hex stored in log."; \
	done
	@echo "All hashes saved to: $(LOG_FILE)"

clean:
	rm -f $(BIN_FILE_PREFIX)_*.bin 
.PHONY: all clean

