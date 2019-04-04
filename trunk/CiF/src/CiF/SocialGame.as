package CiF 
{
	import flashx.textLayout.utils.CharacterUtil;
	/**
	 * The SocialGame class stores social games in their declarative form; the
	 * social game preconditions, influence sets, and effects are stored. What
	 * is not stored is the decisions made by the player or AI system about what
	 * game choices are made. These decisions are stored in the FilledGame class.
	 * 
	 * <p>(deprecated)The defined constants denote the type of social change that 
	 * the social game has as its effect. </p>
	 * 
	 * @see CiF.FilledGame
	 * 
	 */
	public class SocialGame
	{
		public var name:String = "";
		public var intents:Vector.<Rule>;
		public var preconditions:Vector.<Rule>;
		public var initiatorIRS:InfluenceRuleSet;
		public var responderIRS:InfluenceRuleSet;
		public var effects:Vector.<Effect>;
		public var instantiations:Vector.<Instantiation>;
		public var patsyRule:Rule;
		
		public var italic:Boolean = false;
		
		public var thirdPartyTalkAboutSomeone:Boolean;
		public var thirdPartyGetSomeoneToDoSomethingForYou:Boolean;

		public function SocialGame()
		{
			this.intents = new Vector.<Rule>();
			this.instantiations = new Vector.<Instantiation>();
			this.preconditions = new Vector.<Rule>();
			this.initiatorIRS = new CiF.InfluenceRuleSet();
			this.responderIRS = new CiF.InfluenceRuleSet();
			this.effects = new Vector.<Effect>();
			
			this.thirdPartyTalkAboutSomeone = false;
			this.thirdPartyGetSomeoneToDoSomethingForYou = false;
			this.patsyRule = new Rule();
			
			this.italic = false;
		}
		
		/**
		 * Adds an effect to the effects list and gives it an ID.
		 * @param	effect	The effect to add to the social games's effects.
		 */
		public function addEffect(effect:Effect):void {
			var e:Effect = effect.clone();
			var idToUse:Number = 0;
			for each(var iterEffect:Effect in this.effects) {
				if (iterEffect.id > idToUse)
					idToUse = iterEffect.id + 1;
			}
			e.id = idToUse;
			this.effects.push(e);
		}
		
		/**
		 * Returns the effect who's id matches the id provided
		 * @param	effectID
		 * @return
		 */
		public function getEffectByID(effectID:int):Effect
		{
			for each (var e:Effect in this.effects)
			{
				if (e.id == effectID)
				{
					return e;
				}
			}
			Debug.debug(this, "getEffectByID() the id "+effectID+ " is not matched by any effects in the social game " + this.name);
			return new Effect();
		}
		
		/**
		 * Adds an instantation the the social game's instantions and gives
		 * it an ID. 
		 * @param	instantiation	The instantiation to add.
		 */
		public function addInstantiation(instantiation:Instantiation):void {
			var instant:Instantiation = instantiation.clone();
			var idToUse:Number = 0;
			for each(var iterInstant:Instantiation in this.instantiations) {
				if (iterInstant.id > idToUse)
					idToUse = iterInstant.id + 1;
			}
			instant.id = this.instantiations.length;
			this.instantiations.push(instant);
		}
		
		/**
		 * Returns the initiator's influence rule set score with respect to the
		 * character/role mapping given in the arguments.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return
		 */
		//NOTE: this is old news....
		public function getInitiatorScore(initiator:Character, responder:Character, other:Character = null, sg:SocialGame = null, activeOtherCast:Vector.<Character> = null):Number {
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			return this.initiatorIRS.scoreRules(initiator, responder, other, sg,possibleOthers);
		}
		
		/**
		 * This function returns true if the precondition is met in any way
		 * 
		 */
		public function passesAtLeastOnePrecondition(initiator:Character, responder:Character,activeOtherCast:Vector.<Character> = null):Boolean
		{
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			
			if (this.preconditions.length > 0)
			{
				if (this.preconditions[0].requiresThirdCharacter())
				{
					//if the precondition involves an other check preconditions for static others
					for each (var otherChar:Character in possibleOthers)
					{
						if (otherChar.characterName != initiator.characterName &&
							otherChar.characterName != responder.characterName) 
						{
							if (this.preconditions[0].evaluate(initiator, responder, otherChar, this))
							{
								return true;
							}
						}
					}
				}
				else
				{
					
					// if there is a precondition, check precondition normally
					if (this.preconditions[0].evaluate(initiator, responder, null, this))
					{	
						return true;
					}
				}
			}
			else
			{
				//if there are no precondition, we pass the precondition
				return true;
			}
			
			// this means we shouldn't even both scoring this game
			return false;
		}
		
		/**
		 * This function will score an influence rule set for all others that fit the definition or no others 
		 * if the definition doesn't require it. This function assumes that there is one precondition rule.
		 * 
		 * @param	type either "initiator" or "responder"
		 * @param	initiator
		 * @param	responder
		 * @param	activeOtherCast
		 * @return The total weight of the influence rules
		 */
		public function scoreGame(initiator:Character, responder:Character,activeOtherCast:Vector.<Character> = null, isResponder:Boolean = false):Number
		{
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			
			var influenceRuleSet:InfluenceRuleSet = (!isResponder)?this.initiatorIRS:this.responderIRS;
			
			var totalScore:Number = 0.0;
			
			
			if (this.preconditions.length > 0)
			{
				if (this.preconditions[0].requiresThirdCharacter())
				{
					//if the precondition involves an other run the IRS for all others with a static other (for others that satisfy the SG's preconditions)
					for each (var otherChar:Character in possibleOthers)
					{
						if (otherChar.characterName != initiator.characterName &&
							otherChar.characterName != responder.characterName) 
						{
							if (this.preconditions[0].evaluate(initiator, responder, otherChar, this))
							{
								totalScore += influenceRuleSet.scoreRules(initiator, responder, otherChar, this, possibleOthers,"",isResponder);
							}
						}
					}
				}
				else
				{
					// if there is a precondition, but it doesn't require a third, just score the IRS once with variable other
					if (this.preconditions[0].evaluate(initiator, responder, null, this))
					{	
						totalScore += influenceRuleSet.scoreRulesWithVariableOther(initiator, responder, null, this, possibleOthers, "", isResponder);
					}
				}
			}
			else
			{
				//if there are no precondition, just score the IRS, once with a variable other
				totalScore += influenceRuleSet.scoreRulesWithVariableOther(initiator, responder, null, this, possibleOthers,"",isResponder);
			}
			//if (initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
			return totalScore;
		}
		
		/**
		 * Returns the responder's influence rule set score with respect to the
		 * character/role mapping given in the arguments.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return
		 */
		public function getResponderScore(initiator:Character, responder:Character, other:Character = null, sg:SocialGame = null, activeOtherCast:Vector.<Character> = null):Number {
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			return this.responderIRS.scoreRules(initiator, responder, other, sg, possibleOthers);
		}
		
		/**
		 * Evaluates the precditions of the social game with respect to 
		 * character/role mapping given in the arguments for the initiator
		 * and responder while finding an other that fits all precondition 
		 * rules if a third character is require by any of those rules.
		 * 
		 * @param	initiator		The initiator of the social game.
		 * @param	responder		The responder of the social game.
		 * @param 	activeOtherCast The possible characters to fill the other role.
		 * @return True if all precondition rules evaluate to true. False if 
		 * they do not.
		 */
		public function checkPreconditionsVariableOther(initiator:Character, responder:Character, activeOtherCast:Vector.<Character> = null):Boolean {
			if (this.preconditions.length < 1) return true; //no preconditions is automatically true
			
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			var precond:Rule;
			var requiresOther:Boolean = false;
			var otherChar:Character;
			var i:int;
			var isOtherSuitable:Boolean;
			
			
			for each(precond in this.preconditions) {
				if (precond.requiresThirdCharacter()) requiresOther = true;
			}
			
			
			if (requiresOther) {
				//iterate through all possible others and check each precondition with the current other
					for each (otherChar in possibleOthers) {
						isOtherSuitable = true; //assume the other works unilt proven otherwise
						
						if (otherChar.characterName != initiator.characterName && otherChar.characterName != responder.characterName) {
							//if the other is found not to be suitable for filling all precondition rules, break the loop and move on
							//to the next possible other.
							for (i = 0; i < this.preconditions.length && isOtherSuitable; ++i)
								if (!this.preconditions[i].evaluate(initiator, responder, otherChar, this)) 
									isOtherSuitable = false;
						}
					//other was true for all preconditions
					if (isOtherSuitable) return true;
					}

				
			} else {
				for each (precond in this.preconditions) {
					if (!precond.evaluate(initiator, responder, null, this))
						return false;
				}
				return true;
			}
			
			//default case
			return false;
		}
		
		/**
         * Evaluates the precditions of the social game with respect to 
         * character/role mapping given in the arguments.
         * 
         * @param    initiator    The initiator of the social game.
         * @param    responder    The responder of the social game.
         * @param    other        A third party in the social game.
         * @return True if all precondition rules evaluate to true. False if 
         * they do not.
         */
        public function checkPreconditions(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
            for each (var preconditionRule:Rule in this.preconditions) {
                //if (name.toLowerCase() == "true love's kiss") 
                    //Debug.debug(this, initiator.characterName + ", " + responder.characterName + " on " + preconditionRule.toString());
                if (!preconditionRule.evaluate(initiator, responder, other, sg))
                    return false;
            }
            return true;
        }
		
		public function checkEffectConditions(initiator:Character, responder:Character, other:Character = null):Boolean 
		{
			for each (var e:Effect in this.effects)
			{
				if (!e.condition.evaluate(initiator, responder, other))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Evaluates the intents of the social game with respect to 
		 * character/role mapping given in the arguments.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return True if all intent rules evaluate to true. False if 
		 * they do not.
		 */
		public function checkIntents(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
			for each (var intentRule:Rule in this.intents) {
				//if (name.toLowerCase() == "true love's kiss") 
					//Debug.debug(this, initiator.characterName + ", " + responder.characterName + " on " + preconditionRule.toString());
				if (!intentRule.evaluate(initiator, responder, other, sg))
					return false;
			}
			return true;
		}
		
		/**
		 * Synonym setter for the game's name (backward compatability with
		 * GDC demo.
		 */
		public function get specificTypeOfGame():String {
			return this.name;
		}
		
		/**
		 * Synonym setter for the game's name (backward compatability with
		 * GDC demo.
		 */
		public function set specificTypeOfGame(n:String):void {
			this.name = n;
		}
		
		/**
		 * Determines if we need to find a third character for the intent
		 * formation process.
		 * @return True if a third character is needed, false if not.
		 */
		public function thirdForIntentFormation():Boolean {
			for each (var r:Rule in this.preconditions) 
				if (r.requiresThirdCharacter()) return true;
			
				
			var ir:InfluenceRule;
			for each (ir in this.initiatorIRS.influenceRules)
				if (ir.requiresThirdCharacter()) return true;
				
			for each (ir in this.responderIRS.influenceRules)
				if (ir.requiresThirdCharacter()) return true;
				
			for each (var e:Effect in this.effects)
			{
				if (e.condition.requiresThirdCharacter()) return true;
				if (e.change.requiresThirdCharacter()) return true;
			}
			
			return false;
		}
		
		/**
		 * Determines if we need to find a third character for social game 
		 * play.
		 * @return True if a third character is needed, false if not.
		 */
		public function thirdForSocialGamePlay():Boolean {
			//for each (var ir:InfluenceRule in this.responderIRS.influenceRules)
				//if (ir.requiresThirdCharacter()) return true;
			for each (var e:Effect in this.effects) 
				if (e.change.requiresThirdCharacter() || e.condition.requiresThirdCharacter())
					return true;
				
			return false;
		}
		
		/**
		 * Finds an instantiation given an id. 
		 * @param	id	id of instantiation to find.
		 * @return	Instantiation with the parameterized id, null if not
		 * found.
		 */
		public function getInstantiationById(id:int):Instantiation {
			for each(var inst:Instantiation in this.instantiations) {
				if (id == inst.id)
					return inst;
			}
			Debug.debug(this, "getInstiationById() id not found. id=" + id);
			return null;
		}
		
		public function get thirdParty():Boolean
		{
			return this.thirdPartyTalkAboutSomeone || this.thirdPartyGetSomeoneToDoSomethingForYou;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toXMLString():String {
			var returnstr:String = new String();
			var i:Number = 0;
			returnstr += "<SocialGame name=\"" + this.name + "\" italic=\"" + this.italic.toString() + "\"";
			
			if (this.thirdPartyGetSomeoneToDoSomethingForYou)
			{
				returnstr += " thirdPartyGetSomeoneToDoSomethingForYou=\"true\"";
			}
			if (this.thirdPartyTalkAboutSomeone)
			{
				returnstr += " thirdPartyTalkAboutSomeone=\"true\"";
			}
			
			returnstr += ">\n";
	
			returnstr += "<PatsyRule>\n";
			returnstr += this.patsyRule.toXMLString();
			
			returnstr += "</PatsyRule>\n";
			
			returnstr += "<Intents>\n";
			for (i = 0; i < this.intents.length; ++i) {
				//returnstr += "   ";
				returnstr += this.intents[i].toXMLString();
				//returnstr += "\n";
			}
			returnstr += "</Intents>\n";
			
			returnstr += "<Preconditions>\n";
			for (i = 0; i < this.preconditions.length; ++i) {
				//returnstr += "   ";
				returnstr += this.preconditions[i].toXMLString();
				//returnstr += "\n";
			}
			returnstr += "</Preconditions>\n";
			
			//put xml tags here to differentiate between initiator and responder influence rules.
			returnstr += "<InitiatorInfluenceRuleSet>\n";
			returnstr += this.initiatorIRS.toXMLString();
			returnstr += "</InitiatorInfluenceRuleSet>\n";
			
			returnstr += "<ResponderInfluenceRuleSet>\n";
			returnstr += this.responderIRS.toXMLString();
			returnstr += "</ResponderInfluenceRuleSet>\n";
			
			returnstr += "<Effects>\n";
			for (i = 0; i < this.effects.length; ++i) {
				//returnstr += "   ";
				returnstr += this.effects[i].toXMLString();
				//returnstr += "\n";
			}
			returnstr += "</Effects>\n";
			
			returnstr += "<Instantiations>\n";
			for (i = 0; i < this.instantiations.length; ++i) {
				//returnstr += "   ";
				returnstr += this.instantiations[i].toXMLString();
				//returnstr += "\n";
			}
			returnstr += "</Instantiations>\n";
			
			returnstr += "</SocialGame>\n";
			return returnstr;
		}
		 
		public function clone(): SocialGame {
			var sg:SocialGame = new SocialGame();
			sg.name = this.name;
			
			sg.intents = new Vector.<Rule>();
			var r:Rule;
			for each(r in this.intents) {
				sg.intents.push(r.clone());
			}
			
			sg.italic = this.italic;
			
			sg.patsyRule = this.patsyRule.clone();
			
			sg.preconditions = new Vector.<Rule>();
			for each(r in this.preconditions) {
				sg.preconditions.push(r.clone());
			}
			sg.initiatorIRS = this.initiatorIRS.clone();
			sg.responderIRS = this.responderIRS.clone();
			sg.effects = new Vector.<Effect>();
			for each(var e:Effect in this.effects) {
				sg.effects.push(e.clone());
			}
			sg.instantiations = new Vector.<Instantiation>();
			for each(var i:Instantiation in this.instantiations) {
				sg.instantiations.push(i.clone());
			}
			return sg;
		}
		
		public function toNaturalLanguage():String
		{
			var returnString:String = "";
			var pred:Predicate;
			var rule:Rule;
			var infRule:InfluenceRule;
			
			returnString += "-- Social Game --\n";
			returnString += "* Name: " + this.name + "\n";
			returnString += "* Preconditions: \n";
			for each (rule in this.preconditions)
			{
				for each (pred in rule.predicates)
				{
					//returnString += "      " + pred.toNaturalLanguageString(pred.primary,pred.secondary) + "\n";
					returnString += "      " + pred.toString() + "\n";
				}
			}
			returnString += "\n* Initiator Influence Rules:\n"
			for each (infRule in this.initiatorIRS.influenceRules)
			{
				returnString += "   " + infRule.weight + ":\n"
				for each (pred in infRule.predicates)
				{
					//returnString += "      " + pred.toNaturalLanguageString(pred.primary,pred.secondary) + "\n";
					returnString += "      " + pred.toString() + "\n";
				}
			}
			returnString += "\n* Responder Influence Rules:\n"
			for each (infRule in this.initiatorIRS.influenceRules)
			{
				returnString += "   " + infRule.weight + ":\n"
				for each (pred in infRule.predicates)
				{
					//returnString += "      " + pred.toNaturalLanguageString(pred.primary,pred.secondary) + "\n";
					returnString += "      " + pred.toString() + "\n";
				}
			}
			returnString += "\n* Effects/Instantiations:\n";
			for each (var effect:Effect in this.effects)
			{
				returnString += "Effect " + effect.id + ": " + effect.referenceAsNaturalLanguage + "\n";
				returnString += "   Condition Rule: \n";
				for each (pred in effect.condition.predicates)
				{
					//returnString += "      " + pred.toNaturalLanguageString(pred.primary,pred.secondary) + "\n";
					returnString += "      " + pred.toString() + "\n";
				}
				returnString += "   Change Rule: \n";
				for each (pred in effect.change.predicates)
				{
					//returnString += "      " + pred.toNaturalLanguageString(pred.primary,pred.secondary) + "\n";
					returnString += "      " + pred.toString() + "\n";
				}
				returnString += "   Linked to instantiation " + effect.instantiationID + ":\n";
				var inst:Instantiation = this.getInstantiationById(effect.instantiationID);
				if (inst)
				{
					if (inst.toc1)
					{
						if (inst.toc1.rawString != "")
						{
							returnString += "      %toc1%: " + inst.toc1.rawString + "\n";
						}
					}
					if (inst.toc2)
					{
						if (inst.toc2.rawString != "")
						{
							returnString += "      %toc2%: " + inst.toc2.rawString + "\n";
						}
					}
					if (inst.toc3)
					{
						if (inst.toc3.rawString != "")
						{
							returnString += "      %toc3%: " + inst.toc3.rawString + "\n";
						}
					}
					returnString += ""
					for each (var lod:LineOfDialogue in inst.lines)
					{
						returnString += "      Initiator: \"" + lod.initiatorLine + "\" (" + lod.initiatorBodyAnimation + ", " + lod.initiatorFaceAnimation + ", " + lod.initiatorFaceState + ")\n";
						returnString += "      Responder: \"" + lod.responderLine + "\" (" + lod.responderBodyAnimation + ", " + lod.responderFaceAnimation + ", " + lod.responderFaceState + ")\n";
						if (lod.otherLine != "")
						{
							returnString += "      Other: \"" + lod.otherLine + "\" (" + lod.otherBodyAnimation + ", " + lod.otherFaceAnimation + ", " + lod.otherFaceState + ")\n";
						}
						returnString += "      ---\n";
					}
				}
				returnString += "\n";
			}

			return returnString;
		}
		
		public static function equals(x:SocialGame, y:SocialGame): Boolean {
			if (x.name != y.name) return false;
			if (x.intents.length != y.intents.length) return false;
			var i:Number = 0;
			for (i = 0; i < x.intents.length; ++i) {
				if (!Rule.equals(x.intents[i], y.intents[i])) return false;
			}
			if (x.preconditions.length != y.preconditions.length) return false;
			for (i=0; i < x.preconditions.length; ++i) {
				if (!Rule.equals(x.preconditions[i], y.preconditions[i])) return false;
			}
			if (!Rule.equals(x.patsyRule, y.patsyRule)) return false;
			if (!InfluenceRuleSet.equals(x.initiatorIRS, y.initiatorIRS)) return false;
			if (!InfluenceRuleSet.equals(x.responderIRS, y.responderIRS)) return false;
			if (x.effects.length != y.effects.length) return false;
			for (i = 0; i < x.effects.length; ++i) {
				if (!Effect.equals(x.effects[i], y.effects[i])) return false;
			}
			if (x.instantiations.length != y.instantiations.length) return false;
			for (i = 0; i < x.instantiations.length; ++i) {
				if (!Instantiation.equals(x.instantiations[i], y.instantiations[i])) return false;
			}
			return true;
		}
		
		
	}
	
}