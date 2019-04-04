package CiF 
{

	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class ConditionalLocution implements Locution
	{
		public var ifRuleID:int;
		public var ifRuleString:String;
		
		public var elseIfRuleIDs:Vector.<int>;
		public var elseIfStrings:Vector.<String>;
		
		public var elseString:String;
		
		public function ConditionalLocution() 
		{
			elseIfRuleIDs = new Vector.<int>();
			elseIfStrings = new Vector.<String>();
			
			elseString = "";
		}
		
		
		/**********************************************************************
		 * Locution Interface implementation
		 *********************************************************************/
		 
		/**
		 * Creates the dialogue to be presented to the player.
		 * 
		 * @param	initiator	The initator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return	The dialogue to present to the player.
		 */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String {
			
			var resultStr:String = "";
			
			return resultStr;
		}
		
		public function toString():String {
			return "";
		}
		
		public function getType():String {
			return "ConditionalLocuation";
		}
	}

}