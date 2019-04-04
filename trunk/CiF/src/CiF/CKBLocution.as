package CiF 
{
	/**
	 * ...
	 */
	public class CKBLocution implements Locution
	{

		public var pred:Predicate;
		
		public function CKBLocution() 
		{
			pred = new Predicate();
			//pred.type = Predicate.CKBENTRY;
			pred.setByTypeDefault(Predicate.CKBENTRY);
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
			var potentialObjects:Vector.<String> = new Vector.<String>();
			
			//trace("CKB::::: " + pred.primary + ":" + pred.firstSubjectiveLink+ " " + pred.secondary + ":" + pred.secondSubjectiveLink + " TRUTH:" + pred.truthLabel  );
			
			if (pred.primary == "initiator") {
				//Debug.debug(this, "initiator is primary");
				//Debug.debug(this, "renderText() this.predicate: " + this.pred.toString());
				if (pred.secondary == "" || pred.secondary.length == 0 || !pred.secondary) { // if there is no second person.
					//Debug.debug(this, "there is no secondary");
					potentialObjects = pred.evalCKBEntryForObjects(initiator, null);
				}else if (pred.secondary == "initiator") {
					potentialObjects = pred.evalCKBEntryForObjects(initiator, initiator);			
				}else if (pred.secondary == "responder") {
					//Debug.debug(this, "renderText() "+pred.toString());
					potentialObjects = pred.evalCKBEntryForObjects(initiator, responder);			
				}
				else if (pred.secondary == "other") {
					//Debug.debug(this, "other is secondary");
					potentialObjects = pred.evalCKBEntryForObjects(initiator, other);	
				}
			}
			if (pred.primary == "responder") {
				//Debug.debug(this, "responder is primary");
				if (pred.secondary == "") // if there is no second person.
					potentialObjects = pred.evalCKBEntryForObjects(responder, null);
				else if(pred.secondary == "initiator")
					potentialObjects = pred.evalCKBEntryForObjects(responder, initiator); // Do we need to be smarter about the order we pass them in?			
				else if(pred.secondary == "responder")
					potentialObjects = pred.evalCKBEntryForObjects(responder, responder); // Do we need to be smarter about the order we pass them in?			
				else if(pred.secondary == "other")
					potentialObjects = pred.evalCKBEntryForObjects(responder, other); // Do we need to be smarter about the order we pass them in?			
			}			
			if (pred.primary == "other") {
				//Debug.debug(this, "other is primary");
				if (pred.secondary == "") // if there is no second person.
					potentialObjects = pred.evalCKBEntryForObjects(other, null);
				else if (pred.secondary == "initiator")
					potentialObjects = pred.evalCKBEntryForObjects(other, initiator);
				else if (pred.secondary == "responder")
					potentialObjects = pred.evalCKBEntryForObjects(other, responder);
				else if (pred.secondary == "other")
					potentialObjects = pred.evalCKBEntryForObjects(other, other);
			}
			
			// just return the first one for now... this will CERTAINLY have to be smarter in the future.
			if (potentialObjects && potentialObjects.length > 0) {
				return potentialObjects[0];
			}
			return "thing"; // Formerly known as NO OBJECTS FOUND THAT MET REQUIREMENTS!
		}
		
		public function toString():String {
			return "";
		}
		
		public function getType():String {
			return "CKBLocution";
		}
	}

}