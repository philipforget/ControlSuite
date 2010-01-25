package
{
	import flash.events.*;
	
	public class LightTweenEvent extends Event
	{
		public static const LIGHT_ACTIVATED:String = 'light activated';
		
		public var lightNumber:uint;
		public var valueArray:Array;
		
		public function LightTweenEvent(type:String, lightNumber:uint, valueArray:Array )
		{
			
			super(type,false,false);
			
			this.lightNumber = lightNumber;
			this.valueArray = valueArray;
		}
		
	}
}
