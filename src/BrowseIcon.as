package 
{
	import flash.display.*;
	
	public class BrowseIcon extends Sprite
	{
		private var iconSize:uint = 14;
		
		public function BrowseIcon() 
		{
			graphics.lineStyle(2, 0xFFFFFF,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(1, 1, iconSize-2, iconSize-2);
			
			graphics.beginFill(0xFFFFFF);
			graphics.lineStyle(0, 0x000000, 0);
			graphics.drawRect(3, 9, 2, 2);
			graphics.drawRect(6, 9, 2, 2);
			graphics.drawRect(9, 9, 2, 2);
		}
		
	}
	
}
