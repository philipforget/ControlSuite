package
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	
	public class FavoriteColorPicker extends Sprite
	{
		private var colorPicker:Sprite;
		private var colorSelectIcon:Sprite;
		private var mouseHitSprite:Sprite;
		private var closeOnPick:Boolean;
		private var colorArray:Array;
		private var cancelBox:Sprite;
		
		public  var colorPickerHeight:uint = 92;
		public  var colorPickerWidth:uint = 92;
		
		public function FavoriteColorPicker(backerColor:uint = 0x33FFFFFF, closeOnPick:Boolean = true):void
		{
			this.closeOnPick = closeOnPick;
			cancelBox = new Sprite();
			cancelBox.graphics.beginBitmapFill(new SimpleRaster(backerColor));
			cancelBox.graphics.drawRect( -1440, -1440, 2800, 2800);
			cancelBox.mouseChildren = false;
			addChild(cancelBox);
			
			
			colorArray = new Array();
			

			colorArray.push(0xFFD14927,0xFFEBD9A4,0xFF336061,0xFF133436,0xFF696551);

			colorArray.push(0xFFFFF655,0xFFFF3F3F,0xFF982529,0xFF00B0D8,0xFFD1ECF0);

			colorArray.push(0xFF99851F,0xFFADCF4F,0xFF84815B,0xFF4A392C,0xFF8E3557);

			colorArray.push(0xFF2E0927,0xFFD90000,0xFFFF2D00,0xFFFF8C00,0xFF04756F);

			colorArray.push(0xFFB8ECD7,0xFF083643,0xFFB1E001,0xFFCEF09D,0xFF476C5E); 

			var border:uint = 2;
			var iconHeight:uint = 16;
			var iconWidth:uint = 16;

			var colWidth:uint = 5;

			var col:uint = 0;
			var row:uint = 0;

			colorPicker = new Sprite();
			colorPicker.graphics.beginFill(0x000000);

			colorSelectIcon = new Sprite();
			colorSelectIcon.graphics.beginFill(0xFFFFFF);
			colorSelectIcon.graphics.drawRect(border, border + iconHeight/2, iconWidth, iconHeight/2);

			colorSelectIcon.blendMode = BlendMode.INVERT;


			for each(var color:uint in colorArray){
				var colorIcon:Sprite = new Sprite;
				colorIcon.graphics.beginFill(color);
				colorIcon.graphics.drawRect(border,border,iconWidth,iconHeight);
				colorIcon.x = col*(iconWidth+border);
				colorIcon.y = row * (iconHeight + border);
				colorIcon.name = 'color icon';
				colorPicker.addChild(colorIcon);
				col++;
				if(col!=0&&(col%colWidth==0)){
					row++
					col=0;
				}
			}

			colorPicker.addChild(colorSelectIcon);

			colorPicker.graphics.drawRect(0,0,colorPicker.width+border*2,colorPicker.height+border*2);

			addChild(colorPicker);
			
			
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			cancelBox.addEventListener(MouseEvent.CLICK, cancelPick);
			
		}
		
		
		public function truelyRandomColor():uint
		{
			var colors:Array = new Array();
			colors[0]="0"
			colors[1]="1"
			colors[2]="2"
			colors[3]="3"
			colors[4]="4"
			colors[5]="5"
			colors[5]="6"
			colors[6]="7"
			colors[7]="8"
			colors[8]="9"
			colors[9]="a"
			colors[10]="b"
			colors[11]="c"
			colors[12]="d"
			colors[13]="e"
			colors[14] = "f"
			
			var colorString:String = new String();
			colorString = '0x';
			for (var i:uint=0;i<6;i++){
				colorString += colors[Math.floor(Math.random() * colors.length)];
			}
			return(uint(colorString));
		}
		
		private function mouseDownListener(e:MouseEvent):void
		{
			var tempBMP:BitmapData = new BitmapData(colorPicker.width, colorPicker.height,false,0x00000000);
			tempBMP.draw(colorPicker);
			if(tempBMP.getPixel(mouseX, mouseY)){
				var tempColor:uint = tempBMP.getPixel32(mouseX, mouseY);
				dispatchEvent(new ColorPickerEvent(ColorPickerEvent.COLOR_SELECTED, false, false, tempColor));
				//if (closeOnPick)
				///	clearListeners();
			}
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			if (e.target.name == 'color icon'){
				colorSelectIcon.x = e.target.x;
				colorSelectIcon.y = e.target.y;
			}
		}
		
		private function cancelPick(e:MouseEvent):void
		{
			dispatchEvent(new ColorPickerEvent(ColorPickerEvent.COLOR_CANCELED));
			//clearListeners();
		}
		private function clearListeners():void
		{
			cancelBox.removeEventListener(MouseEvent.CLICK, cancelPick);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			
		}
			
		public function randomColor():uint
		{
			return(colorArray[Math.floor(Math.random() * colorArray.length)]);
		}
	}
}
