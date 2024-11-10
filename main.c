/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xbram.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "huffman.h"

typedef struct {
    int *even;
    int *odd;
    int size_even;
    int size_odd;
} Array_odd_even;

Array_odd_even divide_in_odd_even(int *vetor, int n) {
    Array_odd_even result;
    result.even = malloc(n * sizeof(int));
    result.odd = malloc(n * sizeof(int));
    result.size_even = 0;
    result.size_odd = 0;

    for (int i = 0; i < n; i++) {
        if (i % 2 == 0) {
            result.even[result.size_even++] = vetor[i];
        } else {
            result.odd[result.size_odd++] = vetor[i];
        }
    }

    result.even = realloc(result.even, result.size_even * sizeof(int));
    result.odd = realloc(result.odd, result.size_odd * sizeof(int));

    return result;
}

XGpio Gpio;

int Q[8][8] = {
	{16, 11, 10, 16, 24, 40, 51, 61},
	{12, 12, 14, 19, 26, 58, 60, 55},
	{14, 13, 16, 24, 40, 57, 69, 56},
	{14, 17, 22, 29, 51, 87, 80, 62},
	{18, 22, 37, 56, 68, 109, 103, 77},
	{24, 35, 55, 64, 81, 104, 113, 92},
	{49, 64, 78, 87, 103, 121, 120, 101},
	{72, 92, 95, 98, 112, 100, 103, 99}
};

typedef struct {
    int bloco[8][8];
} Matrix;

typedef struct {
    int vetor[64];
    int size_out;
} Array;

Matrix Matrix_int_to_fixed(int bloco[8][8]){

	Matrix m;

	for (int i = 0; i <8; i++) {
		for(int j = 0; j < 8; j++) {
			m.bloco[i][j] = int_to_fixed(bloco[i][j]);
		}
	}
	return m;
}

int int_to_fixed(int valor){

    return valor<<20;

}

float fixed_to_float(int number, int int_part, int frac_part) {
    
    int frac_mask = 0x000FFFFF;
    int int_mask = 0xFFF00000;
    int negative_mask = 0x80000000;
    

    if ((number & negative_mask ) == 0x80000000){
        
        int ones_complement = ~number ;
        int twos_complement = ones_complement + 1;

        int integer_part = twos_complement & int_mask; 
        int fractional_part = twos_complement & frac_mask; 

        return -1 * ((float) integer_part/(1<<frac_part ) + (float) ( fractional_part)/ (1<<frac_part));
    } 
    else{
        
        int integer_part = number & int_mask; 
        int fractional_part = number & frac_mask; 
        return (float) integer_part/(1<<frac_part) + (float) ( fractional_part)/ (1<<frac_part);        

    }


}

void write_on_memory(int bloco[8][8], char dim){

		if (dim == 'x') {
			for (int i = 0; i <= 28; i=i+4){
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR, i, bloco[i/4][0]);
			XBram_WriteReg(XPAR_BRAM_1_BASEADDR, i, bloco[i/4][1]);
			XBram_WriteReg(XPAR_BRAM_2_BASEADDR, i, bloco[i/4][2]);
			XBram_WriteReg(XPAR_BRAM_3_BASEADDR, i, bloco[i/4][3]);
			XBram_WriteReg(XPAR_BRAM_4_BASEADDR, i, bloco[i/4][4]);
			XBram_WriteReg(XPAR_BRAM_5_BASEADDR, i, bloco[i/4][5]);
			XBram_WriteReg(XPAR_BRAM_6_BASEADDR, i, bloco[i/4][6]);
			XBram_WriteReg(XPAR_BRAM_7_BASEADDR, i, bloco[i/4][7]);
			}
		}

		if (dim == 'y') {
			for (int i = 0; i <= 28; i=i+4){
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR, i, bloco[0][i/4]);
			XBram_WriteReg(XPAR_BRAM_1_BASEADDR, i, bloco[1][i/4]);
			XBram_WriteReg(XPAR_BRAM_2_BASEADDR, i, bloco[2][i/4]);
			XBram_WriteReg(XPAR_BRAM_3_BASEADDR, i, bloco[3][i/4]);
			XBram_WriteReg(XPAR_BRAM_4_BASEADDR, i, bloco[4][i/4]);
			XBram_WriteReg(XPAR_BRAM_5_BASEADDR, i, bloco[5][i/4]);
			XBram_WriteReg(XPAR_BRAM_6_BASEADDR, i, bloco[6][i/4]);
			XBram_WriteReg(XPAR_BRAM_7_BASEADDR, i, bloco[7][i/4]);
			}
		}

}

