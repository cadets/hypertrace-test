CSC := $(shell which csc || which csc5)
CSC_FLAGS = -O3

BUILD_DIR := ../../build
MODULE := reporters

.PHONY: all

all:
	@echo "CSC    $(MODULE).scm"
	@$(CSC) -c -J $(CSC_FLAGS) $(MODULE).scm -o $(BUILD_DIR)/$(MODULE).o
