package
{
	import flash.events.*;
	import flash.display.*;
	public class BlankPosition extends Position
	{
		public function BlankPosition(uniqueID:uint):void
		{
			
			super(new BlankPositionXML(uniqueID).positionXMLList);
		}
	}
}
