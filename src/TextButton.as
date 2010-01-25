package 
{
	import flash.display.*;
	import flash.text.*;
	public class TextButton extends Sprite
	{
		public function TextButton(text:String, textColor:uint, backerColor:uint, backerAlpha:Number, width:uint, height:uint) 
		{
			graphics.beginFill(backerColor, backerAlpha);
			graphics.drawRect(0, 0, width, height);
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = textColor;
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.width = width;
			tf.height = height;
			tf.selectable =  false;
			tf.text = text
			addChild(tf);
		}
	}
}
