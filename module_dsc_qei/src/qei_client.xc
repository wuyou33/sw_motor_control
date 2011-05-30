/**
 * Module:  module_dsc_qei
 * Version: 1v0alpha0
 * Build:   e89e295a87b36dc1ad5ce82058b7434d3df4bb94
 * File:    qei_client.xc
 * Modified by : Srikanth
 * Last Modified on : 26-May-2011
 *
 * The copyrights, all other intellectual and industrial 
 * property rights are retained by XMOS and/or its licensors. 
 * Terms and conditions covering the use of this code can
 * be found in the Xmos End User License Agreement.
 *
 * Copyright XMOS Ltd 2010
 *
 * In the case where this code is a modification of existing code
 * under a separate license, the separate license terms are shown
 * below. The modifications to the code are still covered by the 
 * copyright notice above.
 *
 **/                                   
#include <xs1.h>
#include "qei_commands.h"

#define QEI_SPEED_AVG 10
unsigned qei_avg_buffer[QEI_SPEED_AVG] = {0};
unsigned qei_buf_pos = 0;

unsigned get_qei_position ( chanend c_qei )
{
	unsigned tmp;
	unsigned r;

	c_qei <: QEI_CMD_POS_REQ;
	c_qei :> tmp;

	r = tmp ;
	return r;
}

int get_qei_speed ( chanend c_qei )
{
	unsigned t1, t2;
	int r;

	c_qei <: QEI_CMD_SPEED_REQ;
	c_qei :> t1;
	c_qei :> t2;

	if (t2-t1 == 0)
		r = 0;
	else
	{
		r = 3000000000 / ((t2 - t1) * (256 * 4));
		r <<= 1; // double to get RPM
	}

	qei_avg_buffer[qei_buf_pos++] = r;
	if (qei_buf_pos >= QEI_SPEED_AVG)
		qei_buf_pos = 0;

	r = 0;
	for (int i = 0; i < QEI_SPEED_AVG; i++)
		r += qei_avg_buffer[i];

	r = r / QEI_SPEED_AVG;

	return r;
}

int qei_pos_known ( chanend c_qei )
{
	int r;
	c_qei <: QEI_CMD_POS_KNOWN_REQ;
	c_qei :> r;

	return r;
}

int qei_cw ( chanend c_qei )
{
	int r;
	c_qei <: QEI_CMD_CW_REQ;
	c_qei :> r;

	return r;
}
