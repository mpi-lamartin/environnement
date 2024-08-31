main: *.c
	gcc -o main.exe -Wall *.c -lm

safe: *.c
	gcc -o main.exe -g -Wall -Wextra -fsanitize=address *.c -lm

full: *.c
	gcc -o main.exe -g -Wall -Wextra -std=c99 -pedantic -Wvla -fsanitize=address,undefined *.c -lm

clean:
	rm -f *.o *.exe
