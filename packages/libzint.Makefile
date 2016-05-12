
TARGET=zint
LIBNAME=$(addprefix lib, $(TARGET)).a

OBJS+=./backend/common.o
OBJS+=./backend/render.o
OBJS+=./backend/png.o
OBJS+=./backend/library.o
OBJS+=./backend/ps.o
OBJS+=./backend/large.o
OBJS+=./backend/reedsol.o
OBJS+=./backend/gs1.o
OBJS+=./backend/svg.o
######ONEDIM_OBJ
OBJS+=./backend/code.o
OBJS+=./backend/code128.o
OBJS+=./backend/2of5.o
OBJS+=./backend/upcean.o
OBJS+=./backend/telepen.o
OBJS+=./backend/medical.o
OBJS+=./backend/plessey.o
OBJS+=./backend/rss.o
####POSTAL_OBJ
OBJS+=./backend/postal.o
OBJS+=./backend/auspost.o
OBJS+=./backend/imail.o
#####TWODIM_OBJ
OBJS+=./backend/code16k.o
OBJS+=./backend/dmatrix.o
OBJS+=./backend/pdf417.o
OBJS+=./backend/qr.o
OBJS+=./backend/maxicode.o
OBJS+=./backend/composite.o
OBJS+=./backend/aztec.o
OBJS+=./backend/code49.o
OBJS+=./backend/code1.o
OBJS+=./backend/gridmtx.o

ifdef LIBPNG
	CFLAGS=-DZINT_VERSION=\"2.4.2\"
	LIBS=
else
	CFLAGS+=-DNO_PNG -DZINT_VERSION=\"2.4.2\"
	LIBS+=
endif

PREFIX=/usr/local
CFLAGS+=-std=gnu99 -Wall -O2 -fPIC -I./backend -I$(HOME)/usr/local/include
LDFLAGS= -L$(HOME)/usr/local/lib
CC=gcc
AR=ar
RANLIB=ranlib
ARFLAGS=rcu
STRIP=strip
LIBS+=

all:$(TARGET)

$(TARGET):$(OBJS) $(TARGET).o
	@$(AR) $(ARFLAGS) ./backend/$(LIBNAME) $(OBJS)
	@echo "lib: $@"
	@echo "LD $@"
	@$(CC) $(CFLAGS) ./$(TARGET).o $(OBJS) -L./backend $(LDFLAGS) $(addprefix -l,$(LIBS)) -o $@
	@echo "STRIP $@"
	@$(STRIP) $@
install:
	@echo "intstall '$(TARGET)' -> ${PREFIX}/bin/"
	@cp ./backend/*.a ${PREFIX}/lib/
	@cp ./backend/zint.h ${PREFIX}/include/
uninstall:
	@echo "rm '$(TARGET)' form '${PREFIX}/bin'"
	@rm -f ${PREFIX}/lib/$(LIBNAME)
touch:
	touch $(SRCS) 
clean:
	@echo "Clean ..."
	@rm -f ./$(TARGET)
	@rm -f ./backend/*.o
	@rm -f ./backend/*.a

.SECONDARY    :%.o 
# Compiling to object files.
%.o:%.c
	@echo "CC $<"
	@$(CC) $(CFLAGS) -c $< -o $@

.PHONY: test

