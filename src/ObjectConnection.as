package
{
	
	import flash.display.Sprite;
	public class ObjectConnection extends Sprite
	{
		public var tempObject:*;
		public function ObjectConnection(fillColor:uint = 0xFF0000,alpha:Number = 0)
		{
			graphics.beginFill(fillColor, alpha);
			graphics.drawRoundRect(0, 0, 100, 20, 5, 5);
		}
		
	}
}
