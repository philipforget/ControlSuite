package
{
	import flash.events.*;
	
	public class ScrollEvent extends Event
	{
		
		public static const SCROLLER_MOVE:String = 'moved';
		public var value:Number;
		
		public function ScrollEvent(type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									value:Number = 0)
		{
			
			//pass constructor paramaters to the superclass constructor
			super(type,bubbles,cancelable);
			
			this.value = value;
			
		}
	}
}
