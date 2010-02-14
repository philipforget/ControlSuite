package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.*;
	
	public class PositionCallEditor extends Sprite
	{
		private var objectConnection:ObjectConnection;
		private var positionBank:PositionBank;
		private var positionCallGrid:PositionCallGrid;
		private var currentPositionCallObject:PositionCallObject;
		private var positionCallBank:PositionCallBank;
		
		private var saveFileReferance:FileReference;
		private var loadFileReferance:FileReference;
		
		private var gridOptions:XMLList;
		
		public function PositionCallEditor(objectConnection:ObjectConnection, positionBank:PositionBank, gridOptions:XMLList) 
		{
			this.objectConnection = objectConnection;
			this.positionBank = positionBank;
			this.gridOptions = gridOptions;
			init();
		}
		
		private function init():void
		{
			saveFileReferance = new FileReference();
			loadFileReferance = new FileReference();
			var loadPositionCallsButton:RasterButton = new RasterButton('Load Call Bank', 160, new ColorBank().blue);
			addChild(loadPositionCallsButton);
			loadPositionCallsButton.addEventListener(MouseEvent.CLICK, loadPositionCallBank);
			
			var savePositionCallsButton:RasterButton = new RasterButton('Save Call Bank', 160, new ColorBank().green);
			savePositionCallsButton.x = loadPositionCallsButton.x + loadPositionCallsButton.width;
			addChild(savePositionCallsButton);
			savePositionCallsButton.addEventListener(MouseEvent.CLICK, savePositionCallBank);
			
			positionCallBank = new PositionCallBank(objectConnection, positionBank, positionCallGrid);
			positionCallBank.x = 320 + 20;
			positionCallBank.y = 35;
			addChild(positionCallBank);
			
			positionCallGrid = new PositionCallGrid(objectConnection, positionBank,positionCallBank, gridOptions);
			positionCallGrid.y = 35;
			addChild(positionCallGrid);
			
			
			
			objectConnection.addEventListener(PositionCallEvent.OBJET_FOCUS, setCurrentPositionCallObject);
			
		}
		
		private function setCurrentPositionCallObject(e:PositionCallEvent):void
		{
			unsetCurrentPositionCallObject();
			currentPositionCallObject = e.positionCallObject;
			currentPositionCallObject.draw();
			currentPositionCallObject.mouseEnabled = false;
			positionCallGrid.positionGridHolder.setChildIndex(currentPositionCallObject, positionCallGrid.positionGridHolder.numChildren - 1);
		}
		private function unsetCurrentPositionCallObject():void
		{
			if (currentPositionCallObject)
			{
				currentPositionCallObject.mouseEnabled = true;
				currentPositionCallObject.clear();
			}
		}
		
		private function savePositionCallBank(e:MouseEvent):void
		{
			var tempXML:XML = positionCallGrid.getPositionCallBankXML();
			//saveFileReferance.save(tempXML, 'CallBank_' + new Date().getTime()+'.xml');
			saveFileReferance.addEventListener(Event.CANCEL, cancelSave);
			saveFileReferance.addEventListener(Event.COMPLETE, saveComplete);
		}
		
		private function loadPositionCallBank(e:MouseEvent):void
		{
			loadFileReferance.browse([new FileFilter('Position Bank XML', '*.xml')]);
			loadFileReferance.addEventListener(Event.SELECT, loadPositionXML);
			loadFileReferance.addEventListener(Event.CANCEL, loadCancelListener);
			
		}
		
		private function loadPositionXML(e:Event):void
		{
			//loadFileReferance.load();
			loadFileReferance.removeEventListener(Event.SELECT, loadPositionXML);
			loadFileReferance.addEventListener(Event.COMPLETE, loadCompleteListener);
		}
		private function cancelSave(e:Event):void
		{
			clearSaveListeners();
		}
		private function saveComplete(e:Event):void
		{
			clearSaveListeners();
		}
		private function clearSaveListeners():void
		{
			saveFileReferance.removeEventListener(Event.CANCEL, cancelSave);
			saveFileReferance.removeEventListener(Event.COMPLETE, saveComplete);
		}
		
		private function loadCompleteListener(e:Event):void
		{
			//var tempCallXML:XML = new XML(loadFileReferance.data);
			//positionCallGrid.assignPositionCalls(tempCallXML);
			clearLoadListeners();
		}
		
		private function loadCancelListener(e:Event):void
		{
			clearLoadListeners();
		}
		
		private function clearLoadListeners():void
		{
			loadFileReferance.removeEventListener(Event.CANCEL, cancelSave);
			loadFileReferance.removeEventListener(Event.COMPLETE, saveComplete);
		}
	}
	
}
