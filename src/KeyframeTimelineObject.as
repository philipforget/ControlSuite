package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.geom.Matrix;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import flash.net.*;
	import flash.net.URLRequest;
	import flash.text.*;
	import caurina.transitions.*;
	import com.adobe.images.JPGEncoder;
	import flash.utils.Timer;
	import com.makingthings.makecontroller.*;
	import flash.media.*;
	import com.chevalierforget.console;
	import com.dynamicflash.util.Base64;
	
	public class KeyframeTimelineObject extends Sprite
	{
		private static const maxSoundLoops:uint = 20;
		
		private var position:Position;
		
		private var keyframeOrderLabel:TextField;
		
		private var backgroundSprite:Sprite;
		private var backgroundSpriteMask:Sprite;
		
		private var positionKeyframe:PositionKeyframe;

		private var imageHolder:Loader;
		
		private var copyButton:Sprite;

		private var pasteButton:TextButton;
		private var shiftRight:TextButton;
		private var shiftLeft:TextButton;
		
		private var cameraShowing:Boolean;
	
		private var video:Video;
		private var snapShot:Bitmap;
		private var tempBMP:BitmapData;
		private var webcamHolder:Sprite;
		private var webcamMask:Sprite;
		
		private var takePicture:RasterButton;
		private var savePicture:RasterButton;
		
		private var saveFileReferance:FileReference;		
			
		private var imageWidth:Number = 180;
		private var imageHeight:Number = 240;
		
		private var menuWidth:Number = 150;
		private var selectedBorder:Sprite;
		
		private var delayInput:TextField;
		
		private var objectConnection:ObjectConnection;
		
		private var inputFormat:TextFormat;
	
		private var saveImageButton:RasterButton;

		private var temporary_image_name:String;

		private var jpegencoder:JPGEncoder;
		
		public function KeyframeTimelineObject(objectConnection:ObjectConnection, positionKeyframe:PositionKeyframe, position:Position, keyframeOrder:uint, video:Video)
		{
			this.objectConnection = objectConnection;
			this.video = video;

			jpegencoder = new JPGEncoder(50);
			
			inputFormat = new TextFormat();
			inputFormat.font = "PixelMix"
			inputFormat.size = 8;
			inputFormat.color = 0xFFFFFF;
			
			graphics.beginFill(0x000000, .25);
			graphics.drawRect(0, 0, imageWidth+menuWidth, 240);

			this.position = position;
			this.positionKeyframe = positionKeyframe;
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			imageHolder = new Loader();
			imageHolder.scaleX = .75;
			imageHolder.scaleY = .75;
			addChild(imageHolder);
			imageHolder.addEventListener(IOErrorEvent.IO_ERROR, imageHolderError);
			
			createMenu();
			
			cameraShowing = false;
			webcamHolder = new Sprite;
			webcamHolder.graphics.beginBitmapFill(new SimpleRaster(0xDDFFFFFF0));
			webcamHolder.graphics.drawRect(0, 0, imageWidth, imageHeight);
			video = new Video();
			video.rotation = 90;
			video.x = 180;
			video.scaleX = .75;
			video.scaleY = .75;
			
			tempBMP = new BitmapData(240, 320);
			
			snapShot = new Bitmap(tempBMP, 'auto', true);
			
			snapShot.alpha = 0;
			snapShot.scaleX = .75;
			snapShot.scaleY = .75;
			
			webcamMask = new Sprite();
			webcamMask.graphics.beginFill(0xFF0000);
			webcamMask.graphics.drawRect(0, 0, 180, 240);
			webcamMask.cacheAsBitmap = true;
			
			webcamMask.y = 240;
			webcamHolder.addChild(video);
			webcamHolder.addChild(snapShot);
			addChild(webcamMask);
			addChild(webcamHolder);
			webcamHolder.mask = webcamMask;
			
			saveFileReferance = new FileReference();
			
			selectedBorder = new Sprite();
			
			drawCell();
			
			var colorPickerIcon:ColorPickerIcon = new ColorPickerIcon();
			addChild(colorPickerIcon);
			colorPickerIcon.x = menuWidth+imageWidth-colorPickerIcon.width-5;
			colorPickerIcon.y = 5;
			colorPickerIcon.addEventListener(MouseEvent.CLICK, showColorPicker);
			colorPickerIcon.buttonMode = true;
			colorPickerIcon.useHandCursor = true;
			addChild(selectedBorder);
			
			positionKeyframe.addEventListener(KeyframeEvent.KEYFRAME_EDITED, updateCell);
			
			keyframeOrderLabel = new TextField();
			keyframeOrderLabel.autoSize = TextFieldAutoSize.LEFT;
			keyframeOrderLabel.embedFonts = true;
			keyframeOrderLabel.defaultTextFormat = inputFormat;
			keyframeOrderLabel.backgroundColor = 0x222222;
			//keyframeOrderLabel.background = true;
			keyframeOrderLabel.text = String(keyframeOrder);
			keyframeOrderLabel.x = 5;
			keyframeOrderLabel.y = 5;
			
			addChild(keyframeOrderLabel);
			
		}		
		
		private function updateCell(e:KeyframeEvent):void
		{
			drawCell();
		}
		private function drawCell():void
		{
			clearCell();
			drawBackgroundSprite();

			imageHolder.load(new URLRequest('/static/KeyframeImages/' + positionKeyframe.getKeyframeImage()));

		}
		
		public function updateKeyframeOrderLabel(keyframeOrder:uint):void
		{
			keyframeOrderLabel.text = String(keyframeOrder);
		}
		
		private function drawBackgroundSprite():void
		{
			var leadingRaster:SimpleRaster = new SimpleRaster(0x00000000,positionKeyframe.getKeyframeColor());
			var standarRaster:SimpleRaster = new SimpleRaster(0x00FFFFFF,positionKeyframe.getKeyframeColor());
						
			try
			{
				while (backgroundSprite.getChildAt(0)){
					backgroundSprite.removeChildAt(0);
				}
			}
			catch (E:Error)
			{
				
			}
					
			var leadingEdge:Sprite = new Sprite();
			leadingEdge.graphics.beginBitmapFill(leadingRaster);
			leadingEdge.graphics.drawRect(0, 0, menuWidth, imageHeight);
			
			var tempMatrix:Matrix = new Matrix();
			tempMatrix.createGradientBox(menuWidth, imageHeight, Math.PI / 2);
			
			var leadingEdgeBitmapMask:Sprite = new Sprite();
			leadingEdgeBitmapMask.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [1, 0], [0x00, 0x99], tempMatrix);
			leadingEdgeBitmapMask.graphics.drawRect(0, 0, menuWidth, imageHeight);
			
			leadingEdge.x = 180;	
			
			var tempGradient:BitmapData = new BitmapData(menuWidth, 240, true, 0x00000000);
			tempGradient.draw(leadingEdgeBitmapMask);
			
			var tempLines:BitmapData = new BitmapData(menuWidth, 240, true, 0x00000000);
			tempLines.draw(leadingEdge);
			
			var finalGradient:BitmapData = new BitmapData(menuWidth, 240, true, 0x00FFFFFF);
			finalGradient.copyPixels(tempLines, new Rectangle(0, 0, menuWidth, 240), new Point(0, 0), tempGradient);
			
			var bitmap:Bitmap = new Bitmap(finalGradient);
			bitmap.x = 180;
			
			backgroundSprite.addChild(bitmap);
		}
		private function clearCell():void
		{
			if (backgroundSprite.hasEventListener(MouseEvent.CLICK)){
				backgroundSprite.removeEventListener(MouseEvent.CLICK, showColorPicker);
			}
		}
		
		private function showColorPicker(e:Event):void
		{
			objectConnection.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.COLOR_CALL, false, false, 0xFFFF0000, positionKeyframe.setKeyframeColor));
		}
		
		
		private function imageHolderError(e:Event):void
		{

		}
		
		private function shiftLeftListener(e:MouseEvent):void
		{
			dispatchEvent(new KeyframeEvent(KeyframeEvent.SHIFT_LEFT, this.positionKeyframe));
		}
		
		private function shiftRightListener(e:MouseEvent):void
		{
			dispatchEvent(new KeyframeEvent(KeyframeEvent.SHIFT_RIGHT, this.positionKeyframe));
		}
		
		
		public function getPositionKeyframe():PositionKeyframe
		{
			return positionKeyframe;
		}
		
		private function deleteListener(e:MouseEvent):void
		{
			this.positionKeyframe.dispatchEvent(new KeyframeEvent(KeyframeEvent.POSITION_DELETE, this.positionKeyframe));
		}
		
		private function saveImage(e:MouseEvent):void
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate( (Math.PI / 2));
			matrix.tx = 240;
			tempBMP.draw(video, matrix);

			snapShot = new Bitmap(tempBMP, 'auto', true);
			snapShot.alpha = 0;
			snapShot.scaleX = .75;
			snapShot.scaleY = .75;

			var png:ByteArray = jpegencoder.encode(tempBMP);

			var tempDate:Date = new Date();
			temporary_image_name = String(tempDate.getTime())+".jpg";

			var base64Bytes:String = Base64.encodeByteArray(png);
			var url_vars:URLVariables = new URLVariables();
			url_vars.imageName = temporary_image_name;
			url_vars.imageData = base64Bytes;

			var image_save_request:URLRequest = new URLRequest('/save_image');
			image_save_request.method = URLRequestMethod.POST;
			image_save_request.data = url_vars;

			var image_save_urlloader:URLLoader = new URLLoader();

			image_save_urlloader.addEventListener(Event.COMPLETE, load_complete_handler);	
			image_save_urlloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);	
			image_save_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, security_handler);	
			image_save_urlloader.addEventListener(IOErrorEvent.IO_ERROR, io_error_handler);	

			image_save_urlloader.load(image_save_request);
				
		}
	
		private function load_complete_handler(e:Event):void{
			saveCompleteListener();
		}
		private function httpStatus_handler(e:HTTPStatusEvent):void{
			console.log('http status '+e);
		}
		private function security_handler(e:SecurityErrorEvent):void{
			console.log('security error '+e);
		}
		private function io_error_handler(e:IOErrorEvent):void{
			console.log('ioerror: '+e);
		}

		private function saveCompleteListener(e:Event=null):void
		{

			this.positionKeyframe.setKeyframeImage(temporary_image_name);
			
			position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, position));
			position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_IMAGE_EDITED, position));
			
			drawCell();

		}
		
	
		
		public function setCurrent():void
		{
			backgroundSprite.alpha = 1;
			selectedBorder.graphics.clear();
			imageHolder.alpha = 1;
		}
		public function unsetCurrent():void
		{
			
			backgroundSprite.alpha = .5;
			selectedBorder.graphics.clear();
			selectedBorder.graphics.lineStyle(1, getPositionKeyframe().getKeyframeColor(),.5);
			
			
			selectedBorder.graphics.moveTo(0, 0);
			selectedBorder.graphics.lineTo(imageHeight, imageHeight);
			selectedBorder.graphics.moveTo(imageHeight, 0);
			//selectedBorder.graphics.lineTo(0, imageHeight);
			
			selectedBorder.graphics.moveTo(imageWidth+menuWidth, 0);
			//selectedBorder.graphics.lineTo(imageWidth+menuWidth-imageHeight, imageHeight);
			selectedBorder.graphics.moveTo(imageWidth+menuWidth-imageHeight, 0);
			selectedBorder.graphics.lineTo(imageWidth+menuWidth, imageHeight);
			
			imageHolder.alpha = .5;
		}
		
		private function setDelay(e:Event = null):void
		{
			var currentNumber:uint = uint(delayInput.text);
			if (delayInput.text.length)
			{					
				if (currentNumber > 99999)
					currentNumber = 999999;
				positionKeyframe.setKeyframeDelay(currentNumber);
				delayInput.text = currentNumber.toString();
			}
			else
				delayInput.text = positionKeyframe.getKeyframeDelay().toString();;
			
		}

		private function delayInputClick(e:MouseEvent = null):void {
			e.target.setSelection(0,e.target.length);
		}

		private function createMenu():void
		{
			
			var buttonHolder:Sprite = new Sprite();
			addChild(buttonHolder);
			buttonHolder.y = 150;
			
			buttonHolder.x = imageWidth;
			
			var buttonFormat:TextFormat = new TextFormat();
			buttonFormat.font = 'Ahron';
			buttonFormat.align = TextFormatAlign.LEFT;
			buttonFormat.size = 14;
			buttonFormat.color = 0xFFFFFF;
			
			
			
			var delayLabelBacker:Sprite = new Sprite();
			delayLabelBacker.graphics.beginFill(0x000000, .25);
			delayLabelBacker.graphics.drawRect(5, 4, menuWidth -10, 18);
			delayLabelBacker.y = 1;
			
			
			var delayLabel:TextField = new TextField();
			delayLabel.embedFonts = true;
			delayLabel.selectable = false;
			delayLabel.autoSize = TextFieldAutoSize.LEFT;
			delayLabel.x = 5;
			delayLabel.height = 15;
			delayLabel.y = 5;
			delayLabel.defaultTextFormat = buttonFormat;
			delayLabel.text = 'Delay';
			
			delayInput = new TextField();
			delayInput.defaultTextFormat = inputFormat;
			delayInput.embedFonts = true;
			delayInput.type = TextFieldType.INPUT;
			delayInput.restrict = '1234567890';
			delayInput.maxChars = 5;
			delayInput.selectable = true;
			delayInput.x = Math.floor(delayLabel.width+10);
			delayInput.width = 35;
			delayInput.height = 18;
			delayInput.y = Math.floor(delayLabel.y + 3);
			delayInput.text = (getPositionKeyframe().getKeyframeDelay().toString());
			delayInput.addEventListener(Event.CHANGE, setDelay);
			delayInput.addEventListener(MouseEvent.CLICK, delayInputClick);
			
			//buttonHolder.addChild(delayLabelBacker);
			buttonHolder.addChild(delayInput);
			buttonHolder.addChild(delayLabel);
			
			var shiftLeftButton:RasterButton = new RasterButton('Shift Left', .5*menuWidth, new ColorBank().blue);
			shiftLeftButton.y = Math.floor(delayLabel.y+delayLabel.height+5);
			buttonHolder.addChild(shiftLeftButton);
			shiftLeftButton.addEventListener(MouseEvent.CLICK, shiftLeftListener);
			
			var shiftRightButton:RasterButton = new RasterButton('Shift Right', .5*menuWidth, new ColorBank().green);
			shiftRightButton.y = shiftLeftButton.y;
			shiftRightButton.x = shiftLeftButton.width;
			buttonHolder.addChild(shiftRightButton);
			shiftRightButton.addEventListener(MouseEvent.CLICK, shiftRightListener);
			
			saveImageButton = new RasterButton('Save Image', menuWidth, new ColorBank().pink);
			saveImageButton.y = shiftRightButton.y+35;
			buttonHolder.addChild(saveImageButton);
			saveImageButton.addEventListener(MouseEvent.CLICK, saveImage);
		}
	}
}
