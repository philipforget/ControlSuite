package
{
	import flash.events.*;
	
	public class NumericStepperEvent extends Event
	{
		public static const STEPPER_CHANGE:String = 'changed';
		public var value:Number;
		
		
		public function NumericStepperEvent(type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									value:Number = 0)
		{
			
			
			super(type,bubbles,cancelable);
			
			this.value = value;
			
		}
	}
}
