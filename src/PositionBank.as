package
{
	import caurina.transitions.*;
	import flash.display.*
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import flash.net.*;
	
	public class PositionBank extends Sprite{
		private var currentPosition:PositionBankObject;
		private var loadFileReferance:FileReference;
		
		private var saveFileReferance:FileReference;
		
		private var objectConnection:ObjectConnection;
		
		private var positionsArray:Array;
		private var positionsIDArray:Array;
		private var positionBankHolder:Sprite;
		private var positionBank:Sprite;
		private var positionBankMask:Sprite;
		private var verticalScrollBar:VerticalScrollbar;
		private var positionBankHeight:int = 410;
		private var positionBankWidth:int = 305;
		private var currentScroll:Number = 0;
		private var colorBank:ColorBank;
		
		private static const objectHeight:uint = 110;
		
		public function PositionBank(objectConnect:ObjectConnection):void
		{			
			
			this.objectConnection = objectConnect;
			positionsArray = new Array();
			positionsIDArray = new Array();
			
			colorBank = new ColorBank();
			
			
			// Create the position bank buttons!
			var loadButton:RasterButton = new RasterButton("Load Library", (positionBankWidth+15)/2, colorBank.blue);
			loadButton.addEventListener(MouseEvent.CLICK, loadPositionBank);
			addChild(loadButton);
			
			var saveButton:RasterButton = new RasterButton("Save Library", (positionBankWidth+15)/2, colorBank.green);
			saveButton.addEventListener(MouseEvent.CLICK, savePositionBank);
			saveButton.x = (positionBankWidth+15)/2;
			addChild(saveButton);
			
			
			var newPositionButton:RasterButton = new RasterButton("Add New Position", (positionBankWidth+15)/2, colorBank.green);
			newPositionButton.addEventListener(MouseEvent.CLICK, addNewPosition);
			newPositionButton.y = positionBankHeight + 40;
			newPositionButton.x = (positionBankWidth + 15) / 2;
			
			addChild(newPositionButton);
			
			var deleteButton:RasterButton = new RasterButton("Delete Position", (positionBankWidth+15)/2, colorBank.red,true);
			deleteButton.y = positionBankHeight+40;
			
			
			addChild(deleteButton);
			
			deleteButton.addEventListener(MouseEvent.DOUBLE_CLICK, deleteCurrentPosition);
			
			loadFileReferance = new FileReference();
			saveFileReferance = new FileReference();
			
			verticalScrollBar = new VerticalScrollbar(positionBankHeight);
			verticalScrollBar.x = positionBankWidth + 5;
			verticalScrollBar.y = 35;			
			addChild(verticalScrollBar);
			verticalScrollBar.addEventListener(ScrollEvent.SCROLLER_MOVE, scrollListener);
			
			positionBankHolder = new Sprite;
			positionBankHolder.y = 35;
			
			
			positionBankHolder.graphics.beginFill(0x000000, .25);
			positionBankHolder.graphics.drawRect(0, 0, positionBankWidth, positionBankHeight);
			
			addChild(positionBankHolder);
			
			positionBankMask = new Sprite;
			positionBank = new Sprite;
			
			positionBankMask.graphics.beginFill(0x000000);
			positionBankMask.graphics.drawRect(0, 0, positionBankWidth, positionBankHeight);
			
			positionBankHolder.addChild(positionBank);
			positionBankHolder.addChild(positionBankMask);
			positionBank.mask = positionBankMask;
			
			objectConnection.addEventListener(PositionEvent.POSITION_ADDED, newPostionListener);
			
		}
		
		
		private function createPositionsArray(positionBankXML:XML):void
		{
			
			var positionList:XMLList = positionBankXML.position;
			
			for (var i:uint = 0; i < positionList.length(); i++)
			{
				var position:Position = new Position(new XMLList(positionList[i]));
				var positionObject:PositionBankObject = new PositionBankObject(objectConnection,position,positionBankWidth);
				positionsArray.push(positionObject);
				positionsIDArray.push(position.getPositionID());
			}
			if(positionList.length)
				drawBank();
		}
		
		
		private function drawBank():void
		{
			clearPositionBank();
			
			// Populate the position bank with the array of position bank objects
			for (var i:uint = 0; i < positionsArray.length; i++)
			{
				var tempClip:Sprite =  positionsArray[i];
				positionBank.addChild(positionsArray[i]);
				tempClip.y = i * positionsArray[i].height;
				tempClip.name = i.toString();
				if(!tempClip.hasEventListener(MouseEvent.MOUSE_DOWN))
					tempClip.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			}
			
			// Mask the position bank
			
			
			
			if (positionsArray.length)
			{
				if (currentPosition == null)
				{
					setCurrentPosition(positionsArray[0]);
				}
				else 
				{
					var index:uint = uint(currentPosition.name);
					if (index >= positionsArray.length)
						index--;
					setCurrentPosition(positionsArray[index]);
				}	
			}
			// create the scroll ba
		}
		
		private function updateBars():void
		{			
			
			var objectY:int = Math.floor(uint(currentPosition.name) * objectHeight);
		
			var objectOverlap:int = Math.floor((positionBankMask.height - objectHeight) * .5);
				//	set the initial goto x to center the clip directly in the timeline
			var gotoY:int = -(objectY - objectOverlap);
			
			if (gotoY > 0)
			{
				gotoY = 0;
			}
			
			else if (positionBank.height < positionBankMask.height)
			{
				gotoY = 0;
			}
			
			else if(gotoY<positionBankMask.height-positionBank.height)
			{
				gotoY = positionBankMask.height - positionBank.height;
			}
			
				// update the scroll bars based on the mask width, the content width, and the desired new position of the content as determined above
			verticalScrollBar.updateBars(positionBankMask, positionBank, gotoY);
			
		}
		
		
		private function mouseDownListener(e:MouseEvent):void
		{
			if (e.target.name != 'scrubber')
				setCurrentPosition(PositionBankObject(e.currentTarget)); 
		}
		
		private function loadPositionBank(e:MouseEvent):void
		{
			loadFileReferance.browse();
			loadFileReferance.addEventListener(Event.SELECT, loadSelected);
			loadFileReferance.addEventListener(Event.CANCEL, cancelLoad);
			
		}
		private function cancelLoad(e:Event):void
		{
			loadFileReferance.removeEventListener(Event.SELECT, loadSelected);
			loadFileReferance.removeEventListener(Event.CANCEL, cancelLoad);
		}
		
		private function loadSelected(e:Event):void
		{
			loadFileReferance.removeEventListener(Event.SELECT, loadSelected);
			loadFileReferance.removeEventListener(Event.CANCEL, cancelLoad);
	
			loadFileReferance.addEventListener(Event.COMPLETE, xmlLoadComplete);
			//loadFileReferance.load();
		}
		
		
		private function xmlLoadComplete(e:Event):void
		{
			currentPosition = null;
			positionsArray.length = 0;
			positionsIDArray.length = 0;
			//var tempPositionXML:XML = new XML(loadFileReferance.data);
			//createPositionsArray(tempPositionXML);
		}
		
		
		private function scrollListener(e:ScrollEvent):void
		{
			positionBank.y = (positionBank.height-positionBankMask.height)*-e.value;
			//currentScroll = verticalScrollBar.getScrollPercentage();
		}
		
		public function clearPositionBank():void
		{
			try
			{
				while (positionBank.getChildAt(0))
					positionBank.removeChildAt(0);
			}
			catch (e:Error)
			{
				
			}
		}
		
		public function clearPositionBankArray(e:MouseEvent):void
		{
			if (currentPosition)
			{
				currentPosition.getPosition().dispatchEvent(new PositionEvent(PositionEvent.POSITION_DELETED, currentPosition.getPosition()));
				currentPosition = null;
				
			}
				
				
			if (positionsArray)
			{
				positionsArray.length = 0;
				drawBank();
			}
		}
		
		private function savePositionBank(e:MouseEvent):void
		{
			if (positionsArray)
			{
				var xmlBank:XML = <positionsXML/>;
				for (var i:uint = 0; i < positionsArray.length; i++)
				{
					xmlBank.appendChild(positionsArray[i].getPosition().getPositionXML());
					
				}
			//	saveFileReferance.save(xmlBank);
			}
		}
		
		private function setCurrentPosition(positionObject:PositionBankObject):void
		{
			
			if (currentPosition&&currentPosition.getPosition().getPositionID()!=positionObject.getPosition().getPositionID())
			{
				currentPosition.getPosition().dispatchEvent(new PositionEvent(PositionEvent.POSITION_UNSELECTED, currentPosition.getPosition()));
				currentPosition.unsetCurrentPosition();
				currentPosition = positionObject;
				currentPosition.setCurrentPosition();
				currentPosition.getPosition().dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, currentPosition.getPosition()));
				objectConnection.dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, currentPosition.getPosition()));
			}
			else if(currentPosition==null)
			{	
				currentPosition = positionObject;
				currentPosition.setCurrentPosition();
				currentPosition.getPosition().dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, currentPosition.getPosition()));
				objectConnection.dispatchEvent(new PositionEvent(PositionEvent.POSITION_SELECTED, currentPosition.getPosition()));
			}
			updateBars();
				
		}
		
		private function addNewPosition(e:MouseEvent):void
		{
			var blankPosition:BlankPosition = new BlankPosition(getUniqueID());
			positionsArray.push(new PositionBankObject(objectConnection, blankPosition, positionBankWidth));
			positionsIDArray.push(blankPosition.getPositionID());
			drawBank();
		}
		
		private function newPostionListener(e:PositionEvent):void
		{
			var tempIndex:int = positionsIDArray.indexOf(e.position.getPositionID())
			
			if (tempIndex == -1)
			{
				positionsArray.push(new PositionBankObject(objectConnection, e.position,positionBankWidth));
				positionsIDArray.push(e.position.getPositionID());
			}
			
			else
			{
				positionsArray.splice(tempIndex, 1, new PositionBankObject(objectConnection, e.position,positionBankWidth));
			}
			drawBank();
			
		}
		
		private function deleteCurrentPosition(e:MouseEvent):void
		{
			if (currentPosition)
			{
				currentPosition.getPosition().dispatchEvent(new PositionEvent(PositionEvent.POSITION_DELETED, currentPosition.getPosition()));
				var tempIndex:uint = uint(currentPosition.name);
				positionsArray.splice(currentPosition.name, 1);
				positionsIDArray.splice(currentPosition.name, 1);
				drawBank();
				
			}
		}
		public function getCurrentPosition():PositionBankObject
		{
				return currentPosition;
		}
		
		private function getUniqueID():uint
		{
			var date:Date = new Date();
			return(date.getTime());
		}
	}
}
