package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class GenderLocution implements Locution
	{
		public var realizedString:String;
		public var rawString:String = "";
		
		public var who:String;
		
		public var maleString:String;
		public var femaleString:String;
		
		public function GenderLocution() 
		{
			
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			
			if (who == "i") 
				if (initiator.hasTrait(Trait.MALE)) realizedString = maleString 
				else realizedString = femaleString;
			else if (who == "r") 
				if (responder.hasTrait(Trait.MALE)) realizedString = maleString
				else realizedString = femaleString;
			else if (who == "o") 
				if (other.hasTrait(Trait.MALE)) realizedString = maleString
				else realizedString = femaleString;

			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "GenderLocution";
		}
	}
}