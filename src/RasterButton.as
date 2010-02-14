package
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.display.*;
	
	public class RasterButton extends Sprite
	{
		private var button:SimpleButton;
		private var buttonStandard:Sprite;
		private var buttonOver:Sprite;
		private var buttonDown:Sprite;
		private var buttonHitSprite:Sprite;
		
		private var buttonFormat:TextFormat;
		private var buttonFormatOver:TextFormat;
		
		private var simpleRaster:SimpleRaster;
		
		private var textField:TextField;
		private var textFieldOver:TextField;
		
		
		public function RasterButton(buttonText:String, buttonWidth:Number, textColorOver:Number,deleteButton:Boolean = false):void
		{
			simpleRaster = new SimpleRaster(0x00FFFFFF,textColorOver);
			
			buttonFormat = new TextFormat();
			buttonFormat.font = 'Ahron';
			buttonFormat.align = TextFormatAlign.CENTER;
			buttonFormat.size = 14;
			buttonFormat.color = textColorOver;
			
			buttonFormatOver = new TextFormat();
			buttonFormatOver.font = 'Ahron';
			buttonFormatOver.align = TextFormatAlign.CENTER;
			buttonFormatOver.size = 14;
			buttonFormatOver.color = 0xFFFFFF;
			buttonFormatOver.leading = -1;
			
			textField = new TextField();
			textField.defaultTextFormat = buttonFormat;
			textField.width = buttonWidth;
			textField.text = buttonText;
			textField.height = 20;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.y = 1;
			
			textFieldOver = new TextField();
			textFieldOver.defaultTextFormat = buttonFormatOver;
			textFieldOver.width = buttonWidth;
			textFieldOver.text = buttonText;
			textFieldOver.height = 20;
			textFieldOver.embedFonts = true;
			textFieldOver.multiline = true;
			textFieldOver.selectable = false;
			textFieldOver.y = 1;
			
			if (deleteButton)
			{
				textFieldOver.appendText("\nDouble Click");
			}
			var buttonStandard:Sprite = new Sprite();
			
			buttonStandard.graphics.beginBitmapFill(simpleRaster);
			buttonStandard.graphics.drawRect(0, 20, buttonWidth, 10);
			buttonStandard.addChild(textField);

			
			buttonOver = new Sprite();
			buttonOver.graphics.beginBitmapFill(simpleRaster);
			buttonOver.graphics.drawRect(0, 0, buttonWidth, 30);
			
			buttonOver.addChild(textFieldOver);
			
			buttonDown = new Sprite();
			buttonDown.graphics.beginBitmapFill(simpleRaster);
			buttonDown.graphics.drawRect(0, 20, buttonWidth, 10);
			
			buttonHitSprite = new Sprite();
			buttonHitSprite.graphics.beginFill(0xFF0000, 1);
			buttonHitSprite.graphics.drawRect(0, 0, buttonWidth, 35);
			
			button = new SimpleButton(buttonStandard, buttonOver, buttonDown, buttonHitSprite);
			
			addChild(button);
			
			if (deleteButton){
				button.doubleClickEnabled = true;
				button.useHandCursor = false;
			}
		}
		
		public function setLabel(labelText:String):void
		{
			textField.text = labelText;
			textFieldOver.text = labelText;
		}
	}
}
