package
{
	public class ServoPosition{
		
		private var servoPosition:int;
		private var servoSpeed:int;
		
		public function ServoPosition(servoPositionList:XMLList):void
		{
			servoPosition = servoPositionList.servoPosition;
			
			servoSpeed = servoPositionList.servoSpeed;
		}
		
		public function setServoSpeed(servoSpeed:int):void
		{
			this.servoSpeed = servoSpeed;
		}
		
		public function getServoSpeed():int
		{
			return servoSpeed;
		}
		
		public function setServoPosition(servoPosition:int):void
		{
			this.servoPosition = servoPosition;
		}
		
		public function getServoPosition():int
		{
			return servoPosition;
		}
		
	}
}
