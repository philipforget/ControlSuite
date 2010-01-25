package
{
	import flash.events.*;
	
	public class PositionBankLoaderEvent extends Event
	{
		public static const POSITION_BANK_LOADED:String = 'loaded';
		
		public var loadedCorrectly:Boolean;
		public var positionBankXML:XML;
		
		public function PositionBankLoaderEvent(type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									loadedCorrectly:Boolean = false,
									positionBankXML:XML = null)
		{
			
			
			super(type,bubbles,cancelable);
			
			
			this.positionBankXML = positionBankXML;
			this.loadedCorrectly = loadedCorrectly;
			
		}
		
	}
}
