CC:=gcc
CFLAGS:=-Wall -Werror -Wextra

CAT_PATH:= .
CAT:=s21_cat

SRCS_CAT:=$(shell find $(CAT_PATH) -name "*.c")
OBJS_CAT:=$(SRCS_CAT:%.c=%.o)
SRCS_CAT_H:=$(shell find $(CAT_PATH) -name "*.h")

all: $(CAT)

$(CAT): $(OBJS_CAT) $(SRCS_CAT_H)
	$(CC) $(OBJS_CAT) $(CFLAGS) -o $@
	
$(CAT_PATH)/%.o: %.c $(SRCS_CAT_H)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm $(OBJS_CAT) $(CAT)

rebuild: clean all

.PHONY: clean