package {
	public class StandardOptions {

		static public function options():XML {
			return <options>
	<boards>
		<board0>
			<type>USB</type> <!-- 'Ethernet' or 'USB' -->
			<location>COMn</location> <!-- 192.168.x.xxx, or COMn-->
		</board0>
		<board1>
			<type>USB</type> <!-- 'Ethernet' or 'USB' -->
			<location>COMn</location> <!-- 192.168.x.xxx, or COMn-->
		</board1>
	</boards>
	<servos>
		<servo0>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>0</servoNumber>
			<analogIn>0</analogIn><!-- for continous servos only-->
			<zeroPoint>0</zeroPoint><!-- for continous servos only-->
			<servoLabel>Left Arm V</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo0>
		<servo1>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>1</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Left Arm H</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo1>
		<servo2>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>0</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Right Arm V</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo2>
		<servo3>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>1</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Right Arm H</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo3>
		<servo4>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>2</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Head Vertical</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>200</speedMax>
		</servo4>
		<servo5>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>2</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Head Horizontal</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo5>
		<servo6>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>3</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Torso Rotation</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo6>
		<servo7>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>3</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Spine</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo7>
	</servos>
	<globalMode>Standard</globalMode><!-- 'Standard' or 'Economy' -->
	<gridOptions>
		<gridRows>4</gridRows>
		<gridColumns>5</gridColumns>
	</gridOptions>
	<cameras>
		<trackingCamera>3</trackingCamera>
		<keyframeCamera>4</keyframeCamera>
	</cameras>
</options>
		}
	}
}
