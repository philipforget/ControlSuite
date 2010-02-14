package
{
	import flash.events.*;
	import flash.display.*;
	public class Position extends Sprite{
		
		private var positionKeyframeList:XMLList;
		
		private var keyframeArray:Array;
		
		private var positionName:String;
		private var positionID:uint;
		private var positionDescription:String;
		private var positionColor:Number;
				
		
		
		public function Position(positionXML:XMLList):void
		{
			keyframeArray = new Array();
			
			positionName = String(positionXML.positionInformation.positionName);
			
			positionID = uint(positionXML.positionInformation.positionID);
			
			positionDescription = String(positionXML.positionInformation.positionDescription);
			
			positionColor = uint(positionXML.positionInformation.positionColor);
			for ( var i:uint = 0; i < positionXML.positionKeyframes.positionKeyframe.length(); i++)
			{
				var positionKeyframe:PositionKeyframe = new PositionKeyframe(new XMLList(positionXML.positionKeyframes.positionKeyframe[i]),this);
				keyframeArray.push(positionKeyframe);
				
			}
		}
		
		// Swaps the position objects in the positions array in the correct position order for XML output
		// set to public because newly added keyframes need to have the listener applied to them on creation 
		// through the position object that is passed along the chain
		
		
		
		public function getPositionName():String
		{
			return positionName;
		}
		
		
		public function getPositionColor():Number
		{
			return positionColor;
		}
		
		public function getPositionDescription():String
		{
			return positionDescription;
		}
		
		public function getPositionID():uint
		{
			return positionID;
		}
		
		public function setPositionID(positionID:uint):void
		{
			this.positionID = positionID;
		}
		
		public function getPositionKeyframeArray():Array
		{
			return keyframeArray;
		}
		
		public function getKeyframe(keyframeIndex:uint):PositionKeyframe
		{
			return keyframeArray[keyframeIndex];
		}
		
		public function getKeyframeArray():Array
		{
			return keyframeArray;
		}
		
		
		public function getPositionXML():XML
		{
			// start the initial position xml parse
			
			var positionXML:XML = <position/>
			
			//set the position name and description properties
		
			positionXML.positionInformation.positionName = getPositionName();
			positionXML.positionInformation.positionID = getPositionID();
			positionXML.positionInformation.positionDescription = getPositionDescription();
			positionXML.positionInformation.positionColor = "0x"+getPositionColor().toString(16).toUpperCase();
			// start the keyframes list
			
			var keyframesXML:XML = <positionKeyframes/>;
			
			// iterrate through the keyframes array and generate the keyframes individual xml structure
			
			var tempArray:Array = new Array()
			for (var i:uint = 0; i < keyframeArray.length; i++)
			{
				keyframesXML.appendChild(keyframeArray[i].getKeyframeXML());
			}
			//append the keyframes xml list to the position information
			//
			positionXML.positionKeyframes = keyframesXML;
			return(positionXML);
		}
		
		public function setPositionColor(color:uint):void
		{
			this.positionColor = color;
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, this));
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_TITLE_CHANGED, this));
			
		}
		public function setPositionName(positionName:String):void
		{
			this.positionName = positionName;
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED,  this));
		}
		public function setPositionDescription(positionDescription:String):void
		{
			this.positionDescription = positionDescription;
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, this));
		}
	}
}
