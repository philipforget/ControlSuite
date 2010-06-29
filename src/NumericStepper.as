package
{
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.*;
	
	public class NumericStepper extends Sprite
	{
		private var upButton:Sprite;
		private var downButton:Sprite;
		
		private var textField:TextField;
		
		private var min:int, max:int;
		
		private var stepperWidth:uint = 30;
		private var textFieldFormatRed:TextFormat;
		private var textFieldFormat:TextFormat;
		
		public function NumericStepper(min:int,max:int):void
		{
			this.min = min;
			this.max = max;
			upButton = new Sprite();
			upButton.graphics.beginFill(0x000000, .75);
			upButton.graphics.drawRect(0, 0, stepperWidth, 10);
			
			var upArrow:Sprite = new Sprite();
			upArrow.graphics.beginFill(0xFFFFFF);
			upArrow.graphics.moveTo(0, 5);
			upArrow.graphics.lineTo(5, 0);
			upArrow.graphics.lineTo(10, 5);
			
			upArrow.x = Math.floor(.5 * (upButton.width - upArrow.width));
			upArrow.y = Math.floor(.5 * (upButton.height - upArrow.height));
			
			upButton.addChild(upArrow);
			
			downButton = new Sprite();
			downButton.graphics.beginFill(0x000000, .75);
			downButton.graphics.drawRect(0, 0, stepperWidth, 10);
			
			
			var downArrow:Sprite = new Sprite();
			
			downArrow.graphics.beginFill(0xFFFFFF);
			downArrow.graphics.lineTo(5, 5);
			downArrow.graphics.lineTo(10, 0);
			
			downArrow.x = Math.floor(.5 * (downButton.width - downArrow.width));
			downArrow.y = Math.floor(.5 * (downButton.height - downArrow.height));
			downButton.addChild(downArrow);
			
			downButton.y = 25;
			
			//addChild(upButton);
			//addChild(downButton);
			
			//downButton.addEventListener(MouseEvent.CLICK, downListener);
			//upButton.addEventListener(MouseEvent.CLICK, upListener);
			
			
			textFieldFormat = new TextFormat();
			textFieldFormat.size = 8;
			textFieldFormat.font = "PixelMix";
			textFieldFormat.color = 0xFFFFFF;
			textFieldFormat.align = TextFormatAlign.CENTER;
			
			textFieldFormatRed = new TextFormat();
			textFieldFormatRed.color = 0xFF0000
			textFieldFormatRed.size = 8;
			textFieldFormatRed.font = "PixelMix"
			textFieldFormatRed.align = TextFormatAlign.CENTER;
			
			textField = new TextField();
			textField.height = 18;
			textField.width = stepperWidth;
			
			textField.type = 'input';
			textField.defaultTextFormat = textFieldFormat;
			textField.y = 12;
			textField.backgroundColor = 0x222222;
			textField.restrict = '-0123456789';
			textField.embedFonts = true;

			var textFieldBackground:Sprite = new Sprite;
			textFieldBackground.graphics.beginFill(0x222222);
			textFieldBackground.graphics.drawRect(0,0,21,18);
			textFieldBackground.x = 4;
			textFieldBackground.y = 10;
			addChild(textFieldBackground);

			addChild(textField);
			
			textField.addEventListener(FocusEvent.FOCUS_OUT, outListener);
			textField.addEventListener(Event.CHANGE, changeListener);
			
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		
		}
		
		private function changeListener(e:Event):void
		{
			if (Number(textField.text)<min||Number(textField.text)>max)
				textField.setTextFormat(textFieldFormatRed);
			else
				textField.setTextFormat(textFieldFormat);
			dispatchEvent(new SliderEvent(SliderEvent.STEPPER_CHANGE, false, false, Number(textField.text)));
		}
		public function setValue(value:int):void
		{
			textField.text = value.toString();
		}
		
		private function outListener(e:Event):void
		{
			if (Number(textField.text) < min)
				setValue(min);
			if (Number(textField.text) > max)
				setValue(max);
			textField.setTextFormat(textFieldFormat);
			dispatchEvent(new SliderEvent(SliderEvent.STEPPER_CHANGE, false, false, Number(textField.text)));
		}
		
	}
}
