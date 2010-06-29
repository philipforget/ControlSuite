package {
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.*;
	import flash.net.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.ui.Mouse;
	import flash.text.*;
	import caurina.transitions.*;
	import flash.system.*;
	import com.chevalierforget.console;
	
	
	public class Main extends Sprite
	{
		
		// embed the font Ahron
		[Embed(source = '../fonts/ahronbd.ttf', fontName = 'Ahron', fontWeight = 'bold')] 
		public var Ahron:Class;
		
		[Embed(source = '../fonts/pixelmix.ttf', fontName = 'PixelMix', fontWeight = 'normal')] 
		public var PixelMix:Class;

		[Embed(source = '../fonts/C&C Red Alert [INET].ttf', fontName = 'RedAlert', fontWeight = 'normal')] 
		public var RedAlert:Class;

		// objectConnection will be used to call events through the object heirarchy
		private var objectConnection:ObjectConnection;
		
		private var positionEditor:PositionEditor;
		
		private var positionBank:PositionBank;
		
		private var favoriteColorPicker:FavoriteColorPicker;
		
		private var loader:URLLoader;
		
		public function Main():void
		{
			init();
		}
		
		private function init():void
		{
			if(stage){
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
			}

			GlobalVars.vars.mode = GlobalVars.STANDARD_MODE;
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			this.contextMenu = contextMenu;

			loadOptions();
		}
		
		private function loadOptions():void
		{
			console.log('loading options')
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, optionsError);
			loader.addEventListener(Event.COMPLETE, optionsLoaded);
			loader.load(new URLRequest('/static/options.xml'));
		}
		
		private function optionsLoaded(e:Event):void
		{
			console.log('options loaded')
			createStage(XML(e.target.data));
		}
		
		private function optionsError(e:IOErrorEvent):void
		{
			console.log('falling back to default options')
			createStage(StandardOptions.options());
		}

		private function createStage(optionsXML:XML):void
		{
			var boardOptions:XMLList = optionsXML.boards;
			
			var servoOptions:XMLList = optionsXML.servos;
			
			var gridOptions:XMLList = optionsXML.gridOptions;
			
			GlobalVars.vars.mode = optionsXML.globalMode;
			GlobalVars.vars.trackingCamera = optionsXML.cameras.trackingCamera;
			GlobalVars.vars.keyframeCamera = optionsXML.cameras.keyframeCamera;
			
			objectConnection = new ObjectConnection();
			addChild(objectConnection);
			
			positionBank = new PositionBank(objectConnection);
			positionBank.x = 10;
			positionBank.y = 10;
			
			positionEditor = new PositionEditor(objectConnection, boardOptions, servoOptions);
			positionEditor.x = positionBank.width+30;
			positionEditor.y = positionBank.y+10;
			addChild(positionEditor);
			addChild(positionBank);
			
			
			favoriteColorPicker = new FavoriteColorPicker(0x33FFFFFF);
			objectConnection.addEventListener(ColorPickerEvent.COLOR_CALL, displayColorPicker);
			
			var positionCallEditor:PositionCallEditor = new PositionCallEditor(objectConnection, positionBank, gridOptions);
			addChild(positionCallEditor);
			positionCallEditor.y = positionBank.x + positionBank.height + 20;
			positionCallEditor.x = 10;
			
		}
		private function drawBitmap(e:MouseEvent):void
		{
			var tempMatrix:Matrix = new Matrix();
			tempMatrix.tx = -50 + Math.random() * 100;
			tempMatrix.ty = -50 + Math.random() * 100;
			
			//tempBitmapData.draw(parent, tempMatrix,new ColorTransform(Math.random(),Math.random(),Math.random(),Math.random()));
			
		}
		
		private function displayColorPicker(e:ColorPickerEvent):void
		{
			objectConnection.tempObject = e.colorCallFunction;
			
			favoriteColorPicker.y = mouseY;
			favoriteColorPicker.x = mouseX;
			
			if (favoriteColorPicker.y > stage.stageHeight - favoriteColorPicker.colorPickerHeight)
				favoriteColorPicker.y = stage.stageHeight - favoriteColorPicker.colorPickerHeight;
				
			
			if (favoriteColorPicker.x > stage.stageWidth - favoriteColorPicker.colorPickerWidth)
				favoriteColorPicker.x = stage.stageWidth - favoriteColorPicker.colorPickerWidth;
				
			addChild(favoriteColorPicker);
			
			objectConnection.removeEventListener(ColorPickerEvent.COLOR_CALL, displayColorPicker);
			
			favoriteColorPicker.addEventListener(ColorPickerEvent.COLOR_CANCELED, cancelColorPicker);
			favoriteColorPicker.addEventListener(ColorPickerEvent.COLOR_SELECTED, dispatchColorSelected);
			
		}
		
		private function cancelColorPicker(e:ColorPickerEvent):void
		{
			clearColorPickerEvents();
		}
		
		private function dispatchColorSelected(e:ColorPickerEvent):void
		{
			// send the color from the color event to the temp object holding the color setter function for the calling object
			if(objectConnection.tempObject!=null)
				objectConnection.tempObject(e.color);
			//close the color picker and remove it's listeners
			clearColorPickerEvents();
		}
		
		private function clearColorPickerEvents():void
		{
			removeChild(favoriteColorPicker);
			
			favoriteColorPicker.removeEventListener(ColorPickerEvent.COLOR_CANCELED, cancelColorPicker);
			favoriteColorPicker.removeEventListener(ColorPickerEvent.COLOR_SELECTED, dispatchColorSelected);
			
			objectConnection.addEventListener(ColorPickerEvent.COLOR_CALL, displayColorPicker);
		}
	}
}
