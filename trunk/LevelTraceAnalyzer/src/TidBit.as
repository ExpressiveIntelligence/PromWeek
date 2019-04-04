package  
{
	import CiF.*;
	import flash.geom.Vector3D;

	public class TidBit
	{	
		/**
		 * This is the text that gets displayed to the user on the pre-level screen
		 */
		public var originalTemplateString:String
		public var locutions:Vector.<Locution>;
		public var hasBeenSeen:Boolean;
		
		public function TidBit()
		{
			this.locutions = new Vector.<Locution>();
			this.hasBeenSeen = false;
		}
		
		public function renderText(initiator:Character, responder:Character, other:Character=null):String
		{
			var returnString:String = "";
			for each (var loc:Locution in this.locutions)
			{
				returnString += loc.renderText(initiator,responder,other, null);
			}
			return returnString;
		}
	}
}