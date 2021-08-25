CSC := $(shell which csc || which csc5)
CSC_FLAGS = -O3

PROGRAM := hypertrace-test

BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin
LIBEXEC_DIR := $(BUILD_DIR)/libexec
LIBEXEC_HYPERTRACE := $(LIBEXEC_DIR)/hypertrace-test
STAGERS_DIR := $(LIBEXEC_HYPERTRACE)/tests
STAGERS_SRCDIR := stagers

SRC_DIR := src

SRCS := $(shell find $(SRC_DIR) -name '*.scm' -exec basename {} \;)
OBJS := $(patsubst %.scm,$(BUILD_DIR)/%.o,$(SRCS))

MODULE_DIR := modules

STAGERS_SRCS := $(shell find $(STAGERS_SRCDIR) -name '*.scm' -exec basename {} \;)
STAGERS_DSTS := $(patsubst %.scm,$(STAGERS_DIR)/%.scm,$(STAGERS_SRCS))

.SILENT:
.PHONY: $(MODULE_DIR) move_imports $(STAGERS_DIR) move_tests clean cleandir distclean realclean

$(PROGRAM): $(OBJS) $(STAGERS_DIR) $(STAGERS_DSTS) $(BIN_DIR) move_tests
	@echo "LD     $(PROGRAM)"
	@$(CSC) $(CSC_FLAGS) $(shell find $(BUILD_DIR) -name '*.o') -o $(BIN_DIR)/$(PROGRAM)

$(BUILD_DIR)/%.o : $(SRC_DIR)/%.scm | $(MODULE_DIR) move_imports
	@echo "CSC    $<"
	@$(CSC) -c $(CSC_FLAGS) $< -o $@

$(MODULE_DIR): $(BUILD_DIR)
	@$(MAKE) -C $@

move_imports: $(MODULE_DIR)
	@echo "MOVE   imports"
	@$(shell find modules -name '*import.scm' -exec mv -f {} . \;)

move_tests: $(STAGERS_DIR)
	@echo "MOVE   tests"
	@$(shell find tests -mindepth 1 -maxdepth 1 -type d -exec cp -Rp {} $(STAGERS_DIR) \;)

$(STAGERS_DIR)/%.scm : $(STAGERS_SRCDIR)/%.scm $(STAGERS_DIR)
	@echo "CP     $<"
	@cp $< $@

$(BUILD_DIR):
	@echo "MK     $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)

$(BIN_DIR): $(BUILD_DIR)
	@echo "MK     $(BIN_DIR)"
	@mkdir -p $(BIN_DIR)

$(LIBEXEC_DIR): $(BUILD_DIR)
	@echo "MK     $(LIBEXEC_DIR)"
	@mkdir -p $(LIBEXEC_DIR)

$(LIBEXEC_HYPERTRACE): $(LIBEXEC_DIR)
	@echo "MK     $(LIBEXEC_HYPERTRACE)"
	@mkdir -p $(LIBEXEC_HYPERTRACE)

$(STAGERS_DIR): $(LIBEXEC_HYPERTRACE)
	@echo "MK     $(STAGERS_DIR)"
	@mkdir -p $(STAGERS_DIR)

clean:
	@echo "RM     $(BUILD_DIR)"
	@rm -rf $(BUILD_DIR)
	@echo "CLEAN  imports"
	@rm -f *import.scm

cleandir distclean realclean: clean

