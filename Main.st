
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	CASE StateP OF
		INITP:
			IF StartP THEN
				StateP := STARTP;
			END_IF
			
		STARTP:
			MaxVel := 2000;
			CyclicPar.Acceleration := 3000;
			CyclicPar.Deceleration := 10000;
			CyclicCMD.MpLink := ADR(gAxisBasic);
			CyclicCMD.Parameters := ADR(CyclicPar);
			CyclicCMD.Enable := TRUE;
			MotorP.MpLink := ADR(gAxisBasic);
			MotorP.Axis := ADR(gAxis02);
			MotorP.Enable := TRUE;
			BasicParP.Home.Mode := mcHOME_LIMIT_SWITCH;
			BasicParP.Home.Acceleration := 300;
			BasicParP.Home.StartVelocity := 50;
			BasicParP.Home.HomingVelocity := 50;
			MotorP.Parameters := ADR(BasicParP);
			IF MotorP.Info.ReadyToPowerOn THEN
				StateP := POWERP;
			END_IF
			
		POWERP:
			MotorP.Power := TRUE;
			IF MotorP.PowerOn THEN
				StateP := HOMEP;
			END_IF
			
		HOMEP:
			//HomeP.Axis := ADR(gAxis02);
			//HomeP.HomingMode := mcHOME_LIMIT_SWITCH;
			//HomeP.Execute := TRUE;
			MotorP.Home := TRUE;
			IF MotorP.IsHomed THEN
				StateP := READYP;
				MotorP.Home := FALSE;
				//HomeP.Execute := FALSE;
			END_IF
			
		READYP:
			IF EDGEPOS(MotorP.InPosition) THEN
				MotorP.MoveAdditive := FALSE;
				LeftP := FALSE;
				RightP := FALSE;
			END_IF
			IF LeftP THEN
				IF BasicParP.Distance > 0 THEN
					BasicParP.Distance := BasicParP.Distance * -1;
				END_IF
				MotorP.MoveAdditive := TRUE;
			END_IF
			IF RightP THEN
				IF BasicParP.Distance < 0 THEN
					BasicParP.Distance := BasicParP.Distance * -1;
				END_IF
				MotorP.MoveAdditive := TRUE;
			END_IF
		//	IF Analog01 > 7200 THEN
		//		IF NOT MotorP.MoveAdditive THEN
		//			VelocityCMD := (INT_TO_REAL(Analog01)-7200)/9.9130434;
		//			BasicParP.Velocity := VelocityCMD;
		//			BasicParP.Distance := 100;
		//			IF MotorP.Position < -300 THEN
		//				MotorP.MoveAdditive := TRUE;
		//			ELSE
		//				BasicParP.Velocity := 0;
		//				MotorP.MoveAdditive := FALSE;
		//			END_IF
		//		END_IF
		//	ELSIF Analog01 < 6800 THEN
		//		IF NOT MotorP.MoveAdditive THEN
		//			VelocityCMD := 6800-INT_TO_REAL(Analog01);
		//			BasicParP.Velocity := VelocityCMD;
		//			BasicParP.Distance := -100;
		//			IF MotorP.Position > -5800 THEN
		//				MotorP.MoveAdditive := TRUE;
		//			ELSE
		//				BasicParP.Velocity := 0;
		//				MotorP.MoveAdditive := FALSE;
		//			END_IF
		//		END_IF
		//	END_IF
			IF Analog01 > 15700 THEN
				VelocityCMD := INT_TO_LREAL(Analog01) - 15465;
				ScaleP := (VelocityCMD/15465);
				CyclicCMD.Velocity := ScaleP * MaxVel;
				CyclicPar.VelocityModeDirection := mpAXIS_DIR_NEGATIVE;
				IF MotorP.Position > -650 THEN
					CyclicCMD.CyclicVelocity := TRUE;
				ELSE
					CyclicCMD.CyclicVelocity := FALSE;
				END_IF
			ELSIF Analog01 < 15300 THEN
				VelocityCMD := 15465 - INT_TO_LREAL(Analog01);
				ScaleP := (VelocityCMD/15465);
				CyclicCMD.Velocity := ScaleP * MaxVel;
				CyclicPar.VelocityModeDirection := mpAXIS_DIR_POSITIVE;
				IF MotorP.Position < -50 THEN
					CyclicCMD.CyclicVelocity := TRUE;
				ELSE
					CyclicCMD.CyclicVelocity := FALSE;
				END_IF
			ELSE
				CyclicCMD.Velocity := 0;
				CyclicCMD.CyclicVelocity := FALSE;
			END_IF
			IF MotorP.Error OR CyclicCMD.Error THEN
				StateP := ERRORP;
			END_IF
			
		ERRORP:
			MotorP.Power := FALSE;
			StartP := FALSE;
			IF NOT MotorP.Error AND NOT CyclicCMD.Error THEN
				StateP := INITP;
			END_IF
			
	END_CASE
	
	CyclicCMD();
	MotorP();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

