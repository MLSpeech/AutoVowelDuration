

ifeq (,$(filter _%,$(notdir $(CURDIR))))
  include target.mk
else
#----- End Boilerplate

# This section is for the architecture-specific target directory
VPATH =  $(SRCDIR)

# Additional headers and libraries directories
INFRA_PATH = ../../learning_tools/infra2 
LEARNING_PATH = ../../learning_tools

CC = g++
CXXFLAGS = -Wall -I.. -I.
LDLIBS = 

# Check if the configuration is Release or Debug
ifeq ($(CONFIGURATION),Debug)
	CXXFLAGS += -g
	LDLIBS += -g 
else
	CXXFLAGS += -O3 -DNDEBUG
	LDLIBS += -O3
	CONFIGURATION = Release
endif

ifeq ($(ATLAS),yes)
	CXXFLAGS += -D_USE_ATLAS_
  	LDLIBS += -lcblas 
endif


# Targets
VowelDurationFrontEnd: VowelDurationFrontEnd.o Dataset.o infra_dsp.o FFTReal/FFTReal.cpp get_f0s.o sigproc.o WavFile.o \
	infra_vv_funcs.o infra_vm_funcs.o infra_mm_funcs.o infra_exception.o infra_binary.o cmd_line.o

#----- Begin Boilerplate
endif
