package CiF 
{
	/**
	 * ...
	 */
	public class LiteralLocution implements Locution
	{
		public var content:String;
		public function LiteralLocution() 
		{
			content = "";
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
			
			return content;
		}
		
		public function toString():String {
			return "";
		}
		
		public function getType():String {
			return "LiteralLocution";
		}
	}

}