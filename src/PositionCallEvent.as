package
{
	import flash.events.*;
	
	public class PositionCallEvent extends Event
	{
		public static const OBJET_FOCUS:String = 'object focus';
		public static const POSITION_ADDED:String = 'position added';
		public static const POSITION_SELECTED:String = 'position selected';
		public static const SHIFT_LEFT:String = 'shift left';
		public static const SHIFT_RIGHT:String = 'shift right';
		public static const RESET_COUNTS:String = 'reset counts';
		
		
		public var positionCallObject:PositionCallObject;
		public var positionCallBankObject:PositionCallBankObject;
		public var play:Boolean;
		
		
		public function PositionCallEvent(type:String, positionCallObject:PositionCallObject = null, positionCallBankObject:PositionCallBankObject = null, play:Boolean=false)
		{
			
		
			super(type,false,false);
			
			this.positionCallObject = positionCallObject;
			this.positionCallBankObject = positionCallBankObject;
			this.play = play;
		}
	}
}
