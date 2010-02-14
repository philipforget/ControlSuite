package 
{
	import flash.display.*;
	
	public class RadioButton extends Sprite
	{
		private var iconSize:uint = 14;
		private var value:Boolean = false;
		public function RadioButton(value:Boolean) 
		{
			graphics.lineStyle(2, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(1, 1, iconSize - 2, iconSize - 2);
			setValue(value);
		}
		
		public function getValue():Boolean
		{
			return value;
		}
		
		public function setValue(value:Boolean):void
		{
			
			this.value = value;
			drawIcon()
		}
		
		private function drawIcon():void
		{
			if (value)
				drawSelected()
			else
				drawBlank();
		}
		public function toggleValue():void
		{
			value = !value;
			drawIcon();
		}
		private function drawBlank():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(1, 1, iconSize-2, iconSize-2);
		}
		
		private function drawSelected():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginBitmapFill(new SimpleRaster(0x00000000,0xCC00FF00));
			graphics.drawRect(1, 1, iconSize-2, iconSize-2);
		}
	}
}
