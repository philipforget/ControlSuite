package
{
	import com.makingthings.makecontroller.*;
	import flash.display.Sprite;
	import flash.events.*;
	import caurina.transitions.*;
	
	
	import flash.utils.Timer;
	import flash.media.*;
	public class KeyframeTimeline extends Sprite
	{
		private var timelineHolder:Sprite;
		private var timeline:Sprite;
		private var timelineMask:Sprite;
		private var position:Position;
		private var keyframeArray:Array;
		private var currentKeyframe:KeyframeTimelineObject;
		private var objectWidth:Number;
		private var objectConnection:ObjectConnection;
		private var keyframeObjectArray:Array;
		private var scrollbar:HorizontalScrollbar;
		private var timer:Timer;
		private var play:Boolean = false;
		private var scrollSpeed:Number = .5;
		
		private var mcConnect:McFlashConnect;
		private var board0:Board;
		private var board1:Board;
		
		private var lastLightValues:Array;
		private var video:Video;
		
		private static const timelineWidth:uint = 855;
		
		public function KeyframeTimeline(objectConnection:ObjectConnection, video:Video)
		{
			objectWidth = 330;
			
			this.objectConnection = objectConnection;
			this.video = video;
			

			
			timelineHolder = new Sprite();
			timelineHolder.graphics.beginFill(0x000000,.3);
			timelineHolder.graphics.drawRect(0, 0, timelineWidth, 240);
			addChild(timelineHolder);
			
			timeline = new Sprite();
			timelineHolder.addChild(timeline);
			
			timelineMask = new Sprite();
			timelineMask.graphics.beginFill(0xFF0000);
			timelineMask.graphics.drawRect(0, 0, timelineWidth, 240);
			timelineMask.cacheAsBitmap = true;
			
			timelineHolder.addChild(timelineMask)
			
			timeline.mask = timelineMask;
			
			var addButton:RasterButton = new RasterButton("Add New Keyframe", 150, new ColorBank().green);
			addButton.y = 260;
			addButton.x = timelineWidth-addButton.width;
			addButton.addEventListener(MouseEvent.CLICK, addNewKeyframe);
			addChild(addButton);
			
			var deleteButton:RasterButton = new RasterButton("Delete Keyframe", 150, new ColorBank().red,true);
			deleteButton.y = 260;
			deleteButton.x = addButton.x-deleteButton.width;
			deleteButton.addEventListener(MouseEvent.DOUBLE_CLICK, deleteKeyframe);
			addChild(deleteButton);
			
			scrollbar = new HorizontalScrollbar(timelineWidth);
			scrollbar.y = 245;
			scrollbar.addEventListener(ScrollEvent.SCROLLER_MOVE, scrollDragListener);
			addChild(scrollbar);
			
				//	create a new timer object with a temporary delay of 1000 miliseconds
				//	set the repeat to 0(forever) so the timer can loop even with a change in delay and keep only one listener
			timer = new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			
		}
		public function assignPosition(position:Position,playKeyframe:Boolean = false):void
		{
			currentKeyframe = null;
			this.position = position;
			keyframeArray = position.getKeyframeArray();
			populateTimeline(playKeyframe);
			if (playKeyframe)
				playTimeline();
		}
		
		public function populateTimeline(playSounds:Boolean):void
		{	
				// stop the slideshow
			stopTimeline();
			
				//	clear the timeline of display objects
			clearTimeline();
			
				//	clear the keyframeObjectArray by instantiating it
			keyframeObjectArray = new Array();
			
				//	iterate through the keyframe array
			for (var i:uint = 0; i < keyframeArray.length; i++)
			{
					//	create a new timeline object and pass to it the object connection, the keyframe corresponding to it,
					//	the position of the dependant keyframe array and the array index number
				var keyframeTimelineObject:KeyframeTimelineObject = new KeyframeTimelineObject(objectConnection, keyframeArray[i], position, i, video);
					//	push the new keyframe timeline object to the keyframeobject array to keep track of the displayobject and it's properties
				keyframeObjectArray.push(keyframeTimelineObject);
				
					//	add the event listeners to the object to listen for internal calls
				keyframeTimelineObject.addEventListener(MouseEvent.CLICK, keyframeTimelineObjectClick);
				keyframeTimelineObject.addEventListener(KeyframeEvent.SHIFT_LEFT, shiftLeftListener);
				keyframeTimelineObject.addEventListener(KeyframeEvent.SHIFT_RIGHT, shiftRightListener);
					
					//	set the position of the timelineobject based on the loop number
				keyframeTimelineObject.x = i * objectWidth;	
				
				unsetCurrentKeyframe(keyframeTimelineObject);	
				timeline.addChild(keyframeTimelineObject);
			}
			
			if (currentKeyframe == null)
			{
				setCurrentKeyframe(keyframeObjectArray[0], playSounds);
			}
			else 
			{
				var index:uint = uint(currentKeyframe.getPositionKeyframe().getKeyframeOrder());
				if (index >= keyframeArray.length)
					index--;
				setCurrentKeyframe(keyframeObjectArray[index], playSounds);
			}			
		}
		
		private function keyframeTimelineObjectClick(e:MouseEvent):void
		{
			if(e.currentTarget is KeyframeTimelineObject){
				if (currentKeyframe&&currentKeyframe != KeyframeTimelineObject(e.currentTarget))
				{
					unsetCurrentKeyframe(currentKeyframe);
				}
				if (currentKeyframe != KeyframeTimelineObject(e.currentTarget))
				{
					setCurrentKeyframe(KeyframeTimelineObject(e.currentTarget), false);
				}
			}
		}
		
		private function unsetCurrentKeyframe(keyFrameTimelineObject:KeyframeTimelineObject):void
		{
			// tell the object to graphically change and close it's active objects
			lastLightValues = keyFrameTimelineObject.getPositionKeyframe().getLightValueArray();
			keyFrameTimelineObject.unsetCurrent();
		}
		
		private function setCurrentKeyframe(keyframeTimelineObject:KeyframeTimelineObject, playSounds:Boolean):void
		{
				// if the variable current frame is not null, then unset the current keyframe
			if(currentKeyframe)
				currentKeyframe.unsetCurrent()
			
				// regardless of the unsetting operation, set the new desired keyframe to be the current keyframe
			currentKeyframe = keyframeTimelineObject;
			
				// tell the object connection that a new keyframe has been selected for the object connection and 
				// pass the  the keyframe inside the keyframe timeline object
			objectConnection.dispatchEvent(new KeyframeEvent(KeyframeEvent.KEYFRAME_SELECTED, currentKeyframe.getPositionKeyframe(), playSounds));
			
			currentKeyframe.setCurrent();
			
			updateBars();
		}
		
		private function updateBars():void
		{			
			var keyframeX:int = Math.floor(currentKeyframe.getPositionKeyframe().getKeyframeOrder() * objectWidth);
			
			var objectOverlap:int = Math.floor((timelineMask.width - objectWidth) * .5);
			
				//	set the initial goto x to center the clip directly in the timeline
			var gotoX:int = -(keyframeX - objectOverlap);
			
			
			if (gotoX > 0)
			{
				gotoX = 0;
			}
			
			else if (timeline.width < timelineMask.width)
			{
				gotoX = 0;
			}
			
			else if(gotoX<timelineMask.width-timeline.width)
			{
				gotoX = timelineMask.width - timeline.width;
			}
				// update the scroll bars based on the mask width, the content width, and the desired new position of the content as determined above
			scrollbar.updateBars(timelineMask, timeline, gotoX);
			
		}
		public function clearTimeline():void
		{
			// if the keyframeObjectArray is not null, iterate through it and remove the listeners as well as removing the 
			if (keyframeObjectArray)
			{
					// for each object in the array, assign that object to the descriptor keyframeTimelineObject and do this to it...
				for each (var keyframeTimelineObject:KeyframeTimelineObject in keyframeObjectArray)
				{
						// remove the assigned listeners before removing the object from the display
					keyframeTimelineObject.removeEventListener(MouseEvent.CLICK, keyframeTimelineObjectClick);
					keyframeTimelineObject.removeEventListener(KeyframeEvent.SHIFT_LEFT, shiftLeftListener);
					keyframeTimelineObject.removeEventListener(KeyframeEvent.SHIFT_RIGHT, shiftRightListener);
					
						// remove the object from the timelines display
					
				}
				while (timeline.numChildren)
					timeline.removeChildAt(0);
			}
		}
		
			//	listener function activated when a keyframeTimelineObject dispatches that it wants to shift left
		private function shiftLeftListener(e:KeyframeEvent):void
		{
				//	first check if the keyframeObjectArray is greater than one because you can't swap positions 
			if (keyframeObjectArray.length > 1)
			{
					//	determine the first index of the swap as passed through the keyframeevent
				var index1:uint = e.positionKeyframe.getKeyframeOrder();
				
					//	declare a new variable to hold the next index
				var index2:uint = new uint();
					
					//	if the first index is zero, swap with the last element of the keyframeObjectArray
				if (index1 == 0)
				{
					index2 = keyframeObjectArray.length - 1;
				}
				
					//	in all other cases, the next index should be one less than the current index, which
					//	corresponds to being left of of the current object
				else
				{
					index2 = index1--;
				}
				
					//	swap the keyframeTimelineObjects based on their indeces in the array
				swapTimelineObjects(index1, index2);
			}
			
		}
		
			//	listener function activated when a keyframeTimelineObject dispatches that it wants to shift right
		private function shiftRightListener(e:KeyframeEvent):void
		{
				//	first check if the keyframeObjectArray is greater than one because you can't swap positions 
			if (keyframeArray.length > 1)
			{
					//	determine the first index of the swap as passed through the keyframeevent
				var index1:uint = e.positionKeyframe.getKeyframeOrder();
				
					//	declare a new variable to hold the next index
				var index2:uint = new uint();
					
					//	if the first index corresponds as the last in the display order, then the next index should be the first
				if (index1 == keyframeArray.length - 1)
				{
					index2 = 0;
				}
					//	in all other cases, increment the index, which corresponds to the right of the current index
				else
				{
					index2 = index1++;
				}
				
					//	swap the keyframeTimelineObjects based on their indeces in the array
				swapTimelineObjects(index1, index2);
			}
		}
		
			//	swap the timeline objects based on their keyframeObjectArray index
		private function swapTimelineObjects(index1:uint, index2:uint):void
		{
				//	actually swap the timeline objects
				//	first assign two temp objects which will hold the keyframeTimelineObjects
			var keyframeTimelineObject1:KeyframeTimelineObject = KeyframeTimelineObject(keyframeObjectArray[index1]);
			var keyframeTimelineObject2:KeyframeTimelineObject = KeyframeTimelineObject(keyframeObjectArray[index2]);
				
				//	set the keyframe order inside the keyframeTimelineObject
			keyframeTimelineObject1.getPositionKeyframe().setKeyframeOrder(index2);
			keyframeTimelineObject2.getPositionKeyframe().setKeyframeOrder(index1);
			
				//	swap the timeline objects in their place in the timelineObjectArray
			keyframeObjectArray[index1] = keyframeTimelineObject2;
			keyframeObjectArray[index2] = keyframeTimelineObject1;
		
				//	calculate the new x position of the swapped objects based on the known width of the objects and their indeces
				//	instead of their old positions because if a swap is initiated before another is complete
				//	the positions will not be final and thus incorrect
			var gotoX1:Number = objectWidth * index2;
			var gotoX2:Number =  objectWidth * index1;
			
				//	swap the keyframe array entries
			keyframeArray[index1] = keyframeTimelineObject2.getPositionKeyframe();
			keyframeArray[index2] = keyframeTimelineObject1.getPositionKeyframe()
			
			keyframeTimelineObject1.updateKeyframeOrderLabel(index2);
			keyframeTimelineObject2.updateKeyframeOrderLabel(index1);
			
				//	add the tween to the keyframe objects
			
			/*TweenLite.killTweensOf(keyframeTimelineObject1);
			TweenLite.killTweensOf(keyframeTimelineObject2);
			
			TweenLite.to(keyframeTimelineObject1, 1, {x:gotoX1});
			TweenLite.to(keyframeTimelineObject2, 1, {x:gotoX2});
			*/
			Tweener.removeTweens(keyframeTimelineObject1);
			Tweener.removeTweens(keyframeTimelineObject2);
			
			Tweener.addTween(keyframeTimelineObject1, { x:gotoX1, time:1 } );
			Tweener.addTween(keyframeTimelineObject2, { x:gotoX2, time:1 } );
			
				//	tell the position that it has been edited
			position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, position));
			updateBars();
		}
		
		
			//	function that returns the length of the array to add a new keyframe
		private function getNewPositionOrder():uint
		{
			return keyframeArray.length;
		}
		
			//	function that creates a new keyframe and adds it to the array
		private function addNewKeyframe(e:MouseEvent):void
		{
				//	first check to see if a position is being edited
			if (position)
			{
				SoundMixer.stopAll();
					//	create a new positionKeyframe and populate it with blank XML
					//	Pass the variable for positionOrder based on the keyframeArray.length and the position being edited
			
				var newPositionOrder:uint = keyframeArray.length+1;
				if (currentKeyframe)
					newPositionOrder = currentKeyframe.getPositionKeyframe().getKeyframeOrder()+1;
					
				var newPositionKeyFrame:PositionKeyframe = new PositionKeyframe(new BlankKeyframeXML(newPositionOrder).keyframeXMLList, position);
		
				newPositionKeyFrame.setServoProperties(keyframeArray[newPositionOrder-1].getServoProperties());
				newPositionKeyFrame.setLightProperites(keyframeArray[newPositionOrder-1].getLightProperties());
				
					//	Add the new positionKeyframe to the array
				keyframeArray.splice(newPositionOrder, 0, newPositionKeyFrame);
			
				for (var i:uint = 0; i < keyframeArray.length; i++)
				{
					keyframeArray[i].setKeyframeOrder(i);
				}
				
				populateTimeline(false);
					// dispatch a position edited event to the position object
				position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, position));
			}
				
		}
		
		private function deleteKeyframe(e:MouseEvent):void
		{
			if (currentKeyframe&&keyframeArray.length>1)
			{
				SoundMixer.stopAll();
				var currentIndex:uint = currentKeyframe.getPositionKeyframe().getKeyframeOrder();
				
				keyframeArray.splice(currentIndex, 1);
					
				
				for (var i:uint = 0; i < keyframeArray.length; i++)
					keyframeArray[i].setKeyframeOrder(i);
				
					position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, position));
				objectConnection.dispatchEvent(new KeyframeEvent(KeyframeEvent.KEYFRAME_DELETED, currentKeyframe.getPositionKeyframe()));
				
				unsetCurrentKeyframe(currentKeyframe);
				
				populateTimeline(false);
			}
		}
		
			// listen for the scrollbar to dispatch the event that it has been dragged and set the x to match
		private function scrollDragListener(e:ScrollEvent):void
		{
			var scrollValue:int = Math.floor( (timeline.width - timelineMask.width) * -e.value);
			Tweener.removeTweens(timeline);
			Tweener.addTween(timeline, { x:scrollValue, time:scrollSpeed } );
		}
		
			//	function to call the next keyframe as the current frame
		public function nextKeyframe(playSounds:Boolean = false):void
		{
			if (currentKeyframe&&keyframeObjectArray.length>1)
			{
				var currentKeyframeIndex:uint = uint(currentKeyframe.getPositionKeyframe().getKeyframeOrder());
				if (currentKeyframeIndex<keyframeObjectArray.length-1)
					setCurrentKeyframe(keyframeObjectArray[currentKeyframeIndex + 1],playSounds);
				else
					setCurrentKeyframe(keyframeObjectArray[0], playSounds);
			}
		}
		
			//	function to call the previous keyframe as the current frame
		public function previousKeyframe():void
		{
			if (currentKeyframe&&keyframeObjectArray.length>1)
			{
				var currentKeyframeIndex:uint = uint(currentKeyframe.getPositionKeyframe().getKeyframeOrder());
				
				if (currentKeyframeIndex > 0)
				{
					setCurrentKeyframe(keyframeObjectArray[currentKeyframeIndex - 1],false);	
				}
				else
				{
					setCurrentKeyframe(keyframeObjectArray[keyframeObjectArray.length-1],false);
				}
			}
		}
		
			//	simple function called by the timeline timer to advance frames and iterate to the next frame
		private function timerListener(e:TimerEvent):void
		{
				//	call the next frame
			nextKeyframe(true);
			if(play)
				playTimeline();
			else	
				stopTimeline();
		}
		
			//	function to iterate through the timeline objects based on their delay
		public function playTimeline():void
		{
				//	once again, first check if there is a currentkeyframe, which there will be if a position is being edited
			if (currentKeyframe)
			{
					//	check to see that there is more than one object, or else theres no point in playing one frame over and over again
				if (keyframeObjectArray.length > 1)
				{
						//	create a new timer to replace the current one with a default value of 
						//	1000 and then assign the delay
					timer.delay = currentKeyframe.getPositionKeyframe().getKeyframeDelay();
					timer.start();
					setCurrentKeyframe(currentKeyframe,true);
						//	if the timeline isn't already playing, set it to play
					if(!play)
						togglePlay();
				}
				else
					setCurrentKeyframe(currentKeyframe,true);
			}
		}
		
			//	function that turns the play boolean to false and stops the timer
		public function stopTimeline():void
		{
			if (currentKeyframe)
			{
				if(timer)
					if (timer.running)
						timer.stop();
				if (play)
					togglePlay();
			}
			
		}
			//	simple function to toggle the play boolean
		private function togglePlay():void
		{
			play = !play;
		}
	}
}
