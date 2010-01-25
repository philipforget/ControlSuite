package 
{
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.*;
	
	public class PositionCallBank extends Sprite
	{
		private var objectConnection:ObjectConnection;
		private var positionCallObject:PositionCallObject;
		private var positionBank:PositionBank;
		
		private var positionCallBankObjectArray:Array;
		
		private const positionCallBankWidth:uint = 1040;
		
		private const objectWidth:uint = 180;
		
		private var positionBankMask:Sprite;
		private var positionBankHolder:Sprite;
		private var positionBankObject:Sprite;
		
		private var scrollBar:HorizontalScrollbar;
		
		private var currentCallObject:PositionCallBankObject;
		
		private var positionCallGrid:PositionCallGrid;
		
		public function PositionCallBank(objectConnection:ObjectConnection, positionBank:PositionBank, positionCallGrid:PositionCallGrid) 
		{
			this.objectConnection = objectConnection;
			this.positionBank = positionBank;
			this.positionCallGrid = positionCallGrid;
			objectConnection.addEventListener(PositionCallEvent.OBJET_FOCUS, postionCallListener);
			init();
		}
		
		private function init():void
		{
			var addCurrentButton:RasterButton = new RasterButton('Add Current Position', 150, new ColorBank().green);
			addCurrentButton.x = positionCallBankWidth-addCurrentButton.width;
			addCurrentButton.y = 260;
			addChild(addCurrentButton);
			addCurrentButton.addEventListener(MouseEvent.CLICK, addCurrentListener);
			
			var removeCurrentButton:RasterButton = new RasterButton('Remove Position', 150, new ColorBank().red,true);
			removeCurrentButton.x = addCurrentButton.x-removeCurrentButton.width;
			removeCurrentButton.y = addCurrentButton.y;
			addChild(removeCurrentButton);
			removeCurrentButton.addEventListener(MouseEvent.DOUBLE_CLICK, removeCurrentListener);
			
			positionBankHolder = new Sprite();
			positionBankHolder.graphics.beginFill(0x000000, .25);
			positionBankHolder.graphics.drawRect(0, 0, positionCallBankWidth, 240);
			
			positionBankObject = new Sprite();
			positionBankMask = new Sprite();
			
			positionBankMask.graphics.beginFill(0xFF0000, 1);
			positionBankMask.graphics.drawRect(0, 0, positionCallBankWidth, 240);
			
			positionBankHolder.addChild(positionBankObject);
			positionBankHolder.addChild(positionBankMask);
			positionBankObject.mask = positionBankMask;
			
			addChild(positionBankHolder);
			
			scrollBar = new HorizontalScrollbar(positionCallBankWidth);
			scrollBar.y = 245;
			addChild(scrollBar);
			scrollBar.addEventListener(ScrollEvent.SCROLLER_MOVE, scrollBank);
			
			var prevButton:RasterButton = new RasterButton('Previous', 75, new ColorBank().blue);
			prevButton.y = 260;
			addChild(prevButton);
			prevButton.addEventListener(MouseEvent.CLICK, previousObjectListener);
			
			var nextButton:RasterButton = new RasterButton('Next', 75, new ColorBank().green);
			nextButton.x = prevButton.x + prevButton.width;
			nextButton.y = prevButton.y;
			addChild(nextButton);
			nextButton.addEventListener(MouseEvent.CLICK, nextObjectListener);
			
			var resetButton:RasterButton = new RasterButton('Reset Current Count', 200, new ColorBank().pink);
			resetButton.x = nextButton.x + nextButton.width+70;
			resetButton.y = nextButton.y;
			resetButton.addEventListener(MouseEvent.CLICK, resetButtonListener);
			addChild(resetButton);
			
			var resetAllButton:RasterButton = new RasterButton('Reset All Counts', 200, new ColorBank().red,true);
			resetAllButton.x = resetButton.x + resetButton.width+50;
			resetAllButton.y = resetButton.y;
			
			resetAllButton.addEventListener(MouseEvent.DOUBLE_CLICK, resetAllCounts);
			
			addChild(resetAllButton);
			
			
			
		}
		
		private function resetAllCounts(e:Event):void
		{
			if (currentCallObject)
			{
				dispatchEvent(new PositionCallEvent(PositionCallEvent.RESET_COUNTS));
				setCurrentCallObject(positionCallBankObjectArray[0]);
			}
			
		}
		
		private function scrollBank(e:ScrollEvent):void
		{
			Tweener.addTween(positionBankObject, { x: -Math.floor((positionBankObject.width - positionBankMask.width) * e.value), time:.5 } );
		}
		private function postionCallListener(e:PositionCallEvent):void
		{
			this.positionCallObject = e.positionCallObject;
			currentCallObject = null;
			populateBank(true,e.play,positionCallObject.getCallCount());
		}
		
		private function populateBank(updateX:Boolean = true,playCalledPosition:Boolean=false, callIndex:int = -2):void
		{
			clearBank();
			
			positionCallBankObjectArray = new Array();
			
			var positionCallArray:Array = positionCallObject.getPositionCallArray();
			
			for (var i:uint = 0; i < positionCallArray.length; i++)
			{
				var positionCallBankObject:PositionCallBankObject = new PositionCallBankObject(positionCallArray[i],i);
				positionCallBankObject.addEventListener(PositionCallEvent.POSITION_SELECTED, setCurrentListener);
				positionCallBankObject.addEventListener(PositionCallEvent.SHIFT_LEFT, shiftLeftListener);
				positionCallBankObject.addEventListener(PositionCallEvent.SHIFT_RIGHT, shiftRightListener);
				
				positionCallBankObject.x = objectWidth * i;
				positionBankObject.addChild(positionCallBankObject);
				positionCallBankObjectArray.push(positionCallBankObject);
			}
			scrollBar.updateBars(positionBankMask, positionBankObject,positionBankObject.x);
			
			if (positionCallBankObjectArray.length)
			{
				if (callIndex != -2)
				{
					setCurrentCallObject(positionCallBankObjectArray[callIndex],playCalledPosition);
				}
				else if (currentCallObject == null)
				{
					setCurrentCallObject(positionCallBankObjectArray[0]);
					setCurrentCallObject(positionCallBankObjectArray[0]);
				}
				else 
				{
					var index:uint = uint(currentCallObject.getIndex());
					if (index >= positionCallBankObjectArray.length)
						index--;
					setCurrentCallObject(positionCallBankObjectArray[index]);
				}	
			}
		}
		private function setCurrentListener(e:PositionCallEvent):void
		{
			setCurrentCallObject(e.positionCallBankObject,true);
		}
		private function unsetCurrentCallObject():void
		{
			if(currentCallObject)
				currentCallObject.unsetCurrent();
		}
		private function setCurrentCallObject(positionCallBankObject:PositionCallBankObject, playPosition:Boolean = false):void
		{
			var callIndex:uint = positionCallBankObject.getIndex();
			
			if (callIndex < positionCallBankObjectArray.length-1)
						positionCallObject.setCallCount(callIndex + 1);
					else
						positionCallObject.setCallCount(0);
			
			unsetCurrentCallObject();
			currentCallObject = positionCallBankObject;
			currentCallObject.setCurrent();
			objectConnection.dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, currentCallObject.getPosition(),playPosition));
			updateBars();
		}
		
		private function updateBars():void
		{
			var objectX:int = Math.floor(currentCallObject.getIndex() * objectWidth);
			
			var objectOverlap:int = 100;
				
			var gotoX:Number = -objectX+(positionBankMask.width-(objectWidth)-(objectOverlap));
			
			if (positionBankMask.width>positionBankObject.width||currentCallObject.getIndex()==0)
			{
				gotoX = 0;
			}
			else if (gotoX < -(positionBankObject.width - positionBankMask.width))
			{
				// set the gotoX to be the exactly the x position of the current frame plus the distance between
				// the masks width and the objects width which places it at the rightmost edge of the timeline mask
				gotoX = Math.floor(-objectX + (positionBankMask.width - objectWidth));
			}
			if (gotoX > 0)
				gotoX = 0;
			if (gotoX != positionBankObject.x - objectOverlap)
			{
				gotoX = positionBankObject.x;
			}
				// update the scroll bars based on the mask width, the content width, and the desired new position of the content as determined above
			scrollBar.updateBars(positionBankMask, positionBankObject, gotoX);
			
		}
		
		private function addCurrentListener(e:MouseEvent):void
		{
			if (positionBank.getCurrentPosition()&&positionCallObject)
			{
				var tempPosition:Position = positionBank.getCurrentPosition().getPosition();
				positionCallObject.getPositionCallArray().push(tempPosition);
				populateBank(false);
				//tempPosition.addEventListener(PositionEvent.POSITION_DELETED, positionDeleteListener);
				positionCallObject.dispatchEvent(new PositionCallEvent(PositionCallEvent.POSITION_ADDED, positionCallObject));
			}
		}
		
		private function positionDeleteListener(e:PositionEvent):void
		{
			removePositionCallsById(e.position.getPositionID());
		}
		
		private function removePositionCallsById(id:uint):void
		{
			var tempArray:Array = positionCallObject.getPositionCallArray();
			var removeArray:Array = new Array();
			for (var i:uint = 0; i< tempArray.length; i++)
			{
				if (id == (tempArray[i].getPositionID()))
				{
					removeArray.push(i);
				}
			}
			while (removeArray.length)
				tempArray.splice(removeArray.pop(), 1);
			populateBank();
		}
		
		private function clearBank():void
		{
			if (positionBankObject.numChildren)
				while (positionBankObject.numChildren)
					positionBankObject.removeChildAt(0);
		}
		
		
		
		private function shiftLeftListener(e:PositionCallEvent):void
		{
				//	first check if the keyframeObjectArray is greater than one because you can't swap positions 
			if (positionCallBankObjectArray.length > 1)
			{
					//	determine the first index of the swap as passed through the keyframeevent
				var index1:uint = e.positionCallBankObject.getIndex();
				
					//	declare a new variable to hold the next index
				var index2:uint = new uint();
					
					//	if the first index is zero, swap with the last element of the keyframeObjectArray
				if (index1 == 0)
				{
					index2 =positionCallBankObjectArray.length - 1;
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
		private function shiftRightListener(e:PositionCallEvent):void
		{
				//	first check if the keyframeObjectArray is greater than one because you can't swap positions 
			if (positionCallBankObjectArray.length > 1)
			{
					//	determine the first index of the swap as passed through the keyframeevent
				var index1:uint = e.positionCallBankObject.getIndex();
				
					//	declare a new variable to hold the next index
				var index2:uint = new uint();
					
					//	if the first index corresponds as the last in the display order, then the next index should be the first
				if (index1 == positionCallBankObjectArray.length - 1)
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
			var positionCallBankObject1:PositionCallBankObject = PositionCallBankObject(positionCallBankObjectArray[index1]);
			var positionCallBankObject2:PositionCallBankObject = PositionCallBankObject(positionCallBankObjectArray[index2]);
				
				//	set the keyframe order inside the keyframeTimelineObject
			positionCallBankObject1.setIndex(index2);
			positionCallBankObject2.setIndex(index1);
			
				//	swap the timeline objects in their place in the timelineObjectArray
			positionCallBankObjectArray[index1] = positionCallBankObject2;
			positionCallBankObjectArray[index2] = positionCallBankObject1;
		
				//	calculate the new x position of the swapped objects based on the known width of the objects and their indeces
				//	instead of their old positions because if a swap is initiated before another is complete
				//	the positions will not be final and thus incorrect
			var gotoX1:Number = objectWidth * index2;
			var gotoX2:Number =  objectWidth * index1;
			
				//	swap the keyframe array entries
			var positionCallArray:Array = positionCallObject.getPositionCallArray();
			var tempObject:* = positionCallArray[index1];
			positionCallArray[index1] = positionCallArray[index2];
			positionCallArray[index2] = tempObject;
			
			//positionCallArray[index1] = keyframeTimelineObject2.getPositionKeyframe();
			//positionCallArray[index2] = keyframeTimelineObject1.getPositionKeyframe()
			
				//	add the tween to the keyframe objects
			
			
			Tweener.addTween(positionCallBankObject1, { x:gotoX1, time:1 } );
			Tweener.addTween(positionCallBankObject2, { x:gotoX2, time:1 } );
			
				//	tell the position that it has been edited
			updateBars();
		}
		
		private function nextObjectListener(e:Event = null):void
		{
			if (currentCallObject&&positionCallBankObjectArray.length>1)
			{
				var currentObjectIndex:uint = currentCallObject.getIndex();
				if (currentObjectIndex<positionCallBankObjectArray.length-1)
					setCurrentCallObject(positionCallBankObjectArray[currentObjectIndex + 1]);
				else
					setCurrentCallObject(positionCallBankObjectArray[0]);
			}
		}
		
		private function previousObjectListener(e:Event = null):void
		{
			if (currentCallObject&&setCurrentCallObject.length>1)
			{
				var currentObjectIndex:uint = currentCallObject.getIndex();
				
				if (currentObjectIndex > 0)
				{
					setCurrentCallObject(positionCallBankObjectArray[currentObjectIndex - 1]);	
				}
				else
				{
					setCurrentCallObject(positionCallBankObjectArray[positionCallBankObjectArray.length-1]);
				}
			}
		}
		private function advanceFrame(e:Event = null):void
		{
			
		}
		
		private function removeCurrentListener(e:MouseEvent):void
		{
			if (currentCallObject)
			{
				positionCallObject.getPositionCallArray().splice([currentCallObject.getIndex()], 1);
				populateBank(true);
			}
		}
		private function resetButtonListener(e:Event):void
		{
			if (positionCallObject)
			{
				positionCallObject.resetCallCount();
				setCurrentCallObject(positionCallBankObjectArray[0]);
			}
		}
	}
}
