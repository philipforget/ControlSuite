package 
{
	import adobe.utils.CustomActions;
	import flash.display.*;
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.ui.Mouse;
	import caurina.transitions.*;
	
	public class PositionCallGrid extends Sprite
	{
		private var camera:Camera;
		
		private var video:Video;
		private var objectConnection:ObjectConnection;
		private var positionBank:PositionBank;
		
		private var colorPickerBitmapData:BitmapData;
		private var colorPickerBitmap:Bitmap;
		private var colorPickerHolderSprite:Sprite;
		
		
		public var numColumns:uint = 2;
		public var numRows:uint  = 2;
		
		public var objectWidth:uint = 320;
		public var objectHeight:uint = 240;
		
		private static const objectBorderBuffer:uint = 5; // in pixels
		
		private var singleObjectHeight:uint;
		private var singleObjectWidth:uint;
		
		private var setColor:Boolean = false;
		
		private var rowArray:Array;
		private var positionCallBank:PositionCallBank;
		private var cameraShowing:Boolean;
		private var tracking:Boolean;
		
		private var videoBitmap:BitmapData;
		
		private static const skipFrame:uint = 3;
		private var loopRunWidth:uint;
		private var loopRunHeight:uint;
		private var loopRun:uint;
		private var xp:uint;
		private var yp:uint;
		private var color:uint = 8356223;
		private const threshold:uint = 1000;
		private const speed:uint = 2;
		private var newX:uint;
		private var newY:uint;
		private var newScale:uint;
		private var trackingMarker:Sprite;
		
		private var setColorSampleButton:RasterButton;
		private var toggleTrackButton:RasterButton;
		private var currentObjectRow:uint;
		private var currentObjectColumn:uint;
		public var positionGridHolder:Sprite;
		
		public function PositionCallGrid(objectConnection:ObjectConnection, positionBank:PositionBank,positionCallBank:PositionCallBank, gridOptions:XMLList) 
		{
			var tempColumns:uint = uint(gridOptions.gridColumns);
			if(tempColumns>numColumns)
				numColumns = tempColumns;
				
			if (numColumns > 20)
				numColumns = 20;
			
			var tempRows:uint = uint(gridOptions.gridRows);
			if(tempRows>numRows)
				numRows = tempRows;
				
			if (numRows > 20)
				numRows = 20;
			this.objectConnection = objectConnection;
			this.positionBank = positionBank;
			this.positionCallBank = positionCallBank;
			positionCallBank.addEventListener(PositionCallEvent.RESET_COUNTS, resetAllCounts);
			
			init();
		}
		
		private function init():void
		{			
			
			objectWidth = objectWidth - objectWidth % numColumns;
			objectHeight = objectHeight - objectHeight % numRows;
			
			video = new Video();
			
			//if(GlobalVars.vars.trackingCamera) {
				//camera = Camera.getCamera(GlobalVars.vars.trackingCamera);
			//}
				
			try {
				camera = Camera.getCamera();
				camera.setQuality(0,100);
				camera.setMode(320,240,30,false);

				video.attachCamera(camera);
			}
			catch(e:Error){
				// 
			}

			video.smoothing = false;
			
			colorPickerBitmapData = new BitmapData(320, 240);
			colorPickerBitmap = new Bitmap(colorPickerBitmapData);
			colorPickerBitmap.alpha = 0;
			
			colorPickerHolderSprite = new Sprite();
			colorPickerHolderSprite.addChild(colorPickerBitmap);
			
			tracking = false;
			addChild(video);
			var border:Sprite = new Sprite();
			addChild(border);
			
			positionGridHolder = new Sprite();
			addChild(positionGridHolder);
			
			videoBitmap = new BitmapData(320, 240);
			loopRunWidth = Math.floor(video.width / skipFrame);
			loopRunHeight = Math.floor(video.height / skipFrame);
			loopRun = Math.floor(loopRunHeight * loopRunWidth);
			
			
			
			
			
			border.graphics.lineStyle(2, 0xFFFFFF, .5,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
			border.graphics.beginFill(0xFF0000, 0);
			border.graphics.drawRect(0, 0, objectWidth+1 , objectHeight+1);
			
			singleObjectHeight = Math.floor(objectHeight / numRows);
			singleObjectWidth = Math.floor(objectWidth / numColumns);
			
			rowArray = new Array();
			
			graphics.lineStyle(0, 0xFFFFFF);
			
			
			for (var r:uint = 0; r < numRows; r++)
			{
				var colArray:Array = new Array();
				for (var c:uint = 0; c < numColumns; c++)
				{
					var positionCallObject:PositionCallObject = new PositionCallObject(objectConnection, singleObjectWidth, singleObjectHeight,r,c);
					positionCallObject.x = c * singleObjectWidth;
					positionCallObject.y = r * singleObjectHeight;
					colArray.push(positionCallObject);
					positionGridHolder.addChild(positionCallObject);
				}
				rowArray.push(colArray);
			}
			
			setColorSampleButton = new RasterButton('Set Tracking Color', 160, new ColorBank().pink);
			setColorSampleButton.y = 260;
			addChild(setColorSampleButton);
			
			setColorSampleButton.addEventListener(MouseEvent.CLICK, toggleSetColorSample);
			
			toggleTrackButton = new RasterButton('Start Tracking', 160, new ColorBank().green);
			toggleTrackButton.y = setColorSampleButton.y;
			toggleTrackButton.x = setColorSampleButton.x + setColorSampleButton.width;
			addChild(toggleTrackButton);
			
			toggleTrackButton.addEventListener(MouseEvent.CLICK, toggleTrack);
			
			trackingMarker = new Sprite();
			trackingMarker.graphics.lineStyle(3, 0x00FF00);
			trackingMarker.graphics.moveTo( -10, 0)
			trackingMarker.graphics.lineTo(10, 0);
			trackingMarker.graphics.moveTo(0, -10);
			trackingMarker.graphics.lineTo(0, 10);
			
			
			
			
			// addChild(trackingMarker); // UNCOMMENT TO SEE THE MARKER IN ACTION
			
			newScale = 0;
			newY = 0;
			newX = 0;
			
			addChild(colorPickerHolderSprite);
			colorPickerHolderSprite.mouseEnabled = false;
		}
		
		
		
		
		private function toggleTrack(e:MouseEvent = null):void
		{
			
				if (tracking)
				{
					toggleTrackButton.setLabel('Start Tracking');
					removeEventListener(Event.ENTER_FRAME, trackColor);
					tracking = false;
					GlobalVars.vars.trackingMode = false;
				}
				else if(!setColor)
				{
					toggleTrackButton.setLabel('Stop Tracking');
					tracking = true;
					GlobalVars.vars.trackingMode = true;
					addEventListener(Event.ENTER_FRAME, trackColor);
				}
			
			
		}
		
		public function resetAllCounts(e:Event):void
		{
			for (var r:uint = 0; r < rowArray.length; r++)
			{
				var colArray:Array = rowArray[r];
				for (var c:uint = 0; c < colArray.length; c++)
				{
					var positionCallObject:PositionCallObject = colArray[c];
					positionCallObject.resetCallCount()
				}
				
			}
		}
		
		private function trackColor(e:Event):void
		{
			xp = 0;
			yp = 0;
			videoBitmap.draw(video);
			videoBitmap.lock();
			for(var i:uint=0;i<=loopRun;i++){			
					if (videoBitmap.getPixel(xp * skipFrame, yp * skipFrame) >= (color - threshold))
					{
						
						newX=xp*skipFrame;
						newY=yp*skipFrame;
						var pixelValue:uint = videoBitmap.getPixel(newX,newY);
						var counter:uint=1;
						while(pixelValue>=(color-threshold)){
							pixelValue=videoBitmap.getPixel(newX, newY+counter);
							counter++;
						}
						newScale = counter;
						newY = newY + .5 * counter;
						break;
					}
				xp++;
				if(xp==loopRunWidth){
					xp=1;
					yp++;
				}
			}
			
			var columnChanged:Boolean = false;
			var objectColumnOverlap:uint = (newX % singleObjectWidth);
			var tempColumn:uint = Math.floor(newX / singleObjectWidth);
			if (currentObjectColumn != tempColumn&&objectColumnOverlap>objectBorderBuffer&&objectColumnOverlap<singleObjectWidth - objectBorderBuffer)
			{
				currentObjectColumn = tempColumn;
				columnChanged = true;
			}
			
			var rowChanged:Boolean = false;
			var objectRowOverlap:uint = (newY % singleObjectHeight);
			var tempRow:uint = Math.floor(newY / singleObjectHeight);
			if (currentObjectRow != tempRow && objectRowOverlap > objectBorderBuffer && objectRowOverlap < singleObjectHeight - objectBorderBuffer)
			{
				currentObjectRow = tempRow;
				rowChanged = true;
			}
			
			if (columnChanged || rowChanged)
			{
				rowArray[currentObjectRow][currentObjectColumn].setCurrent(tracking);
			}
			
			trackingMarker.x+= (newX-trackingMarker.x)/speed;
			trackingMarker.y += (newY - trackingMarker.y) / speed;
			trackingMarker.width += (newScale - trackingMarker.width)/speed;
			trackingMarker.height+= (newScale- trackingMarker.height)/speed;
			
			videoBitmap.unlock();
		}
		
		public function getPositionCallBankXML():XML
		{
			var positionBankXML:XML = <positions/>
			
			// start the keyframes list
			
			var positionArray:Array = new Array();
			var positionCallArray:Array = new Array();
			
			for (var r:uint = 0; r < rowArray.length; r++)
			{
				var colArray:Array = rowArray[r];
				for (var c:uint = 0; c < colArray.length; c++)
				{
					if (colArray[c].getPositionCallArray().length)
					{
						var tempPositionArray:Array = colArray[c].getPositionCallArray();
						for (var p:uint = 0; p < tempPositionArray.length; p++)
						{
							
							var tempCallArray:Array = new Array();
							tempCallArray.index = p;
							tempCallArray.row = r;
							tempCallArray.column = c;
							
							
							var existingIndex:int = positionArray.indexOf(tempPositionArray[p].getPositionID());
							
								//if an entry for the position does not exist, add it and add this call as the first one
							if (existingIndex == -1)
							{
								var tempPositionCallArray:Array = new Array();
								var callArray:Array = new Array();
								
								tempPositionCallArray.position = tempPositionArray[p].getPositionXML();
								tempPositionCallArray.callArray = callArray;
								
								callArray.push(tempCallArray);
								
								positionCallArray.push(tempPositionCallArray);
								positionArray.push(tempPositionArray[p].getPositionID());
								
							}
							else
							{
								positionCallArray[existingIndex].callArray.push(tempCallArray);
							}
						}
					}
				}
			}
			
			for (var i:uint = 0; i < positionCallArray.length; i++)
			{
				var positionCall:XML = <positionCall/>
				
				var calls:XML = <calls/>;
				
				positionCall.appendChild(calls);
				
				var tempSingleCallArray:Array = positionCallArray[i].callArray;
				for (var ca:uint = 0; ca < tempSingleCallArray.length; ca++)
				{
					var cell:XML = <cell/>
					cell.row = tempSingleCallArray[ca].row;
					cell.column = tempSingleCallArray[ca].column;
					cell.index = tempSingleCallArray[ca].index;
					calls.appendChild(cell);
				}
				positionCall.position = positionCallArray[i].position;
				positionBankXML.appendChild(positionCall);
			}
			return(positionBankXML);
		}
		
		public function assignPositionCalls(tempCallXML:XML):void
		{
			var positionList:XMLList = tempCallXML.positionCall;
			
			for (var i:uint = 0; i < positionList.length(); i++)
			{
				var position:Position = new Position(positionList[i].position);
				objectConnection.dispatchEvent(new PositionEvent(PositionEvent.POSITION_ADDED, position));
				var callList:XMLList = positionList[i].calls.cell;
				
				for (var j:uint = 0; j < callList.length(); j++)
				{
					var row:uint = callList[j].row;
					var column:uint = callList[j].column;
					var index:uint = callList[j].index;
					rowArray[row][column].insertPositionCall(index, position);
					rowArray[row][column].clear();
				}
				
			}
		}
		
		private function toggleSetColorSample(e:MouseEvent=null):void
		{
			if (setColor)
			{
				setColor = false;
				
				colorPickerBitmap.alpha = 0;
				colorPickerHolderSprite.mouseEnabled = false;
				Tweener.addTween(positionGridHolder, { alpha:1, time:1 } );
				setColorSampleButton.setLabel('Set Tracking Color');
				colorPickerHolderSprite.removeEventListener(MouseEvent.CLICK, setMouseColor);
			}
			else
			{
				
				setColor = true;
				if (tracking)
				{
					toggleTrack();
				}
				colorPickerBitmapData.draw(video);
				colorPickerBitmap.alpha = 1;
				colorPickerHolderSprite.mouseEnabled = true;
				Tweener.addTween(positionGridHolder, { alpha:0, time:1 } );
				setColorSampleButton.setLabel('Cancel Color Set');
				colorPickerHolderSprite.addEventListener(MouseEvent.CLICK, setMouseColor);
			}
		}
		private function setMouseColor(e:Event):void
		{
			color = colorPickerBitmapData.getPixel(mouseX, mouseY);
			toggleSetColorSample();
		}
	}
}
