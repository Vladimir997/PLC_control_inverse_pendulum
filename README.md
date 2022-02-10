# PLC_joystick_control_inverse_pendulum

Global variables:
	Analog01 – INT (Process Variable for the joystick)
	gAxis01 (never used)
	gAxis02 (the axis which we use)
  
The local variable StateP goes through 6 states.

In the first state ‘INITP’ we wait for a TRUE value of the variable StartP to go to the next state.

In the next state ‘STARTP’ we set the maximum velocity, acceleration and deceleration of the axis, for the highest input by the joystick. 
We also set the homing mode, velocity and acceleration. 
If the axis is ready to power on, State P goes to the state ‘POWERP’ where the axis is powered and then to the state ‘HOMEP’ where the axis is homed. 
The homing is toward the positive limit switch, or to the right.

After that it reaches the state ‘READYP’. 
The first IF in this state is for stopping additive movement. 
The second and third are for additive movement left and right by the commands of the variables LeftP and RightP.
The reference value of the Analog01 when the joystick is in the middle position is taken to be 15465, although it might change due to some external factors. 
For the value of VelocityCMD, 15465 is subtracted from the analog input to get the value of the signal. 
ScaleP scales the value of VelocityCMD from 0 to 1. 
ScaleP is multiplied by the maximum velocity – MaxVel, and that value affects the velocity of CyclicCMD. 
If Analog01 is greater than 15700 the axis moves in the negative direction or to the left, and if Analog01 is less than 15300 the axis moves in the positive direction or to the right. 
If Analog01 is between those values, the axis doesn’t move. 
If the axis position is greater then -50 when we move to the right or less than -650 when we move to the left, CyclicCMD is disabled so that we don’t reach the positive and negative limit switches, although there are still some errors that I didn’t manage to fix in time. 
If you exceed this limits you can only move in the opposite direction.


If there is some error, StateP goes to ‘ERRORP’, but I didn’t manage to implement a proper error handling in time, hence the variables ErrorConfP and ReadErrorP are not used. 
Also the variable HomeP is not used because MpAxisBasic has a Home command.
