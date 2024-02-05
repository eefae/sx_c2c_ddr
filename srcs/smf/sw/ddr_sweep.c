/*
 * ddr_sweep.c: simple DDR sweep test application
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
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_testmem.h"
#include "xil_io.h"
#include "xil_assert.h"
#include "xgpio.h"


#define DDR_PS_BASEADDR_LOW  0x0
#define DDR_PS_HIGHADDR_LOW  0x7FFFFFFF
#define DDR_PS_BASEADDR_HIGH 0x800000000
#define DDR_PS_HIGHADDR_HIGH 0x87FFFFFFF

#define DDR_HAPS_BASEADDR 0x1000000000
#define DDR_HAPS_HIGHADDR 0x13FFFFFFFF


int main()
{
    init_platform();

    xil_printf("======== C2C DDR Sweep Test ========\n\n\r");
    xil_printf("Checking C2C link status...\n\r");

    u8 c2c_status;

    // Check C2C Link
    for(int i = 0; i < 4; i++){
    	c2c_status = Xil_In8(XPAR_GPIO_0_BASEADDR);

    	xil_printf("   Master Channel:   ");
        if(c2c_status == 0x3 || c2c_status == 0x2) print("LINK UP\n\r");
        else xil_printf("LINK DOWN\n\r");

        xil_printf("   Slave  Channel:   ");
        if(c2c_status == 0x3 || c2c_status == 0x1) print("LINK UP\n\r");
        else xil_printf("LINK DOWN\n\r");

        if(c2c_status != 0x3) {
        	if(i == 4){
        		xil_printf("Cannot establish C2C link. Exiting...\n\r");
        		return XST_FAILURE;
        	}
        	xil_printf("C2C Link Failure. Retrying...\n\r");
        	usleep(2000000);
        }
        else break;
    }



    xil_printf("          C2C link established.\n\n\r");



    xil_printf("****** SWEEP START ******\n\n\r");

    XStatus status;
    u32 read;

    for(u64 i = DDR_HAPS_BASEADDR; i < DDR_HAPS_HIGHADDR; i += 0x400000){
    	Xil_Out32(i, 0xAAAAFFFF);
    	read = Xil_In32(i);

    	xil_printf("       0x%02X%08X: ", i>>32, i);
    	xil_printf(read == 0xAAAAFFFF ? "PASSED":"FAILED");xil_printf("\n\r");
    }




    //xil_printf("       0x%08X: 0x%08X \n\r", DDR_HAPS_BASEADDR, read);


    print("\n******  SWEEP END  ******\n\n\r");
    print("Successfully ran C2C DDR Sweep Test.\n\r");


    cleanup_platform();
    return 0;
}
