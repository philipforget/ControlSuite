package
{
	
	import com.makingthings.makecontroller.*;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.*;
	public class StandardServoController extends Sprite
	{
		
		private var positionSlider:VerticalSlider;
		private var speedSlider:VerticalSlider;
		private var servoPosition:ServoPosition;
		
		private var board:Board;
		private var mcConnect:McFlashConnect;
		private var boardIP:String;
		private var servoNumber:uint;
		private var positionMin:int;
		private var positionMax:int;
		
		private var speedMin:int;
		private var speedMax:int;
		
		public function StandardServoController(positionMin:int, positionMax:int, speedMin:int, speedMax:int, rasterAlpha:Number, servoName:String, servoNumber:uint, mcConnect:McFlashConnect, board:Board):void
		{
			
			this.positionMax = positionMax;
			this.positionMin = positionMin;
			this.speedMax =  speedMax;
			this.speedMin = speedMin;
			this.servoNumber = servoNumber;
			this.mcConnect = mcConnect;
			this.board = board;

			var nameTextFormat:TextFormat = new TextFormat();
			nameTextFormat.align = TextFormatAlign.CENTER;
			nameTextFormat.color = 0xFFFFFF;
			nameTextFormat.size = 12;
			nameTextFormat.font = 'Ahron';
			
			var nameText:TextField = new TextField();
			nameText.defaultTextFormat = nameTextFormat;
			nameText.embedFonts = true;
			nameText.width = 100;
			nameText.height = 20;
			nameText.y = 4;
			nameText.text = servoName;
			addChild(nameText);
			
			var slideBacker:Sprite = new Sprite();
			slideBacker.graphics.beginFill(0x000000, rasterAlpha);
			slideBacker.graphics.drawRect(0, 0, 100, 150);
			addChild(slideBacker);
			positionSlider = new VerticalSlider(100, 0, 0, 100, false, true);
			addChild(positionSlider);
			positionSlider.x = 12;
			positionSlider.y = 23;
			
			speedSlider = new VerticalSlider(100, 0, 0, 100, false, true);
			addChild(speedSlider);
			speedSlider.x = 58;
			speedSlider.y = 23;
			
			positionSlider.addEventListener(SliderEvent.SLIDER_CHANGE, positionSliderListener);
			speedSlider.addEventListener(SliderEvent.SLIDER_CHANGE, speedSliderListener);
			
		}
				
		
		public function setSliders(servoPosition:ServoPosition):void
		{
			
			this.servoPosition = servoPosition;
			positionSlider.setScrollValue(servoPosition.getServoPosition(),true);
			speedSlider.setScrollValue(servoPosition.getServoSpeed(), true);
			
			var multipliedPosition:int = Math.floor(positionMin + ((positionMax - positionMin) * (servoPosition.getServoPosition() / 100)));
			var multipliedSpeed:int = Math.floor(speedMin + ((speedMax - speedMin) * (servoPosition.getServoSpeed() / 100)));
			
			try
			{
				sendPositionCommand(multipliedPosition);
				sendSpeedCommand(multipliedSpeed);
			}
			catch (e:Error)
			{
				
			}
		}
		
		private function sendSpeedCommand(multipliedSpeed:int):void
		{
			if(mcConnect)
				mcConnect.sendToBoard('/servo/' + servoNumber + '/speed', [multipliedSpeed],board);
		}
		
		private function sendPositionCommand(multipliedPosition:int):void
		{
			if(mcConnect)
				mcConnect.sendToBoard('/servo/' + servoNumber + '/position', [multipliedPosition],board);
		}
		
		private function positionSliderListener(e:SliderEvent):void
		{
			var multipliedPosition:int = Math.floor(positionMin+((positionMax-positionMin)*(e.value/100)));
			sendPositionCommand(multipliedPosition);
			servoPosition.setServoPosition(e.value);
			trace(multipliedPosition);
		}
		
		private function speedSliderListener(e:SliderEvent):void
		{
			var multipliedSpeed:int = Math.floor(speedMin + ((speedMax - speedMin) * (e.value/100)));
			
			sendSpeedCommand(multipliedSpeed);
			servoPosition.setServoSpeed(e.value);
		}	
	}
}
