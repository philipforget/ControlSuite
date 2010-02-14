package
{
	import flash.events.*;
	
	public class SliderEvent extends Event
	{
		public static const SCROLLER_MOVE:String = 'moved';
		public static const STEPPER_CHANGE:String = 'changed';
		public static const SLIDER_CHANGE:String = 'changed';
		public var value:Number;
		
		
		public function SliderEvent(type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									value:Number = 0)
		{
			
			super(type,bubbles,cancelable);
			
			this.value = value;
			
		}
		
	}
}
