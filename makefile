sistema_eq: sistema_eq.s
	gcc -c -m32 sistema_eq.s -o sistema_eq.o
	gcc -m32 sistema_eq.o -o sistema_eq
