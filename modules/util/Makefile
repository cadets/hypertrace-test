CSC := $(shell which csc || which csc5)
CSC_FLAGS = -O3

BUILD_DIR := ../../build

UTIL_SRCS := $(shell find . -name '*.scm' -and ! -name '*import.scm' -exec basename {} \;)
UTIL_OBJS := $(patsubst %.scm,$(BUILD_DIR)/%.o,$(UTIL_SRCS))

.PHONY: all

all: $(UTIL_OBJS)

$(BUILD_DIR)/%.o : %.scm
	@echo "CSC    $<"
	@$(CSC) -c -J $(CSC_FLAGS) $< -o $@

