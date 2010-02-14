package
{
	import flash.events.*;
	
	public class ToggleEvent extends Event
	{
		public static const TOGGLE:String = 'toggle';
		
		public var toggleState:Boolean;
		
		public function ToggleEvent(type:String,
									toggleState:Boolean)
		{
			
		
			super(type,false,false);
			
			this.toggleState = toggleState;
			
		}
	}
}
