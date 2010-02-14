package 
{
	import flash.display.*;
	
	public class StopButton extends Sprite
	{
		private var iconSize:uint = 14;
		
		public function StopButton() 
		{
			graphics.lineStyle(1, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, iconSize - 1, iconSize - 1);
			
			graphics.lineStyle(0, 0x000000, 0);
			graphics.beginFill(0xFF0000, .5);
			graphics.drawRect(4, 4, 6, 6);
		}
	}
}
