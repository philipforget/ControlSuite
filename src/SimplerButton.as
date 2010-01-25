package 
{
	import flash.display.*;
	import flash.events.*;
	
	public class SimplerButton extends Sprite
	{
		public var upState:Sprite;
		public var overState:Sprite;
		public var downState:Sprite;
		public var hitTestState:Sprite;
		
		public var deleteButton:Boolean;
		
		public function SimplerButton(upState:Sprite, overState:Sprite, downState:Sprite, hitTestState:Sprite, deleteButton:Boolean = false) 
		{
			this.upState = upState;
			this.overState = overState;
			this.downState = downState;
			this.hitTestState = hitTestState;
			
			addChild(upState);
			
			hitTestState.buttonMode = true;
			if (!deleteButton)
				hitTestState.useHandCursor = true;
		}
		
	}
	
}
