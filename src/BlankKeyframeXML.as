package
{
	import flash.xml.*;
	public class BlankKeyframeXML {
				
		public var keyframeXMLList:XMLList;
		public function BlankKeyframeXML(keyframeOrder:uint):void
		{
			var keyframeXML:XML =<positionKeyframe>
						  <keyframeOrder>0</keyframeOrder>
						  <keyframeColor>new ColorBank().green</keyframeColor>
						  <keyframeImage>placeholder.png</keyframeImage>
						  <keyframeDelay>1000</keyframeDelay>
						  <keyframeSound></keyframeSound>
						  <keyframeSoundLoopCount>0</keyframeSoundLoopCount>
						  <keyframeClearsSounds>false</keyframeClearsSounds>
						  <keyframeSoundVolume>100</keyframeSoundVolume>
						  <keyframeSoundPan>0</keyframeSoundPan>
						  <lightProperties>
							<light0>0</light0>
							<light1>0</light1>
							<light2>0</light2>
							<light3>0</light3>
							<light4>0</light4>
							<light5>0</light5>
							<light6>0</light6>
							<light7>0</light7>							
						  </lightProperties>
						  <servoProperties>
							<servo0>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo0>
							<servo1>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo1>
							<servo2>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo2>
							<servo3>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo3>
							<servo4>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo4>
							<servo5>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo5>
							<servo6>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo6>
							<servo7>
							  <servoPosition>50</servoPosition>
							  <servoSpeed>25</servoSpeed>
							</servo7>
						  </servoProperties>
						</positionKeyframe>;
			
			keyframeXML.keyframeColor = new FavoriteColorPicker().randomColor();
			keyframeXML.keyframeOrder = keyframeOrder;
			keyframeXMLList = new XMLList(keyframeXML);
		}
	}
}
