package
{
	import com.makingthings.makecontroller.Board;
	import com.makingthings.makecontroller.*;
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	import flash.media.Camera;
	import flash.media.Video;
	public class PositionEditor extends Sprite{
		
		// listens for events binded by the connection object
		private var objectConnection:ObjectConnection;
		
		private var positionLabel:PositionLabel;
		private var servoEditor:ServoEditor;
		private var keyframeTimeline:KeyframeTimeline;
		private var lightAndSoundEditor:LightAndSoundEditor;
	
		
		private var currentPosition:Position;
		
		private var mcConnect:McFlashConnect;
		private var board0:Board;
		private var board1:Board;
	
		private var camera:Camera;
		private var video:Video;
		
		public function PositionEditor(objectConnection:ObjectConnection, boardOptions:XMLList, servoOptions:XMLList):void
		{
			// declare the position connection and listen for the events
			this.objectConnection = objectConnection;
			objectConnection.addEventListener(PositionEvent.POSITION_SELECTED, positionSelectedListener);
			
			objectConnection.addEventListener(KeyframeEvent.KEYFRAME_DISPATCH, dispatchListener);
			
			
			mcConnect = new McFlashConnect();
			//mcConnect.connect();
	
			
			board0 = new Board(boardOptions.board0.type, boardOptions.board0.location);
			board1 = new Board(boardOptions.board1.type, boardOptions.board1.location);
			
			
			positionLabel = new PositionLabel();
			addChild(positionLabel);
			
			servoEditor = new ServoEditor(objectConnection, mcConnect, board0, board1, servoOptions);
			servoEditor.y = 25;
			servoEditor.mouseChildren = false;
			servoEditor.mouseEnabled = false;
			addChild(servoEditor);
			
			lightAndSoundEditor = new LightAndSoundEditor(objectConnection, mcConnect, board0, board1);
			addChild(lightAndSoundEditor);
			lightAndSoundEditor.x = servoEditor.width+servoEditor.x+5;
			lightAndSoundEditor.y = servoEditor.y;
			
			//if(GlobalVars.vars.keyframeCamera.length)
				//camera = Camera.getCamera(GlobalVars.vars.keyframeCamera);
				camera = Camera.getCamera();
				
			video = new Video(320, 240);
			video.attachCamera(camera);
			video.scaleX = .75;
			video.scaleY = .75;
			video.rotation = 90;
			addChild(video);
			
			keyframeTimeline = new KeyframeTimeline(objectConnection, video);
			keyframeTimeline.y = 180;
			addChild(keyframeTimeline);
			
			video.x = keyframeTimeline.width + video.width + 5;
			video.y = keyframeTimeline.y;
			
			var keyframeControls:KeyframeControls = new KeyframeControls(keyframeTimeline);
			keyframeControls.y = 440;
			addChild(keyframeControls);
		}
	
		
		private function dispatchListener(e:KeyframeEvent):void
		{
			trace('dispatched');
		}
		
		private function positionSelectedListener(e:PositionEvent):void
		{
			if (e.position is Position)
				setCurrentPosition(e.position, e.playPosition);
		}
		
		
		private function setCurrentPosition(position:Position, playPosition:Boolean =false):void
		{
			if (currentPosition)
				clearCurrentPosition();
			servoEditor.mouseEnabled = true;
			servoEditor.mouseChildren = true;
			positionLabel.setPosition(position);
			currentPosition = position;
			positionLabel.setLabel(currentPosition.getPositionName(), currentPosition.getPositionColor());
			currentPosition.addEventListener(PositionEvent.POSITION_TITLE_CHANGED, setPositionLabel);
			currentPosition.addEventListener(PositionEvent.POSITION_DELETED, checkIfCurrentDeleted);
			keyframeTimeline.assignPosition(currentPosition,playPosition);
		}
		
		public function getCurrentPostition():Position
		{
			if (currentPosition)
				return(currentPosition)
			else
				return(null);
		}
		
		public function clearCurrentPosition(e:Event = null):void
		{
			servoEditor.mouseEnabled = false;
			servoEditor.mouseChildren = false;
			currentPosition.removeEventListener(PositionEvent.POSITION_TITLE_CHANGED, setPositionLabel);
			currentPosition.removeEventListener(PositionEvent.POSITION_DELETED, checkIfCurrentDeleted);
			currentPosition = null;
			keyframeTimeline.clearTimeline();
			positionLabel.clearLabel();
		}
		
		public function checkIfCurrentDeleted(e:PositionEvent):void
		{
			if (e.position.getPositionID() == currentPosition.getPositionID())
				clearCurrentPosition();
		}
		
		public function setPositionLabel(e:Event):void
		{
			positionLabel.setLabel(currentPosition.getPositionName(), currentPosition.getPositionColor());
		}
		
	}
}
