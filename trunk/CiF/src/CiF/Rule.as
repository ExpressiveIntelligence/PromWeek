package CiF 
{
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import flashx.textLayout.utils.CharacterUtil;
	import flash.utils.Dictionary;
	import test.TestCharacter;
	/**
	 * The Rule class aggregates Predicates together and allows for them to be
	 * treated as logical formulae. They are meant to represent a single rule
	 * used in either an InfluenceSet, a precondition for playing a social game,
	 * or used in determing the most specific game effect is true when a game is
	 * concluded.
	 * 
	 * <p>If we wanted to add rules of a non-conjunctive style, this would be the class
	 * to add that functionality to.</p>
	 * 
	 * @see CiF.SocialGame
	 * @see CiF.Predicate
	 * @see CiF.InfluenceSet
	 */
	public class Rule
	{
		/**
		 * The vector of Predicates that comprise the Rule.
		 */
		public var predicates:Vector.<Predicate>;
		/**
		 * The natural language name of the Rule.
		 */
		public var name:String;
		/**
		 * The Generated name of the rule, based on what predicates it contains
		 */
		public var generatedName:String;
		/**
		 * The number of predicates that were true in the rule during it's last
		 * evaluation.
		 */
		public var lastTrueCount:int;
		/**
		 * The unique indentifier of the rule.
		 */
		public var id:int;
		/**
		 * True if all predicates in the rule other than the intent predicate are true.
		 */
		public var allButIntentTrue:Boolean;
		/**
		 * True if the rule has been evaluated. This will be set to false in the 
		 * intent formation process.
		 */
		public var evaluated:Boolean;
		 
		public function Rule() {
			this.predicates = new Vector.<Predicate>();
			this.name = "Anonymous Rule";
			this.lastTrueCount = 0;
			this.id = -1;
			this.allButIntentTrue = false;
			this.evaluated = false;
		}
		
		
		/**
		 * Sorts the list of predicates in a specific order. The order is 
		 * defined to be the order that rules are added to microtheories
		 * to prevent repeat rules.
		 * 
		 */
		public function sortPredicates():void
		{
			var intentPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var relationshipPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var networkPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var statusPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var traitPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var sfdbPreds:Vector.<Predicate> = new Vector.<Predicate>();
			var ckbPreds:Vector.<Predicate> = new Vector.<Predicate>();
			
			
			var hasSFDBOrder:Boolean = false;
			for each (var pred:Predicate in this.predicates)
			{
				if (pred.sfdbOrder != 0)
				{
					hasSFDBOrder = true;
				}
				
				//this if is to make up for there not being a predType for intent.
				if (pred.intent)
				{
					intentPreds.push(pred);
				}
				else
				{
					switch (pred.type)
					{
						//split into separate vectors by type and do some clean up
						case Predicate.RELATIONSHIP:
							/*if (pred.first > pred.second)
							{
								//when the order doesn't matter put in alphabetical order
								var tmp:String = pred.first;
								pred.first = pred.second;
								pred.second = tmp;									
							}*/
							relationshipPreds.push(pred);
							break;
						case Predicate.NETWORK:
							networkPreds.push(pred);
							break;
						case Predicate.STATUS:
							if (pred.status < CiF.Status.FIRST_DIRECTED_STATUS)
							{
								if (pred.status != Status.CAT_FEELING_BAD_ABOUT_SOMEONE && pred.status != Status.CAT_FEELING_GOOD_ABOUT_SOMEONE)
								{
									//this is an exception pertaining to categories
									pred.second = "";
								}
							}
							statusPreds.push(pred);
							break;
						case Predicate.TRAIT:
							pred.second = "";
							traitPreds.push(pred);
							break;
						case Predicate.SFDBLABEL:
							sfdbPreds.push(pred);
							break;
						case Predicate.CKBENTRY:
							ckbPreds.push(pred);
							break;
						default:
					}
				}
			}
			
			intentPreds = intentPreds.sort(comparePredicateNames);
			relationshipPreds = relationshipPreds.sort(comparePredicateNames);
			networkPreds = networkPreds.sort(comparePredicateNames);
			statusPreds = statusPreds.sort(comparePredicateNames)
			traitPreds = traitPreds.sort(comparePredicateNames)
			sfdbPreds = sfdbPreds.sort(comparePredicateNames)
			ckbPreds = ckbPreds.sort(comparePredicateNames)
			
			this.predicates = new Vector.<Predicate>;
			var p:Predicate;
			for each (p in intentPreds) this.predicates.push(p);
			for each (p in relationshipPreds) this.predicates.push(p);
			for each (p in networkPreds) this.predicates.push(p);
			for each (p in statusPreds) this.predicates.push(p);
			for each (p in traitPreds) this.predicates.push(p);
			for each (p in sfdbPreds) this.predicates.push(p);
			for each (p in ckbPreds) this.predicates.push(p);
			
			if (hasSFDBOrder)
			{
				//don't screw with the ordering if there isn't any of these
				this.predicates.sort(compSFDBOrder);
			}
		}
		
		public function sortBySFDBOrder():void
		{
			var hasSFDBOrder:Boolean = false;
			for each (var pred:Predicate in this.predicates)
			{
				if (pred.sfdbOrder != 0)
				{
					hasSFDBOrder = true;
				}
			}
			if (hasSFDBOrder)
			{
				this.predicates.sort(compSFDBOrder);
			}
		}
		
		public function compSFDBOrder(x:Predicate, y:Predicate):Number 
		{
			return x.sfdbOrder - y.sfdbOrder;
		}
		
		public function comparePredicateNames(x:Predicate, y:Predicate):Number
		{
			switch (x.type)
			{
				case Predicate.RELATIONSHIP:
					if (RelationshipNetwork.getRelationshipNameByNumber(x.relationship) < RelationshipNetwork.getRelationshipNameByNumber(y.relationship)) {
						return -1;
					}
					else if (RelationshipNetwork.getRelationshipNameByNumber(x.relationship) > RelationshipNetwork.getRelationshipNameByNumber(y.relationship)) {
						return 1;
					}
					else return 0;
					break;
				case Predicate.NETWORK:
					if (SocialNetwork.getNameFromType(x.networkType) < SocialNetwork.getNameFromType(y.networkType)) {
						return -1;
					}
					else if (SocialNetwork.getNameFromType(x.networkType) > SocialNetwork.getNameFromType(y.networkType)) {
						return 1;
					}
					else return 0;
					break;
				case Predicate.STATUS:
					if (Status.getStatusNameByNumber(x.status) < Status.getStatusNameByNumber(y.status)) {
						return -1;
					}
					else if (Status.getStatusNameByNumber(x.status) > Status.getStatusNameByNumber(y.status)) {
						return 1;
					}
					else return 0;
					break;
				case Predicate.TRAIT:
					if (Trait.getNameByNumber(x.trait) < Trait.getNameByNumber(y.trait)) {
						return -1;
					}
					else if (Trait.getNameByNumber(x.type) > Trait.getNameByNumber(y.type)) {
						return 1;
					}
					else return 0;
					break;
				case Predicate.SFDBLABEL:
					if (SocialFactsDB.getLabelByNumber(x.sfdbLabel) < SocialFactsDB.getLabelByNumber(y.sfdbLabel)) {
						return -1;
					}
					else if (SocialFactsDB.getLabelByNumber(x.sfdbLabel) > SocialFactsDB.getLabelByNumber(y.sfdbLabel)) {
						return 1;
					}
					else return 0;
					break;
				case Predicate.CKBENTRY:
					if (x.truthLabel < y.truthLabel) {
						return -1;
					}
					else if (x.truthLabel > y.truthLabel) {
						return 1;
					}
					else return 0;
					break;
				default:
					Debug.debug(this, "Failed to sort the following predicates: " + x.toString() + " " + y.toString());
					return 0;
			}
			
		}
		
		
		/**
		 * This function is to be used in the loading of microtheories, this simply swaps the first and second roles
		 */
		public function reverseInitiatorAndResponderRoles():void
		{
			var tmpStr:String;
			for each (var pred:Predicate in this.predicates)
			{
				if (pred.primary == "initiator") pred.primary = "responder";
				else if (pred.primary == "responder") pred.primary = "initiator";
				
				if (pred.secondary == "initiator") pred.secondary = "responder";
				else if (pred.secondary == "responder") pred.secondary = "initiator";
				
				if (pred.tertiary == "initiator") pred.tertiary = "responder";
				else if (pred.tertiary == "responder") pred.tertiary = "initiator";
			}
		}
		
		/**
		 * This function will check to see if there are three bound characters necessary to satisfy the
		 * rule. This is different than the requiresThirdCharacter because it doesn't care whether or not there
		 * is an "other" referenced. It also takes care of situations where numTimesUniquelyTrue makes it look
		 * like we require a third!
		 * 
		 * @return
		 */
		public function requiresThreeBoundCharacters():Boolean
		{	
			var initiatorBound:Boolean = false;
			var responderBound:Boolean = false;
			var otherBound:Boolean = false;
			
			for each (var p:Predicate in this.predicates) 
			{
				if (p.numTimesUniquelyTrueFlag) {
					switch(p.numTimesRoleSlot.toLowerCase()) {
						case "first":
							//if the first role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
							if (p.primary.toLowerCase() == "other") {
								otherBound = true;
							}
							if (p.primary.toLowerCase() == "responder") {
								responderBound = true;
							}
							if (p.primary.toLowerCase() == "initator") {
								initiatorBound = true;
							}
							continue;
							break;
						case "second":
							//if the second role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
							if (p.secondary.toLowerCase() == "other") {
								otherBound = true;
							}
							if (p.secondary.toLowerCase() == "responder") {
								responderBound = true;
							}
							if (p.secondary.toLowerCase() == "initiator") {
								initiatorBound = true;
							}
							
							continue;
							break;
						case "both":
							//if either the first or second role is an 'other', then return true.  Otherwise we move on to next predicate.
							if (p.primary.toLowerCase() == "initiator")
							{
								initiatorBound = true;
							}
							else if (p.primary.toLowerCase() == "responder")
							{
								responderBound = true;
							}
							else if (p.primary.toLowerCase() == "other")
							{
								otherBound = true;
							}
							
							if (p.secondary.toLowerCase() == "initiator")
							{
								initiatorBound = true;
							}
							else if (p.secondary.toLowerCase() == "responder")
							{
								responderBound = true;
							}
							else if (p.secondary.toLowerCase() == "other")
							{
								otherBound = true;
							}							
							continue;
							break;
					}
				}
				else
				{
					if (p.primary.toLowerCase() == "initiator")
					{
						initiatorBound = true;
					}
					else if (p.primary.toLowerCase() == "responder")
					{
						responderBound = true;
					}
					else if (p.primary.toLowerCase() == "other")
					{
						otherBound = true;
					}
					
					if (p.secondary.toLowerCase() == "initiator")
					{
						initiatorBound = true;
					}
					else if (p.secondary.toLowerCase() == "responder")
					{
						responderBound = true;
					}
					else if (p.secondary.toLowerCase() == "other")
					{
						otherBound = true;
					}	
				}
				
			}
			
			var threeBound:Boolean = false;
			if (initiatorBound && responderBound && otherBound)
			{
				threeBound = true;
			}
			
			return threeBound;
		}
		
		
		
		/**
		 * Determines if the rule requires a third character to be evaluated
		 * or valuated. This is true if there is a "other" role or "z" 
		 * variable present in any predicate in the rule.
		 * @return	True if a third character is needed for processing the
		 * rule. False if no third character is needed.
		 */
		public function requiresThirdCharacter():Boolean {
			var thirdNeeded:Boolean = false;
			
			for each (var p:Predicate in this.predicates) {
				
				//We can't allow ourselves to be mis-lead by predicates that are 'num times uniquely true'
				//predicates.  We ONLY want those to count as requiring an other if there is an other specified
				//in the role slot that we care about (first, second, or either first or second if 'both' is checked.
				if (p.numTimesUniquelyTrueFlag) {
					switch(p.numTimesRoleSlot.toLowerCase()) {
						case "first":
							//if the first role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
							if (p.primary.toLowerCase() == "other") {
								return true;
							}
							continue;
							break;
						case "second":
							//if the second role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
							if (p.secondary.toLowerCase() == "other") {
								return true;
							}
							continue;
							break;
						case "both":
							//if either the first or second role is an 'other', then return true.  Otherwise we move on to next predicate.
							if (p.primary.toLowerCase() == "other" || p.secondary.toLowerCase() == "other") {
								return true;
							}
							continue;
							break;
					}
				}
				
				switch(p.getPrimaryValue()) {
					case "other":
					case "z":
						thirdNeeded = true;
					default:
				}
				switch(p.getSecondaryValue()) {
					case "other":
					case "z":
						thirdNeeded = true;
					default:
				}
				
				switch(p.getTertiaryValue()) {
					case "other":
					case "z":
						thirdNeeded = true;
					default:
				}
				
				if (thirdNeeded) {
					//Debug.debug(this, "requiresThirdCharacter() is true in predicate: " + p.toString() );
					//Debug.debug(this, "requiresThirdCharacter() " + p.getPrimaryValue() + " " + p.getSecondaryValue() + " " + p.getTertiaryValue() + " ");
					return true;
				}
			}
			//Debug.debug(this, "requiresThirdCharacter() is false.");
			return thirdNeeded;
		}
		
		
		public function requiresOnlyOneCharacter():Boolean 
		{
			var role:String = "";
			for each (var p:Predicate in this.predicates) 
			{
				if (role == "")
				{
					role = p.getPrimaryValue();
				}
				
				if (p.getPrimaryValue() != "")
				{
					if (p.getPrimaryValue() != role)
					{
						return false;
					}
				}
				if (p.getSecondaryValue() != "")
				{
					if (p.getSecondaryValue() != role)
					{
						return false;
					}
				}
				if (p.getTertiaryValue() != "")
				{
					if (p.getTertiaryValue() != role)
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function hasSFDBOrder():Boolean
		{
			for each (var pred:Predicate in this.predicates)
			{
				if (pred.sfdbOrder != 0) return true;
			}
			return false;
		}
		
		
		/**
		 * Goes through all the predicates and returns the highest percentage true from the initiator
		 * If you pass in a responder or other it will hold those static
		 * @return
		 */
		public function getPercentageTrueForInitiator(initiator:Character,charsToUse:Vector.<Character>=null,responder:Character=null,other:Character=null):Dictionary
		{
			
			var possibleChars:Vector.<Character> = (charsToUse)?charsToUse:CiFSingleton.getInstance().cast.characters;
			var numTrue:int = 0;
			var maxNumTrue:int = -1;
			var pred:Predicate;
			var currentWinningResponder:String; // the name of the character that satisfies the most of the 'secondChar' rules
			var currentWinningOther:String; // the name of the character that satisfies the most of the 'thirdChar' rules.
			var firstChar:Character;
			var secondChar:Character;
			var predTrue:Boolean
			var sfdbOrderFailed:Boolean;
			
			//this is when all we know is the initiator
			if (responder == null && other == null)
			{
				for each (responder in possibleChars)
				{
					if (responder.characterName != initiator.characterName)
					{
						if (this.requiresThirdCharacter())
						{
							for each (other in possibleChars)
							{
								if (initiator.characterName != other.characterName && 
									responder.characterName != other.characterName)
								{
									numTrue = 0;
									sfdbOrderFailed = false;
									for each (pred in this.predicates)
									{
										predTrue = pred.evaluate(initiator, responder, other);
										
										if (!predTrue)
										{
											if (!sfdbOrderFailed )
											{
												sfdbOrderFailed = true;
											}
										}
										if (sfdbOrderFailed)
										{
											predTrue = false;
										}
										
										//if (pred.first == "initiator") firstChar = initiator;
										//else if (pred.first == "responder") firstChar = responder;
										//else if (pred.first == "other") firstChar = other;
										//if (pred.second == "initiator") secondChar = initiator;
										//else if (pred.second == "responder") secondChar = responder;
										//else if (pred.second == "other") secondChar = other;
										
										//if (pred.evaluate(firstChar,secondChar))
										if (predTrue)
										{
											if (!pred.isCharNameTrait()) numTrue++;
											//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
										}
										else {
											//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
										}
									}
									if (numTrue > maxNumTrue)
									{
										maxNumTrue = numTrue;
										currentWinningResponder = responder.characterName;
										currentWinningOther = other.characterName;
									}
								}
							}
						}
						else
						{
							numTrue = 0;
							sfdbOrderFailed = false;
							for each (pred in this.predicates)
							{
								//if (pred.first == "initiator") firstChar = initiator;
								//else if (pred.first == "responder") firstChar = responder;
								//if (pred.second == "initiator") secondChar = initiator;
								//else if (pred.second == "responder") secondChar = responder;
								//if (pred.evaluate(firstChar,secondChar))
								
								predTrue = pred.evaluate(initiator, responder);
								
								
								if (!predTrue)
								{
									if (!sfdbOrderFailed )
									{
										sfdbOrderFailed = true;
									}
								}
								if (sfdbOrderFailed)
								{
									predTrue = false;
								}
								
								
								
								if (predTrue)
								{
									if (!pred.isCharNameTrait()) numTrue++;
									//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName));
								}
								else {
									//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName));
								}
							}
							if (numTrue > maxNumTrue)
							{
								maxNumTrue = numTrue;
								currentWinningResponder = responder.characterName;
							}
						}
					}
				}
			}
			//this is when we want to also keep the responder statis along with the initiator
			else if (responder != null && other == null)
			{
				if (this.requiresThirdCharacter())
				{
					for each (other in possibleChars)
					{	
						if (initiator.characterName != other.characterName && 
							responder.characterName != other.characterName)
						{
							numTrue = 0;
							sfdbOrderFailed = false;
							for each (pred in this.predicates)
							{
								//if (pred.first == "initiator") firstChar = initiator;
								//else if (pred.first == "responder") firstChar = responder;
								//else if (pred.first == "other") firstChar = other;
								//if (pred.second == "initiator") secondChar = initiator;
								//else if (pred.second == "responder") secondChar = responder;
								//else if (pred.second == "other") secondChar = other;
								//if (pred.evaluate(firstChar,secondChar))
								
								
								predTrue = pred.evaluate(initiator, responder,other);
								
								
								if (!predTrue)
								{
									if (!sfdbOrderFailed )
									{
										sfdbOrderFailed = true;
									}
								}
								if (sfdbOrderFailed)
								{
									predTrue = false;
								}
								
								
								if (predTrue)
								{
									if (!pred.isCharNameTrait()) numTrue++;
									//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
								}
								else {
									//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
								}
							}
							if (numTrue > maxNumTrue)
							{
								maxNumTrue = numTrue;
								currentWinningResponder = responder.characterName;
								currentWinningOther = other.characterName;
							}
						}
					}
				}
				else
				{
					numTrue = 0;
					sfdbOrderFailed = false;
					for each (pred in this.predicates)
					{
						//if (pred.first == "initiator") firstChar = initiator;
						//else if (pred.first == "responder") firstChar = responder;
						//if (pred.second == "initiator") secondChar = initiator;
						//else if (pred.second == "responder") secondChar = responder;
						//if (pred.evaluate(firstChar,secondChar))
						
						
						predTrue = pred.evaluate(initiator, responder);
						
						
						if (!predTrue)
						{
							if (!sfdbOrderFailed )
							{
								sfdbOrderFailed = true;
							}
						}
						if (sfdbOrderFailed)
						{
							predTrue = false;
						}
						
						
						
						if (predTrue)
						{
							if (!pred.isCharNameTrait()) numTrue++;
							//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName));
						}
						else {
							//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName));
						}
					}
					if (numTrue > maxNumTrue)
					{
						maxNumTrue = numTrue;
						currentWinningResponder = responder.characterName;
					}
				}
			}
			else if (responder == null && other != null && this.requiresThirdCharacter())
			{
				for each (responder in possibleChars)
				{	
					if (initiator.characterName != responder.characterName && 
						responder.characterName != other.characterName)
					{
						numTrue = 0;
						sfdbOrderFailed = false;
						for each (pred in this.predicates)
						{
							//if (pred.first == "initiator") firstChar = initiator;
							//else if (pred.first == "responder") firstChar = responder;
							//else if (pred.first == "other") firstChar = other;
							//if (pred.second == "initiator") secondChar = initiator;
							//else if (pred.second == "responder") secondChar = responder;
							//else if (pred.second == "other") secondChar = other;
							//if (pred.evaluate(firstChar,secondChar))
							
							predTrue = pred.evaluate(initiator, responder,other);
							
							if (!predTrue)
							{
								if (!sfdbOrderFailed )
								{
									sfdbOrderFailed = true;
								}
							}
							if (sfdbOrderFailed)
							{
								predTrue = false;
							}
							
							
							if (predTrue)
							{
								if (!pred.isCharNameTrait()) numTrue++;
								//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
							}
							else {
								//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
							}
						}
						if (numTrue > maxNumTrue)
						{
							maxNumTrue = numTrue;
							currentWinningResponder = responder.characterName;
							currentWinningOther = other.characterName;
						}
					}
				}
			}
			else if (responder != null && other != null)
			{
				numTrue = 0;
				sfdbOrderFailed = false;
				for each (pred in this.predicates)
				{
					//if (pred.first == "initiator") firstChar = initiator;
					//else if (pred.first == "responder") firstChar = responder;
					//else if (pred.first == "other") firstChar = other;
					//if (pred.second == "initiator") secondChar = initiator;
					//else if (pred.second == "responder") secondChar = responder;
					//else if (pred.second == "other") secondChar = other;
					
					predTrue = pred.evaluate(initiator, responder,other);
					if (!predTrue)
					{
						if (!sfdbOrderFailed )
						{
							sfdbOrderFailed = true;
						}
					}
					if (sfdbOrderFailed)
					{
						predTrue = false;
					}
					
					
					if (predTrue)
					{
						if (!pred.isCharNameTrait()) numTrue++;
						//Debug.debug(this, "this predicate evaluated to true: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
					}
					else {
						//Debug.debug(this, "this predicate evaluated to false: " + pred.toNaturalLanguageString(firstChar.characterName, secondChar.characterName, thirdChar.characterName));
					}
				}
				if (numTrue > maxNumTrue)
				{
					maxNumTrue = numTrue;
					currentWinningResponder = responder.characterName;
					currentWinningOther = other.characterName;
				}
			}
			
			var numToSubtract:int = 0;			
			for each (pred in this.predicates)
			{
				if (pred.isCharNameTrait())
				{
					numToSubtract++;
				}
			}
			
			
			var returnDictionary:Dictionary = new Dictionary();
			returnDictionary["percent"] = maxNumTrue / (this.predicates.length - numToSubtract);
			returnDictionary["responder"] = currentWinningResponder;
			returnDictionary["other"] = currentWinningOther;
			return returnDictionary;
			
			//return maxNumTrue / this.predicates.length;
		}
		
		/**
		 * Determines the highest SFDB order of the predicates in this rule.
		 * 
		 * @return The value of the highest SFDB order of this rule.
		 */
		public function highestSFDBOrder():Number {
			var order:Number = 0;
			for each (var pred:Predicate in this.predicates) 
				if (pred.sfdbOrder > order)
					order = pred.sfdbOrder;
			return order;
		}
		
		
		public function evaluateRuleForInitiatorAndCast(initiator:Character, charsToUse:Vector.<Character> = null):Boolean
		{
			var possibleChars:Vector.<Character> = (charsToUse)?charsToUse:CiFSingleton.getInstance().cast.characters;
			
			for each (var responder:Character in possibleChars)
			{
				if (initiator.characterName != responder.characterName)
				{
					if (this.requiresThirdCharacter())
					{
						for each (var other:Character in possibleChars)
						{
							if (other.characterName != initiator.characterName && other.characterName != initiator.characterName)
							{
								if (this.evaluate(initiator, responder, other))
								{
									return true;
								}
							}
						}
					}
					else
					{
						
						if (this.evaluate(initiator, responder))
						{
							return true;
						}
					}
					
				}
			}
			return false;
		}
		
		
		/**
		 * Returns the conjunction of all the truth values of the Predicates
		 * that compose the rules. 
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return True if all the predicates in the rules are true. Otherwise,
		 * false.
		 */
		public function evaluate(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
			this.lastTrueCount = 0;
			var p:Predicate;
			var p1:Predicate;
			
			//if there is a time ordering dependency in this rule, use the evaluateTimeOrderedRule() pipeline.
			
			if (0 < this.highestSFDBOrder()) {
				//Debug.debug(this, "evaluate() this.highestSFDBOrder of the rule: " + this.highestSFDBOrder());
				return this.evaluateTimeOrdedRule(initiator, responder, other);
			}
			
			//test for the evaluation of a specific rule
			/*if (this.name)
			{
				if (this.name == "fooo")
				{
					Debug.debug(this, "found our rule!");
					if (initiator && responder)
					{
						Debug.debug(this, "there are two chars and the third is: " + ((other)?other.characterName:"NULLZ"));
						if (initiator.characterName.toLowerCase() == "monica" && responder.characterName.toLowerCase() == "zack")
						{
							Debug.debug(this, "found our rule with right chars! " + this.toXMLString());
						}
					}
				}
			}*/
			
			for each (p in this.predicates) {
				//Debug.debug(this, "evaluating predicate of type: " + Predicate.getNameByType(p.type), 0);
				var startTime:Number = getTimer();
				if (!p.evaluate(initiator, responder, other, sg)) {
					Predicate.evalutionComputationTime += getTimer() - startTime;

					return false;
				}
				Predicate.evalutionComputationTime += getTimer() - startTime;
				++this.lastTrueCount;
			}
			return true;
		}
		
		/**
		 * Evaluates a rule with respect to the time order specified in the predicates of the rule. 
		 * 
		 * All rules with a sfdbOrder less than 1 are evaluated without temporal ordering constraints.
		 * 
		 * This function tolerates gaps in order meaning a rule can have predicates of orders 0, 3, 9, 100
		 * and this function will ignore the missing orders.
		 * 
		 * If there are multiple predicates of the same order in the rule, they must all be true after the next
		 * lowest order and before the next highest order. Any predicate of the same order is considered true as
		 * long as they are true in this time interval.
		 * 
		 * @param	p	Predicate to check for.
		 * @param	x	Primary character.
		 * @param	y	Secondary character.
		 * @param	z	Tertiary character.
		 * @return	True if the rule is true when evaluated for the specific character binding wrt
		 * the time ordering of the Predicates in the rule.
		 */
		public function evaluateTimeOrdedRule(x:Character, y:Character, z:Character):Boolean {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//The max order value of the rule.
			var maxOrderInRule:Number = this.highestSFDBOrder();
			//when evaluating an order, this is value is updated with the highest truth time for the order.
			//when evaluating an order, this is value is updated with the highest truth time for the order.
			var curOrderTruthTime:Number = cif.sfdb.getLowestContextTime();
			//the highest truth time of all the predicates in the previous order.
			var lastOrderTruthTime:Number = curOrderTruthTime;
			//the truth time of the current predicate.
			var time:Number;
			//the current order being evaluated
			var order:Number;
			var pred:Predicate; //predicate iterator
			var startTime:Number;
			
			for (order = 1; order <= maxOrderInRule; ++order) {
				for each (pred in this.predicates) {
					if (pred.sfdbOrder == order) {
						startTime = getTimer(); 
						//the predicate is of the order we are currently concerned with
						time = cif.sfdb.timeOfPredicateInHistory(pred, x, y, z);
						Predicate.evalutionComputationTime += getTimer() - startTime;
						//was the predicate true at all in history? If not, return false.
						if (SocialFactsDB.PREDICATE_NOT_FOUND == time) return false;
						
						//this predicate was true only before the last order, so rule is not true.
						if (time < lastOrderTruthTime) return false;
						
						//update curOrderTruthTime to highest value for this order
						if (time > curOrderTruthTime) curOrderTruthTime = time;
						
						//if the preceeding conditions are passed, this predicate of the rule is true; continue to next predicate.
					}
				}
				lastOrderTruthTime = curOrderTruthTime;
			}
			
			//evaluate the predicates in the rule that are not time sensitive (i.e. their order is less than 1).
			for each (pred in this.predicates) {
				if (pred.isSFDB < 1) {
					startTime = getTimer();
					if (!pred.evaluate(x, y, z)) {
						Predicate.evalutionComputationTime += getTimer() - startTime;
						return false;
					}
					Predicate.evalutionComputationTime += getTimer() - startTime;
				}
			}
			
			return true;
		}
		
		/**
		 * Returns the conjunction of all the truth values of the Predicates
		 * that compose the rules other than the rule's intent predicate.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return True if all the predicates in the rules are true. Otherwise,
		 * false.
		 */
		public function evaluateAllNonIntent(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
			this.lastTrueCount = 0;
			for each (var p:Predicate in this.predicates) {
				//Debug.debug(this, "evaluating predicate of type: " + Predicate.getNameByType(p.type), 0);
				if(!p.intent) {
					if (!p.evaluate(initiator, responder, other, sg)) {
						//Debug.debug(this, "predicate is false - " + p.toString());
						this.evaluated = true;
						this.allButIntentTrue = false;
						return false;
					}
					++this.lastTrueCount;
				}
				
			}
			this.evaluated = true;
			this.allButIntentTrue = true;
			return true;
		}
		
		
		
		/**
		 * Performs valuation (aka updating the social state according to
		 * parameterized predicates) for every predicate in the rule.
		 * 
		 * @param	initiator The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 */
		public function valuation(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):void {
			//Debug.debug(this, "valuation() " + toString());
			for each(var pred:Predicate in this.predicates) {
				pred.valuation(initiator, responder, other);
			}
		}
		
		/**
		 * Gets the number of predicates in the rule.
		 */
		public function get length():uint { return predicates.length; }		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toString(): String {
			var returnstr:String = new String();
			for (var i:Number = 0; i < this.predicates.length; ++i) {
				returnstr += this.predicates[i];
				if (i < this.predicates.length - 1) {
					returnstr += "^";
				}
			}
			return returnstr;//this.id + ": " +  	returnstr;
		}
		
		public function toXMLString(): String {
			return this.toXML().toXMLString();
			//var returnstr:String = new String();
			//returnstr += "<Rule name=\"" + this.name + "\">\n";
			//for (var i:Number = 0; i < this.predicates.length; ++i) {
				//returnstr += "   ";
				//returnstr += this.predicates[i].toXMLString();
				//returnstr += "\n";
			//}			
			//returnstr += "</Rule>\n";
			//return returnstr;
		}
		
		public function toXML():XML {
			var outXML:XML = <Rule name={this.name} id={this.id}></Rule>;
			for each (var pred:Predicate in this.predicates) {
				outXML.appendChild(new XML(pred.toXMLString()));
			}
			return outXML;
		}
		
		public function clone(): Rule {
			var r:Rule = new Rule();
			r.predicates = new Vector.<Predicate>();
			for each(var p:Predicate in this.predicates) {
				r.predicates.push(p.clone());
			}
			r.name = this.name;
			r.id = this.id;
			return r;
		}
		

		public static function equalsForMicrotheoryDefinitionAndSocialGameIntent(x:Rule, y:Rule): Boolean {
			if (x.predicates.length != y.predicates.length) return false;
			for (var i:Number = 0; i < x.predicates.length; ++i) {
				if (!Predicate.equalsForMicrotheoryDefinitionAndSocialGameIntent(x.predicates[i], y.predicates[i])) return false;
			}
			return true;
		}
		
		
		public static function equals(x:Rule, y:Rule): Boolean {
			if (x.name != y.name) return false;
			if (x.predicates.length != y.predicates.length) return false;
			for (var i:Number = 0; i < x.predicates.length; ++i) {
				if (!Predicate.equals(x.predicates[i], y.predicates[i])) return false;
			}
			return true;
		}
		
		public static function equalsWithoutWorryingAboutName(x:Rule, y:Rule): Boolean {
			//if (x.name != y.name) return false;
			if (x.predicates.length != y.predicates.length) return false;
			for (var i:Number = 0; i < x.predicates.length; ++i) {
				if (!Predicate.equals(x.predicates[i], y.predicates[i])) return false;
			}
			return true;
		}
		
		/**
		 * DOESN'T WORK RIGHT NOW!!!
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public static function functionallyEquals(x:Rule, y:Rule):Boolean 
		{
			if (x.predicates.length != y.predicates.length)
			{
				return false;
			}
			var predTrue:Boolean;
			for (var i:Number = 0; i < x.predicates.length; i++)
			{
				predTrue = false;
				for each (var pred:Predicate in y.predicates.length)
				{
					if (Predicate.equals(x.predicates[i], pred))
					{
						//this means you found a match
						predTrue = true;
						break;
					}
				}
				//if you've been through all pred and found no match return false
				if (!predTrue)
				{
					return false;
				}
			}
			//if you manage to get here then you found a match for everything
			return true;
		}

		/**
		 * Tells you whether x contains the rule specified in y
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public static function contains(x:Rule, y:Rule):Boolean
		{	
			for each (var predY:Predicate in y.predicates)
			{
				if (!containsPredicate(x, predY))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Returns true is the rule, r, contains a given predicate
		 * 
		 * @param	r
		 * @param	p
		 * @return
		 */
		public static function containsPredicate(r:Rule, p:Predicate):Boolean
		{
			for each (var pred:Predicate in r.predicates)
			{
				if (Predicate.equals(pred, p))
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * This function generates a formatted string based on the contents of the rule
		 * An example generated string name would be: 
		 * intent(Not Friends) Friends and Enemies
		 * @return The genereated name of the rule, based on it's contents
		 */
		public function generateRuleName():String {
			this.sortPredicates(); // Should sort all of the predicates.
			var ruleName:String = "";
			var intentIndex:int = this.findIntentIndex();
			
			// used for handling special case of medium network values.
			var tempNetworkString:String = ""; 
			var tempNetworkBooleanArray:Vector.<Boolean> = new Vector.<Boolean>(3);
			tempNetworkBooleanArray[0] = false;
			tempNetworkBooleanArray[1] = false;
			tempNetworkBooleanArray[2] = false;
			
			if(intentIndex != -1) // It's OK for some rules to not have intents.
				ruleName += this.generateIntentString(intentIndex);
			
			
				
			for (var i:int = 0; i < this.predicates.length; i++) {
				if (i == intentIndex) continue; //Don't repeat Intent
				tempNetworkString = ""; // reset to empty string for next predicate
				var predicateName:String = Predicate.getNameByType(this.predicates[i].type);
				
				if (this.predicates[i].negated && predicateName != "relationship") { // relationship predicates get negation handled elsewhere.
					ruleName += "~";
					//Debug.debug(this, "adding a ~ on " + Predicate.getNameByType(this.predicates[i].type) + "  here we go with this... " + generateNetworkPredicateString(i)); 
				}
				
				if (predicateName.toLowerCase() == "network") {
					tempNetworkString += generateNetworkPredicateString(i);
					//ruleName += "value of tempNetworkString: " + tempNetworkString;
					switch(tempNetworkString) {
						case "BudNetMed":
							if (!tempNetworkBooleanArray[0]) tempNetworkBooleanArray[0] = true;
							else continue;
							break;
						case "RomNetMed":
							if (!tempNetworkBooleanArray[1]) tempNetworkBooleanArray[1] = true;
							else continue;
							break;
						case "CoolNetMed":
							if (!tempNetworkBooleanArray[2]) tempNetworkBooleanArray[2] = true;
							else continue;
							break;
						case "": continue; //Returned if the medium has already been caught--can move on to next predicate.
						default: break; //Assume that it must not have been a medium network value.
					}
					ruleName += tempNetworkString;
					
				}
				else if (predicateName.toLowerCase() == "relationship") {
					ruleName += generateRelationshipPredicateString(i);
				}
				else if (predicateName.toLowerCase() == "status") {
					ruleName += generateStatusPredicateString(i);
				}
				else if (predicateName.toLowerCase() == "trait") {
					ruleName += generateTraitPredicateString(i);
				}
				else if (predicateName.toLowerCase() == "ckb") {
					ruleName += generateCKBPredicateString(i);
				}
				else if (predicateName.toLowerCase() == "sfdblabel") {
					ruleName += generateSFDBPredicateString(i);
				}
				else {
					ruleName += "Unrecognized Predicate Type: " + predicateName;
				}
				
				//Deal with numTimesUniquelTrue
				ruleName += numTimesUniquelyTrueString(i);
				
				//Deal with SFDB Order
				ruleName += sfdbOrderString(i);
				
				if(i + 1 != this.predicates.length) 
					ruleName += " | ";
			}
			
			
			this.generatedName = ruleName;
			return ruleName;
		}
		
		/**
		 * findIntentIndex returns the integer index of the rule's Intent.
		 * because any given rule should only have a single intent, the function
		 * stops searching when it find the first Intent.  Will return -1 if there
		 * was no intent found.
		 * @return The index of the Intent in the predicate vector, or -1 if no
		 * intent was found.
		 */
		public function findIntentIndex():int {
			var targetIndex:int = 0;
			for (targetIndex = 0; targetIndex < this.predicates.length; targetIndex++) {
				if (this.predicates[targetIndex].intent)
					return targetIndex;
			}
			return -1;
		}
		
		/**
		 * Generates the 'intent' portion of the generated rule name
		 * @param	intentIndex the location in the predicates vector of this rules intent
		 * @return the generated intent in string form.
		 */
		private function generateIntentString(intentIndex:int):String {
			var intentType:int = this.predicates[intentIndex].type;
			var generatedRuleName:String = "Intent(";
						
			if (Predicate.getNameByType(intentType) == "network") {
				//Get the name of the type of network
				var networkType:String = SocialNetwork.getNameFromType(this.predicates[intentIndex].networkType);
				if (networkType == "buddy") generatedRuleName += "Bud";
				else if (networkType == "romance") generatedRuleName += "Rom";
				else if (networkType == "cool") generatedRuleName += "Cool";
				else generatedName += "Not-Recognized Network Type";
					
				//Find out if it is network up or network down
				if (this.predicates[intentIndex].operator == "+") generatedRuleName += "Up";
				else if (this.predicates[intentIndex].operator == "-") generatedRuleName += "Down";
				else generatedRuleName += "Neither '-' or '+' were specified!";
			}
			else if (Predicate.getNameByType(intentType) == "relationship") {
				generatedRuleName += generateRelationshipPredicateString(intentIndex);
			}
			generatedRuleName += ")*";
			return generatedRuleName;
		}
		
		/**
		 * generateRelationshipPredicateString will create an 'english' version name of any
		 * relationship predicates in a rule (e.g. Friends, Enemies, Dating).
		 * 
		 * @param	predicateIndex The location in the rules predicates vector of the 
		 * relationship predicate that we will find the english name of.
		 * @return The String form of the relationship predicate, to be used in the automated
		 * name of a rule.
		 */
		private function generateRelationshipPredicateString(predicateIndex:int):String {
				var ruleName:String = "";
				
				//Find out if the relationship is negated or not
				if (this.predicates[predicateIndex].negated) ruleName += "~";
				
				//Get the name of the type of relationship
				var relationshipType:String = RelationshipNetwork.getRelationshipNameByNumber(this.predicates[predicateIndex].relationship);
				if (relationshipType == "friends") ruleName += "Friends";
				else if (relationshipType == "dating") ruleName += "Dating";
				else if (relationshipType == "enemies") ruleName += "Enemies";
				else ruleName += "Unspecified Relationship Type";
				
				ruleName += "(" + this.predicates[predicateIndex].first.substring(0,1);
				ruleName += "," + this.predicates[predicateIndex].second.substring(0,1);
				ruleName += ")";
				
				return ruleName;
		}
		
		/**
		 * 
		 * Given the index of a network predicate, returns the 'string representation of it
		 * (e.g. BudNetMed)
		 * 
		 * @param	predicateIndex the index of the network predicate in teh Predicate Vector of the rule
		 * @return the string representation of the predicate
		 */
		private function generateNetworkPredicateString(predicateIndex:int):String {
			var ruleName:String = "";
			var tempNetworkType:String = "";
			switch(SocialNetwork.getNameFromType(this.predicates[predicateIndex].networkType)) {
				case "buddy": tempNetworkType += "BudNet"; break;
				case "romance": tempNetworkType += "RomNet"; break;
				case "cool": tempNetworkType += "CoolNet"; break;
				default: tempNetworkType += "Unrecognized network type";
			}
			if (this.predicates[predicateIndex].comparator == "greaterthan" && this.predicates[predicateIndex].networkValue == 66){
				ruleName += tempNetworkType + "High";
				ruleName += generateDirected(predicateIndex);
			}
			else if (this.predicates[predicateIndex].comparator == "lessthan" && this.predicates[predicateIndex].networkValue == 34){
				ruleName += tempNetworkType + "Low";
				ruleName += generateDirected(predicateIndex);
			}
			else if (this.predicates[predicateIndex].comparator == "lessthan" && this.predicates[predicateIndex].networkValue == 67){
				if(mediumExists(predicateIndex, this.predicates[predicateIndex].networkType, true)){		
					ruleName += tempNetworkType + "Med";
					ruleName += generateDirected(predicateIndex);
				}
				else if (isMediumAlreadyFound(predicateIndex, this.predicates[predicateIndex].networkType, true)) { /*medium is already dealt with*/ }
				else ruleName += tempNetworkType + "No Match for this Medium";
			}
			else if (this.predicates[predicateIndex].comparator == "greaterthan" && this.predicates[predicateIndex].networkValue == 33){
				if (mediumExists(predicateIndex, this.predicates[predicateIndex].networkType, false)) {
					ruleName += tempNetworkType + "Med";
					ruleName += generateDirected(predicateIndex);
				}
				else if (isMediumAlreadyFound(predicateIndex, this.predicates[predicateIndex].networkType, false)) { /*medium is already dealt with*/ }
				else ruleName += tempNetworkType + "No Match For This Medium";			
			}
			//else ruleName += tempNetworkType + "Non-Standard Network Value Used"; //THIS IS THE 'NORMAL WAY'
			else { // THIS IS THE BUCKET WAY
				//Just gonna do a 'naive' thing at first -- anything <= to 34 is low, anything >= 66 is high, everything else is medium.
				if (this.predicates[predicateIndex].comparator == "lessthan" && this.predicates[predicateIndex].networkValue <= 34) {
					//this is the bucket for low!
					ruleName += tempNetworkType + "Low";
					ruleName += generateDirected(predicateIndex);
				}
				else if (this.predicates[predicateIndex].comparator == "greaterthan" && this.predicates[predicateIndex].networkValue >= 66){
					ruleName += tempNetworkType + "High";
					ruleName += generateDirected(predicateIndex);
				}
				else {
					ruleName += tempNetworkType + "Med";
					ruleName += generateDirected(predicateIndex);
				}
			}
			
			//ruleName += "(" + this.predicates[predicateIndex].primary + " to " + this.predicates[predicateIndex].secondary + ")";
			
			return ruleName;
		}
		
		/**
		 * generateDirected takes the index of a predicate in this rule's predicate vector, and looks
		 * at the values of it's primary and secondary fields (which should be things along the lines
		 * of initiator, responder, or other).  Based on this, we can generate a condensed version
		 * such as (i->r) that we can use in our generated rule names. 
		 * @param	predicateIndex the index of the predicate we are dealing with in our predicates vector
		 * @return the good, condensed generated rule string name.
		 */
		private function generateDirected(predicateIndex:int):String {
			var from:String = "";
			var to:String = "";
			var finishedString:String = "";
			if (this.predicates[predicateIndex].primary == "initiator") {
				from = "i";
			}
			else if (this.predicates[predicateIndex].primary == "responder") {
				from = "r";
			}
			else if (this.predicates[predicateIndex].primary == "other") {
				from = "o";
			}
			if (this.predicates[predicateIndex].secondary == "initiator") {
				to = "i";
			}
			else if (this.predicates[predicateIndex].secondary == "responder") {
				to = "r";
			}
			else if (this.predicates[predicateIndex].secondary == "other") {
				to = "o";
			}
			
			finishedString += "(" + from + "->" + to + ")";
			return finishedString;
		}
		
		/**
		 * mediumExists checks to see if there is a 'medium network value' in a rule (e.g. a Buddy Network
		 * that is in between the values of 34 and 66), and returns true if there is, or false if there is not.
		 * This function will only look at items PAST startIndex, so that it will not get a false positive
		 * of 'yes' two times.
		 * @param startIndex The index in the rules parameters vector that we begin our search on for another pair.
		 * @param	networkType  The type of network of the first half (buddy, romance, or cool)
		 * @param hasHigh  if true, then we already have the 'high' half of the medium ( < 67), and so we only
		 * need to look for the low half ( > 33).  If false, then the opposite holds true.
		 * @return true if the rule does in fact contain a medium.
		 */
		private function mediumExists(startIndex:int, networkType:int, hasHigh:Boolean):Boolean {
			for (var i:int = startIndex; i < this.predicates.length; i++) {
				if (Predicate.getNameByType(this.predicates[i].type) != "network") continue;
				else if (this.predicates[i].networkType != networkType) continue;
				else if (hasHigh) {
					if (this.predicates[i].comparator == "greaterthan" && this.predicates[i].networkValue == 33) {
						return true;
					}
				}
				else if (!hasHigh) {
					if (this.predicates[i].comparator == "lessthan" && this.predicates[i].networkValue == 67) {
						return true;
					}	
				}
			}
			return false;
		}
		
		/**
		 *  Essentially the opposite of mediumExists -- this goes backwards in the predicate list to see if the
		 *  other half has already been seen.  If so, then it assumes that the text has already been output
		 *  successfully and will return true, as
		 *  as a sign to do nothing.  If not, then there is something weird going on and returns false. This
		 *  function should only ever be called AFTER mediumExists has been called in the program logic.
		 * @param	endIndex  The 'ending index' -- we check everything before this point to see if we have in fact seen the other 
		 * half of this medium pair
		 * @param	networkType the network type that we are looking for (buddy, romance, cool)
		 * @param	hasHigh (if true, then we have already seen the 'high' end ( > 67), and are looking for the low end ( < 34 ) vice versa if false
		 * @return true if the other half was successfully found, false if otherwise.
		 */
		private function isMediumAlreadyFound(endIndex:int, networkType:int, hasHigh:Boolean):Boolean {
			for (var i:int = endIndex; i >= 0; i--) {
				if (Predicate.getNameByType(this.predicates[i].type) != "network") continue;
				else if (this.predicates[i].networkType != networkType) continue;
				else if (hasHigh) {
					if (this.predicates[i].comparator == "greaterthan" && this.predicates[i].networkValue == 33) {
						return true;
					}
				}
				else if (!hasHigh) {
					if (this.predicates[i].comparator == "lessthan" && this.predicates[i].networkValue == 67) {
						return true;
					}	
				}
			}
			return false;
		}
		
		/**
		 * Given the index of a status predicate in the given rule's predicates vector, returns
		 * a string representation of that status (e.g. Cheerful).
		 * 
		 * @param	predicateIndex The location in the rule's predicate vector that holds the status predicate.
		 * @return A string representation of that predicate.
		 */
		private function generateStatusPredicateString(predicateIndex:int):String {
			var predicateString:String = "";
			
			switch(this.predicates[predicateIndex].status) {
				//Catagories
				case Status.CAT_FEELING_BAD:
					predicateString = "cat: feeling bad";
					break;
				case Status.CAT_FEELING_GOOD:
					predicateString = "cat: feeling good";
					break;
				case Status.CAT_FEELING_BAD_ABOUT_SOMEONE:
					predicateString = "cat: feeling bad about someone";
					break;
				case Status.CAT_FEELING_GOOD_ABOUT_SOMEONE:
					predicateString = "cat: feeling good about someone";
					break;
				case Status.CAT_REPUTATION_BAD:
					predicateString = "cat: reputation bad";
					break;
				case Status.CAT_REPUTATION_GOOD:
					predicateString = "cat: reputation good";
					break;
				
				//Non-Directed
				case Status.EMBARRASSED:
					predicateString = "Embarrassed";
					break;
				case Status.CHEATER:
					predicateString = "Cheater";
					break;
				case Status.SHAKEN:
					predicateString = "Shaken";
					break;
				case Status.DESPERATE:
					predicateString = "Desperate";
					break;
				case Status.CLASS_CLOWN:
					predicateString = "class Clown";
					break;
				case Status.BULLY:
					predicateString = "Bully";
					break;
				case Status.LOVE_STRUCK:
					predicateString = "Love Struck";
					break;
				case Status.GROSSED_OUT:
					predicateString = "Grossed Out";
					break;
				case Status.EXCITED:
					predicateString = "Excited";
					break;
				case Status.POPULAR:
					predicateString = "Popular";
					break;
				case Status.SAD:
					predicateString = "Sad";
					break;
				case Status.ANXIOUS:
					predicateString = "Anxious";
					break;
				case Status.HONOR_ROLL:
					predicateString = "Honor Roll";
					break;
				case Status.LOOKING_FOR_TROUBLE:
					predicateString = "Looking For Trouble";
					break;
				case Status.GUILTY:
					predicateString = "Guilty";
					break;
				case Status.FEELS_OUT_OF_PLACE:
					predicateString = "Feels Out Of Place";
					break;
				case Status.HEARTBROKEN:
					predicateString = "Heartbroken";
					break;
				case Status.CHEERFUL:
					predicateString = "Cheerful";
					break;
				case Status.CONFUSED:
					predicateString = "Confused";
					break;
				case Status.LONELY:
					predicateString = "Lonely";
					break;
					
				//New statuses that never got added somehow
				case Status.HOMEWRECKER:
					predicateString = "Homewrecker";
					break;
				case Status.RESIDUAL_POPULAR:
					predicateString = "Residual Popular";
					
				//Directed
				case Status.HAS_A_CRUSH_ON:
					return "Has A Crush On" + generateDirected(predicateIndex);
				case Status.ANGRY_AT:
					return "Angry At" + generateDirected(predicateIndex);
				case Status.WANTS_TO_PICK_ON:
					return "Wants To Pick On" + generateDirected(predicateIndex);
				case Status.ANNOYED_WITH:
					return "Annoyed With" + generateDirected(predicateIndex);
				case Status.SCARED_OF:
					return "Scared Of" + generateDirected(predicateIndex);
				case Status.PITIES:
					return "Pities" + generateDirected(predicateIndex);
				case Status.ENVIES:
					return "Envies" + generateDirected(predicateIndex);
				case Status.GRATEFUL_TOWARD:
					return "Grateful Toward" + generateDirected(predicateIndex);
				case Status.CHEATING_ON:
					return "Cheating on" + generateDirected(predicateIndex);
				case Status.TRUSTS:
					return "Trusts" + generateDirected(predicateIndex);
				//new statuses that hadn't  been added!
				case Status.FEELS_SUPERIOR_TO:
					return "Feels superior to:" + generateDirected(predicateIndex);
				case Status.CHEATED_ON_BY:
					return "Cheated on by:" + generateDirected(predicateIndex);
				case Status.HOMEWRECKED:
					return "Homewrecked:" + generateDirected(predicateIndex);
				
				default:
					predicateString = "unknown status";
			}
			predicateString += "(";
			if (this.predicates[predicateIndex].primary == "initiator") {
				predicateString += "i";
			}
			else if (this.predicates[predicateIndex].primary == "responder") {
				predicateString += "r";
			}
			else if (this.predicates[predicateIndex].primary == "other") {
				predicateString += "o";
			}
			predicateString += ")";
			return predicateString;
		}
		
		/**
		 * generateTraitPredicateString will, given the index of a trait predicate in the given
		 * rules predicates vector, return a string representation of that predicate (e.g. arrogant)
		 * 
		 * @param	predicateIndex The location of the trait predicate in the predicates vector
		 * @return A string representation of the trait predicate
		 */
		
		private function generateTraitPredicateString(predicateIndex:int):String {
			var traitString:String = "";
			switch (this.predicates[predicateIndex].trait) {
				case Trait.CAT_SEXY:
					traitString = "cat: sexy";
					break;
				case Trait.CAT_JERK:
					traitString = "cat: jerk";
					break;
				case Trait.CAT_NICE:					
					traitString = "cat: nice";
					break;
				case Trait.CAT_SHARP:
					traitString = "cat: sharp";
					break;
				case Trait.CAT_INTROVERTED:
					traitString = "cat: introverted";
					break;
				case Trait.CAT_EXTROVERTED:
					traitString = "cat: extroverted";
					break;
				case Trait.CAT_CHARACTER_FLAW:
					traitString = "cat: character flaw";
					break;
				case Trait.CAT_CHARACTER_VIRTUE:
					traitString = "cat: character virtue";
					break;
				
				case Trait.OUTGOING:
					traitString = "Outgoing";
					break;
				case Trait.SHY:
					traitString = "Shy";
					break;
				case Trait.ATTENTION_HOG:
					traitString = "Attention Hog";
					break;
				case Trait.IMPULSIVE:
					traitString = "Impulsive";
					break;
				case Trait.COLD:
					traitString = "Cold";
					break;
				case Trait.KIND:
					traitString = "Kind";
					break;
				case Trait.IRRITABLE:
					traitString = "Irritable";
					break;
				case Trait.LOYAL:
					traitString = "Loyal";
					break;
				case Trait.LOVING:
					traitString = "Loving";
					break;
				case Trait.SYMPATHETIC:
					traitString = "Sympathetic";
					break;
				case Trait.MEAN:
					traitString = "Mean";
					break;
				case Trait.CLUMSY:
					traitString = "Clumsy";
					break;
				case Trait.CONFIDENT:
					traitString = "Confident";
					break;
				case Trait.INSECURE:
					traitString = "Insecure";
					break;
				case Trait.MOPEY:
					traitString = "Mopey";
					break;
				case Trait.BRAINY:
					traitString = "Brainy";
					break;
				case Trait.DUMB:
					traitString = "Dumb";
					break;
				case Trait.DEEP:
					traitString = "Deep";
					break;
				case Trait.SHALLOW:
					traitString = "Shallow";
					break;
				case Trait.SMOOTH_TALKER:
					traitString = "Smooth Talker";
					break;
				case Trait.INARTICULATE:
					traitString = "Inarticulate";
					break;
				case Trait.SEX_MAGNET:
					traitString = "Sex Magnet";
					break;
				case Trait.AFRAID_OF_COMMITMENT:
					traitString = "Afraid Of Commitment";
					break;
				case Trait.TAKES_THINGS_SLOWLY:
					traitString = "Takes Things Slowly";
					break;
				case Trait.DOMINEERING:
					traitString = "Domineering";
					break;
				case Trait.HUMBLE:
					traitString = "Humble";
					break;
				case Trait.ARROGANT:
					traitString = "Arrogant";
					break;
				case Trait.DEFENSIVE:
					traitString = "Defensive";
					break;
				case Trait.HOTHEAD:
					traitString = "Hothead";
					break;
				case Trait.PACIFIST:
					traitString = "Pacifist";
					break;
				case Trait.RIPPED:
					traitString = "Ripped";
					break;
				case Trait.WEAKLING:
					traitString = "Weakling";
					break;
				case Trait.FORGIVING:
					traitString = "Forgiving";
					break;
				case Trait.EMOTIONAL:
					traitString = "Emotional";
					break;
				case Trait.SWINGER:
					traitString = "Swinger";
					break;
				case Trait.JEALOUS:
					traitString = "Jealous";
					break;
				case Trait.WITTY:
					traitString = "Witty";
					break;
				case Trait.SELF_DESTRUCTIVE:
					traitString = "Self Destructive";
					break;
				case Trait.OBLIVIOUS:
					traitString = "Oblivious";
					break;
				case Trait.VENGEFUL:
					traitString = "Vengeful";
					break;
				case Trait.COMPETITIVE:
					traitString = "Competitive";
					break;
				case Trait.STUBBORN:
					traitString = "Stubborn";
					break;
				case Trait.DISHONEST:
					traitString = "Dishonest";
					break;
				case Trait.HONEST:
					traitString = "Honest";
					break;
				default:
					traitString = "trait not declared";	
					break;
			}
			traitString += "(";
			if (this.predicates[predicateIndex].primary == "initiator") {
				traitString += "i";
			}
			else if (this.predicates[predicateIndex].primary == "responder") {
				traitString += "r";
			}
			else if (this.predicates[predicateIndex].primary == "other") {
				traitString += "o";
			}
			traitString += ")";
			return traitString;
		}
		
		/**
		 * generateCKBKPredicateString will, given the location of a predicate of type 'ckb' in
		 * the given rules predicates vector, return a string representation of the predicate
		 * @param	predicateIndex the location of the ckb predicate inside of the given rules predicates vector
		 * @return  The string representation of the ckb predicate
		 */
		private function generateCKBPredicateString(predicateIndex:int):String {
			var firstRole:String = "";
			var firstSubjective:String = "";
			var secondRole:String = "";
			var secondSubjective:String = "";
			var objectiveTruth:String = "";
			var ckbLocutionTranslation:String = "";
			var ckbPredicate:Predicate = this.predicates[predicateIndex];
			//conditionEditor.locutionTranslation.text = "Dealing with CKB...";
			
			firstRole = ckbPredicate.primary;
			//firstRole = conditionEditor.firstRole.selectedItem;
			firstSubjective = ckbPredicate.firstSubjectiveLink;
			//firstSubjective = conditionEditor.firstRoleSubjective.selectedItem;
			secondRole = ckbPredicate.secondary;
			//secondRole = conditionEditor.secondRole.selectedItem;
			secondSubjective = ckbPredicate.secondSubjectiveLink;
			//secondSubjective = conditionEditor.secondRoleSubjective.selectedItem;
			objectiveTruth = ckbPredicate.truthLabel;
			//objectiveTruth = conditionEditor.ckbValue.selectedItem;
			
			if (firstRole == "initiator") firstRole = "i";
			else if (firstRole == "responder") firstRole = "r";
			else if (firstRole == "other") firstRole = "o";
			else firstRole = "";
			
			if (secondRole == "initiator") secondRole = "i";
			else if (secondRole == "responder") secondRole = "r";
			else if (secondRole == "other") secondRole = "o";
			else secondRole = "";
			
			ckbLocutionTranslation = "CKB_((";
			ckbLocutionTranslation += firstRole;	
			ckbLocutionTranslation += ",";
			ckbLocutionTranslation += firstSubjective;
			ckbLocutionTranslation += "),(";
			ckbLocutionTranslation += secondRole;
			ckbLocutionTranslation += ",";
			ckbLocutionTranslation += secondSubjective;
			ckbLocutionTranslation += "),(";
			ckbLocutionTranslation += objectiveTruth;
			ckbLocutionTranslation += "))";
					
			/*
			if (!conditionEditor.useFirstRoleSubjective.selected) {
				ckbLocutionTranslation += firstSubjective;
			}
			ckbLocutionTranslation += "),(";
			if (!conditionEditor.useSecondRole.selected) {
				ckbLocutionTranslation += secondRole;
			}
			ckbLocutionTranslation += ",";
			if (!conditionEditor.useSecondRoleSubjective.selected) {
				ckbLocutionTranslation += secondSubjective;
			}
			ckbLocutionTranslation += "),(";
			if (!conditionEditor.useCKBTruthValue.selected) {
				ckbLocutionTranslation += objectiveTruth;
			}
			ckbLocutionTranslation += "))%";
			conditionEditor.locutionTranslation.text = ckbLocutionTranslation;
			*/
			return ckbLocutionTranslation;
		}
		
		/**
		 * TODO: Determine a standard way of writing SFDB Entries
		 * TODO: Fill in this function with whatever specifics apply to the determined 'standard way'
		 * generateSFDBPredicateString will, given the location of a predicate of type 'sfdb' in
		 * the given rules predicates vector, return a string representation of the predicate
		 * @param	predicateIndex the location of the ckb predicate inside of the given rules predicates vector
		 * @return  The string representation of the ckb predicate
		 */
		private function generateSFDBPredicateString(predicateIndex:int):String {
				
			var firstRole:String = "";
			var secondRole:String = "";
			var SFDBLabel:String = "";
			var window:int = -1;
			var SFDBTranslatedLocution:String = "";
			var sfdbPredicate:Predicate = this.predicates[predicateIndex];
			
			firstRole = sfdbPredicate.primary;
			secondRole = sfdbPredicate.secondary;
			SFDBLabel = SocialFactsDB.getLabelByNumber(sfdbPredicate.sfdbLabel);
			window = sfdbPredicate.window;
			
			if (sfdbPredicate.sfdbLabel <= SocialFactsDB.LAST_CATEGORY_COUNT) {
				SFDBLabel = SFDBLabel.slice(5);
			}
			
			/*
			firstRole = conditionEditor.firstRole.selectedItem;
			secondRole = conditionEditor.secondRole.selectedItem;
			SFDBLabel = conditionEditor.sfdbValue.selectedItem;
			window = conditionEditor.sfdbWindowStepper.value;
			*/
			
			if (firstRole == "initiator") firstRole = "i";
			else if (firstRole == "responder") firstRole = "r";
			else if (firstRole == "other") firstRole = "o";
			
			if (secondRole == "initiator") secondRole = "i";
			else if (secondRole == "responder") secondRole = "r";
			else if (secondRole == "other") secondRole = "o";
			
			SFDBTranslatedLocution = "SFDB_(";
			SFDBTranslatedLocution += SFDBLabel;
			SFDBTranslatedLocution += "," + firstRole + ",";
			SFDBTranslatedLocution += secondRole
			SFDBTranslatedLocution += "," + window + ")";
		
			return SFDBTranslatedLocution;
		}
		
		/**
		 * Returns the 'num times uniquely true' part of a predicate, assuming of course that it 
		 * IS a num times uniquely true predicate (we DON"T do a check ahead of time to see that
		 * it is, so we must do the check inside of this function).
		 * @param	predicateIndex the index of the predicate in question in THIS current rule
		 * @return the string representation of the NTUT portion of the predicate.
		 */
		public function numTimesUniquelyTrueString(predicateIndex:int):String {
			var currentPredicate:Predicate = this.predicates[predicateIndex];
			var returnString:String = "";
			var roleString:String = "";
			if (currentPredicate.numTimesUniquelyTrueFlag) {
				//This is pretty easy, it is just going to be of the form
				//OLDPREDICATE--UT(role,5)
				//where 'role' can be f (first), s (second) or b (both). and the number is the num times uniquely true it can be.
				roleString = currentPredicate.numTimesRoleSlot.substr(0, 1);
				returnString += "--UT(" + roleString + "," + currentPredicate.numTimesUniquelyTrue + ")";
				return returnString;
			}
			else { // oops! not a num times uniquely true!  Nothing to return!
				return "";
			}
		}
		
		/**
		 * Deals with the 'SFDB order' of predicates -- many predicates have an 
		 * sFDB order of 0, which means we don't care about them.  However, occasionally
		 * we stumble upon some that have one that is MORE than zero -- in those situations
		 * they matter, and it is for those situations that we wish this function to capture.
		 * @param	predicateIndex the index of the predicate in THIS rule that we are examining.
		 * @return the piece of the string that covers the SFDB order portion of the predicate.
		 */
		public function sfdbOrderString(predicateIndex:int):String {
			var returnString:String = "";
			var order:int = this.predicates[predicateIndex].sfdbOrder;
			if (order == 0) {
				return returnString
			}
			else { // it is a number we actually care about!
				returnString += "--SFDBOrder(" + order + ")";
			}
			return returnString;
		}
		
		/**
		 * isGeneratedRuleEqualToName simply returns true if the value of the generated variable
		 * is the same as the value of the hand authored 'name' for the rule.  The philosophy being that
		 * the generated name is always what the rule IS, while the hand authored name is what we
		 * want the rule TO ACTUALLY BE.  Thus, if they are equal to each other, then the rule is perfect
		 * If they are not, then there is a typo somewhere -- if the typo is in the actual predicates themselves,
		 * this will help us to catch it!
		 * @return
		 */
		public function isGeneratedRuleEqualToName():Boolean {
			if (this.generatedName.charAt(this.generatedName.length - 1) == " ")
				return (this.name == this.generatedName.substring(0, this.generatedName.length - 1));
			else
				return this.name == this.generatedName;
		}
	}
}