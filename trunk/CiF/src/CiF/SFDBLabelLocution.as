package CiF 
{
	/**
	 * ...
	 */
	public class SFDBLabelLocution implements Locution
	{
		public var pred:Predicate;
		public var sfdb:SocialFactsDB;
		
		public var speaker:String;
		
		public function SFDBLabelLocution() 
		{
			pred = new Predicate();
			pred.setByTypeDefault(Predicate.SFDBLABEL);
			sfdb = SocialFactsDB.getInstance();
		}
		
		/**********************************************************************
		 * Locution Interface implementation
		 *********************************************************************/
		 
		/**
		 * Creates the dialogue to be presented to the player. Of all of the
		 * social game contexts that match the locutions parameters, one is
		 * chosen randomly to be the subject of this locution.
		 * 
		 * @param	initiator	The initator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return	The dialogue to present to the player.
		 */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String 
		{
			var potentialSFDBEntries:Vector.<int> = new Vector.<int>();
			var socialGameName:String = "";
			var effectID:int;
			var chosenContext:SocialGameContext;
			
			//Debug.debug(this, "renderText() pred: " + this.pred.toString());
			
			if (pred.getPrimaryValue() == "initiator") {
				//Debug.debug(this, "initiator is primary");
				if (pred.getSecondaryValue() == "") { // if there is no second person.
					//Debug.debug(this, "there is no secondary");
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel,initiator, null, null, 0,pred);
				}
				else if (pred.getSecondaryValue() == "initiator") {
					//Debug.debug(this, "responder is secondary");
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, initiator, initiator, null, 0, pred);			
				}
				else if (pred.getSecondaryValue() == "responder") {
					//Debug.debug(this, "responder is secondary");
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, initiator, responder, null, 0, pred);			
				}
				else if (pred.getSecondaryValue() == "other") {
					//Debug.debug(this, "other is secondary");
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, initiator, other, null, 0, pred);	
				}
			}
			if (pred.getPrimaryValue() == "responder") {
				//Debug.debug(this, "responder is primary");
				if (pred.getSecondaryValue() == "") // if there is no second person.
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, responder, null, null, 0, pred);
				else if(pred.getSecondaryValue() == "initiator")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, responder, initiator, null, 0, pred); // Do we need to be smarter about the order we pass them in?			
				else if(pred.getSecondaryValue() == "responder")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, responder, responder, null, 0, pred); // Do we need to be smarter about the order we pass them in?			
				else if(pred.getSecondaryValue() == "other")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, responder, other, null, 0, pred); // Do we need to be smarter about the order we pass them in?			
			}			
			if (pred.getPrimaryValue() == "other") {
				//Debug.debug(this, "other is primary");
				if (pred.getSecondaryValue() == "") // if there is no second person.
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, other, null, null, 0, pred);
				else if (pred.getSecondaryValue() == "initiator")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, other, initiator, null, 0, pred);
				else if (pred.getSecondaryValue() == "responder")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, other, responder, null, 0,  pred);
				else if (pred.getSecondaryValue() == "other")
					potentialSFDBEntries = sfdb.findLabelFromValues(pred.sfdbLabel, other, other, null, 0,  pred);
			}
			
			
			if (potentialSFDBEntries && potentialSFDBEntries.length > 0) {
				
				
				var contextPick:int = Math.floor(Math.random() * potentialSFDBEntries.length);
				//get the name of the social game of the latest context
				//get the effect ID taken in the latest context
				//return the performance realization string of the taken effect
				//chosenContext = sfdb.contexts[potentialSFDBEntries[contextPick]] as SocialGameContext;
				chosenContext = sfdb.getSocialGameContextAtTime(potentialSFDBEntries[contextPick]);
				//Debug.debug(this, "renderText() chosenContext: " + chosenContext.toXMLString());
				//Debug.debug(this, "renderText() effectInfo: " + CiFSingleton.getInstance().socialGamesLib.getByName(chosenContext.gameName).getEffectByID(chosenContext.effectID).toString());
				//Debug.debug(this, "renderText() PerformanceString: "+ CiFSingleton.getInstance().socialGamesLib.getByName(chosenContext.gameName).getEffectByID(chosenContext.effectID).referenceAsNaturalLanguage);

				return chosenContext.getEffectPerformanceRealizationString(initiator, responder, other, speaker);

				
				
				return "We found a big list of entires! Here is the index of the first one: " + potentialSFDBEntries[0]; 
			}
			return "*whisper whisper*";
		}
		
		public function toString():String {
			return "";
		}
		
		public function getType():String {
			return "SFDBLabelLocution";
		}
	}

}