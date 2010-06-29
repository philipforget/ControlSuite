package
{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.net.*;
	import caurina.transitions.*;
	
	public class PositionBankObject extends Sprite{
		private var currentKeyframe:uint = 0;
		
		private var position:Position;
		
		private var backerRaster:SimpleRaster;
		
		private var iconOverlay:Sprite;
		private var iconLoader:Loader;
		private var iconHolder:Sprite;
		private var imageWidth:uint = 60;
		private var imageHeight:uint = 80;
		
		private var scrubberMin:Number = 0;
		private var scrubberMax:Number;
		private var scrubberXOffset:Number = 0;
		
		private var positionNameText:TextField;
		private var positionNameTextBacker:Sprite;
		
		
		private var positionDescriptionText:TextField;
		
		private var positionFormat:TextFormat;
		private var positionFormatBlack:TextFormat;
		private var positionDescriptionFormat:TextFormat;
		
		private var backerSprite:Sprite;
		private var keyFrameNavigation:Sprite;
		
		private var objectConnection:ObjectConnection;
		
		private var positionBankWidth:uint;
		
		public function PositionBankObject(objectConnection:ObjectConnection, position:Position, positionBankWidth:uint):void
		{
			this.objectConnection = objectConnection;
			
			this.position = position;
			
			this.positionBankWidth = positionBankWidth;
			
			position.addEventListener(PositionEvent.POSITION_EDITED, update);
			
			backerRaster = new SimpleRaster(0x11FFFFFF);
			backerSprite = new Sprite();
			
			backerSprite.graphics.beginBitmapFill(backerRaster);
			backerSprite.graphics.drawRect(0, 0, positionBankWidth, imageHeight + 30);
			
			addChild(backerSprite);
			
			positionFormat = new TextFormat();
			positionFormat.font = 'Ahron';
			positionFormat.align = TextFormatAlign.LEFT;
			positionFormat.size = 18;
			positionFormat.color = 0xffffff;
			
			positionFormatBlack = new TextFormat();
			positionFormatBlack.font = 'Ahron';
			positionFormatBlack.align = TextFormatAlign.LEFT;
			positionFormatBlack.size = 18;
			positionFormatBlack.color = 0x000000;
			
			positionDescriptionFormat = new TextFormat();
			positionDescriptionFormat.color = 0xFFFFFF;
			positionDescriptionFormat.font = "PixelMix"
			positionDescriptionFormat.size = 8;
			
			positionNameTextBacker = new Sprite();
			drawNameBacker();
			positionNameText = new TextField();
			positionNameText.defaultTextFormat = positionFormat;
			positionNameText.embedFonts = true;
			positionNameText.width = positionBankWidth;
			positionNameText.autoSize = TextFieldAutoSize.LEFT;
			positionNameText.type = TextFieldType.INPUT;
			positionNameText.addEventListener(Event.CHANGE, titleChangeListener);
			
			positionDescriptionText = new TextField();
			positionDescriptionText.restrict = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .1234567890(),';
			positionDescriptionText.width = positionBankWidth - imageWidth - 2;
			positionDescriptionText.height = imageHeight;
			positionDescriptionText.autoSize = TextFieldAutoSize.LEFT;
			positionDescriptionText.wordWrap = true;
			positionDescriptionText.embedFonts = true;

			positionDescriptionText.type = TextFieldType.INPUT;
			positionDescriptionText.addEventListener(Event.CHANGE, descriptionChangeListener);
			
			positionDescriptionText.y = 20;
			positionDescriptionText.x = 2;
			
			positionDescriptionText.defaultTextFormat = positionDescriptionFormat;
			
			addChild(positionNameTextBacker);
			
			var colorPickerIcon:ColorPickerIcon = new ColorPickerIcon();
			colorPickerIcon.x = positionBankWidth - 18;
			colorPickerIcon.y = 3;
			addChild(colorPickerIcon);
			colorPickerIcon.addEventListener(MouseEvent.CLICK, callColorPicker);
			
			addChild(positionDescriptionText);
			addChild(positionNameText);
			
			keyFrameNavigation = new Sprite();
			keyFrameNavigation.graphics.beginFill(0x000000, 0);
			keyFrameNavigation.graphics.drawRect(0, 0, positionBankWidth, 10);
			keyFrameNavigation.y = 20+imageHeight;
			
			addChild(keyFrameNavigation);
			
			iconLoader = new Loader();
			iconLoader.addEventListener(IOErrorEvent.IO_ERROR, loader_error);
			
			var iconLoaderMask:Sprite = new Sprite();
			iconLoaderMask.graphics.beginFill(0xFF0000);
			iconLoaderMask.graphics.drawRect(0, 0, imageWidth, imageHeight);
			iconLoaderMask.cacheAsBitmap = true;
			addChild(iconLoaderMask);
			addChild(iconLoader);
			
			iconLoader.y = 20;
			iconLoaderMask.y = 20;
			
			iconLoader.x = positionBankWidth - imageWidth;
			iconLoaderMask.x = positionBankWidth-imageWidth;
			
			iconLoader.mask = iconLoaderMask;
			
			iconLoader.scaleX=.25;
			iconLoader.scaleY = .25;
			
			iconOverlay = new Sprite();
			iconOverlay.name = "scrubber";
			iconOverlay.addEventListener(MouseEvent.MOUSE_DOWN, scrubberDown);
			iconOverlay.useHandCursor = true;
			iconOverlay.buttonMode = true;
			
			iconHolder = new Sprite();
			keyFrameNavigation.addChild(iconHolder);
			
			iconHolder.addChild(iconOverlay);
			
			drawCell();
			unsetCurrentPosition();
		}
		
		private function update(e:PositionEvent):void
		{
			drawCell()
		}
		private function drawCell():void
		{
			
			var positionKeyframeArray:Array = position.getPositionKeyframeArray();
			
			if (currentKeyframe >= positionKeyframeArray.length)
				currentKeyframe--;
			
			positionNameText.text = position.getPositionName();
			positionDescriptionText.text = position.getPositionDescription();
			positionNameText.backgroundColor = position.getPositionColor();
			
			if (!currentKeyframe)
				currentKeyframe = 0;
				
			iconLoader.load(new URLRequest("/static/KeyframeImages/" + position.getKeyframe(currentKeyframe).getKeyframeImage()));

			var iconLength:Number = (positionBankWidth) / positionKeyframeArray.length;
			scrubberMax = positionBankWidth - iconLength;
			try
			{
				while (iconHolder.getChildAt(0))
					iconHolder.removeChildAt(0);
			}
			catch (e:Error)
			{
				
			}
			for (var a:uint = 0; a < positionKeyframeArray.length; a++ )
			{
				var icon:Sprite = new Sprite();
				var backerRaster:SimpleRaster = new SimpleRaster(0x00FFFFFF,positionKeyframeArray[a].getKeyframeColor());
				icon.graphics.beginBitmapFill(backerRaster);
				//icon.graphics.lineStyle(1, positionKeyframeArray[a].getKeyframeColor());
				icon.graphics.drawRect(0, 0, iconLength, 10);
				icon.x = a * iconLength;
				iconHolder.addChild(icon);
				icon.name = a.toString();
				icon.addEventListener(MouseEvent.CLICK, keyFrameClick);
				icon.buttonMode = true;
				icon.useHandCursor = true;
			}
			
			var overlayRaster:SimpleRaster = new SimpleRaster(0xFFFFFFFF);
		
			iconOverlay.graphics.clear();
			iconOverlay.graphics.lineStyle(2, 0xFFFFFF);
			iconOverlay.graphics.beginBitmapFill(overlayRaster);
			iconOverlay.graphics.drawRect(1, 1, iconLength - 2, 8);
			
			iconHolder.addChild(iconOverlay);
			
			showKeyframe(currentKeyframe);
			
			drawNameBacker();
		}
		private function scrubberDown(e:Event):void
		{
			scrubberXOffset = mouseX - iconOverlay.x;
			
			stage.addEventListener(MouseEvent.MOUSE_UP,	mouseUpListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,	mouseMoveListener);
		}
		
		
		private function mouseUpListener(e:Event):void
		{
			showKeyframe(Math.floor((iconOverlay.x+(.5*iconOverlay.width) )/ iconOverlay.width));
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpListener);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			var tempIndex:Number = Math.floor((iconOverlay.x+(.5*iconOverlay.width) )/ iconOverlay.width);
			try {
				if (tempIndex != currentKeyframe){
					showKeyframeImage(Math.floor((iconOverlay.x+(.5*iconOverlay.width) )/ iconOverlay.width));
				}
			}
			catch(e:Error){}

			iconOverlay.x=mouseX-scrubberXOffset;
			
			if(iconOverlay.x <= scrubberMin)
				iconOverlay.x = scrubberMin;
			if(iconOverlay.x >= scrubberMax)
				iconOverlay.x = scrubberMax;
			
			e.updateAfterEvent();
		}
		
		private function keyFrameClick(e:Event):void
		{
			showKeyframe(Number(e.target.name));
		}
		
		private function showKeyframe(index:Number):void
		{
			if(currentKeyframe!=index){
				iconLoader.load(new URLRequest("/static/KeyframeImages/"+position.getKeyframe(index).getKeyframeImage()));
			}

			currentKeyframe = index;
			
			Tweener.removeTweens(iconOverlay);
			Tweener.addTween(iconOverlay, { x:iconOverlay.width * index, time:.5 } );
			
		}
		
		private function showKeyframeImage(index:Number):void
		{
			currentKeyframe = index;
			iconLoader.load(new URLRequest("/static/KeyframeImages/"+position.getKeyframe(index).getKeyframeImage()));

		}
		
		public function getPosition():Position
		{
			return(position);
		}
		
		public function setPosition(position:Position):void
		{
			this.position = position;
		}
		
		
		public function setCurrentPosition():void
		{
			this.positionNameTextBacker.blendMode = BlendMode.NORMAL
			positionNameText.setTextFormat(positionFormat);
			positionNameText.alpha = 1;
			positionDescriptionText.alpha = 1;
		}
		
		public function unsetCurrentPosition():void
		{
			
			this.positionNameTextBacker.blendMode = BlendMode.OVERLAY;
			positionNameText.setTextFormat(positionFormatBlack);
			positionNameText.alpha = .5;
			positionDescriptionText.alpha = .5
		}
		
		private function titleChangeListener(e:Event):void
		{
			if (positionNameText.width < 280)
			{
				position.setPositionName(positionNameText.text);
				position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_TITLE_CHANGED, position));
			}
			else
				positionNameText.text = positionNameText.text.substring(0, positionNameText.text.length - 1);
			
		}

		private function descriptionChangeListener(e:Event):void
		{
			if (positionDescriptionText.height < imageHeight)
			{
				position.setPositionDescription(positionDescriptionText.text);
			}
			else
				positionDescriptionText.text = positionDescriptionText.text.substring(0, positionDescriptionText.text.length - 1);
		}
		
		private function drawNameBacker():void
		{
			positionNameTextBacker.graphics.clear();
			positionNameTextBacker.graphics.beginFill(position.getPositionColor());
			positionNameTextBacker.graphics.drawRect(0, 0, positionBankWidth, 20);
		}
		
		private function callColorPicker(e:MouseEvent ):void
		{
			objectConnection.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.COLOR_CALL, false, false, 0xFFFF0000, position.setPositionColor));
		}

		private function loader_error(e:IOErrorEvent):void {
		}
	}
}
