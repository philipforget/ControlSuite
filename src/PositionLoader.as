package
{
	import flash.xml.*;
	import flash.events.*;
	import flash.net.*;
	public class PositionLoader{
		
		private var position:Position;
		public var xmlLoader:URLLoader;
		
		public function PositionLoader(positionsXML:URLRequest):void
		{
			xmlLoader.load(positionsXML);
			xmlLoader.addEventListener(Event.COMPLETE,loadComplete);
		}
		private function loadComplete(e:Event):void
		{
			dispatchEvent(new PositionLoaderEvent(PositionLoaderEvent.XML_LOADED));
		}
	}
}
