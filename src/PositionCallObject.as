package 
{

	import flash.display.*;
	import flash.events.*;
	
	public class PositionCallObject extends Sprite
	{
		private var objectConnection:ObjectConnection;
		private var objectWidth:uint;
		private var objectHeight:uint;
		private var row:uint;
		private var column:uint;
		
		private var callCount:uint = 0;
		
		private var positionCallArray:Array;
		
		private var positionIconHolder:Sprite;
		
		public function PositionCallObject(objectConnection:ObjectConnection, objectWidth:uint, objectHeight:uint, row:uint, column:uint) 
		{
			this.objectConnection = objectConnection;
			this.objectHeight = objectHeight;
			this.objectWidth = objectWidth;
			this.row = row;
			this.column = column;
			
			
			positionCallArray = new Array();
			
			positionIconHolder = new Sprite();
			positionIconHolder.x = 1;
			positionIconHolder.y = 1;
			addChild(positionIconHolder);
			clear();
			addEventListener(MouseEvent.CLICK, mouseClickListener);
			//addEventListener(PositionCallEvent.POSITION_ADDED, drawIcons);
		}
		
		private function mouseClickListener(e:MouseEvent):void
		{
			setCurrent(false);
		}
		
		public function setCurrent(play:Boolean = false):void
		{
			objectConnection.dispatchEvent(new PositionCallEvent(PositionCallEvent.OBJET_FOCUS, this,null, play));
			draw();
		}
		
		public function clear():void
		{
			graphics.clear();
			graphics.beginFill(0x000000, .2);
			graphics.lineStyle(0, new ColorBank().blue,.5);
			graphics.drawRect(0, 0, objectWidth, objectHeight);
			graphics.endFill();
			if (positionCallArray.length)
			{
				graphics.lineStyle(2, new ColorBank().green,1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
				graphics.drawRect(2, 2, objectWidth-3, objectHeight-3);
			}
		}
		public function draw():void
		{
			graphics.clear();
			graphics.beginBitmapFill(new SimpleRaster(0x88FFFFFF));
			graphics.lineStyle(0, new ColorBank().green);
			graphics.drawRect(0, 0, objectWidth, objectHeight);
			if (positionCallArray.length)
			{
				graphics.endFill();
				graphics.lineStyle(2, new ColorBank().blue,1,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
				graphics.drawRect(2, 2, objectWidth-3, objectHeight-3);
			}
		}
		
		public function getPositionCallArray():Array 
		{
			return positionCallArray;
		}
		public function insertPositionCall(index:uint, position:Position):void
		{
			positionCallArray[index] = position;
		}
		public function getRow():uint
		{
			return row;
		}
		public function getColumn():uint
		{
			return column;
		}
		
		public function getCallCount():uint
		{
			return callCount;
		}
		
		public function setCallCount(callCount:uint):void
		{
			this.callCount = callCount;
		}
		
		public function resetCallCount():void
		{
			callCount = 0;
		}
	}
	
}
