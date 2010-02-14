package
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class PositionLabel extends Sprite{
		
		private var backerSprite:Sprite;
		private var positionLabel:TextField;
		private var textFormat:TextFormat;
		private var position:Position;
		public function PositionLabel():void
		{
			
			backerSprite = new Sprite();
			
			textFormat = new TextFormat();
			textFormat.font = 'Ahron';
			textFormat.color = 0xFFFFFF;
			textFormat.size = 45;

			positionLabel = new TextField();
			positionLabel.autoSize = TextFieldAutoSize.LEFT;
			positionLabel.embedFonts = true;
			positionLabel.defaultTextFormat = textFormat;
			positionLabel.x = -4;
			positionLabel.y = -15;
			positionLabel.selectable = false;
			
			addChild(backerSprite);
			addChild(positionLabel);
			
			clearLabel();
		}
		
		public function setLabel(labelText:String, backerColor:uint):void
		{
			
			positionLabel.text = labelText;
			
			var stripRaster:SimpleRaster = new SimpleRaster(0x00FFFFFF,backerColor);
			backerSprite.graphics.clear();
			backerSprite.graphics.beginBitmapFill(stripRaster);
			backerSprite.graphics.drawRect(positionLabel.width, 0, 1040-positionLabel.width, 20);
		}
		
		public function clearLabel():void
		{
			setLabel("No Position Selected",0xFF666666);
		}
		public function setPosition(position:Position):void
		{
			this.position = position;
		}
	}
}
