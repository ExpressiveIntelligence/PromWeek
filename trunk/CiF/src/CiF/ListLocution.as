package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Aaron Reed
	 */
	public class ListLocution implements Locution
	{
		public var realizedString:String;
		public var rawString:String = "";
		
		public var type:String;
		public var who1:String;
		public var who2:String;
		
		public var subject:String = ""
		public var object:String = "";
		
		public var speaker:String = ""
		public var speakee:String = "";		
		
		public function ListLocution() 
		{
			
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			var list1Name:String = "";
			var list2Name:String = "";
			if (who1 == "i")
			{
				list1Name = initiator.characterName;
			}
			else if (who1 == "r")
			{
				list1Name = responder.characterName;
			}
			else if (who1 == "o")
			{
				list1Name = other.characterName;
			}
			if (who2 == "i")
			{
				list2Name = initiator.characterName;
			}
			else if (who2 == "r")
			{
				list2Name = responder.characterName;
			}
			else if (who2 == "o")
			{
				list2Name = other.characterName;
			}
			if (type.toLowerCase() == "we/they")
			{
				realizedString = "they";
			}
			else if (type.toLowerCase() == "us/them")
			{
				realizedString = "them";
			}
			else if (type.toLowerCase() == "our/their")
			{
				realizedString = "their";
			}
			else if (type.toLowerCase() == "and")
			{
				realizedString = list1Name + " and " + list2Name;
			}
			else if (type.toLowerCase() == "andp")
			{
				realizedString = list1Name + " and " + list2Name + "'s";
				
			}		
			
			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "ListLocution";
		}
	}
}