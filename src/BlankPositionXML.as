package
{
	import flash.xml.*;
	public class BlankPositionXML {
				
		public var positionXMLList:XMLList;
		public function BlankPositionXML(positionID:uint):void
		{
			var positionXML:XML =<position>
					  <positionInformation>
						<positionName>Blank Position</positionName>
						<positionID>PositionID</positionID>
						<positionDescription>blank position description</positionDescription>
						<positionColor></positionColor>
					  </positionInformation>
					  <positionKeyframes>
					  </positionKeyframes>
					</position>;
			positionXML.positionInformation.positionColor = new FavoriteColorPicker().randomColor();
			positionXML.positionKeyframes.positionKeyframe = new BlankKeyframeXML(0).keyframeXMLList;
			positionXML.positionInformation.positionID = positionID;
			positionXMLList = new XMLList(positionXML);
		}
	}
}
