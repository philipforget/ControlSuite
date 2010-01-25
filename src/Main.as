package
{
	
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
	
	
	public class Main extends Sprite
	{
		
		// embed the font Ahron
		[Embed(source = '../fonts/ahronbd.ttf', fontName = 'Ahron', fontWeight = 'bold')] 
		public var Ahron:Class;
		
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
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			GlobalVars.vars.mode = GlobalVars.STANDARD_MODE;
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			this.contextMenu = contextMenu;

			loadOptions();
		}
		
		private function loadOptions():void
		{
			createStage(standardOptions());
			/*
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, optionsError);
			loader.addEventListener(Event.COMPLETE, optionsLoaded);
			loader.load(new URLRequest('options.xml'));
			*/
		}
		
		private function optionsLoaded(e:Event):void
		{
			//var tempXML:XML = new XML(e.target.data);
			//createStage(tempXML);
		}

		private function standardOptions():XML {
			return <options>
	<boards>
		<board0>
			<type>USB</type> <!-- 'Ethernet' or 'USB' -->
			<location>COMn</location> <!-- 192.168.x.xxx, or COMn-->
		</board0>
		<board1>
			<type>USB</type> <!-- 'Ethernet' or 'USB' -->
			<location>COMn</location> <!-- 192.168.x.xxx, or COMn-->
		</board1>
	</boards>
	<servos>
		<servo0>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>0</servoNumber>
			<analogIn>0</analogIn><!-- for continous servos only-->
			<zeroPoint>0</zeroPoint><!-- for continous servos only-->
			<servoLabel>Left Arm V</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo0>
		<servo1>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>1</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Left Arm H</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo1>
		<servo2>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>0</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Right Arm V</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo2>
		<servo3>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>1</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Right Arm H</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo3>
		<servo4>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>2</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Head Vertical</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>200</speedMax>
		</servo4>
		<servo5>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>2</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Head Horizontal</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo5>
		<servo6>
			<boardNumber>0</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>3</servoNumber>
			<analogIn></analogIn>
			<zeroPoint></zeroPoint>
			<servoLabel>Torso Rotation</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo6>
		<servo7>
			<boardNumber>1</boardNumber>
			<servoType>Standard</servoType><!-- servo types 'Standard' or 'Continous' -->
			<servoNumber>3</servoNumber>
			<analogIn>0</analogIn>
			<zeroPoint>0</zeroPoint>
			<servoLabel>Spine</servoLabel>
			<positionMin>-400</positionMin>
			<positionMax>1400</positionMax>
			<speedMin>1</speedMin>
			<speedMax>50</speedMax>
		</servo7>
	</servos>
	<globalMode>Standard</globalMode><!-- 'Standard' or 'Economy' -->
	<gridOptions>
		<gridRows>4</gridRows>
		<gridColumns>5</gridColumns>
	</gridOptions>
	<cameras>
		<trackingCamera>3</trackingCamera>
		<keyframeCamera>4</keyframeCamera>
	</cameras>
</options>
		}
		
		private function optionsError(e:IOErrorEvent):void
		{
			var errorTextField:TextField = new TextField();
			errorTextField.textColor = 0xFFFFFF;
			errorTextField.autoSize = TextFieldAutoSize.LEFT;
			errorTextField.text = 'Error Loading bin/options.xml';
			addChild(errorTextField);
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
