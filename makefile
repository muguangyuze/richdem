#CC=i586-mingw32msvc-g++
#CFLAGS=-Wall -Wno-unknown-pragmas -DARCGIS #-fopenmp

CC=g++
CFLAGS=-Wall -fopenmp #-DARCGIS #-lX11 -pthread #-ltbb

ODIR=obj
#PRE_FLAGS=-lgcov -g -fprofile-arcs -ftest-coverage
PRE_FLAGS=-O3
DEPS = d8_methods.h data_structures.h dinf_methods.h interface.h data_io.h pit_fill.h utility.h flat_resolution.h debug.h visualize.h watershed.h unit_test.h

_OBJ = d8_methods.o dinf_methods.o interface.o data_io.o pit_fill.o utility.o debug.o watershed.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

obj/%.d: %.cpp %.h
	$(CC) $(PRE_FLAGS) -MM -MT %.cpp -o %.o $< -MF $@

$(ODIR)/%.o: %.cpp obj/%.d
	$(CC) $(PRE_FLAGS) -c -o $@ $< $(CFLAGS)

richdem: $(OBJ) obj/main.o
	$(CC) $(PRE_FLAGS) -o richdem.exe $^ $(CFLAGS)
	du -hs ./richdem.exe

unit: $(OBJ) obj/unit_test.o
	$(CC) $(PRE_FLAGS) -o richdem_unit.exe $^ $(CFLAGS)
	du -hs ./richdem_unit.exe

debug: $(OBJ)
	$(CC) $(PRE_FLAGS) -g -o richdem.exe $^ $(CFLAGS)
	du -hs ./richdem.exe

clean:
	rm -f $(ODIR)/*.o *~ core
