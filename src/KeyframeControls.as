package 
{
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	
	public class KeyframeControls extends Sprite
	{
		private var keyframeTimeline:KeyframeTimeline;
		
		public function KeyframeControls(keyframeTimeline:KeyframeTimeline):void
		{
			
			this.keyframeTimeline = keyframeTimeline;
			
			var prevButton:RasterButton = new RasterButton('Previous', 75, new ColorBank().blue);
			prevButton.x = 0;
			addChild(prevButton);
			prevButton.addEventListener(MouseEvent.CLICK, previousListener);
			
			var playButton:RasterButton = new RasterButton('Play', 75, new ColorBank().green);
			playButton.x = prevButton.x + prevButton.width;
			addChild(playButton);
			playButton.addEventListener(MouseEvent.CLICK, playListener);
			
			var stopButton:RasterButton = new RasterButton('Stop', 75, new ColorBank().red);
			stopButton.x = playButton.x+playButton.width;
			addChild(stopButton);
			stopButton.addEventListener(MouseEvent.CLICK, stopListener);
		
			var nextButton:RasterButton = new RasterButton('Next', 75, new ColorBank().blue);
			nextButton.x = stopButton.x+stopButton.width;
			addChild(nextButton);
			nextButton.addEventListener(MouseEvent.CLICK, nextListener);
			
			var stopSoundButton:RasterButton = new RasterButton('Stop All Sounds', 200, new ColorBank().pink);
			stopSoundButton.x = nextButton.x+nextButton.width+30;
			addChild(stopSoundButton);
			stopSoundButton.addEventListener(MouseEvent.CLICK, stopSoundListener);
		}
		private function playListener(e:MouseEvent):void
		{
			keyframeTimeline.playTimeline();
		}
		private function stopSoundListener(e:MouseEvent):void
		{
			SoundMixer.stopAll();
		}
		private function stopListener(e:MouseEvent):void
		{
			keyframeTimeline.stopTimeline();
		}
		private function previousListener(e:MouseEvent):void
		{
			keyframeTimeline.stopTimeline();
			keyframeTimeline.previousKeyframe();
		}
		private function nextListener(e:MouseEvent):void
		{
			keyframeTimeline.stopTimeline();
			keyframeTimeline.nextKeyframe();
		}
	}
	
}
