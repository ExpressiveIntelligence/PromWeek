package CiF 
{
	import flashx.textLayout.utils.CharacterUtil;
	/**
	 * This class implements the pairing of a Rule class with a set of
	 * SocialChange classes. Multiple Effect classes are aggregated by
	 * the SocialGame class to process the outcome of social game play.
	 * 
	 * <p>This class knows the specificity of the rule (aka the number of
	 * preconditions in the Rule part of the Effect) so the SocialGame can
	 * pick the most salient effect of those who's Rule evaluates to true.</p>
	 * 
	 * <p>The class also stores the ID of it's associated social game 
	 * instantiation.</p>
	 * 
	 * @see CiF.SocialGame
	 * @see CiF.Rule
	 * @see CiF.SocialChange
	 * @see CiF.Predicate
	 * 
	 */
	public class Effect
	{
		private var _salience:Number;
		public static const EFFECT_TOO_SOON_TIME:Number = 6;
		public static const LOW_NETWORK_SALIENCE:Number = 2;
		public static const MEDIUM_NETWORK_SALIENCE:Number = 2;
		public static const HIGH_NETWORK_SALIENCE:Number = 2;
		public static const UNRECOGNIZED_NETWORK_SALIENCE:Number = 2;
		
		/**
		 * The conditions for which this effect can be take.
		 */
		public var condition:Rule;
		/**
		 * The rule containing the social change associated with the effect.
		 */
		public var change:Rule;
		
		/**
		 * Stores what last cif.time the instantiation was seen last
		 */
		public var lastSeenTime:Number = -1;
		
		/**
		 * Salience Score is an approximate measure of how "awesome" we we think this effect oughta be
		 */
		public var salienceScore:Number;
		 
		/**
		 * Locutions that comprise this effect's performance realization string
		 */
		public var locutions:Vector.<Locution>;
		/**
		 * The unique identifier.
		 */
		public var id:Number;
		/**
		 * True if the Effect is in the accept branch of the social game and
		 * false if the Effect is in the reject branch.
		 */
		public var isAccept:Boolean;
		/**
		 * The english interpretation of the Effect's outcome to be used when
		 * this effect is referenced in later game play.
		 */		
		public var referenceAsNaturalLanguage:String;
		/**
		 * The ID of the instantiation this effect uses for performance
		 * realization.
		 */
		public var instantiationID:Number;
		
		public function Effect() {
				this.condition = new Rule();
				this.change = new Rule();
				this.id = -1;
				this.isAccept = true;
				this.instantiationID = -1;
				
				this.locutions = new Vector.<Locution>();
		}
		
		/**
		 * Evaluations the condition of the Effect for truth given the current
		 * game state.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return True if all the predicates in the condition are true. Otherwise,
		 * false.
		 */
		public function evaluateCondition(initiator:Character, responder:Character=null, other:Character=null):Boolean {
			return this.condition.evaluate(initiator, responder, other);
		}
		
		/**
		 * Updates the social state if given the predicates in this valuation
		 * rule.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 */
		public function valuation(initiator:Character, responder:Character=null, other:Character = null):void {
			this.change.valuation(initiator, responder, other);
		}

		/**
		 * Determines if the Effect instantiation requires a third character.
		 * @return True if a third character requires or false if one is not.
		 */
		public function requiresThirdCharacter():Boolean {
			return this.condition.requiresThirdCharacter() || this.change.requiresThirdCharacter();
		}
		
		/**
		 * Determines if the Effect instantiation requires a second character.
		 * @return True if a third character requires or false if one is not.
		 */
		public function requiresOnlyOneCharacter():Boolean {
			return this.condition.requiresOnlyOneCharacter() || this.change.requiresOnlyOneCharacter();
		}
		
		/**
		 * Checks the Effect's condition rule for a CKB predicate (which
		 * constitutes a CKB item reference).
		 * 
		 * @return True if a CKB reference exists in the Effect's change rule,
		 * false if none exists.
		 */
		public function hasCKBReference():Boolean {
			for each (var p:Predicate in this.condition.predicates) {
				if (p.type == Predicate.CKBENTRY) {
					return true;
				}
			}
			return false;
		}
		 

		
		/**
		 * Returns the Predicate that holds the CKB reference for the Effect.
		 * @return A Predicate of type CKBENTRY or null if no CKBENTRY
		 * Predicate exists in the Effect's condition Rule.
		 */
		public function getCKBReferencePredicate():Predicate {
			for each (var p:Predicate in this.condition.predicates) {
				if (p.type == Predicate.CKBENTRY) {
					return p;
				}
			}
			return null;
		}
		
		
		
		/**
		 * Checks the Effect's condition rule for a SFDB LAbel
		 * 
		 * @return True if a SFDB label exists in the Effect's change rule,
		 * false if none exists.
		 */
		public function hasSFDBLabel():Boolean {
			for each (var p:Predicate in this.change.predicates) {
				if (p.type == Predicate.SFDBLABEL) {
					return true;
				}
			}
			return false;
		}
		 

		
		/**
		 * Returns the Predicate that holds the SFDB Label for the Effect.
		 * @return A Predicate of type SFDBLabel or null if no SFDBLabel
		 * Predicate exists in the Effect's condition Rule.
		 */
		public function getSFDBLabelPredicate():Predicate {
			for each (var p:Predicate in this.change.predicates) {
				if (p.type == Predicate.SFDBLABEL) {
					return p;
				}
			}
			return null;
		}
		
		public function renderTextNotForDialogue(currentInitiator:Character, currentResponder:Character, currentOther:Character):String
		{
			if (!currentOther)
			{
				currentOther = new Character();
			}
			
			var returnString:String = "";
			
			for each (var loc:Locution in this.locutions)
			{
				returnString += loc.renderText(currentInitiator, currentResponder, currentOther, null);
			}
			
			return returnString;
		}
		
		public function get salience():Number { return this._salience; }
		
		public function set salience(x:Number):void { 
			var oldValue:Number = this._salience;
			this._salience = x;
			if (30 == this.instantiationID || 43 == this.instantiationID) {
				Debug.debug(this, "salience() is now " + this._salience + " and was " + oldValue + " on " + this.condition);
			}
		}
		
		public function scoreSalience():void
		{
			//var salience:Number = 0;
			salience = 0;
			var pred:Predicate;
			
			for each (pred in this.change.predicates)
			{
				if (pred.type == Predicate.SFDBLABEL)
				{
					if (pred.sfdbLabel > SocialFactsDB.FIRST_STORY_SEQUENCE)
					{
						salience += 6;
					}
				}
			}
			
			for each (pred in this.condition.predicates)
			{
				switch (pred.type) 
				{
					case Predicate.RELATIONSHIP:
						if (pred.negated)
						{
							salience += 1
						}
						else
						{
							salience += 3
						}	
						break;
					case Predicate.NETWORK:
						if (pred.comparator == "lessthan" && pred.networkValue == 34) {
							//We are dealing with a 'low' network.
							salience += LOW_NETWORK_SALIENCE;
						}
						else if (pred.comparator == "greaterthan" && pred.networkValue == 66) {
							//we are dealing with a high network.
							salience += HIGH_NETWORK_SALIENCE;
						}
						else if (pred.comparator == "greaterthan" && pred.networkValue == 33) {
							//We are dealing with MEDIUM network (don't pay attention to the 'other half' of a network.
							salience += MEDIUM_NETWORK_SALIENCE;
						}
						else if (pred.comparator == "lessthan" && pred.networkValue == 67) {
							//Technically this is 'medium', but we are going to ignore it in here, because we already caught it in the previous if.
						}
						else {
							//There was an 'unrecognized network value!' here.  Lets give it some salience anyway.
							salience += UNRECOGNIZED_NETWORK_SALIENCE;
							//Debug.debug(this, "scoreSalience() effect id: " + id + " linked to instantiation " + instantiationID + " had a 'non-standard' network value used.");
						}
						/*
						//a cruddy way to not get the second medium network value
						if (pred.comparator != "lessthan" && pred.networkValue != 67)
						{
							salience += 2
						}
						*/
						break;
					case Predicate.STATUS:
						if (pred.negated)
						{
							salience += 1
						}
						else
						{
							salience += 3
						}
						break;
					case Predicate.TRAIT:
						if (pred.trait == Trait.TRIP || pred.trait == Trait.GRACE)
						{
							salience += 10000;
						}
						if (pred.negated)
						{
							salience += 1
						}
						else
						{
							salience += 4
						}						
						break;
					case Predicate.CKBENTRY:
						//TODO: current I don't take into consideration whether or not first or second subjective link
						if (pred.primary == "" || pred.secondary == "")
						{
							if (pred.truthLabel == "")
							{
								salience += 3
							}
							else
							{
								salience += 4
							}
						}
						else if (pred.truthLabel == "")
						{
							salience += 4
						}
						else
						{
							//this means all are speciufied
							salience += 5
						}
						break;
					case Predicate.SFDBLABEL:
						if (pred.primary == "" || pred.secondary == "")
						{
							if (pred.sfdbLabel < 0)
							{
								salience += 8
							}
							else
							{
								salience += 8
							}
						}
						else if (pred.sfdbLabel < 0)
						{
							salience += 10
						}
						else
						{
							//this means all are specified
							salience += 10
						}
						break;
					default:
						Debug.debug(this, "scoring salience for a predicate without an unrecoginzed type of: " + pred.type);
				}
				if (Status.getStatusNameByNumber(pred.status) == "cheating on")
				{
					salience += 3;
				}
				else if (RelationshipNetwork.getRelationshipNameByNumber(pred.relationship) == "enemies")
				{
					salience += 3;
				}
				else if (RelationshipNetwork.getRelationshipNameByNumber(pred.relationship) == "dating")
				{
					salience += 3;
				}
			}
			
			
			if (this.lastSeenTime >= 0)
			{
				//this means we've seen this effect before
				/*if ((CiFSingleton.getInstance().time - this.lastSeenTime) < Effect.EFFECT_TOO_SOON_TIME)
				{
					salience -= (Effect.EFFECT_TOO_SOON_TIME*2.5 - 2*(CiFSingleton.getInstance().time - this.lastSeenTime));
				}*/
				var penalty:Number;
				penalty = 1000 - (CiFSingleton.getInstance().time - this.lastSeenTime);
				salience = salience - penalty;
			}
			
			this.salienceScore = salience;
		}
		
		
		public static function generateTestData():void
		{
			var sgc:SocialGameContext;

			var cif1:CiFSingleton = CiFSingleton.getInstance();
			
			var zack:Character = cif1.cast.getCharByName("zack");
			var buzz:Character = cif1.cast.getCharByName("buzz");
			var simon:Character = cif1.cast.getCharByName("simon");
			var doug:Character = cif1.cast.getCharByName("doug");
			var monica:Character = cif1.cast.getCharByName("monica");
			var chloe:Character = cif1.cast.getCharByName("chloe");

			var tmpCtr:Number = 0;
			var maxGames:Number = 50;
			for each (var sg:SocialGame in cif1.socialGamesLib.games)
			{
				tmpCtr++;
				if (tmpCtr <= maxGames) {
					sgc = new SocialGameContext();
					sgc.gameName = sg.name;
					for each (var e:Effect in sg.effects)
					{
						trace(sg.name);
						trace("link to inst: " + e.instantiationID);
					
						trace(e.referenceAsNaturalLanguage);
					
						//Monica was in love with Zack
						sgc.setCharacters(monica, zack, simon);
						trace(e.renderTextNotForDialogue(monica, zack, simon));
					
						if (e.requiresThirdCharacter())
						{
							//currently, renderText does not (I think) pass in enough information to determine who an other is addressing (i or r), which means we can't do this right.
							//Monica pissed off Zack by insulting me (and permutations)
							trace(Effect.renderText(chloe, doug, simon, sgc, "other", e.locutions, true));
							//monica pissed off Zack by insulting you
							trace(Effect.renderText(chloe, doug, simon, sgc, "responder", e.locutions, true, "other"));
							//I pissed off Zack by insulting you
							trace(Effect.renderText(monica, doug, simon, sgc, "initiator", e.locutions, true, "other"));
							//You pissed off Zack by insulting me
							trace(Effect.renderText(monica, doug, simon, sgc, "other", e.locutions, true, "initiator"));
							//monica pissed off you by insulting me
							trace(Effect.renderText(monica, doug, simon, sgc, "other", e.locutions, true, "responder"));
							//monica pissed off me by insulting you
							trace(Effect.renderText(monica, zack, simon, sgc, "responder", e.locutions, true, "other"));
						}
						else
						{
							//I was in love with Zack
							sgc.setCharacters(monica, zack);
							trace(Effect.renderText(monica, chloe, null, sgc, "initiator", e.locutions));
						
							//You were in love with Zack
							trace(Effect.renderText(monica, chloe, null, sgc, "responder", e.locutions));
						
							//Monica was in love with you
							trace(Effect.renderText(chloe, zack, null, sgc, "initiator", e.locutions));
						
							//Monica was in love with me
							trace(Effect.renderText(chloe, zack, null, sgc, "responder", e.locutions));
						
							//I was in love with you
							trace(Effect.renderText(monica, zack, null, sgc, "initiator", e.locutions));
						
							//You were in love with me
							trace(Effect.renderText(monica, zack, null, sgc, "responder", e.locutions));
						}
						
						trace("\n");
					}
				}
			}
		}
		
		
		public static function renderText(currentInitiator:Character, currentResponder:Character, currentOther:Character, sgContext:SocialGameContext, speaker:String, locs:Vector.<Locution> = null, otherPresent:Boolean = false, speakerAddressing:String = ""):String
		{	
			if (!currentOther)
			{
				currentOther = new Character();
			}
			
			var realizedString:String = "";
			
			var pronounLocution:PronounLocution;
			var charLocution:CharacterReferenceLocution;
			var thisList:ListLocution;
			var thisPOV:POVLocution;
			
			var referencedInitiator:Character = sgContext.getInitiator();
			var referencedResponder:Character = sgContext.getResponder();
			var referencedOther:Character = sgContext.getOther();
			
			
			var speakerName:String;
			var listenerName:String;
			if (speaker == "initiator" || speaker == "i")
			{
				speakerName = currentInitiator.characterName.toLowerCase();
				listenerName = currentResponder.characterName.toLowerCase();
			}
			else if (speaker == "responder" || speaker == "r")
			{
				speakerName = currentResponder.characterName.toLowerCase();
				listenerName = currentInitiator.characterName.toLowerCase();
			}
			else if (speaker == "other" || speaker == "o")
			{
				speakerName = currentOther.characterName.toLowerCase();
				listenerName = currentInitiator.characterName.toLowerCase();
			}
			else
			{
				Debug.debug(Effect,"No speaker info was passed in");
			}
			
			if (speakerAddressing != "")
			{
				if (speakerAddressing == "initiator" || speakerAddressing == "i")
				{
					listenerName = currentInitiator.characterName.toLowerCase();
				}
				else if (speakerAddressing == "responder" || speakerAddressing == "r")
				{
					listenerName = currentResponder.characterName.toLowerCase();
				}
				else if (speakerAddressing == "other" || speakerAddressing == "o")
				{
					listenerName = currentOther.characterName.toLowerCase();
				}
			}
		
				
			var subjectName:String = "";
			//this means we need to loop through the locutions again to determine subject
			//by convention, all that aren't the subject are the object.
			for each (var loc:Locution in locs)
			{
				if (subjectName == "")
				{
					if (loc.getType() == "CharacterReferenceLocution")
					{
						if ((loc as CharacterReferenceLocution).type == "I" || (loc as CharacterReferenceLocution).type == "IP")
						{
							subjectName = referencedInitiator.characterName.toLowerCase();//"i"; //the referred to initiator
						}
						else if ((loc as CharacterReferenceLocution).type == "R" || (loc as CharacterReferenceLocution).type == "RP")
						{
							subjectName = referencedResponder.characterName.toLowerCase();
						}
						else if ((loc as CharacterReferenceLocution).type == "O" || (loc as CharacterReferenceLocution).type == "OP")
						{
							subjectName = referencedOther.characterName.toLowerCase();//"o";
						}
					}
					else if (loc.getType() == "ListLocution")
					{
						if ((loc as ListLocution).who1 == "i")
						{
							subjectName = referencedInitiator.characterName.toLowerCase();//"i"; //the referred to initiator
						}
						else if ((loc as ListLocution).who1 == "r")
						{
							subjectName = referencedResponder.characterName.toLowerCase();
						}
						else if ((loc as ListLocution).who1 == "o")
						{
							subjectName = referencedOther.characterName.toLowerCase();//"o";
						}					
					}
				}
			}
			
			
			var currentCharacterName:String = "";
			var tempSubjectName:String = "";
			
			//the we know who the speaker is, and who is the subject, we can render the text
			for each (var locution:Locution in locs)
			{
				//is the person being referred to present?
				
				//who is the person being referred to?
									
				if (locution.getType() == "PronounLocution")
				{
					pronounLocution = locution as PronounLocution;
					if (pronounLocution.who == "i")
					{
						currentCharacterName = sgContext.getInitiator().characterName.toLowerCase()//referencedInitiator.characterName.toLowerCase();
					}
					else if (pronounLocution.who == "r")
					{
						currentCharacterName = sgContext.getResponder().characterName.toLowerCase()
					}
					else if (pronounLocution.who == "o")
					{
						currentCharacterName = sgContext.getOther().characterName.toLowerCase()
					}
					
					tempSubjectName = subjectName;
					if (pronounLocution.isSubject)
					{
						tempSubjectName = currentCharacterName;
					}
					
					if (Effect.isCurrentCharacterPresent(currentCharacterName, currentInitiator, currentResponder, currentOther,otherPresent))
					{
						 /* 	
						 *	PronounLocution (for all types, but he's/she's):
						 * 		- can be speaker and subject, which means "I"
						 * 		- can be speaker and object, which means "me"
						 * 		- can be speakee and subject, which means "you"
						 * 		- can be speakee and object, which means "you"
						 */ 
						/* 	
						 *	PronounLocution (for he's/she's):							 
						 * 		- can be speaker, they're being referred to, and subject, which means "I'm"
						 * 		- can be speaker and object, which means "I'm"
						 * 		- can be speakee and subject, which means "you're"
						 * 		- can be speakee and object, which means "you're"
						 */
						 if (pronounLocution.type != "he's/she's" && pronounLocution.type != "was/were")
						 {
							if (pronounLocution.type == "his/her" 
								&& currentCharacterName != speakerName 
								//&& currentCharacterName == subjectName)
								&& currentCharacterName == listenerName)
							{
								//special case 1
								realizedString += "your";
							}
							else if (pronounLocution.type == "his/her" 
								&& currentCharacterName == speakerName 
								&& currentCharacterName != tempSubjectName)
							{
								//special case 1
								realizedString += "my";
							}
							else if (pronounLocution.type == "him/her"
								&& currentCharacterName == tempSubjectName 
								&& currentCharacterName == speakerName)
							{
								//special case 2
								realizedString += "me";
							}
							//"normal cases"
							else if (currentCharacterName == tempSubjectName && currentCharacterName == speakerName)
							{
								if (pronounLocution.isSubject)
								{
									realizedString += "I";
								}
								else {
									realizedString += "my"
								}
							}
							else if (currentCharacterName != tempSubjectName && currentCharacterName == speakerName)
							{
								realizedString += "me";
							}
							else if (currentCharacterName != speakerName && currentCharacterName == tempSubjectName)
							{
								realizedString += "you";									
							}
							else if (currentCharacterName != speakerName && currentCharacterName != tempSubjectName)
							{
								realizedString += "you";
							}
						 }
						 else if (pronounLocution.type == "he's/she's")
						 {
							if (currentCharacterName == tempSubjectName && currentCharacterName == speakerName)
							{
								realizedString += "I'm";
							}
							else if (currentCharacterName != tempSubjectName && currentCharacterName == speakerName)
							{
								realizedString += "I'm";
							}
							else if (currentCharacterName != speakerName && currentCharacterName == tempSubjectName)
							{
								realizedString += "you're";
							}
							else if (currentCharacterName != speakerName && currentCharacterName != tempSubjectName)
							{
								realizedString += "you're";
							}
							else
							{
								realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
							}
						 }
						 else  // pronounLocution.type == "was/were"
						 {
							if (currentCharacterName == listenerName)
							{
								realizedString += "were";
							}
							else
							{
								realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
							}						
						 }
					}
					else  // !Effect.isCurrentCharacterPresent
					{
						realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
					}
				}
				else if (locution.getType() == "CharacterReferenceLocution")
				{
					charLocution = locution as CharacterReferenceLocution;
					
					var isPossessive:Boolean = false;
					if (charLocution.type == "IP" || charLocution.type == "RP" || charLocution.type == "OP")
					{
						isPossessive = true;
					}
					
					if (charLocution.type == "I" || charLocution.type == "IP" || charLocution.type == "IS")
					{
						currentCharacterName = referencedInitiator.characterName.toLowerCase();
					}
					else if (charLocution.type == "R" || charLocution.type == "RP" || charLocution.type == "RS")
					{
						currentCharacterName = referencedResponder.characterName.toLowerCase();
					}
					else if (charLocution.type == "O" || charLocution.type == "OP" || charLocution.type == "OS")
					{
						currentCharacterName = referencedOther.characterName.toLowerCase();
					}
					tempSubjectName = subjectName;
					if (charLocution.type == "IS" || charLocution.type == "RS" || charLocution.type == "OS")
					{
						tempSubjectName = currentCharacterName;
					}
					
					if (Effect.isCurrentCharacterPresent(currentCharacterName, currentInitiator, currentResponder, currentOther,otherPresent))
					{
						/*
						 * CharacterReferenceLocution:
						 * 		- can be speaker: I or my
						 * 		- can be !speaker, but there can be a speaker: 
						 */

						//at this stage we do know that SOMEONE who will be talking is being referenced
						
						//now we have to find out if the locution is the speaker or not

						if (currentCharacterName == speakerName 
								&& !isPossessive
								&& tempSubjectName != speakerName)
						{
							realizedString += "me";
						}
						else if (currentCharacterName == speakerName && !isPossessive)
						{
							realizedString += "I";
						}
						else if (currentCharacterName == speakerName 
								&& isPossessive
								&& tempSubjectName == speakerName)
						{
							realizedString += "mine";
						}
						else if (currentCharacterName == speakerName && isPossessive)
						{
							realizedString += "my";
						}
						else if (currentCharacterName != speakerName && !isPossessive)
						{
							realizedString += "you";								
						}
						else if (currentCharacterName != speakerName && isPossessive)
						{
							realizedString += "your";
						}
						else
						{
							realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
						}
					}
					else // NOT Effect.isCurrentCharacterPresent
					{
						realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);	
					}
				}
				else if (locution.getType() == "ListLocution")
				{
					thisList = locution as ListLocution;
					var list1Name:String = "";
					var list2Name:String = "";
					
					// Get character names.
					if (thisList.who1 == "i")
					{
						list1Name = sgContext.getInitiator().characterName.toLowerCase()//referencedInitiator.characterName.toLowerCase();
					}
					else if (thisList.who1 == "r")
					{
						list1Name = sgContext.getResponder().characterName.toLowerCase()
					}
					else if (thisList.who1 == "o")
					{
						list1Name = sgContext.getOther().characterName.toLowerCase()
					}
					if (thisList.who2 == "i")
					{
						list2Name = sgContext.getInitiator().characterName.toLowerCase()//referencedInitiator.characterName.toLowerCase();
					}
					else if (thisList.who2 == "r")
					{
						list2Name = sgContext.getResponder().characterName.toLowerCase()
					}
					else if (thisList.who2 == "o")
					{
						list2Name = sgContext.getOther().characterName.toLowerCase()
					}
					
					if (thisList.type == "we/they")
					{
						// If either speaker is i, listener is i, speaker is r, or listener is r, use "we"
						if (speakerName == list1Name || speakerName == list2Name) {
							realizedString += "we";
						} else if (listenerName == list1Name || listenerName == list2Name) {
							realizedString += "you";
						} else {
							realizedString += "they";
						}
					}
					else if (thisList.type == "us/them")
					{
						if (speakerName == list1Name || speakerName == list2Name) {
							realizedString += "us";
						} else if (listenerName == list1Name || listenerName == list2Name) {
							realizedString += "you";
						} else {
							realizedString += "them";
						}
					}
					else if (thisList.type == "our/their")
					{
						if (speakerName == list1Name || speakerName == list2Name) {
							realizedString += "our";
						} else if (listenerName == list1Name || listenerName == list2Name) {
							realizedString += "your";
						} else {
							realizedString += "their";
						}
					}
					else if (thisList.type == "and")
					{
						if ((list1Name == speakerName && list2Name == listenerName) ||
							(list2Name == speakerName && list1Name == listenerName))
						{
							realizedString += "you and me";
						}
						else if (list1Name == speakerName)
						{
							realizedString += list2Name + " and I";
						}
						else if (list2Name == speakerName)
						{
							realizedString += list1Name + " and I";
						}
						else if (list1Name == listenerName)
						{
							realizedString += "you and " + list2Name;
						}
						else if (list2Name == listenerName)
						{
							realizedString += "you and " + list1Name;
						}
						else
						{
							realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
						}
					}
					else if (thisList.type == "andp")
					{
						if ((list1Name == speakerName && list2Name == listenerName) ||
							(list2Name == speakerName && list1Name == listenerName))
						{
							realizedString += "our";
						}
						else if (list1Name == speakerName)
						{
							realizedString += list2Name + "'s and my";
						}
						else if (list2Name == speakerName)
						{
							realizedString += list1Name + "'s and my";
						}
						else if (list1Name == listenerName)
						{
							realizedString += "your and " + list2Name + "'s";
						}
						else if (list2Name == listenerName)
						{
							realizedString += "your and " + list1Name + "'s";
						}
						else
						{
							realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
						}
					}	
				}
				else if (locution.getType() == "POVLocution")
				{	
					// This is still not pulling up the right characters... don't use this for now :(
					thisPOV = locution as POVLocution;
					if (currentCharacterName == speakerName && currentCharacterName == sgContext.getInitiator().characterName.toLowerCase())
					{
						realizedString += thisPOV.initiatorString;
					}
					else if (currentCharacterName == speakerName && currentCharacterName == sgContext.getResponder().characterName.toLowerCase())
					{
						realizedString += thisPOV.responderString;
					}
					else
					{
						realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
					}
				}
				else  // NOT locution.getType() == "PronounLocution" || locution.getType() == "CharacterReferenceLocution"
				{
					//just do the normal thing because no one involved in the thing referenced is talking
					realizedString += locution.renderText(referencedInitiator, referencedResponder, referencedOther, null);
				}
			}
			
			return realizedString;
		}
		
		public static function isCurrentCharacterPresent(currentCharacterName:String, currentInitiator:Character, currentResponder:Character, currentOther:Character,otherPresent:Boolean = false):Boolean
		{
			if (currentInitiator.characterName.toLowerCase() == currentCharacterName ||
				currentResponder.characterName.toLowerCase() == currentCharacterName)
			{
				return true;
			}
			if (currentOther.characterName.toLowerCase() == currentCharacterName && otherPresent)
			{
				return true;
			}
			return false;
		}
		
		public function isCharacterReferencedPresent(currentInitiator:Character, currentResponder:Character, currentOther:Character, sgContext:SocialGameContext, speaker:String):Boolean
		{
			var referencedInitiator:Character = sgContext.getInitiator();
			var referencedResponder:Character = sgContext.getResponder();
			var referencedOther:Character = sgContext.getOther();
			
			if (currentInitiator.characterName.toLowerCase() == referencedInitiator.characterName.toLowerCase() ||
				currentResponder.characterName.toLowerCase() == referencedResponder.characterName.toLowerCase() ||
				currentOther.characterName.toLowerCase() == referencedOther.characterName.toLowerCase())
			{
				return true;
			}
			
			return false;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toString():String {
			var result:String = (this.isAccept)?"Accept: ":"Reject: ";
			result += this.condition.toString();
			result += " | ";
			result += this.change.toString();
			return result;
		}
		
		public function toXMLString():String {
			var returnstr:String = new String();
			returnstr += "<Effect id=\"" + this.id + "\" accept=\"" + this.isAccept +  "\" instantiationID=\"" + this.instantiationID + "\">\n";
			returnstr += "<PerformanceRealization>" + this.referenceAsNaturalLanguage + "</PerformanceRealization>\n";
			returnstr += "<ConditionRule>\n ";
			for (var i:Number = 0; i < this.condition.predicates.length; ++i) {
				//returnstr += "   ";
				returnstr += this.condition.predicates[i].toXMLString();
				returnstr += "\n";
			}
			returnstr += "</ConditionRule>\n<ChangeRule>\n";
			for (i = 0; i < this.change.predicates.length; ++i) {
				//returnstr += "   ";
				returnstr += this.change.predicates[i].toXMLString();
				returnstr += "\n";
			}
			returnstr += "</ChangeRule>\n</Effect>\n";
			return returnstr;
		}
		
		public function clone(): Effect {
			var e:Effect = new Effect();
			e.change = new Rule();
			e.condition = new Rule();
			for each(var p:Predicate in this.condition.predicates) {
				e.condition.predicates.push(p.clone());
			}
			for each(p in this.change.predicates) {
				e.change.predicates.push(p.clone());
			}
			e.id = this.id;
			e.isAccept = this.isAccept;
			e.referenceAsNaturalLanguage = this.referenceAsNaturalLanguage;
			e.instantiationID = this.instantiationID;
			return e;
		}
		
		public static function equals(x:Effect, y:Effect): Boolean {
			if (!Rule.equals(x.change, y.change)) return false;
			if (!Rule.equals(x.condition, y.condition)) return false;
			if (x.id != y.id) return false;
			if (x.isAccept != y.isAccept) return false;
			return true;
		}
	}
}