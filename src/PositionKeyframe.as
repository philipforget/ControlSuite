package
{
	import flash.display.Sprite;

	public class PositionKeyframe extends Sprite
	{
		
		public var servoPositionArray:Array;
		
		private var keyframeOrder:uint;
		private var keyframeDelay:uint;
		private var keyframeColor:uint;
		private var keyframeImage:String;
		private var position:Position;
		private var keyframeSoundLoopCount:uint;
		private var keyframeSound:String;
		private var keyframeClearsSounds:Boolean;
		private var keyframeSoundVolume:uint;
		private var keyframeSoundPan:int;
		
		private var lightValueArray:Array;
		
		public function PositionKeyframe(keyframeList:XMLList, position:Position):void
		{			
			this.position = position;
			this.keyframeOrder = keyframeList.keyframeOrder;
			this.keyframeDelay = keyframeList.keyframeDelay;
			this.keyframeColor = keyframeList.keyframeColor;
			this.keyframeImage = keyframeList.keyframeImage;
			this.keyframeSound = keyframeList.keyframeSound;
			this.keyframeSoundLoopCount = keyframeList.keyframeSoundLoopCount;
			
			if ( keyframeList.keyframeClearsSounds == 'false')
				this.keyframeClearsSounds = false;
			else
				this.keyframeClearsSounds = true;
			
			this.keyframeSoundVolume = keyframeList.keyframeSoundVolume;
			this.keyframeSoundPan = keyframeList.keyframeSoundPan;
			
			lightValueArray = new Array();
			for (var i:uint = 0; i < 8; i++)
			{
				lightValueArray.push(keyframeList.lightProperties["light" + i]);
				
			}
						
			servoPositionArray = new Array();
			for(i = 0;i<8;i++){
				var servoPosition:ServoPosition = new ServoPosition(new XMLList(keyframeList.servoProperties["servo"+i]));
				servoPositionArray.push(servoPosition);
			}
		}
		
		public function getServoPosition(servoIndex:uint):ServoPosition
		{
			return servoPositionArray[servoIndex];
		}
		
		public function getLightValueArray():Array
		{
			return lightValueArray;
		}
		
	
		public function setkeyframeLightValue(lightValueIndex:uint, lightValue:Boolean):void
		{
			lightValueArray[lightValueIndex] = uint(lightValue);
		}
		
		public function setServoPosition(servoIndex:uint,servoPosition:ServoPosition):void
		{
			servoPositionArray[servoIndex] = servoPosition;
		}
		
		public function getKeyframeColor():uint
		{
			return(keyframeColor);
		}
		
		public function setKeyframeColor(color:uint):void
		{
			keyframeColor = color;
			
			position.dispatchEvent(new PositionEvent(PositionEvent.POSITION_EDITED, position));
			dispatchEvent(new KeyframeEvent(KeyframeEvent.KEYFRAME_EDITED, this));
			
		}
		
		public function getKeyframeImage():String
		{
			return(keyframeImage);
		} 
		public function setKeyframeImage(keyframeImage:String):void
		{
			this.keyframeImage = keyframeImage;
		} 
		public function getKeyframeXML():XML
		{
			var positionKeyframeXML:XML = <positionKeyframe/>;
			
			positionKeyframeXML.keyframeDelay = keyframeDelay;
			positionKeyframeXML.keyframeOrder = keyframeOrder;
			positionKeyframeXML.keyframeColor = '0x' + keyframeColor.toString(16).toUpperCase();
			positionKeyframeXML.keyframeImage = keyframeImage;
			positionKeyframeXML.keyframeSound = keyframeSound;
			positionKeyframeXML.keyframeSoundLoopCount = keyframeSoundLoopCount;
			positionKeyframeXML.keyframeClearsSounds = keyframeClearsSounds;
			positionKeyframeXML.keyframeSoundVolume = keyframeSoundVolume;
			positionKeyframeXML.keyframeSoundPan = keyframeSoundPan;
			
			var lightXML:XML = <lightProperties/>
			
			for (var i:uint = 0; i < lightValueArray.length ; i++)
			{
				lightXML['light' + i] = lightValueArray[i];
			}
			positionKeyframeXML.lightProperties = lightXML;
			
			var servoXML:XML = <servoProperties/>
			for (i = 0; i < servoPositionArray.length ; i++)
			{
				var tempServo:XML = <tempServo/>;
				tempServo.servoPosition = servoPositionArray[i].getServoPosition();
				tempServo.servoSpeed = servoPositionArray[i].getServoSpeed();
				tempServo.setName("servo" + i);
				servoXML.appendChild(tempServo);
			}
			
			positionKeyframeXML.servoProperties = servoXML;
			
			return(positionKeyframeXML);
		}
		
		public function getLightProperties():XML
		{
			var lightXML:XML = <lightProperties/>
			
			for (var i:uint = 0; i < lightValueArray.length ; i++)
			{
				lightXML['light' + i] = lightValueArray[i];
			}
			return(lightXML);
		}
		
		public function getServoProperties():XML
		{
			
			var servoXML:XML = <servoProperties/>
			for (var i:uint = 0; i < servoPositionArray.length ; i++)
			{
				var tempServo:XML = <tempServo/>;
				tempServo.servoPosition = servoPositionArray[i].getServoPosition();
				tempServo.servoSpeed = servoPositionArray[i].getServoSpeed();
				tempServo.setName("servo" + i);
				servoXML.appendChild(tempServo);
			}
			
			return(servoXML);
		}
		
		public function setServoProperties(servoXML:XML):void
		{
			servoPositionArray.length = 0;
			for (var i:uint = 0; i < 8; i++)
			{
				var servoPosition:ServoPosition = new ServoPosition(servoXML["servo"+i]);
				servoPositionArray.push(servoPosition);
			}
		}
		
		public function setLightProperites(lightXML:XML):void
		{
			lightValueArray.length = 0;
			for (var i:uint = 0; i < 8; i++)
			{
				lightValueArray.push(lightXML["light" + i]);
				
			}
		}
		
		public function setKeyframeDelay(keyframeDelay:uint):void
		{
			this.keyframeDelay = keyframeDelay;
		}
		public function getKeyframeDelay():uint
		{
			return keyframeDelay;
		}
		
		public function getKeyframeSound():String
		{
			return keyframeSound;
		}
		
		public function setKeyframeSound(keyframeSound:String):void
		{
			this.keyframeSound = keyframeSound;
		}
		
		public function getKeyframeSoundLoopCount():uint
		{
			return keyframeSoundLoopCount;
		}
		
		public function setKeyframeSoundLoopCount(keyframeSoundLoopCount:uint):void
		{
			this.keyframeSoundLoopCount = keyframeSoundLoopCount;
		}
		
		public function getKeyframeClearsSounds():Boolean
		{
			return keyframeClearsSounds;
		}
		
		public function setKeyframeClearsSounds(keyframeClearsSounds:Boolean):void
		{
			this.keyframeClearsSounds = keyframeClearsSounds;
		}
		
		public function getKeyframeSoundVolume():uint
		{
			return keyframeSoundVolume;
		}
		
		public function setKeyframeSoundVolume(keyframeSoundVolume:uint):void
		{
			this.keyframeSoundVolume = keyframeSoundVolume;
		}
		
		public function getKeyframeSoundPan():int
		{
			return keyframeSoundPan;
		}
		
		public function setKeyframeSoundPan(keyframeSoundPan:int):void
		{
			this.keyframeSoundPan = keyframeSoundPan;
		}
		
		public function setKeyframeOrder(keyframeOrder:uint):void
		{
			this.keyframeOrder = keyframeOrder;
			
		}
		public function getKeyframeOrder():uint
		{
			return keyframeOrder;
		}
	}
}
