package 
{
	import flash.display.*;
	import flash.events.*;
	
	public class ToggleButton extends Sprite
	{
		
		private var toggleState:Boolean;
		
		public function ToggleButton(initialState:Boolean = false) 
		{
			toggleState = initialState;
			drawButton();
			
			addEventListener(MouseEvent.CLICK, toggle);
		}
		
		private function toggle(e:MouseEvent):void
		{
			toggleState = !toggleState;
			dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE, toggleState));
			drawButton();
		}
		
		private function drawButton():void
		{
			if (toggleState)
				drawTrue();
			else
				drawFalse();
		}
		private function drawTrue():void
		{
			graphics.clear();
			graphics.beginBitmapFill(new SimpleRaster(new ColorBank().green));
			graphics.lineStyle(2, 0xFFFFFF,1);
			graphics.drawCircle(0, 0, 7);
		}
		
		public function setToggleState(toggleState:Boolean):void
		{
			this.toggleState = toggleState;
			dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE, toggleState));
			drawButton();
		}
		
		private function drawFalse():void
		{
			graphics.clear();
			graphics.beginBitmapFill(new SimpleRaster(new ColorBank().grey));
			graphics.lineStyle(2, 0xFFFFFF,.5);
			graphics.drawCircle(0, 0, 7);
		}
	}
}
