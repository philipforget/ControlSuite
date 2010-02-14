package 
{
	import flash.display.*;
	import com.makingthings.makecontroller.*;
	import caurina.transitions.*;
	
	public class LightTween extends Sprite
	{
		public var lightValue:int;
		private var mcConnect:McFlashConnect;
		private var board:Board;
		private var lightNumber:uint;
		
		public function LightTween(mcConnect:McFlashConnect, board:Board, lightNumber:uint) 
		{
			this.lightNumber = lightNumber;
			this.mcConnect = mcConnect;
			this.board = board;
			this.lightValue = new uint(0);
		}
		
		public function tweenValues(valueArray:Array):void
		{
			Tweener.removeTweens(this);
			var milisecondDelay:Number = valueArray.lightDelay / 1000;
			Tweener.addTween(this, { lightValue:valueArray.lightValue, transition:'easeNone', time:milisecondDelay, onUpdate:sendTween } );
		}
		
		private function sendTween():void
		{
			mcConnect.sendToBoard('/pwmout/' + lightNumber + '/duty', [this.lightValue], board);
		}
		
	}
	
}
