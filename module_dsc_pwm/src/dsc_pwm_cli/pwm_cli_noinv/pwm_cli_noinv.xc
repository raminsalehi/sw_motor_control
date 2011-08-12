/**
 * Module:  module_dsc_pwm
 * Version: 0v9sd
 * Build:   33b57590556e94c1ec6b31d6675d6fe851442ee1
 * File:    pwm_cli_noinv.xc
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
#include "pwm_cli_noinv.h"

#ifdef PWM_NOINV_MODE

void update_pwm( chanend c, unsigned value[])
{
	unsigned mode;
	unsigned chan_id[PWM_CHAN_COUNT];
	t_out_data pwm_out_data[PWM_CHAN_COUNT];

	for (int i = 0; i < PWM_CHAN_COUNT; i++)
	{
		chan_id[i] = i;
	}

	/* calculate the required outputs */
	for (int i = 0; i < PWM_CHAN_COUNT; i++)
	{
		calculate_data_out( value[i], pwm_out_data[i] );
	}

	/* now order them and work out the mode */
	order_pwm( mode, chan_id, pwm_out_data );

	/* trigger update */
	c <: mode;

	master
	{
		/* get ordered pwm channels */
		for (int i = 0; i < PWM_CHAN_COUNT; i++)
			c <: chan_id[i];

		/* get channel information */
		for (int i = 0; i < PWM_CHAN_COUNT; i++)
		{
			c <: pwm_out_data[i].ts0;
			c <: pwm_out_data[i].out0;
			c <: pwm_out_data[i].ts1;
			c <: pwm_out_data[i].out1;
		}
	}
}
#endif
