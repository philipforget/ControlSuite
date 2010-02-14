package 
{
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	public class HorizontalScrollbar extends Sprite
	{
		private var scrollBarX:uint;
		
		private var scrollBacker:Sprite;
		private var scrollBackerWidth:uint;
		
		private var scrollButton:Sprite;
		private var scrollButtonWidth:uint;
		
		private var oldWidth:Number;
		
		private var xOffset:Number;
		
		private var xMin:Number;
		private var xMax:Number;
		
		private var scrollTweenSpeed:Number = .5;
		
		public function HorizontalScrollbar(scrollBackerWidth:uint) 
		{
			xMin = 0;
			this.scrollBackerWidth = scrollBackerWidth;
			scrollBacker = new Sprite();
			scrollBacker.graphics.beginBitmapFill(new SimpleRaster());
			scrollBacker.graphics.drawRect(0, 2, scrollBackerWidth, 6);
			addChild(scrollBacker);
			
			scrollButton = new Sprite();
			scrollButton.graphics.beginFill(0xFFFFFF, .25);
			scrollButton.graphics.drawRect(0, 0, scrollBackerWidth, 10);
			addChild(scrollButton);
		}
		
		public function updateBars(mask:DisplayObject, content:DisplayObject, gotoX:Number=NaN):void
		{
			
			if (scrollButton.hasEventListener(MouseEvent.MOUSE_DOWN))
					scrollButton.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
					
			// makes sure that the mask width is smaller than the contentwidth to prevent the scroll bar from negatively scaling (makes sense?)
			
			var scrollButtonX:Number = 0;
			if (mask.width >= content.width)
			{
				scrollButtonWidth = scrollBackerWidth;
			}
			else	
			{
				scrollButtonWidth = Math.floor((mask.width / content.width) * scrollBackerWidth); // new width of the scrollbar
				scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
				scrollButtonX = Math.floor((gotoX / content.width) * -scrollBackerWidth); // new value of the scrollbar for the x coordinate
			}
			
			
			xMax = scrollBackerWidth - scrollButtonWidth;
			
			content.cacheAsBitmap = true;
			
			if(GlobalVars.vars.mode == 'Standard')
			{
				Tweener.addTween(content, { x:gotoX, time:scrollTweenSpeed } );
				Tweener.addTween(scrollButton, { x:scrollButtonX, width:scrollButtonWidth, time:scrollTweenSpeed } );
			}
			else
			{
				trace(gotoX);
				content.x = gotoX;
				scrollButton.width = scrollButtonWidth;
				scrollButton.x  = scrollButtonX;
			}
			
		}
		
		private function mouseDownListener(e:MouseEvent):void
		{
			xOffset = scrollButton.x - mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			scrollButton.x = xOffset + mouseX;
			if (scrollButton.x < xMin)
				scrollButton.x = xMin;
			if (scrollButton.x > xMax)
				scrollButton.x = xMax;
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
			return scrollButton.x / (scrollBackerWidth - scrollButton.width);
		}
		private function restoreListeners():void
		{
			scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
	}
}
