package 
{
	import flash.display.*;
	
	public class ClearIcon extends Sprite
	{
		private var iconSize:uint = 14;
		
		public function ClearIcon() 
		{
			graphics.lineStyle(1, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, iconSize-1, iconSize-1);
			
			graphics.lineStyle(2, 0xFF0000, .5);
			graphics.moveTo(3, 3);
			graphics.lineTo(11, 11);
			graphics.moveTo(3, 11);
			graphics.lineTo(11, 3);
		}
		
	}
	
}
