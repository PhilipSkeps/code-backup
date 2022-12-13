# pskeps 11/9/2022
# build datacontainers library 
# move to desired location
# and clean

# if file names in directory are changed then run make delete to rebuild a clean archive

IDIR = ../incps
LDIR = ../libps
SDIR = .
DDIR = dep
ODIR = obj

AR=ar
ARFLAGS=-crs

CC = gcc
CFLAGS = -c -O3 -Wall -Wextra -pedantic -fpic -I$(IDIR) -o
CDFLAGS = -MP -MMD -MF $(DDIR)/$*.d
SHFLAGS = -shared -o

SRC := $(wildcard *.c)
LIB := $(LDIR)/libdc.so
OBJ := $(SRC:%.c=$(ODIR)/%.o)

all : $(DDIR) $(ODIR) $(LIB)

$(ODIR)/%.o : %.c $(DDIR)/%.d | $(DDIR)
	${CC} ${CFLAGS} $@ $< ${CDFLAGS}

$(LIB): $(OBJ)
	${CC} ${SHFLAGS} $@ $<

$(DDIR):
	@mkdir -p $@

$(ODIR):
	@mkdir -p $@

clean:
	@echo clearing obj and dep hidden directories
	@rm -fr $(DDIR) $(ODIR)

delete: clean
	@echo removing built file
	@rm -f $(LDIR)/$(LIB)

DEP := $(SRC:%.c=$(DDIR)/%.d)

$(DEP) :

include $(wildcard $(DEP))