package
{
	import flash.display.Sprite;
	import flash.xml.*;
	import flash.events.*;
	import flash.net.*;
	public class PositionBankLoader extends Sprite
	{
		
		private var xmlLoader:URLLoader;
		private var loadedCorrectly:Boolean;
		private var xmlURL:URLRequest;
		
		private var positionsXML:XML;
		
		public function PositionBankLoader():void
		{
			
		}
		public function loadPositionBankXML(xmlURL:URLRequest):void
		{
			this.xmlURL = xmlURL;
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, broadcastIOError);
			xmlLoader.addEventListener(Event.COMPLETE, broadcastComplete);
			xmlLoader.load(xmlURL);
		}
		
		public function getXML():XML
		{
			return positionsXML;
		}
		
		private function broadcastComplete(e:Event):void
		{
			
			positionsXML = new XML(e.target.data);
			dispatchEvent(new PositionBankLoaderEvent(PositionBankLoaderEvent.POSITION_BANK_LOADED,
										  true,
										  false,
										  true,
										  positionsXML));
										  
		}
		
		
		private function broadcastIOError(e:Event):void
		{
			dispatchEvent(new PositionBankLoaderEvent(PositionBankLoaderEvent.POSITION_BANK_LOADED,
										  true,
										  false,
										  false));
		}
	}
}
