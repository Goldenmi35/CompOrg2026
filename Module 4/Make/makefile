all:	userPrompt tabPrint quoteString
userPrompt:	../src/userPrompt.s
	gcc ../src/userPrompt.s -g -c -o userPrompt.o
	gcc userPrompt.o -g -o ../userPrompt
tabPrint:	../src/tabPrint.s
	gcc ../src/tabPrint.s -g -c -o tabPrint.o
	gcc tabPrint.o -g -o ../tabPrint
quoteString:	../src/quoteString.s
	gcc ../src/quoteString.s -g -c -o quoteString.o
	gcc quoteString.o -g -o ../quoteString
clean:
	rm ../userPrompt ../tabPrint ../quoteString tabPrint.o userPrompt.o quoteString.o
