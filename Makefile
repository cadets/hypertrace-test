CSC := $(shell which csc)
CSC_FLAGS = -O3

PROGRAM := hypertrace-test

BUILD_DIR := build
SRC_DIR := src

SRCS := $(shell find $(SRC_DIR) -name *.scm -exec basename {} \;)
OBJS := $(patsubst %.scm,$(BUILD_DIR)/%.o,$(SRCS))

$(PROGRAM): $(OBJS)
	@$(CSC) $(CSC_FLAGS) $(OBJS) -o $(BUILD_DIR)/$(PROGRAM)

$(BUILD_DIR)/%.o : src/%.scm $(BUILD_DIR)
	@echo "CSC    $<"
	@$(CSC) -c $(CSC_FLAGS) $< -o $@

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@echo "MK     $(BUILD_DIR)"

clean:
	@rm -rf $(BUILD_DIR)
	@echo "RM     $(BUILD_DIR)"

cleandir distclean realclean: clean
