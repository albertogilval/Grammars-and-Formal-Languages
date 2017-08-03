YFLAGS=-d
OBJS = p1.o p1lex.o

p1:	$(OBJS)
	cc $(OBJS) -lm  -ll -o p1

p1.o:	p1.h

p1lex.o: p1.h 

p1.h:	y.tab.h

y.tab.h:	p1.y

clean:
	rm -f *.o p1.c p1lex.c p1 y.tab.h
