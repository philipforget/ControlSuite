package 
{
	import flash.display.*;
	
	public class PlayButton extends Sprite
	{
		private var iconSize:uint = 14;
		
		public function PlayButton() 
		{
			graphics.lineStyle(1, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, iconSize - 1, iconSize - 1);
			
			graphics.lineStyle(0, 0x000000, 0);
			graphics.beginFill(0x00FF00, .5);
			graphics.moveTo(4, 3);
			graphics.lineTo(10, 7);
			graphics.lineTo(4, 11);
		}
	}
}
