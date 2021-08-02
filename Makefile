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

SRCS := $(shell find $(SRC_DIR) -name *.scm -exec basename {} \;)
OBJS := $(patsubst %.scm,$(BUILD_DIR)/%.o,$(SRCS))

STAGERS_SRCS := $(shell find $(STAGERS_SRCDIR) -name *.scm -exec basename {} \;)
STAGERS_DSTS := $(patsubst %.scm,$(STAGERS_DIR)/%.scm,$(STAGERS_SRCS))

$(PROGRAM): $(OBJS) $(STAGERS_DSTS)
	@echo "LD     $(PROGRAM)"
	@$(CSC) $(CSC_FLAGS) $(OBJS) -o $(BIN_DIR)/$(PROGRAM)

$(BUILD_DIR)/%.o : src/%.scm $(BIN_DIR)
	@echo "CSC    $<"
	@$(CSC) -c $(CSC_FLAGS) $< -o $@

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

cleandir distclean realclean: clean
