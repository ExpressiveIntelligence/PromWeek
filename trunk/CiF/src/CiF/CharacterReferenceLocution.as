package CiF 
{
	/**
	 * ...
	 */
	public class CharacterReferenceLocution implements Locution
	{
		
		public var type:String; // I == Initiator, R == Responder, IP == Initiator Possessive, RP == Responder Possessive.
		
		public function CharacterReferenceLocution() 
		{
			
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
			
			var tempString:String = "";

			if (type == "I" || type == "IS") {
				tempString = initiator.characterName;
			}
			if (type == "IP") {
				tempString = initiator.characterName;
				tempString += "'s";
			}
			if (type == "R" || type == "RS") {
				tempString = responder.characterName;
			}
			if (type == "RP") {
				tempString = responder.characterName;
				tempString += "'s";
			}
			if (type == "O" || type == "OS")
			{
				tempString = other.characterName;
			}
			if (type == "OP")
			{
				tempString = other.characterName;
				tempString += "'s";
			}
			return tempString;

		}
		
		public function toString():String {
			return this.type;
		}
		
		public function getType():String {
			return "CharacterReferenceLocution";
		}
	}

}