Matrix read_memory(char dim){

	int out_data0, out_data1, out_data2, out_data3, out_data4, out_data5, out_data6, out_data7;
	Matrix m;
	if (dim=='x'){
		for (int i = 0; i <= 28; i=i+4){
			out_data0 = XBram_ReadReg(XPAR_BRAM_0_BASEADDR,i);
			out_data1 = XBram_ReadReg(XPAR_BRAM_1_BASEADDR,i);
			out_data2 = XBram_ReadReg(XPAR_BRAM_2_BASEADDR,i);
			out_data3 = XBram_ReadReg(XPAR_BRAM_3_BASEADDR,i);
			out_data4 = XBram_ReadReg(XPAR_BRAM_4_BASEADDR,i);
			out_data5 = XBram_ReadReg(XPAR_BRAM_5_BASEADDR,i);
			out_data6 = XBram_ReadReg(XPAR_BRAM_6_BASEADDR,i);
			out_data7 = XBram_ReadReg(XPAR_BRAM_7_BASEADDR,i);
			m.bloco[i/4][0]=out_data0;
			m.bloco[i/4][1]=out_data1;
			m.bloco[i/4][2]=out_data2;
			m.bloco[i/4][3]=out_data3;
			m.bloco[i/4][4]=out_data4;
			m.bloco[i/4][5]=out_data5;
			m.bloco[i/4][6]=out_data6;
			m.bloco[i/4][7]=out_data7;	
		}
	}
	
	if (dim=='y'){
		for (int i = 0; i <= 28; i=i+4){
			out_data0 = XBram_ReadReg(XPAR_BRAM_0_BASEADDR,i);
			out_data1 = XBram_ReadReg(XPAR_BRAM_1_BASEADDR,i);
			out_data2 = XBram_ReadReg(XPAR_BRAM_2_BASEADDR,i);
			out_data3 = XBram_ReadReg(XPAR_BRAM_3_BASEADDR,i);
			out_data4 = XBram_ReadReg(XPAR_BRAM_4_BASEADDR,i);
			out_data5 = XBram_ReadReg(XPAR_BRAM_5_BASEADDR,i);
			out_data6 = XBram_ReadReg(XPAR_BRAM_6_BASEADDR,i);
			out_data7 = XBram_ReadReg(XPAR_BRAM_7_BASEADDR,i);
			m.bloco[0][i/4]=out_data0;
			m.bloco[1][i/4]=out_data1;
			m.bloco[2][i/4]=out_data2;
			m.bloco[3][i/4]=out_data3;
			m.bloco[4][i/4]=out_data4;
			m.bloco[5][i/4]=out_data5;
			m.bloco[6][i/4]=out_data6;
			m.bloco[7][i/4]=out_data7;	
		}
	}
	for (int i = 0; i < 8; i=i+1){
		for (int j = 0; j < 8; j=j+1){

			printf(" %f   ", fixed_to_float(m.bloco[i][j],12,20));
		}
		printf("\n\r");
	}

	printf("\n\r");

    return m;
}

void check_finish(){
	while(1){
		if (XGpio_DiscreteRead(&Gpio,2)== 1){
			break;
		}
	}
}

Matrix DCT_2D(int bloco[8][8]){

	Matrix dct_result, dct_2d_result;

	//write bloco
    write_on_memory(bloco,'x');

    //start_DCT_operation
	XGpio_DiscreteWrite(&Gpio, 1, 0x00000001);

	//check_finish
	check_finish();

	// turn off start/en  and   resetar
	XGpio_DiscreteWrite(&Gpio, 1, 0x00000002);
	print("\nDCT 1D completed \n\r");

	//read DCT-1D transformed values
	dct_result = read_memory('x');

	
	//write dct_result
	write_on_memory(dct_result.bloco, 'y');

    //start_DCT_operation
	XGpio_DiscreteWrite(&Gpio, 1, 0x00000001);

	//check_finish
	check_finish();

	// turn off start/en  and  turn on resetar 
	XGpio_DiscreteWrite(&Gpio, 1, 0x00000002); 
	print("\nDCT 2D completed \n\r");

	//read DCT-2D transformed values
	dct_2d_result = read_memory('y');
	return dct_2d_result;

}

