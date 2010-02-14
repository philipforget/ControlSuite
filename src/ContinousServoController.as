package
{
	
	import com.makingthings.makecontroller.*;
	import flash.display.*;
	import flash.geom.Matrix;
	import caurina.transitions.*;
	import flash.text.*;
	
	public class ContinousServoController extends Sprite
	{
		
		
		private var positionSlider:VerticalSlider;
		private var speedSlider:VerticalSlider;
		
		private var actualPositionIndicator:Sprite;
		
		private var servoPosition:ServoPosition;
		
		private var board:Board;
		private var mcConnect:McFlashConnect;
		
		private var servoNumber:uint;
		
		private var positionMin:int;
		private var positionMax:int;
		
		private var speedMin:int;
		private var speedMax:int;
		
		private var initialize:Boolean = true;
		
		private var analogIn:uint;// Analog In Port to listen for servo position
		
		private var wantedPosition:uint;
		private var actualPosition:uint;
		
		private var currentServoSpeed:int; // the current speed of the servo to avoid sending too many position commands to the cr servo
		private var runLoop:Boolean;
		
		private var zeroPoint:int;
		
		private var servoName:String;
		
		
		public function ContinousServoController(positionMin:int, positionMax:int, speedMin:int, speedMax:int, rasterAlpha:Number, servoName:String, servoNumber:uint, analogIn:uint, zeroPoint:int, mcConnect:McFlashConnect, board:Board ):void
		{
			
			this.positionMax = positionMax;
			this.positionMin = positionMin;
			this.speedMax =  speedMax;
			this.speedMin = speedMin;
			
			this.servoName = servoName;
			this.servoNumber = servoNumber;
			this.analogIn = analogIn;
			this.mcConnect = mcConnect;
			this.board = board;
			
			this.zeroPoint = zeroPoint;
			
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
			
			currentServoSpeed = 0;
			
			var slideBacker:Sprite = new Sprite();
			slideBacker.graphics.beginFill(0x000000, rasterAlpha);
			slideBacker.graphics.drawRect(0, 0, 100, 150);
			addChild(slideBacker);
			
			positionSlider = new VerticalSlider(100, 0, 0, 100, false, true);
			addChild(positionSlider);
			positionSlider.x = 12;
			positionSlider.y = 23;
			
			actualPositionIndicator = new Sprite();
			actualPositionIndicator.graphics.lineStyle(1, 0xFFFFFF, .75);
			actualPositionIndicator.graphics.drawRect(0, 0, 30, 10);
			actualPositionIndicator.x = 12;
			addChild(actualPositionIndicator);
			
			Tweener.addTween(actualPositionIndicator, { y:112, time:1 } );
			
			speedSlider = new VerticalSlider(100, 0, 0, 100, false, true);
			addChild(speedSlider);
			speedSlider.x = 58;
			speedSlider.y = 23;
			
			positionSlider.addEventListener(SliderEvent.SLIDER_CHANGE, positionSliderListener);
			speedSlider.addEventListener(SliderEvent.SLIDER_CHANGE, speedSliderListener);
			mcConnect.addEventListener(McEvent.ON_MESSAGE_IN, onMessageIn);
			mcConnect.sendToBoard('/analogin/' + analogIn + '/value', [], board);
		
			
		}
		
		
		public function setSliders(servoPosition:ServoPosition):void
		{
			this.servoPosition = servoPosition;
			positionSlider.setScrollValue(servoPosition.getServoPosition(),true);
			speedSlider.setScrollValue(servoPosition.getServoSpeed(), true);
			
			
			var multipliedPosition:int = Math.floor(positionMin + ((positionMax - positionMin) * (servoPosition.getServoPosition() / 100)));
			wantedPosition = multipliedPosition;
			var multipliedSpeed:int = Math.floor(speedMin + ((speedMax - speedMin) * (servoPosition.getServoSpeed() / 100)));
			
			mcConnect.sendToBoard('/analogin/' + analogIn + '/value', [], board);
			sendSpeedCommand(multipliedSpeed);
			
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
			var multipliedPosition:int = Math.floor(positionMin + ((positionMax - positionMin) * (e.value / 100)));
			wantedPosition = multipliedPosition;
			servoPosition.setServoPosition(e.value);
			mcConnect.sendToBoard('/analogin/' + analogIn + '/value', [], board);
		}
		
		private function speedSliderListener(e:SliderEvent):void
		{
			var multipliedSpeed:int = Math.floor(speedMin + ((speedMax - speedMin) * (e.value/100)));
			sendSpeedCommand(multipliedSpeed);
			servoPosition.setServoSpeed(e.value);
		}	
		private function onMessageIn(e:McEvent):void
		{
			if (servoPosition)
			{
				var msg:OscMessage = e.data;
				if (msg.from == '192.168.0.1')
				{
					if(msg.address.toString()==("/analogin/"+analogIn+"/value")){
						actualPosition = msg.args[0];
						// if this is the first message, initialize the servos actual position to be that of the servos assigned analog in port
						
						// check to see if the actual position is less than or greater than the 
						
						if (wantedPosition < actualPosition - 5)
						{
			
							if (currentServoSpeed != (3 * servoPosition.getServoSpeed()))
							{
								currentServoSpeed = 3*servoPosition.getServoSpeed()
								sendPositionCommand(currentServoSpeed);
								sendPositionCommand(currentServoSpeed);
							}
							mcConnect.sendToBoard('/analogin/' + analogIn + '/value', [], board);
							
						}
							
						else if (wantedPosition > actualPosition+5)
						{
							
							if (currentServoSpeed != ( -3*(1+servoPosition.getServoSpeed())))
							{
								currentServoSpeed = ( -3 * (1 + servoPosition.getServoSpeed()));
								sendPositionCommand(currentServoSpeed);
								sendPositionCommand(currentServoSpeed);
							}
							mcConnect.sendToBoard('/analogin/' + analogIn + '/value', [], board);
							
						}
						else
						{
							currentServoSpeed = zeroPoint;
							sendPositionCommand(zeroPoint);
						}
					}
				}
			}
		}
	}
}
