package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class PronounLocution implements Locution
	{
		public var realizedString:String;
		public var rawString:String = "";
		
		public var type:String;
		public var who:String;
		public var isSubject:Boolean = false;
		
		public var subject:String = ""
		public var object:String = "";
		
		public var speaker:String = ""
		public var speakee:String = "";		
		
		public function PronounLocution() 
		{
			
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			if (type.toLowerCase() == "he/she")
			{
				if (who == "i") 
					if (initiator.hasTrait(Trait.MALE)) realizedString = "he" 
					else realizedString = "she";
				else if (who == "r") 
					if (responder.hasTrait(Trait.MALE)) realizedString = "he" 
					else realizedString = "she";
				else if (who == "o") 
					if (other.hasTrait(Trait.MALE)) realizedString = "he" 
					else realizedString = "she";
			}
			else if (type.toLowerCase() == "his/her")
			{
				if (who == "i") 
					if (initiator.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "her";
				else if (who == "r") 
					if (responder.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "her";
				else if (who == "o") 
					if (other.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "her";
			}
			else if (type.toLowerCase() == "his/hers")
			{
				if (who == "i") 
					if (initiator.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "hers";
				else if (who == "r") 
					if (responder.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "hers";
				else if (who == "o") 
					if (other.hasTrait(Trait.MALE)) realizedString = "his" 
					else realizedString = "hers";
			}
			else if (type.toLowerCase() == "him/her")
			{
				if (who == "i") 
					if (initiator.hasTrait(Trait.MALE)) realizedString = "him" 
					else realizedString = "her";
				else if (who == "r") 
					if (responder.hasTrait(Trait.MALE)) realizedString = "him" 
					else realizedString = "her";
				else if (who == "o") 
					if (other.hasTrait(Trait.MALE)) realizedString = "him" 
					else realizedString = "her";
			}
			else if (type.toLowerCase() == "he's/she's")
			{
				if (who == "i") 
					if (initiator.hasTrait(Trait.MALE)) realizedString = "he's" 
					else realizedString = "she's";
				else if (who == "r")
					if (responder.hasTrait(Trait.MALE)) realizedString = "he's" 
					else realizedString = "she's";
				else if (who == "o") 
					if (other.hasTrait(Trait.MALE)) realizedString = "he's" 
					else realizedString = "she's";				
			}
			else if (type.toLowerCase() == "was/were")
			{
				realizedString = "was";			
			}			
			
			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "PronounLocution";
		}
	}
}