Matrix quantize(int bloco[8][8]){
	Matrix m ={0};
	printf("\nDCT 2D results quantized \n\r");
	for (int i = 0; i < 8; i=i+1){
		for (int j = 0; j < 8; j=j+1){
			m.bloco[i][j] = (int) roundf(fixed_to_float(bloco[i][j],12,20)/Q[i][j]);
			printf("%d	  ",m.bloco[i][j]);
		}
		printf("\n\r");
	}
	return m;

}

Array zigzag(int bloco[8][8]){

	Array A={0};

	A.vetor[0]=bloco[0][0];
	A.vetor[1]=bloco[0][1];
	A.vetor[2]=bloco[1][0];
	A.vetor[3]=bloco[2][0];
	A.vetor[4]=bloco[1][1];
	A.vetor[5]=bloco[0][2];
	A.vetor[6]=bloco[0][3];
	A.vetor[7]=bloco[1][2];
	A.vetor[8]=bloco[2][1];
	A.vetor[9]=bloco[3][0];
	A.vetor[10]=bloco[4][0];
	A.vetor[11]=bloco[3][1];
	A.vetor[12]=bloco[2][2];
	A.vetor[13]=bloco[1][3];
	A.vetor[14]=bloco[0][4];
	A.vetor[15]=bloco[0][5];
	A.vetor[16]=bloco[1][4];
	A.vetor[17]=bloco[2][3];
	A.vetor[18]=bloco[3][2];
	A.vetor[19]=bloco[4][1];
	A.vetor[20]=bloco[5][0];
	A.vetor[21]=bloco[6][0];
	A.vetor[22]=bloco[5][1];
	A.vetor[23]=bloco[4][2];
	A.vetor[24]=bloco[3][3];
	A.vetor[25]=bloco[2][4];
	A.vetor[26]=bloco[1][5];
	A.vetor[27]=bloco[0][6];
	A.vetor[28]=bloco[0][7];
	A.vetor[29]=bloco[1][6];
	A.vetor[30]=bloco[2][5];
	A.vetor[31]=bloco[3][4];
	A.vetor[32]=bloco[4][3];
	A.vetor[33]=bloco[5][2];
	A.vetor[34]=bloco[6][1];
	A.vetor[35]=bloco[7][0];
	A.vetor[36]=bloco[7][1];
	A.vetor[37]=bloco[6][2];
	A.vetor[38]=bloco[5][3];
	A.vetor[39]=bloco[4][4];
	A.vetor[40]=bloco[3][5];
	A.vetor[41]=bloco[2][6];
	A.vetor[42]=bloco[1][7];
	A.vetor[43]=bloco[2][7];
	A.vetor[44]=bloco[3][6];
	A.vetor[45]=bloco[4][5];
	A.vetor[46]=bloco[5][4];
	A.vetor[47]=bloco[6][3];
	A.vetor[48]=bloco[7][2];
	A.vetor[49]=bloco[7][3];
	A.vetor[50]=bloco[6][4];
	A.vetor[51]=bloco[5][5];
	A.vetor[52]=bloco[4][6];
	A.vetor[53]=bloco[3][7];
	A.vetor[54]=bloco[4][7];
	A.vetor[55]=bloco[5][6];
	A.vetor[56]=bloco[6][5];
	A.vetor[57]=bloco[7][4];
	A.vetor[58]=bloco[7][5];
	A.vetor[59]=bloco[6][6];
	A.vetor[60]=bloco[5][7];
	A.vetor[61]=bloco[6][7];
	A.vetor[62]=bloco[7][6];
	A.vetor[63]=bloco[7][7];

	printf("\nZig-zag\n");
	for (int i = 0; i < 64; i++)
	{
			printf("%d ", A.vetor[i]);
	}

	return A;

}

