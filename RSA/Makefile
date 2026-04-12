# Makefile for ARM Assembly Project

CC = gcc
CFLAGS = -g -Wall

TARGET = program
SRCS = main.s test.s libFunctions.s
OBJS = $(SRCS:.s=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	gcc -g -Wall -o $(TARGET) $(OBJS)

%.o: %.s
	gcc -g -Wall -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

