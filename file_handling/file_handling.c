#include<stdio.h>
#include<conio.h>
#include<dos.h>
#include<stdlib.h>
#include<string.h>

char directoryName[50];
char sourceFileName[50];
char destinationFileName[50];
char buffer[200];

union REGS input,output;
struct SREGS segment;

int sourceHandler=0x0,destinationHandler=0x0;

void createDirectory()
{
	printf("Directory Name: ");
	scanf("%s",&directoryName);

	input.h.ah=0x39;
	input.x.dx=FP_OFF(directoryName);
	segment.ds=FP_SEG(directoryName);

	intdosx(&input,&output,&segment);

	if(output.x.cflag)
		printf("\nError: Directory \"%s\" not created",directoryName);
	else
		printf("\nDirectory \"%s\" successfully created",directoryName);
}

void deleteFile()
{
	printf("File to delete: ");
	scanf("%s",&sourceFileName);

	input.h.ah=0x41;
	input.x.dx=FP_OFF(sourceFileName);
	segment.ds=FP_SEG(sourceFileName);

	intdosx(&input,&output,&segment);

	if(output.x.cflag)
		printf("\nError: File \"%s\" not deleted",sourceFileName);
	else
		printf("\nFile \"%s\" successfully deleted",sourceFileName);
}

void copyFile()
{
	printf("\nSource File: ");
	scanf("%s",&sourceFileName);
	printf("\nDestination File: ");
	scanf("%s",&destinationFileName);

	input.h.ah=0x3d;
	input.h.al=00;
	input.x.dx=FP_OFF(sourceFileName);
	segment.ds=FP_SEG(sourceFileName);

	intdosx(&input,&output,&segment);

	if(output.x.cflag)
		printf("\nSource file \"%s\" not opened",sourceFileName);
	else
	{
		printf("\nSource file \"%s\" successfully opened",sourceFileName);
		sourceHandler=output.x.ax;

		input.h.ah=0x3c;
		input.x.dx=FP_OFF(destinationFileName);
		segment.ds=FP_SEG(destinationFileName);
		input.h.al=01;

		intdosx(&input,&output,&segment);

		if(output.x.cflag)
			printf("\nDestination file \"%s\" not created",destinationFileName);
		else
		{
			printf("\nDestination file \"%s\" created successfully",destinationFileName);

			destinationHandler=output.x.ax;

			input.h.ah=0x3f;
			input.x.bx=sourceHandler;
			input.x.cx=0xFF;
			input.x.dx=FP_OFF(buffer);
			segment.ds=FP_SEG(buffer);

			intdosx(&input,&output,&segment);
			if(output.x.cflag)
				printf("\nError: Source file not read");
			else
			{
				printf("\nSource file read successfully");

				input.h.ah=0x40;
				input.x.bx=destinationHandler;
				input.x.cx=strlen(buffer);
				input.x.dx=FP_OFF(buffer);
				segment.ds=FP_SEG(buffer);

				intdosx(&input,&output,&segment);
				if(output.x.cflag)
					printf("\nError: Destination file not written");
				else
					printf("\nDestination file written successfully");

				input.h.ah=0x3e;
				intdosx(&input,&output,&segment);
				if(output.x.cflag)
					printf("\nError: Destination file not closed");
				else
					printf("\nDestination file closed successfully");
			}
		}

		input.h.ah=0x3e;
		input.x.bx=sourceHandler;
		intdosx(&input,&output,&segment);

		if(output.x.cflag)
			printf("\nError: Source file not closed");
		else
			printf("\nSource file closed successfully");
	}
}

int main()
{
	int choice;
	while(1)
	{
		printf("Menu\n1. Create Directory\n2. Delete File\n3. Copy File\n4. Exit\nChoice: ");
		scanf("%d",&choice);
		switch(choice)
		{
		case 1:
			createDirectory();
			printf("\n\n");
			break;
		case 2:
			deleteFile();
			printf("\n\n");
			break;
		case 3:
			copyFile();
			printf("\n\n");
			break;
		case 4:
			printf("\nSuccessfully exited the program\n");
			return 0;
		default:
			printf("\nInvalid Choice\n\n");
			break;
		}
	}
}
