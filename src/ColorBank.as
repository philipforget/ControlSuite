package
{
	public class ColorBank
	{
		
		public var white:uint = 0xFFFFFFFF;
		public var grey:uint = 0xFF333333;
		public var pink:uint = 0xFFFF358B;
		public var blue:uint = 0xFF01B0F0;
		public var green:uint = 0xFF87EE17;
		public var red:uint = 0xFFFF3029;
		
		public function ColorBank():void
		{
			
		}
		public function randomColor():uint
		{
			var colorReturn:uint = new uint();
			
			switch(Math.floor(Math.random()*4))
			{
				case 0:
					colorReturn = pink;
					break;
				case 1:
					colorReturn = blue;
					break;
				case 2:
					colorReturn = green;
					break;
				case 3:
					colorReturn = red;
					break;
			}
			return colorReturn;
		}
	}
}
