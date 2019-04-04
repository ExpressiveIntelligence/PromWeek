package CiF 
{
	/**
	 */
	public class TriggerContext implements SFDBContext
	{
		public var id:int;
		public var time:int;
		public var initiator:String;
		public var responder:String;
		public var other:String;

		public var statusTimeoutChange:Rule;
		
		/**
		 * The SFDB labels associated with this context entry.
		 */
		public var SFDBLabels:Vector.<SFDBLabel>;

		
		public function TriggerContext() 
		{
			this.SFDBLabels = new Vector.<SFDBLabel>();
			this.time = -1;
		}

		
		/**********************************************************************
		 * SFDBContext Interface implementation.
		 *********************************************************************/
		public function getTime():int { return this.time; }
		
		public function isSocialGame():Boolean { return false; }
		
		public function isTrigger():Boolean { return true; }
		
		public function isJuice():Boolean { return false; }
		
		public function isStatus():Boolean { return false; }

		public function getChange():Rule 
		{ 
			if (this.id == Trigger.STATUS_TIMEOUT_TRIGGER_ID)
			{
				return statusTimeoutChange;
			}
			var trigger:Trigger = CiFSingleton.getInstance().sfdb.getTriggerByID(this.id);
			return trigger.change; 
		}

		public function getCondition():Rule 
		{ 
			var trigger:Trigger = CiFSingleton.getInstance().sfdb.getTriggerByID(this.id);
			return trigger.condition; 
		}
		
		/**
		 * Determines if the SocialGameContext represents a status change consistent
		 * with the passed-in Predicate.
		 * 
		 * @param	p	Predicate to check for.
		 * @param	x	Primary character.
		 * @param	y	Secondary character.
		 * @param	z	Tertiary character.
		 * @return	True if the SocialGameContext's change is the same as the valuation
		 * of p. False if not.
		 */
		public function isPredicateInChange(p:Predicate, x:Character, y:Character, z:Character):Boolean {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//get a reference to the social game this context is about
			var changeRule:Rule = this.getChange();
			//for each predicate in the change rule of the effect
			for each (var predInChange:Predicate in changeRule.predicates) {
				//see if that predicates' structures match!				
				if (Predicate.equalsValuationStructure(p, predInChange)) {
					//see of the characters and roles match up
					if (doPredicateRolesMatchCharacterVariables(predInChange, x, y, z, p)) 
						return true; //a match was found!
				}
			}
			return false; // no match was found
		}
		
		/**
		 * Determines if the passed-in parameters of label and characters match the SFDBLabel and
		 * characters related to the label in this SocialGameContext. If this context is a backstory
		 * context, the first and second character parameters must match the context's initiator and
		 * responder respectively. If it is a non-backstory context, the first and second character
		 * parameters must match the labelArg1 and labelArg2 properties respectively.
		 * 
		 * @param	label			The label to match. If -1 is passed in, all labels are considered to match.
		 * @param	firstCharacter	The first character paramter.
		 * @param	secondCharacter	The second character parameter.
		 * @param	thirdCharacter	The third character paramter (not currently used).
		 * @return	True if this context is a match to the paramters. False if not a match.
		 */
		public function doesSFDBLabelMatch(label:int, firstCharacter:Character = null, secondCharacter:Character = null, thirdCharacter:Character = null, pred:Predicate = null):Boolean {
			var testBool:Boolean = false;
			if (this.SFDBLabels) {//the multi-SFDBLabel way
				for each(var sfdblabel:SFDBLabel in this.SFDBLabels) 
				{
					testBool = true;
					if (!(label == -1 || SocialFactsDB.doesMatchLabelOrCategory(SocialFactsDB.getLabelByName(sfdblabel.type),label)))
					{
						//if the label doesn't match and it isn't a wildcard FAIL
						testBool = false;
					}
					
					if (firstCharacter)
					{
						if (firstCharacter.characterName != sfdblabel.from)
						{
							testBool = false;
						}
					}
					if (secondCharacter)
					{
						if (secondCharacter.characterName != sfdblabel.to)
						{
							testBool = false;
						}
					}
					
					
					if (testBool)
					{
						return true;
					}
				}	
			}
			return false;
		}
		
		
		
		
		/**
		 * This one is used with numTimesUniquelyTrue sfdb label predicates
		 * 
		 * Determines if the passed-in parameters of label and characters match the SFDBLabel and
		 * characters related to the label in this SocialGameContext. If this context is a backstory
		 * context, the first and second character parameters must match the context's initiator and
		 * responder respectively. If it is a non-backstory context, the first and second character
		 * parameters must match the labelArg1 and labelArg2 properties respectively.
		 * 
		 * @param	label			The label to match. If -1 is passed in, all labels are considered to match.
		 * @param	firstCharacter	The first character paramter.
		 * @param	secondCharacter	The second character parameter.
		 * @param	thirdCharacter	The third character paramter (not currently used).
		 * @return	True if this context is a match to the paramters. False if not a match.
		 */
		public function doesSFDBLabelMatchStrict(label:int, firstCharacter:Character, secondCharacter:Character = null, thirdCharacter:Character = null, pred:Predicate = null):Boolean {
			if (this.SFDBLabels) {//the multi-SFDBLabel way
				for each(var sfdblabel:SFDBLabel in this.SFDBLabels) 
				{
					if (label == -1 || SocialFactsDB.doesMatchLabelOrCategory(SocialFactsDB.getLabelByName(sfdblabel.type),label))
					{
						//in here either the label matches or it is a wild card. check characaters
						if (sfdblabel.from == firstCharacter.characterName) 
						{
							if (secondCharacter)
							{
								if (secondCharacter.characterName == sfdblabel.to)
								{
									return true;
								}
							}
							else if (sfdblabel.to == "")
							{
								return true;
							}
						}
						//no first character was present here -- move on to the next (by doing nothing).
					}
				}	
				return false;
			}
			return false;
		}
		
		/**
		 * Determines if the character variable binding between the context and the predicate's
		 * primary chacacter reference match. This is not bidirectional.
		 * 
		 * @param	predInChange	A predicate in the context's change.
		 * @param	x				Primary character of non-context predicate.
		 * @param	y				secondary character of non-context predicate.
		 * @param	z				Tertiary character of non-context predicate.
		 * @return	True if the character names in context's predicates primary
		 * character variable matches the character names from the non-context
		 * character variables, x,y, and z.
		 */
		private function doesPredicatePrimaryMatch(predInEvalRule:Predicate, predInChange:Predicate, x:Character, y:Character, z:Character):Boolean {
			var characterReferedToInEvalRule:String;
			var characterReferedToInPredInChange:String;
			
			//1 - get the character refered to in predInEvalRule.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the appropriate x, y, or z.
			
			switch(predInEvalRule.getPrimaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInEvalRule = x.characterName;
					break;
				case "responder":
				case "y":
					characterReferedToInEvalRule = y.characterName;
					break;
				case "other":
				case "z":
					characterReferedToInEvalRule = z.characterName;
					break;
				case "":
					characterReferedToInEvalRule = "";
					break;
				default:
					characterReferedToInEvalRule = predInEvalRule.primary;
					//it's a character name
			}
			
			//2 - get the character refered to  in predInChange.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the context's i, r, o.
			switch(predInChange.getPrimaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInPredInChange = this.initiator;
					break;
				case "responder":
				case "y":
					characterReferedToInPredInChange = this.responder;
					break;
				case "other":
				case "z":
					characterReferedToInPredInChange = this.other;
					break;
				case "":
					characterReferedToInPredInChange = "";
					break;
				default:
					characterReferedToInPredInChange = predInChange.primary;
					//it's a character name
			}
			
			//3 - compare!
			if (characterReferedToInEvalRule == characterReferedToInPredInChange) return true;
			return false;
		}
		
		/**
		 * Determines if the character variable binding between the context and the predicate's
		 * secondary chacacter reference match. This is not bidirectional.
		 * 
		 * @param	predInChange	A predicate in the context's change.
		 * @param	x				Primary character of non-context predicate.
		 * @param	y				secondary character of non-context predicate.
		 * @param	z				Tertiary character of non-context predicate.
		 * @return	True if the character names in context's predicates secondary
		 * character variable matches the character names from the non-context
		 * character variables, x,y, and z.
		 */
		private function doesPredicateSecondaryMatch(predInEvalRule:Predicate, predInChange:Predicate, x:Character, y:Character, z:Character):Boolean {
			var characterReferedToInEvalRule:String;
			var characterReferedToInPredInChange:String;
			
			//1 - get the character refered to in predInEvalRule.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the appropriate x, y, or z.
			
			switch(predInEvalRule.getSecondaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInEvalRule = x.characterName;
					break;
				case "responder":
				case "y":
					characterReferedToInEvalRule = y.characterName;
					break;
				case "other":
				case "z":
					characterReferedToInEvalRule = z.characterName;
					break;
				case "":
					characterReferedToInEvalRule = "";
					break;
				default:
					characterReferedToInEvalRule = predInEvalRule.secondary;
					//it's a character name
			}
			
			//2 - get the character refered to  in predInChange.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the context's i, r, o.
			switch(predInChange.getSecondaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInPredInChange = this.initiator;
					break;
				case "responder":
				case "y":
					characterReferedToInPredInChange = this.responder;
					break;
				case "other":
				case "z":
					characterReferedToInPredInChange = this.other;
					break;
				case "":
					characterReferedToInPredInChange = "";
					break;
				default:
					characterReferedToInPredInChange = predInChange.secondary;
					//it's a character name
			}
			
			//3 - compare!
			if (characterReferedToInEvalRule == characterReferedToInPredInChange) return true;
			return false;
		}
		
		/**
		 * Determines if the character variable binding between the context and the predicate's
		 * tertiary chacacter reference match. This is not bidirectional.
		 * 
		 * @param	predInChange	A predicate in the context's change.
		 * @param	x				Primary character of non-context predicate.
		 * @param	y				secondary character of non-context predicate.
		 * @param	z				Tertiary character of non-context predicate.
		 * @return	True if the character names in context's predicates tertiary
		 * character variable matches the character names from the non-context
		 * character variables, x,y, and z.
		 */
		private function doesPredicateTertiaryMatch(predInEvalRule:Predicate, predInChange:Predicate, x:Character, y:Character, z:Character):Boolean {
			var characterReferedToInEvalRule:String;
			var characterReferedToInPredInChange:String;
			
			//1 - get the character refered to in predInEvalRule.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the appropriate x, y, or z.
			
			switch(predInEvalRule.getTertiaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInEvalRule = x.characterName;
					break;
				case "responder":
				case "y":
					characterReferedToInEvalRule = y.characterName;
					break;
				case "other":
				case "z":
					characterReferedToInEvalRule = z.characterName;
					break;
				case "":
					characterReferedToInEvalRule = "";
					break;
				default:
					characterReferedToInEvalRule = predInEvalRule.tertiary;
					//it's a character name
			}
			
			//2 - get the character refered to  in predInChange.primary
			// To do this, match the getPrimaryValue() return (i,r,o) with the context's i, r, o.
			switch(predInChange.getTertiaryValue()) {
				case "initiator":
				case "x":
					characterReferedToInPredInChange = this.initiator;
					break;
				case "responder":
				case "y":
					characterReferedToInPredInChange = this.responder;
					break;
				case "other":
				case "z":
					characterReferedToInPredInChange = this.other;
					break;
				case "":
					characterReferedToInPredInChange = "";
					break;
				default:
					characterReferedToInPredInChange = predInChange.tertiary;
					//it's a character name
			}
			
			//3 - compare!
			if (characterReferedToInEvalRule == characterReferedToInPredInChange) return true;
			return false;
		}
		
		/**
		 * Determines if the character names in context's predicates primary, secondary, 
		 * and tertiary character variables match the character names from the non-context
		 * character variables x,y, and z respectively.
		 * 
		 * @param	predInChange	A predicate in the context's change.
		 * @param	x				Primary character of non-context predicate.
		 * @param	y				secondary character of non-context predicate.
		 * @param	z				Tertiary character of non-context predicate.
		 * @return	True if the character names in context's predicates primary, secondary, 
		 * and tertiary character variables match the character names from the non-context
		 * character variables x,y, and z respectively.
		 */
		private function doPredicateRolesMatchCharacterVariables(predInChange:Predicate, x:Character, y:Character, z:Character, predInEvalRule:Predicate=null):Boolean {
			/*The trick to this function is that the x,y, and z are in correspondence with the predicates primary
			 * secondary, and tertiary character variables. This means we need to translate the predicates character
			 * variables to actual character names (if they are roles and not direct character names inititally) via
			 * the name<=>role mapping in the this SocialGameContext.
			 */
			
			 
			if (Util.xor(x != null, predInChange.primary != null)) return false; //only one exists
			if (Util.xor(y != null, predInChange.secondary != null)) return false; //only one exists
			
			//z is a case we want to ignore as it is likely to be in the context but no in the evaluation.
			//We want to be lax in this case.
			//if (Util.xor(z!=null, predInChange.tertiary!=null)) return false; //only one exists

			//relationships are bi-directional; the primary and secondary can flip around accordingly.
			if (predInChange.type == Predicate.RELATIONSHIP) {
				var result:Boolean;
				var temp:String;
				//the case where the ordering matches
				result = this.doesPredicatePrimaryMatch(predInEvalRule, predInChange, x, y, z) && this.doesPredicateSecondaryMatch(predInEvalRule, predInChange, x, y, z);
				if (result) {
					return true;
				}
				
				//the other side of the bi-directional relationship where the ordering is flipped
				temp = predInChange.primary;
				predInChange.primary = predInChange.secondary;
				predInChange.secondary = temp;
				
				result = this.doesPredicatePrimaryMatch(predInEvalRule, predInChange, x, y, z) && this.doesPredicateSecondaryMatch(predInEvalRule, predInChange, x, y, z);
				
				temp = predInChange.primary;
				predInChange.primary = predInChange.secondary;
				predInChange.secondary = temp;
				
				if (result) {
					return true;
				}
				else return false;
			}
			
			if (!this.doesPredicatePrimaryMatch(predInEvalRule, predInChange, x, y, z)) return false;
			if (!this.doesPredicateSecondaryMatch(predInEvalRule, predInChange, x, y, z)) return false;
			if (!this.doesPredicateTertiaryMatch(predInEvalRule, predInChange, x, y, z)) return false;
			return true;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toString():String {
			return this.toXMLString();
		}
		
		public function toXML():XML {
			var outXML:XML = <TriggerContext time = { this.time } id = {this.id} initiator= {this.initiator} />;
			if (this.responder) outXML.@responder = this.responder;
			if (this.other) outXML.@other = this.other;
			
			for each(var label:SFDBLabel in this.SFDBLabels) {
				outXML.appendChild(label.toXML());
			}
			
			//Debug.debug(this, "toXML()\n" + outXML.toXMLString());
			return outXML;
		}
		public function toXMLString():String {
			return this.toXML().toXMLString();
			/*var returnString:String = new String();
			returnString += "<TriggerContext time=\"" + this.time + "\">\n<Change>\n" + this.change.toXMLString() + "</Change>\n</TriggerContext>";
			return returnString;*/
		}
		
		public function clone(): TriggerContext {
			var tc:TriggerContext = new TriggerContext();
			tc.time = this.time;
			tc.id = this.id;
			tc.SFDBLabels = this.SFDBLabels.slice(0, this.SFDBLabels.length - 1);
			return tc;
		}
		
		public static function equals(x:TriggerContext, y:TriggerContext): Boolean {
			if (x.id != y.id) return false;
			if (x.time != y.time) return false;
			for (var i:int = 0; i <  x.SFDBLabels.length; ++i ) {
				if (!SFDBLabel.equals(x.SFDBLabels[i], y.SFDBLabels[i])) return false;
			}
			
			return true;
		}
		
		public function loadFromXML(xml:XML):SFDBContext
		{
			//this is currently handled in ParseXML SFDBContextParse
			return null;
		}
		
	}

}