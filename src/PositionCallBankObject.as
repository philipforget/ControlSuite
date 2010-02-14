package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	
	public class PositionCallBankObject extends Sprite
	{
		private var position:Position;
		private var imageLoader:Loader;
		private var index:uint;
		private var overlaySprite:Sprite;
		public function PositionCallBankObject(position:Position, index:uint) 
		{
			this.position = position;
			this.index = index;
			position.addEventListener(PositionEvent.POSITION_IMAGE_EDITED, drawCell);
			graphics.beginFill(0x000000, Math.random());
			graphics.drawRect(0, 0, 180, 240);
			imageLoader = new Loader();
			imageLoader.scaleX = .75;
			imageLoader.scaleY = .75;
		
			addChild(imageLoader);
			overlaySprite = new Sprite();
			addChild(overlaySprite);
			drawCell();
			addEventListener(MouseEvent.CLICK, dispatchCurrent);
			
			var shiftLeft:RasterButton = new RasterButton('Shift Left', 86, new ColorBank().blue);
			shiftLeft.x = 4;
			shiftLeft.y = 240 - 30 - 4;
			shiftLeft.addEventListener(MouseEvent.CLICK, shiftLeftListener);
			addChild(shiftLeft);
			
			var shiftRight:RasterButton = new RasterButton('Shift Right',86, new ColorBank().green);
			shiftRight.x = shiftLeft.x + shiftLeft.width;
			shiftRight.y = shiftLeft.y;
			shiftRight.addEventListener(MouseEvent.CLICK, shiftRightListener);
			addChild(shiftRight);
		}
		
		private function shiftRightListener(e:MouseEvent):void
		{
			dispatchEvent(new PositionCallEvent(PositionCallEvent.SHIFT_RIGHT,null, this));
		}
		private function shiftLeftListener(e:MouseEvent):void
		{
			dispatchEvent(new PositionCallEvent(PositionCallEvent.SHIFT_LEFT,null, this));
		}
		private function dispatchCurrent(e:MouseEvent):void
		{
			dispatchEvent(new PositionCallEvent(PositionCallEvent.POSITION_SELECTED, null, this));
		}
		private function drawCell(e:Event = null):void
		{
			try {
				imageLoader.load(new URLRequest('/static/KeyframeImages/' + position.getKeyframe(0).getKeyframeImage()));
			}
			catch(e:Error){}
		}
		public function setCurrent():void
		{
			position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, position));
			overlaySprite.graphics.clear();
			overlaySprite.graphics.lineStyle(4, position.getPositionColor(),1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			overlaySprite.graphics.drawRect(2, 2, 176, 236);
		}
		public function unsetCurrent():void
		{
			overlaySprite.graphics.clear();
		}
		public function getIndex():uint
		{
			return index;
		}
		public function setIndex(index:uint):void
		{
			this.index = index;
		}
		public function getPosition():Position
		{
			return position;
		}
	}
}