Array runLengthEncoding(int array[64]) {

	int size = 64;
    int count, i, j;
	Array v_out={0};
	printf("\n\n\Run length encoding\n\r");
    int k = 0;
    for (i = 0; i < size; i += count) {
        count = 1; 

        for (j = i + 1; j < size && array[i] == array[j]; j++) {
            count++;
        }
        
        printf("%d %d, ", count, array[i]);
		v_out.vetor[k*2] = count;
		v_out.vetor[(k*2)+1] = array[i];
        k=k+1;
    }
    v_out.size_out = (k*2);
	printf("\n\n\r");
	return v_out;
    
}




int main()
{
    init_platform();

	XBram Bram;	
	XBram_Config *ConfigPtr;

	int Status;

	// Iniciar o  GPIO driver
	Status = XGpio_Initialize(&Gpio,XPAR_GPIO_0_DEVICE_ID );
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}


	// Iniciar o driver BRAM

	ConfigPtr = XBram_LookupConfig(XPAR_BRAM_0_DEVICE_ID);
	if (ConfigPtr == (XBram_Config *) NULL) {
		return XST_FAILURE;
	}

	Status = XBram_CfgInitialize(&Bram, ConfigPtr,
				     ConfigPtr->CtrlBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Definir as direções dos bits das GPIOs
	XGpio_SetDataDirection(&Gpio, 1, 0x00000000); // output -- start/en, resetar
	XGpio_SetDataDirection(&Gpio, 2, 0x00000001); // input -- finished


    print("BRAM OK and GPIO OK \n\r");


	int bloco1[8][8] = {
		{0x00C00000, 0x00A00000, 0x00800000, 0x00A00000, 0x00C00000, 0x00A00000, 0x00800000, 0x00B00000},
        {0x00E00000, 0x00E00000, 0x00800000, 0x00E00000, 0x00E00000, 0x00200000, 0x00A00000, 0x00B00000},
        {0x00800000, 0x00900000, 0x00A00000, 0x00B00000, 0x00C00000, 0x00D00000, 0x00E00000, 0x00F00000},
        {0x00F00000, 0x00E00000, 0x00D00000, 0x00C00000, 0x00B00000, 0x00A00000, 0x00900000, 0x00800000},
        {0x00900000, 0x00900000, 0x00A00000, 0x00B00000, 0x00B00000, 0x00C00000, 0x00D00000, 0x00E00000},
        {0x00C00000, 0x00D00000, 0x00E00000, 0x00F00000, 0x00800000, 0x00900000, 0x00A00000, 0x00B00000},
        {0x00D00000, 0x00C00000, 0x00B00000, 0x00A00000, 0x00900000, 0x00800000, 0x00F00000, 0x00E00000},
        {0x00A00000, 0x00C00000, 0x00D00000, 0x00F00000, 0x00B00000, 0x00800000, 0x00900000, 0x00E00000}
   };
	int bloco2[8][8] = {

		{-76, -73, -67, -62, -58, -67, -64, -55},
        {-65, -69, -73, -38, -19, -43, -59, -56},
        {-66, -69, -60, -15,  16, -24, -62, -55},
        {-65, -70, -57,  -6,  26, -22, -58, -59},
        {-61, -67, -60, -24,  -2, -40, -60, -58},
        {-49, -63, -68, -58, -51, -60, -70, -53},
        {-43, -57, -64, -69, -73, -67, -63, -45},
        {-41, -49, -59, -60, -63, -52, -50, -34}

   };
   	
	Matrix dct_2d_result, quantized_result;
   	Array zigzag_result, rle_result, huffman_result;
	dct_2d_result = DCT_2D(Matrix_int_to_fixed(bloco2).bloco);
	quantized_result=quantize(dct_2d_result.bloco);
	zigzag_result=zigzag(quantized_result.bloco);
	rle_result=runLengthEncoding(zigzag_result.vetor);

	Array_odd_even result = divide_in_odd_even(rle_result.vetor, rle_result.size_out);

	printf("Huffman Encoding\n");
	HuffmanCodes(result.odd, result.even, rle_result.size_out/2);
	



    return 0;
}
