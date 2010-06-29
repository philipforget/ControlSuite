package
{

	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	
	public class VerticalSlider extends Sprite
	{
		private var sliderHeight:Number;
		private var sliderPosition:Number;
	
		private var yMin:Number
		private var yMax:Number;
		
		private var minValue:Number;
		private var maxValue:Number;
		
		private var inverted:Boolean;
		
		private var sliderButton:Sprite;
		private var sliderColor1:Sprite;
		private var sliderColor2:Sprite;
		
		
		private var sliderBacker:Sprite;
		
		private var yOffset:Number;
		
		private var stepper:NumericStepper;
		
		private var buttonWidth:int;
		private var buttonHeight:int;
		
		private var gotoY:Number;
		
		public var tweenHolder:int;
		
		public function VerticalSlider(sliderHeight:Number = 100, sliderPosition:Number = 0 ,minValue:Number=0,maxValue:Number=100,inverted:Boolean=false,showStepper:Boolean = false,buttonWidth:int = 30,buttonHeight:int = 10):void
		{
			
			this.buttonHeight = buttonHeight;
			this.buttonWidth = buttonWidth;
			this.inverted = inverted;
			
			this.maxValue = maxValue;
			this.minValue = minValue;
			
			sliderBacker = new Sprite();
			sliderBacker.graphics.lineStyle(0, 0xFFFFFF, .2);
			sliderBacker.graphics.lineTo(0, sliderHeight);
			sliderBacker.x = buttonWidth/2;
			
			sliderButton = new Sprite();
			sliderButton.useHandCursor = true;
			sliderButton.buttonMode = true;
			
			sliderColor1 = new Sprite();
			sliderColor2 = new Sprite();
			
			sliderColor1.graphics.beginBitmapFill(new SimpleRaster(new ColorBank().red));
			sliderColor1.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			
			sliderColor2.graphics.beginBitmapFill(new SimpleRaster(0x00FF0000,new ColorBank().green));
			sliderColor2.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			
			sliderButton.addChild(sliderColor1);
			sliderButton.addChild(sliderColor2);
			
			
			addChild(sliderBacker);
			addChild(sliderButton);
			
			this.yMin = 0;
			this.yMax = sliderHeight-sliderButton.height;
			
			
			createStepper(showStepper);
			
			sliderButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			setScrollValue(sliderPosition,true,true);
			
		}
		
		private function createStepper(showStepper:Boolean):void
		{
			stepper = new NumericStepper(minValue, maxValue);
			stepper.addEventListener(SliderEvent.STEPPER_CHANGE, stepperListener);
				
			
			stepper.x = -.5 * (stepper.width - sliderButton.width);
			stepper.y = height-5;
			stepper.setValue(sliderPosition);
			if (showStepper)
				addChild(stepper);
		}
		
		private function stepperListener(e:SliderEvent):void
		{
			setStepperScrollValue(e.value);
		}
		private function mouseDownListener(e:MouseEvent):void
		{
			Tweener.removeTweens(sliderButton);
			yOffset=mouseY-sliderButton.y;
			
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);
		}
		
		private function mouseUpListener(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpListener);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			sliderButton.y=Math.floor(mouseY-yOffset);
			if(sliderButton.y <= yMin)
				sliderButton.y = yMin;
			if(sliderButton.y >= yMax)
				sliderButton.y = yMax;
						
			updateSliderColor();
			dispatchScrollValue();
			e.updateAfterEvent();
		}
		
		public function setScrollValue(wantedPosition:Number, updateStepper:Boolean,tween:Boolean =true):void
		{
			var value:Number = new Number();
			
			if (inverted)
				value = (wantedPosition - minValue) / (maxValue - minValue);
			else
				value = 1 - (value = (wantedPosition - minValue) / (maxValue - minValue));
			
			if (value < 0)
				value = 0;
			if (value > 1)
				value = 1;
			
			gotoY = Math.floor(value * (sliderBacker.height - sliderButton.height));
			
			if (gotoY != sliderButton.y)
			{
				if (tween)
				{
					if (updateStepper){
						if(GlobalVars.vars.mode == 'Standard')
							Tweener.addTween(sliderButton, { y:gotoY, time:1, onUpdate:setStepper } );
						else
						{
							
							sliderButton.y = gotoY;
							setStepper();
							updateSliderColor()
						}
					}
					else
					{
						if(GlobalVars.vars.mode == 'Standard')
							Tweener.addTween(sliderButton, { y:gotoY, time:1, onUpdate:updateSliderColor } );
						else
						{
							sliderButton.y = gotoY;
							updateSliderColor();
						}
					}
				}
				else
				{
					sliderButton.y = gotoY;
					updateSliderColor();
				}
			}
		}
		private function setStepper():void
		{
			stepper.setValue(100 * getScrollPercentage());
			updateSliderColor();
		}
		private function setStepperScrollValue(wantedPosition:Number):void
		{
			if (wantedPosition >= minValue && wantedPosition <= maxValue ){
					setScrollValue(wantedPosition, false);
					dispatchEvent(new SliderEvent(SliderEvent.SLIDER_CHANGE, false, false, wantedPosition));
			}
		}
		
		private function dispatchScrollValue():void
		{
			var value:Number = Math.floor((getScrollPercentage()) * (maxValue - minValue) + minValue);
			stepper.setValue(value);
			dispatchEvent(new SliderEvent(SliderEvent.SLIDER_CHANGE,false,false,value));
		}
		
		
		public function getValue():int
		{
			var value:int = Math.floor((getScrollPercentage()) * (maxValue - minValue) + minValue);
			return(value);
		}
		
		public function getScrollPercentage():Number
		{
			if (inverted)
				return ((sliderButton.y / (sliderBacker.height - sliderButton.height)) );
			else	
				return (1-(sliderButton.y / (sliderBacker.height - sliderButton.height)) );
		}
		
		private function updateSliderColor():void
		{
			sliderColor1.alpha = 1 - getScrollPercentage();
			sliderColor2.alpha = getScrollPercentage();
		}
		
	}
}
