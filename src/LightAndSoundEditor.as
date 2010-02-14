package 
{
	import com.makingthings.makecontroller.Board;
	import com.makingthings.makecontroller.McFlashConnect;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.*;

	

	public class LightAndSoundEditor extends Sprite
	{
		private var objectConnection:ObjectConnection;
		private var mcConnect:McFlashConnect;
		private var board0:Board;
		private var board1:Board;
		
		private var positionKeyframe:PositionKeyframe;
		
		private static const menuWidth:uint = 235;
		
		private var volumeSlider:VerticalSlider;
		private var panSlider:VerticalSlider;
		private var toggleArray:Array;
		private var clearsSoundsToggle:ToggleButton;
		private var soundNameLabel:TextField;
		
		private var browseFileReferance:FileReference;
		
		public function LightAndSoundEditor(objectConnection:ObjectConnection, mcConnect:McFlashConnect, board0:Board, board1:Board) 
		{
			this.objectConnection = objectConnection;
			this.mcConnect = mcConnect;
			this.board0 = board0;
			this.board1 = board1;
			
			objectConnection.addEventListener(KeyframeEvent.KEYFRAME_SELECTED, keyframeSelectionListener);
			
			init();
		}
		
		private function init():void
		{
			
			graphics.beginFill(0x000000, .35);
			graphics.drawRect(0, 0, menuWidth, 150);
			
			var buttonFormat:TextFormat = new TextFormat();
			buttonFormat.font = 'Ahron';
			buttonFormat.align = TextFormatAlign.LEFT;
			buttonFormat.size = 14;
			buttonFormat.color = 0xFFFFFF;
			
			var inputFormat:TextFormat = new TextFormat();
			inputFormat.font = 'Ahron';
			inputFormat.align = TextFormatAlign.LEFT;
			inputFormat.size = 14;
			inputFormat.color = new ColorBank().blue;
			
			var lightLabel:TextField = new TextField();
			lightLabel.embedFonts = true;
			lightLabel.x = 5;
			lightLabel.y = 5;
			lightLabel.autoSize = TextFieldAutoSize.LEFT;
			lightLabel.defaultTextFormat = buttonFormat;
			lightLabel.text = 'Lights';
			addChild(lightLabel);
			
			
			toggleArray = new Array();
			for (var i:uint = 0; i < 8; i++)
			{
				var toggleButton:ToggleButton = new ToggleButton();
				toggleButton.name = i.toString();
				toggleButton.x = (i * 25)+30;
				toggleButton.y = 30;
				addChild(toggleButton);
				toggleButton.addEventListener(ToggleEvent.TOGGLE, toggleListener);
				toggleArray.push(toggleButton);
			}
			
			var soundLabel:TextField = new TextField();
			soundLabel.embedFonts = true;
			soundLabel.x = 5;
			soundLabel.y = toggleArray[0].y+10;
			soundLabel.autoSize = TextFieldAutoSize.LEFT;
			soundLabel.defaultTextFormat = buttonFormat;
			soundLabel.text = 'Sound';
			addChild(soundLabel);
			
			var volumeLabel:TextField = new TextField();
			volumeLabel.embedFonts = true;
			volumeLabel.x = 5;
			volumeLabel.y = soundLabel.y + 20;
			volumeLabel.autoSize = TextFieldAutoSize.LEFT;
			volumeLabel.defaultTextFormat = buttonFormat;
			volumeLabel.text = 'Vol';
			addChild(volumeLabel);
			
			var panLabel:TextField = new TextField();
			panLabel.embedFonts = true;
			panLabel.x = .5*(menuWidth-10);
			panLabel.y = volumeLabel.y;
			panLabel.autoSize = TextFieldAutoSize.LEFT;
			panLabel.defaultTextFormat = buttonFormat;
			panLabel.text = 'Pan';
			addChild(panLabel);
			
			
			volumeSlider = new VerticalSlider(panLabel.x - (volumeLabel.x + volumeLabel.width) - 10, 0, 0, 100, true, false, 10, 5);
			volumeSlider.setScrollValue(100, true);
			volumeSlider.x = volumeLabel.x + volumeLabel.width+5;
			volumeSlider.y = volumeLabel.y+12;
			volumeSlider.rotation = -90;
			addChild(volumeSlider);
			
			volumeSlider.addEventListener(SliderEvent.SLIDER_CHANGE, volumeSliderListener);
			
			panSlider = new VerticalSlider(menuWidth - (panLabel.width+panLabel.x) - 10, 0, -100, 100, true, false, 10, 5);
			panSlider.setScrollValue(0, true);
			panSlider.x = panLabel.x + panLabel.width+5;
			panSlider.y = volumeLabel.y+12;
			panSlider.rotation = -90;
			addChild(panSlider);
			
			panSlider.addEventListener(SliderEvent.SLIDER_CHANGE, panSliderListener);
			
			
			var clearsSounds:TextField = new TextField();
			clearsSounds.embedFonts = true;
			clearsSounds.x = 5;
			clearsSounds.y = volumeLabel.y+20;
			clearsSounds.autoSize = TextFieldAutoSize.LEFT;
			clearsSounds.defaultTextFormat = buttonFormat;
			clearsSounds.text = 'Clear sounds before playing:';
			addChild(clearsSounds);
			
			clearsSoundsToggle = new ToggleButton(false);
			clearsSoundsToggle.x  = clearsSounds.x + clearsSounds.width+15;
			clearsSoundsToggle.y = clearsSounds.y+8;
			addChild(clearsSoundsToggle);
			clearsSoundsToggle.addEventListener(ToggleEvent.TOGGLE, clearSoundListener);
			
			var soundFileLabel:TextField = new TextField();
			soundFileLabel.embedFonts = true;
			soundFileLabel.x = 5;
			soundFileLabel.y = clearsSounds.y+20;
			soundFileLabel.autoSize = TextFieldAutoSize.LEFT;
			soundFileLabel.defaultTextFormat = buttonFormat;
			soundFileLabel.text = 'Sound File:';
			addChild(soundFileLabel);
			
			soundNameLabel = new TextField();
		
			soundNameLabel.x = soundFileLabel.width+soundFileLabel.x-3;
			soundNameLabel.y = clearsSounds.y+20;
			soundNameLabel.width = menuWidth - (soundFileLabel.width + soundFileLabel.x) - 2;
			soundNameLabel.height = 30;
			soundNameLabel.embedFonts = true;
			soundNameLabel.defaultTextFormat = inputFormat;
			soundNameLabel.text = '';
			addChild(soundNameLabel);
			
			
			var browseButton:RasterButton = new RasterButton('Browse', menuWidth / 4, new ColorBank().blue);
			browseButton.y =120;
			addChild(browseButton);
			
			var playButton:RasterButton = new RasterButton('Play', menuWidth / 4, new ColorBank().green);
			playButton.y = 120;
			playButton.x = browseButton.x + browseButton.width;
			addChild(playButton);
			
			playButton.addEventListener(MouseEvent.CLICK, previewSound);
			
			var stopButton:RasterButton = new RasterButton('Stop', menuWidth / 4, new ColorBank().pink);
			stopButton.y = 120;
			stopButton.x = playButton.x + playButton.width;
			addChild(stopButton);
			
			stopButton.addEventListener(MouseEvent.CLICK, stopSounds);
			
			var clearButton:RasterButton = new RasterButton('Clear', menuWidth / 4, new ColorBank().red,true);
			clearButton.y = 120;
			clearButton.x = stopButton.x + stopButton.width;
			addChild(clearButton);
			clearButton.addEventListener(MouseEvent.DOUBLE_CLICK, clearSoundFile);
			
			browseFileReferance = new FileReference();
			
			browseButton.addEventListener(MouseEvent.CLICK, browseListener);
		}
		
		private function stopSounds(e:Event = null):void
		{
			SoundMixer.stopAll();
		}
		private function previewSound(e:Event):void
		{
			SoundMixer.stopAll();
			playSound();
		}
		private function playSound():void
		{
			if (positionKeyframe)
			{
				if (positionKeyframe.getKeyframeClearsSounds())
						stopSounds();
						
				var songString:String = positionKeyframe.getKeyframeSound();
				if (songString.length)
				{
					var sound:Sound = new Sound(new URLRequest('../sound/' + songString));
					sound.addEventListener(IOErrorEvent.IO_ERROR, soundLoadError);
					var soundChannel:SoundChannel = sound.play();
					var soundTransform:SoundTransform = new SoundTransform(positionKeyframe.getKeyframeSoundVolume()/100, positionKeyframe.getKeyframeSoundPan()/100);
					soundChannel.soundTransform = soundTransform;
				}
			}
		}
		
		private function soundLoadError(e:Event):void
		{
			
		}
		private function clearSoundFile(e:Event):void
		{
			if (positionKeyframe)
			{
				positionKeyframe.setKeyframeSound('');
				soundNameLabel.text = '';
			}
		}
		
		private function browseListener(e:Event):void
		{
			browseFileReferance.browse();
			browseFileReferance.addEventListener(Event.CANCEL, clearBrowseListeners);
			browseFileReferance.addEventListener(Event.SELECT, selectListener);
		}
		private function clearBrowseListeners(e:Event):void
		{
			browseFileReferance.removeEventListener(Event.CANCEL, clearBrowseListeners);
			browseFileReferance.removeEventListener(Event.SELECT, selectListener);
		}
		private function selectListener(e:Event):void
		{
			if (positionKeyframe)
			{
				positionKeyframe.setKeyframeSound(browseFileReferance.name);
				soundNameLabel.text = browseFileReferance.name;
			}
		}
		private function clearSoundListener(e:ToggleEvent):void
		{
			if (positionKeyframe)
			{
				
				positionKeyframe.setKeyframeClearsSounds(e.toggleState);
			}
		}
		private function volumeSliderListener(e:SliderEvent):void
		{
			if (positionKeyframe)
			{
				
				positionKeyframe.setKeyframeSoundVolume(e.value);
				var soundTransform:SoundTransform = new SoundTransform(positionKeyframe.getKeyframeSoundVolume()/100, positionKeyframe.getKeyframeSoundPan()/100);
				SoundMixer.soundTransform = soundTransform;
			}
			
		}
		private function panSliderListener(e:SliderEvent):void
		{
			if (positionKeyframe)
			{
				positionKeyframe.setKeyframeSoundPan(e.value);
				var soundTransform:SoundTransform = new SoundTransform(positionKeyframe.getKeyframeSoundVolume()/100, positionKeyframe.getKeyframeSoundPan()/100);
				SoundMixer.soundTransform = soundTransform;
				
			}
		}
		
		private function toggleListener(e:ToggleEvent):void
		{
			if (positionKeyframe)
			{
				positionKeyframe.setkeyframeLightValue(e.target.name, e.toggleState);
				
				var index:uint = e.target.name;
				var board:Board = board0;
				if (index > 3)
				{
					board = board1;
					index = index - 4;
				}
				mcConnect.sendToBoard('/digitalout/' + index + '/value', [int(e.toggleState)], board);
			}
		}
		public function populateEditor(positionKeyframe:PositionKeyframe, playSounds:Boolean):void
		{
			this.positionKeyframe = positionKeyframe;
			var tempLightArray:Array = positionKeyframe.getLightValueArray();
			for ( var i:uint = 0; i < tempLightArray.length; i++)
			{
				var tempState:Boolean = false;
				if (tempLightArray[i] == 1)
					tempState = true;
				toggleArray[i].setToggleState(tempState);
			}
			volumeSlider.setScrollValue(positionKeyframe.getKeyframeSoundVolume(), false);
			panSlider.setScrollValue(positionKeyframe.getKeyframeSoundPan(), false);
			clearsSoundsToggle.setToggleState(positionKeyframe.getKeyframeClearsSounds());
			soundNameLabel.text = positionKeyframe.getKeyframeSound();
			
			if (playSounds)
				playSound();
		}
		
		private function keyframeSelectionListener(e:KeyframeEvent):void
		{
			populateEditor(e.positionKeyframe, e.playSounds);
		}
		
	}
}
