package CiF 
{
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class MixInLocution implements Locution
	{
		public var content:String;
		
		public var mixInType:String;
		
		public function MixInLocution() 
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
			
			var character:Character;
			var whoIsSpeaking:String = "";
			if (initiator && initiator.isSpeakerForMixInLocution)
			{
				character = initiator;
				whoIsSpeaking = "initiator";
			}
			else if (responder && responder.isSpeakerForMixInLocution)
			{
				character = responder;
				whoIsSpeaking = "responder";
			}
			else if (other && other.isSpeakerForMixInLocution)
			{
				character = other;
				whoIsSpeaking = "other";
			}
			
			//Awesome -- we have the speaker.  They live inside of 'character.'
			//have to do something special if it is buddymale or buddyfemale
			//We need to look at the line of dialogue, who they are speaking to, and then
			//grab the gender of the person they are speaking to.
			
			//Debug.debug(this,"characterName: "+character.characterName);
			var mixIn:String = "";
			if (mixInType.toLowerCase() == "buddy") {
				if(line){ // if we have gotten here via SSUs, then we won't have a line... and thus we won't have a 'who is the person addressing' variable. Maybe just guess that it is trait of responder for now.
					if (whoIsSpeaking == "initiator") {
						if (line.initiatorAddressing.toLowerCase() == "responder") { // initiator is talking to responder -- what is responder's gender!
							if (responder.hasTrait(Trait.MALE)) { // responder is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
						else { // initiator is talking to other -- what is other's gender?
							if (other.hasTrait(Trait.MALE)) { // other is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
					}
					else if (whoIsSpeaking == "responder") {
						if (line.responderAddressing.toLowerCase() == "initiator") { // responder is talking to initiator -- what is initiators's gender!
							if (initiator.hasTrait(Trait.MALE)) { // initiator is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
						else { // responder is talking to other -- what is other's gender?
							if (other.hasTrait(Trait.MALE)) { // other is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
					}
					else if (whoIsSpeaking == "other") {
						if (line.otherAddressing.toLowerCase() == "initiator") { // other is talking to initiator -- what is initiators's gender!
							if (initiator.hasTrait(Trait.MALE)) { // initiator is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
						else { // other is talking to responder -- what is responder's gender?
							if (responder.hasTrait(Trait.MALE)) { // responder is a boy!  use buddymale!
								mixIn = character.locutions["buddymale"];
							}
							else {
								mixIn = character.locutions["buddyfemale"];
							}
						}
					}
					else {
						Debug.debug(this, "renderText() -- improperly formatted buddy locution");
					}
				}
				else {
					// here it appears that we have no line.  Probably got here via SSU.  Let's just assume that
					//the initiator is talking, and that they want the gender of the responder.
					if (responder.hasTrait(Trait.MALE)) { // responder is a boy!  use buddymale!
						mixIn = character.locutions["buddymale"];
					}
					else {
						mixIn = character.locutions["buddyfemale"];
					}
				}
			}
			else{
				mixIn = character.locutions[mixInType.toLowerCase()];
			}
			
			//Debug.debug(this, "renderText: mixInType: " + mixInType + " characterLocution: " + character.locutions[mixInType] + " character: " + character.characterName);
			
			if (mixIn == null)
			{
				return Character.defaultLocutions[mixInType.toLowerCase()];
			}
			
			return mixIn;
		}
		
		public function toString():String {
			return "";
		}
		
		public function getType():String {
			return "MixInLocution";
		}
	}

}