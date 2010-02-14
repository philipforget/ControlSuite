package 
{
	
	public class RotateAllChildren 
	{
		
		public function RotateAllChildren() 
		{
			
		}
		
		private function focusListener(e:MouseEvent):void
		{
			//randomlyLoopChildren(stage);
				
		}
		
		private function randomlyLoopChildren(container:Object):void
		{
			if (container.name != null && container.name != 'root1')
			{
				//Tweener.addTween(container,{rotation:-1 + Math.floor(Math.random() * 2),time:Math.random()*2});
			container.rotation += -5 + (Math.floor(Math.random() * 10));
			}
			if (container.numChildren)
				for (var i:uint = 0; i < container.numChildren; i++)
				{
					if (!(container.getChildAt(i) is TextField)&&!(container.getChildAt(i) is SimpleButton)&&!(container.getChildAt(i) is Bitmap)&&!(container.getChildAt(i) is Video))
						randomlyLoopChildren(container.getChildAt(i));
				}
		}
		
	}
	
}
