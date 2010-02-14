package 
{
	import flash.display.*;
	
	public class ColorPickerIcon extends Sprite
	{
		private var iconSize:uint = 14;
		private var arrowSize:uint = 10;
		public function ColorPickerIcon() 
		{
			graphics.lineStyle(2, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .1);
			graphics.drawRect(1, 1, iconSize-2, iconSize-2);
			graphics.beginFill(0xFFFFFF);
			graphics.lineStyle(0, 0xFFFFFF,0);
			graphics.moveTo(iconSize, iconSize-arrowSize);
			graphics.lineTo(iconSize-arrowSize, iconSize);
			graphics.lineTo(iconSize, iconSize);
		}
		
	}
	
}
