package
{
	import flash.events.*;
	
	public class ColorPickerEvent extends Event
	{
		public static const COLOR_SELECTED:String = 'selected';
		public static const COLOR_CANCELED:String = 'canceled';
		public static const COLOR_CALL:String = 'called';
		
		public var color:uint;
		public var colorCallFunction:Function;
		
		public function ColorPickerEvent(type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									color:uint = 0xFFFF0000,
									colorCallFunction:Function = null)
		{
			
			
			super(type,bubbles,cancelable);
			
			
			this.color = color;
			this.colorCallFunction = colorCallFunction;
			
		}
	}
}
