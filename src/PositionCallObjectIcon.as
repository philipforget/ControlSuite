package 
{
	import flash.display.*;
	import flash.events.Event;
	
	public class PositionCallObjectIcon extends Sprite
	{
		private var position:Position;
		private var iconWidth:Number;
		private var iconHeight:Number;
		
		public function PositionCallObjectIcon(position:Position, iconWidth:Number, iconHeight:Number )
		{
			
			this.position = position;
			this.iconWidth = iconWidth;
			this.iconHeight = iconHeight;
			
			position.addEventListener(PositionEvent.POSITION_SELECTED, showMe);
			position.addEventListener(PositionEvent.POSITION_UNSELECTED, hideMe);
			showMe();
		}
		private function hideMe(e:Event = null):void
		{
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			graphics.lineStyle(0, 0x000000,.25);
			graphics.drawRect(0, 0, iconWidth, iconHeight);
		}
		private function showMe(e:Event = null):void
		{
			graphics.clear();
			graphics.lineStyle(0, 0x000000,.25);
			graphics.beginBitmapFill(new SimpleRaster(0x000000,0x66FF0000));
			graphics.drawRect(0, 0, iconWidth, iconHeight);
		}
		
	}
	
}
