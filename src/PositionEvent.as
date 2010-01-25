package
{
	import flash.events.*;
	
	public class PositionEvent extends Event
	{
		public static const POSITION_SELECTED:String = 'selected';
		public static const POSITION_UNSELECTED:String = 'unselected';
		public static const POSITION_EDITED:String = 'edited';
		public static const POSITION_TITLE_CHANGED:String = 'title changed';
		public static const POSITION_DELETED:String = 'deleted';
		public static const POSITION_ADDED:String = 'added';
		public static const POSITION_IMAGE_EDITED:String = 'added';
		
		public var position:Position;
		public var playPosition:Boolean
		public function PositionEvent(type:String,position:Position = null, playPosition:Boolean = false)
		{
			
			super(type,false,false);
			
			this.position = position;			
			this.playPosition = playPosition;
		}
		
	}
}
