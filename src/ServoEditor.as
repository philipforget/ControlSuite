package
{

	import com.makingthings.makecontroller.Board;
	import com.makingthings.makecontroller.McEvent;
	import com.makingthings.makecontroller.McFlashConnect;
	import flash.display.Sprite;
	
	public class ServoEditor extends Sprite
	{
		private var objectConnection:ObjectConnection;
		private var positionKeyframe:PositionKeyframe;
		private var servoControllerArray:Array;
		
		private var mcConnect:McFlashConnect;
		
		private var board0:Board;
		private var board1:Board;
		
		public function ServoEditor(objectConnection:ObjectConnection, mcConnect:McFlashConnect, board0:Board, board1:Board, servoOptions:XMLList)
		{
			this.objectConnection = objectConnection;
			
			this.mcConnect = mcConnect;
			this.board0 = board0;
			this.board1 = board1;
			
			
			
			objectConnection.addEventListener(KeyframeEvent.KEYFRAME_SELECTED, keyframeSelectionListener);
			objectConnection.addEventListener(KeyframeEvent.KEYFRAME_DELETED, keyframeDeletedListener);
			
			
			
			graphics.beginFill(0x000000,.25);
			graphics.drawRect(0, 0, 800, 150);
			
			graphics.beginBitmapFill(new SimpleRaster(0x00FFFFFF,0x44FFFFFF));
			graphics.drawRect(0, 126, 800, 22);
			
			servoControllerArray = new Array();
			
			for (var i:uint = 0; i < 8; i++)
			{
				var backAlpha:Number = 0;
				if (i % 2)
					backAlpha = .25;
				
				var tempBoard:Board = board0;
				if (servoOptions['servo' + i].boardNumber == 1)
					tempBoard = board1
					
				var servoType:String = servoOptions['servo' + i].servoType;
				var servoLabel:String = servoOptions['servo' + i].servoLabel;
				var servoNumber:uint = servoOptions['servo' + i].servoNumber;
			
				var analogIn:uint = servoOptions['servo' + i].analogIn;
				var zeroPoint:int = servoOptions['servo' + i].zeroPoint;
				var positionMin:int = servoOptions['servo' + i].positionMin;
				var positionMax:int = servoOptions['servo' + i].positionMax;
				var speedMin:int = servoOptions['servo' + i].speedMin;
				var speedMax:int = servoOptions['servo' + i].speedMax;
				
				var servoController:*;
				
				if (servoType == 'Continous')
					servoController = new ContinousServoController(positionMin, positionMax, speedMin, speedMax, backAlpha, servoLabel, servoNumber, analogIn,zeroPoint, mcConnect, tempBoard);
				else
					servoController = new StandardServoController( positionMin, positionMax, speedMin, speedMax, backAlpha,servoLabel, servoNumber, mcConnect, tempBoard);
				
				servoController.x = i * 100;
				addChild(servoController);
				servoControllerArray.push(servoController);
			}			
			
		}
		
		public function populateEditor(positionKeyframe:PositionKeyframe):void
		{
			this.positionKeyframe = positionKeyframe;
			for (var i:uint = 0; i < 8; i++)
			{
				servoControllerArray[i].setSliders(positionKeyframe.getServoPosition(i));
			}
		}
		
		private function keyframeSelectionListener(e:KeyframeEvent):void
		{
			populateEditor(e.positionKeyframe);
		}
		
		private function keyframeDeletedListener(e:KeyframeEvent):void
		{
			
		}
	}
}
