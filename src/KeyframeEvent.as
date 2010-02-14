package
{
	import flash.events.*;
	
	public class KeyframeEvent extends Event
	{
		public static const SHIFT_LEFT:String = 'shift left';
		public static const SHIFT_RIGHT:String = 'shift right';
		public static const POSITION_CHANGE:String = 'position change';
		public static const POSITION_SWAP:String = 'position swap';
		public static const POSITION_DELETE:String = 'position delete';
		public static const KEYFRAME_SELECTED:String = 'keyframe selected';
		public static const KEYFRAME_DELETED:String = 'keyframe deleted';
		public static const KEYFRAME_EDITED:String = 'keyframe edited';
		public static const KEYFRAME_DISPATCH:String = 'keyframe dispatched';
		
		public var positionKeyframe:PositionKeyframe;
		public var playSounds:Boolean;
		
		
		
		public function KeyframeEvent(type:String,
									positionKeyframe:PositionKeyframe = null, playSounds:Boolean = false)
		{
			
		
			super(type,false,false);
			this.playSounds = playSounds;
			this.positionKeyframe = positionKeyframe;
			
			
		}
	}
}
