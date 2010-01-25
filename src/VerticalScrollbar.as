package 
{

	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	
	public class VerticalScrollbar extends Sprite
	{
		private var scrollBarY:uint;
		
		private var scrollBacker:Sprite;
		private var scrollBackerHeight:uint;
		
		private var scrollButton:Sprite;
		private var scrollButtonHeight:uint;
		
		private var oldHeight:Number;
		
		private var yOffset:Number;
		
		private var yMin:Number;
		private var yMax:Number;
		
		private var scrollTweenSpeed:Number = .5;
		
		public function VerticalScrollbar(scrollBackerHeight:uint) 
		{
			yMin = 0;
			this.scrollBackerHeight = scrollBackerHeight;
			scrollBacker = new Sprite();
			scrollBacker.graphics.beginBitmapFill(new SimpleRaster());
			scrollBacker.graphics.drawRect(2, 0, 6, scrollBackerHeight);
			addChild(scrollBacker);
			
			scrollButton = new Sprite();
			scrollButton.graphics.beginFill(0xFFFFFF, .25);
			scrollButton.graphics.drawRect(0, 0, 10,scrollBackerHeight);
			addChild(scrollButton);
		}
		
		public function updateBars(mask:DisplayObject, content:DisplayObject, gotoY:int):void
		{
			
			if (scrollButton.hasEventListener(MouseEvent.MOUSE_DOWN))
					scrollButton.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
					
			// makes sure that the mask width is smaller than the contentwidth to prevent the scroll bar from negatively scaling (makes sense?)
			
			var scrollButtonY:Number = 0;
			if (mask.height >= content.height)
			{
				scrollButtonHeight = scrollBackerHeight;
			}
			else	
			{
				scrollButtonHeight = Math.floor((mask.height / content.height) * scrollBackerHeight); // new width of the scrollbar
				scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
				scrollButtonY = Math.floor((gotoY / content.height) * -scrollBackerHeight); // new value of the scrollbar for the x coordinate
			}
			
			
			yMax = scrollBackerHeight - scrollButtonHeight;
			
			content.cacheAsBitmap = true;
			
			if (GlobalVars.vars.mode == 'Standard')
			{
				Tweener.addTween(content, { y:gotoY, time:scrollTweenSpeed } );
				Tweener.addTween(scrollButton, { y:scrollButtonY, height:scrollButtonHeight, time:scrollTweenSpeed } );
			}
			else
			{
				content.y = gotoY;
				scrollButton.y = scrollButtonY;
				scrollButton.height = scrollButtonHeight;
			}
		}
		
		private function mouseDownListener(e:MouseEvent):void
		{
			yOffset = scrollButton.y - mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			scrollButton.y = yOffset + mouseY;
			if (scrollButton.y < yMin)
				scrollButton.y = yMin;
			if (scrollButton.y > yMax)
				scrollButton.y = yMax;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLER_MOVE, false, false, getPercentage()));
			e.updateAfterEvent();
		}
		
		private function mouseUpListener(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		private function getPercentage():Number
		{
			return scrollButton.y / (scrollBackerHeight - scrollButton.height);
		}
		private function restoreListeners():void
		{
			scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		public function updateY(content:DisplayObject, gotoY:Number):void
		{
			var value:Number = Math.floor((gotoY / content.height) * -scrollBackerHeight);
			Tweener.addTween(scrollButton, { y: value, time:.5 } );
		}
	}
	
}
