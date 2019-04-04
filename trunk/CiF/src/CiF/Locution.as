package CiF 
{
	
	/**
	 * The Locution interface is to be implemented by any class that wishes to
	 * be rendered as part of a dialogue act.
	 * 
	 * @see CiF.LineOfDialogue
	 * @see CiF.Instantiation
	 */
	public interface Locution 
	{
		/**
		 * Creates the dialogue to be presented to the player.
		 * 
		 * @param	initiator	The initator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return	The dialogue to present to the player.
		 */
		function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String;
		
		
		function getType():String;

	}
	
}