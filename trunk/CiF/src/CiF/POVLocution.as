package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Aaron Reed
	 */
	public class POVLocution implements Locution
	{
		public var realizedString:String;
		public var rawString:String = "";
		
		public var initiatorString:String;
		public var responderString:String;
		public var defaultString:String;
		
		public var subject:String = ""
		public var object:String = "";
		
		public var speaker:String = ""
		public var speakee:String = "";		
		
		public function POVLocution() 
		{
			
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			realizedString += defaultString;
			
			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "POVLocution";
		}
	}
}