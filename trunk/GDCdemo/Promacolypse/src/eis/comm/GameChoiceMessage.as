package eis.comm 
{
	import merapi.messages.Message;
	
	
	/**
	 * Message for sending a game choice to CiF's side of the bridge.
	 * @author Josh
	 */
	[RemoteClass( alias="eis.comm.GameChoiceMessage" )]
	public class GameChoiceMessage extends Message
	{
		public static const GAME_CHOICE:String = "gameChoice";
		
		public function GameChoiceMessage() 
		{
			super( GAME_CHOICE );
		}
		
		
		/**
		 * Sends the XML statement to CiF with the player's chosen social game
		 * and the characters in the initiator and target roles.
		 * 
		 * Sample XML request:
		 *  <PLAY_GAME name='SocialGameName' target='edward' initiator='bruce' />
		 */
		public function sendSocialGameChoice(socialGameName:String, initiator:String, target:String):void {
			this.data = "<PLAY_GAME name=\"" + socialGameName + "\" target=\"" + target + "\" initiator=\"" + initiator + "\" />";
			trace("GameChoiceMessage.sendSocialGameChoice(): sending social game request: " + this.data);
			this.send();
		}
		
	}

}