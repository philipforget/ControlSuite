package 
{
	import flash.display.BitmapData;
	
	public class SimpleRaster extends BitmapData
	{
		public function SimpleRaster(lineColor:Number = 0xFF000000,backerColor:Number = 0x00FFFFFF):void
		{
			super(3, 3, true, backerColor);
			this.setPixel32(0, 2, lineColor);
			this.setPixel32(1, 1, lineColor);
			this.setPixel32(2, 0, lineColor);
		}
		
	}
	
}
