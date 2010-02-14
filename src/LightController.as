package 
{
	import flash.display.*;
	import com.makingthings.makecontroller.*;
	import caurina.transitions.*;
	import flash.events.Event;
	
	public class LightController extends Sprite
	{
		private var lightControllerArray:Array;
		private var lightValueArray:Array;
		private var objectConnection:ObjectConnection;
		private var positionKeyframe:PositionKeyframe;
		
		public function LightController(objectConnection:ObjectConnection, positionKeyframe:PositionKeyframe) 
		{
			this.objectConnection = objectConnection;
			this.positionKeyframe = positionKeyframe;
			
			this.lightValueArray = positionKeyframe.getLightValueArray();
			
			lightControllerArray = new Array();
			
			for (var i:uint = 0; i < 4; i++)
			{
				var lightValueSlider:VerticalSlider = new VerticalSlider(50, lightValueArray[i].lightValue, 0, 700, false, false, 14, 5);
				lightValueSlider.x = 5+i * 50;
				lightValueSlider.name = i.toString();
				
				lightValueSlider.tweenHolder = lightValueArray[i].lightValue;
				
				lightValueSlider.addEventListener(SliderEvent.SLIDER_CHANGE, lightValueSliderListener);
			
				addChild(lightValueSlider);
				
				lightControllerArray.push(lightValueSlider)
				
				var lightDelaySlider:VerticalSlider = new VerticalSlider(50, lightValueArray[i].lightDelay, 0, 5000, false, false, 14, 5);
				lightDelaySlider.x = lightValueSlider.x + 20;
				lightDelaySlider.name = i.toString();
				
				lightDelaySlider.addEventListener(SliderEvent.SLIDER_CHANGE, lightDelaySliderListener);
				
				addChild(lightDelaySlider);
			}
			
			
		}
		
		private function lightValueSliderListener(e:SliderEvent):void
		{
			var tweenIndex:uint = uint(e.target.name);
			lightValueArray[tweenIndex].lightValue = e.value;
			objectConnection.dispatchEvent(new LightTweenEvent(LightTweenEvent.LIGHT_ACTIVATED, tweenIndex, lightValueArray[tweenIndex]));
		}
		
		private function lightDelaySliderListener(e:SliderEvent):void
		{
			var tweenIndex:uint = uint(e.target.name);
			lightValueArray[tweenIndex].lightDelay = e.value;
		}
		
		
	}
}
