CXX=mpicxx
INCDIR=../include
CFLAGS=-I$(INCDIR) -O3 -DNDEBUG

OBJDIR=obj
LDFLAGS=

BINDIR=bin

_DEPS = mmm.h
DEPS = $(patsubst %,$(INCDIR)/%,$(_DEPS))

_OBJ = mmm.o 
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

$(BINDIR)/mmm: $(OBJ) | $(BINDIR)
	$(CXX) -o $@ $^ $(CFLAGS) $(LDFLAGS)

$(OBJDIR):
	mkdir -p $@

$(BINDIR):
	mkdir -p $@

$(OBJDIR)/%.o: %.cpp | $(OBJDIR)
	$(CXX) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o  

