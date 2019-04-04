package CiF 
{
	import flash.utils.Dictionary;
	/**
	 * The Predicate class is the terminal and functional end of the logic
	 * constructs in CiF. All rules, influence rules, rule sets, and social
	 * changes are composed of predicates.
	 * 
	 * <p>Predicates have two major functions: evaluation (to determine truth
	 * given the current social state) and valuation (to modify the current
	 * social state). Each type of predicate has its own valuation and evaluation
	 * functions to enact the logical statement within CiFs data structures.</p>
	 * 
	 * TODO: TESTING!!!!
	 * TODO: Finish evaluation for SFDBLABEL types.
	 */
	public class Predicate
	{
		public static var creationCount:Number = 0.0;
		public static var evaluationCount:Number = 0.0;
		public static var valuationCount:Number = 0.0;
		public static var evalutionComputationTime:Number = 0.0;
		
		/**
		 * The number of distinct predicate types.
		 */
		public static const TYPE_COUNT:Number = 7;
		
		public static const TRAIT:Number = 0;
		public static const NETWORK:Number= 1;
		public static const STATUS:Number = 2;
		public static const CKBENTRY:Number = 3;
		public static const SFDBLABEL:Number = 4;
		public static const RELATIONSHIP:Number = 5;
		public static const CURRENTSOCIALGAME:Number = 6;
		
		
		public static const NEGATE:Boolean = true;
		
		/**
		 * The number of distinct social network comparators.
		 */
		public static const COMPARATOR_COUNT:Number = 6;
		//Network comparision operators (a.k.a. comparators).
		public static const LESSTHAN:Number = 0;
		public static const GREATERTHAN:Number = 1;
		public static const AVERAGEOPINION:Number = 2;
		public static const FRIENDSOPINION:Number = 3;
		public static const DATINGOPINION:Number = 4;
		public static const ENEMIESOPINION:Number = 5;
		
		/**
		 * The number of social change operators over social networks.
		 */
		public static const OPERATOR_COUNT:Number = 8;
		//network operators
		public static const ADD:Number = 0;
		public static const SUBTRACT:Number = 1;
		public static const MULTIPLY:Number = 2;
		public static const ASSIGN:Number = 3;
		public static const EVERYONEUP:Number = 4;
		public static const ALLFRIENDSUP:Number = 5;
		public static const ALLDATINGUP:Number = 6;
		public static const ALLENEMYUP:Number = 7;
		
		
		// The following numbers are for referenceing the twelve intent types
		public static const INTENT_BUDDY_UP:Number = 0;
		public static const INTENT_BUDDY_DOWN:Number = 1
		public static const INTENT_ROMANCE_UP:Number = 2
		public static const INTENT_ROMANCE_DOWN:Number = 3
		public static const INTENT_COOL_UP:Number = 4
		public static const INTENT_COOL_DOWN:Number = 5
		public static const INTENT_FRIENDS:Number = 6
		public static const INTENT_END_FRIENDS:Number = 7
		public static const INTENT_DATING:Number = 8
		public static const INTENT_END_DATING:Number = 9
		public static const INTENT_ENEMIES:Number = 10
		public static const INTENT_END_ENEMIES:Number = 11
		
		public static const NUM_INTENT_TYPES:Number = 12
		
		
		public var type:Number;
		public var trait:Number;
		public var primary:String;
		public var secondary:String;
		public var tertiary:String;
		public var networkValue:Number;
		public var comparator:String;
		public var operator:String;
		public var relationship:Number;
		public var status:Number;
		public var networkType:Number;
		public var firstSubjectiveLink:String;
		public var secondSubjectiveLink:String;
		public var truthLabel:String;
		public var sfdbOrder:int;
		/**
		 * True if the truth value of the predicate should be negated.
		 */
		public var negated:Boolean;
		/**
		 * Flag marking the predicate as an SFDB lookup if true.
		 */
		public var isSFDB:Boolean;
		/**
		 * Size of the window in the SFDB 
		 */
		public var window:Number;
		/**
		 * The SFDB effect label to lookup.
		 */
		public var sfdbLabel:Number;
		/**
		 * If the predicate should be viewed as intent rather than literal.
		 */
		public var intent:Boolean;
		/**
		 * The name of the current social game to check for.
		 */
		public var currentGameName:String;
		
		/**
		 * Flag that specifies if this is a number of times this pred is uniquely true type pred
		 */
		public var numTimesUniquelyTrueFlag:Boolean;
		
		/**
		 * The number of times this pred needs to be uniquely true
		 */
		public var numTimesUniquelyTrue:int;
		
		/**
		 * What role slots we want to compare against for numTimesUniquely check
		 */
		public var numTimesRoleSlot:String;
		
		/**
		 * Text that describes information about the predicate. For PromWeek, this is where we write hints for how
		 * to make this the case
		 */
		public var description:String;
		
		public function Predicate() {
			this.type = -1;
			this.trait = -1;
			this.description = "";
			this.primary = "";
			this.secondary = "";
			this.tertiary = "";
			this.networkValue = 0;
			this.comparator = "~";
			this.status = -1;
			this.networkType = -1;
			this.firstSubjectiveLink = "";
			this.secondSubjectiveLink = "";
			this.truthLabel = "";
			this.negated = false;
			this.window = 0;
			this.isSFDB = false;
			this.sfdbLabel = -1;
			this.intent = false;
			this.currentGameName = "";
			this.numTimesUniquelyTrueFlag = false;
			this.numTimesUniquelyTrue = 0;
			this.numTimesRoleSlot = "";
			this.sfdbOrder = 0;
			Predicate.creationCount++;
		}
		
		/**********************************************************************
		 * Predicate meta information.
		 *********************************************************************/
		
		/**
		 * Given the integer representation of a Predicate type, this function
		 * returns the String representation of that type. This is intended to
		 * be used in UI elements of the design tool.
		 * 
		 * @example <listing version="3.0">
		 * Predicate.getNameByType(Predicate.TRAIT); //returns "trait"
		 * </listing>
		 * @param	type The Predicate type as an integer.
		 * @return The string representation of the Predicate type.
		 */
		public static function getNameByType(t:Number):String {
			switch (t) {
				case Predicate.TRAIT:
					return "trait";
				case Predicate.NETWORK:
					return "network";
				case Predicate.STATUS:
					return "status";
				case Predicate.CKBENTRY:
					return "CKB";
				case Predicate.SFDBLABEL:
					return "SFDBLabel";
				case Predicate.RELATIONSHIP:
					return "relationship";
				case Predicate.CURRENTSOCIALGAME:
					return "currentSocialGame";
				default:
					return "type not declared";
			}
		}
		
		public static function getTypeByName(name:String):Number {
			switch (name.toLowerCase()) {
				case "trait":
					return Predicate.TRAIT;
				case "network":
					return Predicate.NETWORK;
				case "status":
					return Predicate.STATUS;
				case "ckb":
					return Predicate.CKBENTRY;
				case "sfdblabel":
					return Predicate.SFDBLABEL;
				case "relationship":
					return Predicate.RELATIONSHIP;
				case "currentSocialGame":
					return Predicate.CURRENTSOCIALGAME;
				default:
					return -1;
			}
		}
		
		public static function getCompatorByNumber(n:Number):String {
			switch (n) {
				case Predicate.LESSTHAN:
					return "lessthan";
				case Predicate.GREATERTHAN:
					return "greaterthan";
				case Predicate.AVERAGEOPINION:
					return "AverageOpinion";
				case Predicate.FRIENDSOPINION:
					return "FriendsOpinion";
				case Predicate.DATINGOPINION:
					return "DatingOpinion";
				case Predicate.ENEMIESOPINION:
					return "EnemiesOpinion";
				default:
					return "";
			}
		/*
		 * public static const LESSTHAN:Number = 0;
		public static const GREATERTHAN:Number = 1;
		public static const AVEROPINION:Number = 2;
		public static const FRIENDSOPINION:Number = 3;
		public static const DATINGOPINION:Number = 4;
		public static const ENEMIESOPINION:Number = 5;
		*/
		}
		
		public static function getNumberFromComparator(name:String):Number {
			switch (name.toLowerCase()) {
				case "<":
				case "lessthan":
				case "less than":
				case "less":
					return Predicate.LESSTHAN;
				case ">":
				case "greaterthan":
				case "greater than":
				case "greater":
					return Predicate.GREATERTHAN;
				case "average opinion":
				case "averageopinion":
					return Predicate.AVERAGEOPINION;
				case "friendsopinion":
				case "friends opinion":
				case "friends'opinion":
				case "friends' opinion":
					return Predicate.FRIENDSOPINION;
				case "datingopinion":
				case "dates opinion":
				case "Dates' opinion":
				case "Date's opinion":
					return Predicate.DATINGOPINION;
				case "enemiesopinion":
				case "enemies opinion":
				case "enemies'opinion":
				case "enemy's opinion":
					return Predicate.ENEMIESOPINION;

				default:
					return -1;
			}
		}
		
		public static function getOperatorByNumber(n:Number):String {
			switch (n) {
				case Predicate.ADD:
					return "+";
				case Predicate.SUBTRACT:
					return "-";
				case Predicate.MULTIPLY:
					return "*";
				case Predicate.ASSIGN:
					return "=";
				case Predicate.EVERYONEUP:
					return "EveryoneUp";
				case Predicate.ALLFRIENDSUP:
					return "AllFriendsUp";
				case Predicate.ALLDATINGUP:
					return "AllDatingUp";
				case Predicate.ALLENEMYUP:
					return "AllEnemyUp";
				default:
					return "";
			}
		}
		
		public static function getOperatorByName(name:String):Number {
			switch (name.toLowerCase()) {
				case "+":
					return Predicate.ADD;
				case "-":
					return Predicate.SUBTRACT;
				case "*":
					return Predicate.MULTIPLY;
				case "=":
					return Predicate.ASSIGN;
				case "everyoneup":
					return Predicate.EVERYONEUP;
				case "allfriendsup":
					return Predicate.ALLFRIENDSUP;
				case "alldatingup":
					return Predicate.ALLDATINGUP;
				case "allenemyup":
					return Predicate.ALLENEMYUP;
				default:
					return -1;
			}
		}
		
		/**********************************************************************
		 * Getters and Setters
		 *********************************************************************/
		/*
		public function get primary():String {
			return this._primary;
		}
		
		public function set primary(n:String):void {
			this._primary = n;
		}
		*/ 
		public function get first():String {
			return this.primary;
		}
		
	
		public function set first(n:String):void {
			this.primary = n;
		}
		
		public function get second():String {
			return this.secondary;
		}
		
		public function set second(g:String):void {
			this.secondary = g;
		}
		 
		/**********************************************************************
		 * Predicate initializers
		 *********************************************************************/
		
		/**
		 * Initializes this instance of the Predciate class as a trait or ~trait
		 * predicate.
		 * 
		 * @example <listing version="3.0">
		 * var p:Predicate = new Predicate();
		 * p.setTraitPredicate("x", Trait.SEX_MAGNET, Predicate.NOTTRAIT);
		 * </listing>
		 * @param	first The character variable to which this predicate applies.
		 * @param	trait The enumerated representation of a trait.
		 * @param	isNegated True if the predicate is to be negated.
		 */
		
		public function setTraitPredicate(first:String="initiator", trait:Number=0, isNegated:Boolean = false, isSFDB:Boolean = false):void {
			this.type = Predicate.TRAIT;
			this.trait = trait;
			this.primary = first;
			this.negated = isNegated;
			this.isSFDB = isSFDB;
		}
		
		/**
		 * Initializes this instance of the Predciate class as a network
		 * predicate.
		 * 
		 * TODO: list the types of premissible network comparisions.
		 * 
		 * @example <listing version="3.0">
		 * var p:Predicate = new Predicate();
		 * p.setNetworkPredicate("x", "y", "", 70, SocialNetwork.ROMANCE);
		 * </listing>
		 * @param	first The character variable of the first predicate parameter.
		 * @param	second The character variable of the second predciate parameter.
		 * @param	operator The comparision or valuation operation to perform the
		 * network predicate evaulation or valuation by.
		 * @param	networkValue The network value used in the comparison.
		 * @param	networkType The network on which the comparison is to be made.
		 */
		public function setNetworkPredicate(first:String="initiator", second:String="responder", op:String="lessthan", networkValue:Number=0, networkType:Number=0, isNegated:Boolean=false, isSFDB:Boolean = false):void {
			this.type = Predicate.NETWORK;
			this.networkValue = networkValue;
			this.primary = first;
			this.secondary = second;
			this.comparator = op;
			this.operator = op;
			this.networkType = networkType;
			this.negated = isNegated;
			this.isSFDB = isSFDB;
		}
		
		/**
		 * Initializes this instance of the Predicate class as a relationship 
		 * predicate.
		 * 
		 * @example <listing version="3.0">
		 * var p:Predicate = new Predicate();
		 * p.setRelationshipPredciate("x", "y", 
		 * </listing>
		 * 
		 * @param	first The character variable of the first predicate parameter.
		 * @param	second The character variable of the second predciate parameter.
		 * @param	relationship The relationship of the predicate.
		 * @param	type The type of the predicate as either Predicate.RELATIONSHIP (default)
		 * or Predicate.NOTRELATIONSHIP (have to include as an argument).
		 */
		public function setRelationshipPredicate(first:String="initiator", second:String="responder", relationship:Number=0, isNegated:Boolean = false, isSFDB:Boolean = false ):void {
			this.type = Predicate.RELATIONSHIP;
			this.primary = first;
			this.secondary = second;
			this.relationship = relationship;
			this.negated = isNegated;
			this.isSFDB = isSFDB;
		}		
		
		/**
		 * Initializes this instance of the Predicate class as a status 
		 * predicate.
		 * 
		 * @example <listing version="3.0">
		 * var p:Predicate = new Predicate();
		 * p.setStatusPredciate("x", "y", Status.HAS_CRUSH);
		 * </listing>
		 * 
		 * @param	first The character variable of the first predicate parameter.
		 * @param	second The character variable of the second predciate parameter.
		 * @param	status The status of the predicate.
		 * @param	type The type of the predicate as either Predicate.STATUS (default)
		 * or Predicate.NOTSTATUS (have to include as an argument).
		 */
		public function setStatusPredicate(first:String="initiator", second:String="responder", status:Number=0, isNegated:Boolean = false, isSFDB:Boolean = false ):void {
			this.type = Predicate.STATUS;
			this.primary = first;
			this.secondary = second;
			this.status = status;
			this.negated = isNegated;
			this.isSFDB = isSFDB;
		}
		
		/**
		 * Initializes the Predicate as a CKB predicate.
		 * 
		 * @example <listing version="3.0"> 
		 * var p:Predicate = new Predicate();
		 * p.setCKBPredciate("x", "y", "likes", "dislikes", "cool");
		 * </listing>
		 * @param	first Character variable of the first parameter.
		 * @param	second Character variable of the second parameter.
		 * @param	firstSub Subjective link to the item from the first character.
		 * @param	secondSub Subjective link to the item from the second character.
		 * @param	truth The truth label of the item.
		 * @param	negated true means that the predicate IS negated (i.e. these conditions must NOT exist for the predicate to be evaluated to true)
		 */
		public function setCKBPredicate(first:String="initiator", second:String="responder", firstSub:String="likes", secondSub:String="likes", truth:String="cool", isNegated:Boolean=false):void {
			this.type = Predicate.CKBENTRY;
			this.primary = first;
			this.secondary = second;
			this.firstSubjectiveLink = firstSub;
			this.secondSubjectiveLink = secondSub;
			this.truthLabel = truth;
			this.negated = isNegated;
		}
		
		/**
		 * Initializes the Predicate as a CURRENTSOCIALGAME predicate.
		 * 
		 * @example <listing version="3.0"> 
		 * var p:Predicate = new Predicate();
		 * p.setCurrentSocialGamePredciate("True Love's Kiss", true);
		 * </listing>
		 * @param	name	Name of to check the current social game's name against.
		 * @param	negated true means that the predicate IS negated (i.e. these conditions must NOT exist for the predicate to be evaluated to true)
		 */
		public function setCurrentSocialGamePredicate(name:String="brag", isNegated:Boolean=false):void {
			this.type = Predicate.CURRENTSOCIALGAME;
			this.currentGameName = name;
			this.negated = isNegated;
		}
		
		/**
		 * Modifies the type of the predicate to make it an SFDB entry or make
		 * it not a SFDB entry. The subType and the type are swapped or otherwise
		 * modified to mark the predicate as or not a SFDB entry.
		 */
		public function makeSFDB():void {
			this.isSFDB = true;
		}
		
		/**
		 * Makes the predicate not an SFDB entry. SFDBLABEL type Predicates
		 * cannot have their isSFDB property undone.
		 */
		public function undoSFDB():void {
			//SFDBLABEL types of predicates must be SFDB
			if (Predicate.SFDBLABEL == this.type) {
				Debug.debug(this, "undoSFDB(): instances of Predicate with the type of SFDBLABEL have their isSFDB flag set to false");
			}else {
				this.isSFDB = false;
			}
		}
		
		/**
		 * Initializes the predicate to be of type SFDBLABEL. This is the only
		 * initiator that sets the the isSFDB flag to true. Predicates of type
		 * SFDBLABEL are invalid of their isSFDB is false.
		 * 
		 * @param	first Character variable of the first parameter.
		 * @param	second Character variable of the second parameter.
		 * @param	sfdbLabel The specific SFDB label.
		 * @param	isNegated The truth label of the item.
		 */
		public function setSFDBLabelPredicate(first:String = "initiator", second:String = "responder", label:Number = 0, isNegated:Boolean = false, window1:Number = 0):void {
			this.isSFDB = true;
			this.primary = first;
			this.secondary = second;
			this.type = Predicate.SFDBLABEL;
			this.negated = isNegated;
			this.sfdbLabel = label;
			this.window = window1;
		}

		/**
		 * Initializes the predicate by type enumeration. Default values are
		 * assigned according to the type provided.
		 * @param	t	An enumerated value that corresponds to a predicate type.
		 */
		public function setByTypeDefault(t:Number):void {
			switch (t) {
				case Predicate.TRAIT:
					this.setTraitPredicate();
					break;
				case Predicate.NETWORK:
					this.setNetworkPredicate();
					break;
				case Predicate.STATUS:
					this.setStatusPredicate();
					break;
				case Predicate.CKBENTRY:
					this.setCKBPredicate();
					break;
				case Predicate.SFDBLABEL:
					this.setSFDBLabelPredicate();
					break;
				case Predicate.RELATIONSHIP:
					this.setRelationshipPredicate();
					break;
				case Predicate.CURRENTSOCIALGAME:
					this.setCurrentSocialGamePredicate();
					break;
				default:
					Debug.debug(this, "setByTypeDefault(): unkown type found.");
			}
		}
		
		/**
		 * Determines the value class of the primary property and returns a
		 * value based on that class. If it is a role class, "initiator", 
		 * "responder" or "other" will be returned. If it is a variable class,
		 * "x","y" or "z" will be returned. If it is anything else (character
		 * name or a mispelling), the raw value will be returned.
		 * @return The value based on the value class of the primary property.
		 */
		public function getPrimaryValue():String {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			switch (this.primary.toLowerCase()) {
				case "init":
				case "initiator":
				case "i":
					return "initiator"
				case "r":
				case "res":
				case "responder":
					return "responder";
				case "o":
				case "oth":
				case "other":
					return "other";
				case "x":
					return "x";
				case "y":
					return "y";
				case "z":
					return "z";
				case "":
					return "";
					Debug.debug(this, "getPrimaryValue(): primary was not set.");
				default:
					if (cif.cast.getCharByName(this.primary))
						return this.primary;
					Debug.debug(this, "getPrimaryValue() primary could not be placed in a known class: " + this.primary + " " + this);
			}
			return "";
		}
		
		/**
		 * Determines the value class of the secondary property and returns a
		 * value based on that class. If it is a role class, "initiator", 
		 * "responder" or "other" will be returned. If it is a variable class,
		 * "x","y" or "z" will be returned. If it is anything else (character
		 * name or a mispelling), the raw value will be returned.
		 * @return The value based on the value class of the secondary property.
		 */
		public function getSecondaryValue():String {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			switch (this.secondary.toLowerCase()) {
				case "i":
				case "init":
				case "initiator":
					return "initiator"
				case "r":
				case "res":
				case "responder":
					return "responder";
				case "o":
				case "oth":
				case "other":
					return "other";
				case "x":
					return "x";
				case "y":
					return "y";
				case "z":
					return "z";
				case "":
					//Debug.debug(this, "getSecondaryValue(): secondary was not set.");
					return "";
				default:
					if (cif.cast.getCharByName(this.secondary))
						return this.secondary;
					//Debug.debug(this, "getSecondaryValue() primary could not be placed in a known class: " + this.secondary);
			}
			return "";
		}
		
		/**
		 * Determines the value class of the tertiary property and returns a
		 * value based on that class. If it is a role class, "initiator", 
		 * "responder" or "other" will be returned. If it is a variable class,
		 * "x","y" or "z" will be returned. If it is anything else (character
		 * name or a mispelling), the raw value will be returned.
		 * @return The value based on the value class of the teriary property.
		 */
		public function getTertiaryValue():String {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			switch (this.tertiary.toLowerCase()) {
				case "i":
				case "init":
				case "initiator":
					return "initiator"
				case "r":
				case "res":
				case "responder":
					return "responder";
				case "o":
				case "oth":
				case "other":
					return "other";
				case "x":
					return "x";
				case "y":
					return "y";
				case "z":
					return "z";
				case "":
					//Debug.debug(this, "getTertiaryValue(): tertiary was not set.");
					return "";
				default:
					if (cif.cast.getCharByName(this.tertiary))
						return this.tertiary;
					Debug.debug(this, "getTertiaryValue(): tertiary could not be placed in a known class: " + this.tertiary);
			}
			return "";
		}
		
		/**
		 * Determines the names of any character who was 
		 * explicitly bound to a character variable in this predicate.
		 * @return the names of any character who was 
		 * explicitly bound to a character variable in this predicate.
		 */
		public function getBoundCharacterNames():Vector.<String>{
			var boundCharNames:Vector.<String> = new Vector.<String>();
			
			if (isVariableExplicitlyBound("primary"))
				boundCharNames.push(new String(this.primary));
			if (isVariableExplicitlyBound("secondary"))
				boundCharNames.push(new String(this.secondary));
			if (isVariableExplicitlyBound("teriary"))
				boundCharNames.push(new String(this.tertiary));
			return boundCharNames;
		}
		/**
		 * Determines if the character variable (either first, second, or third or primary, secondary, tertiary)
		 * is explicitly bound to a character (i.e. this.first == "Edward").
		 * 
		 * @param variable	The string representation of a character variable. Can either be "first", "second", or "third".
		 * @return true if the variable is explicitly bound to a character or false if not.
		 */
		public function isVariableExplicitlyBound(variable:String):Boolean {
			var slot:String;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			switch(variable) {
				case "first":
				case "primary":
					slot = this.primary;
					break;
				case "second":
				case "secondary":
					slot = this.secondary;
					break;
				case "third":
				case "teriary":
					slot = this.tertiary
					break;
				default:
					Debug.debug(this, "isVariableExplicitlyBound() could not determine a character variable slot from: " + variable);
			}
			
			switch (slot.toLowerCase()) {
				case "i":
				case "init":
				case "initiator":
				case "r":
				case "res":
				case "responder":
				case "o":
				case "oth":
				case "other":
				case "x":
				case "y":
				case "z":
				case "":
					//Debug.debug(this, "getTertiaryValue(): tertiary was not set.");
					return false;
				default:
					if (cif.cast.getCharByName(slot))
						return true;
					Debug.debug(this, "isVariableExplicitlyBound(): slot was not a role type or a recognized character. slot: " + slot.toLowerCase());
			}
			return false;
		}
		
		/**********************************************************************
		 * Valutation
		 *********************************************************************/
		
		/**
		 * Performs the predicate as a valuation (aka a change to the current game model/social state).
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 * @param	third Character variable of the third predicate parameter.
		 */
		public function valuation(x:Character, y:Character=null, z:Character=null, sg:SocialGame=null):void {
			var first:CiF.Character;
			var second:CiF.Character;
			var third:CiF.Character;
			
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			Predicate.valuationCount++;
			
			//trace(Predicate.getNameByType(this.type));
			
			/**
			 * Need to determine if the predicate's predicate variables reference
			 * roles (initiator,responder), generic variables (x,y,z), or 
			 * characters (edward, karen).
			 */
			//if this.primary is not a reference to a character, determine if 
			//it is either a role or a generic variable
			if (!(first = cif.cast.getCharByName(this.primary))) {
				switch (this.getPrimaryValue()) {
					case "initiator":
					case "x":
						first = x;
						break;
					case "responder":
					case "y": 
						first = y;
						break;
					case "other":
					case "z":
						first = z;
						break;
					default:
						//trace("Predicate: the first variable was not bound to a character!");
						if(this.type != Predicate.CURRENTSOCIALGAME) 
							Debug.debug(this, "the first variable was not bound to a character; it could be a binding problem.");
					//default first is not bound
				}
			}
			
			if (!(second = cif.cast.getCharByName(this.secondary))) {
				switch (this.getSecondaryValue()) {
					case "initiator":
					case "x":
						second = x;
						break;
					case "responder":
					case "y": 
						second = y;
						break;
					case "other":
					case "z":
						second = z;
						break;
					default:
						second = null;
				}
			}
			
			if (!(third = cif.cast.getCharByName(this.tertiary))) {
				switch (this.getTertiaryValue()) {
					case "initiator":
					case "x":
						third = x;
						break;
					case "responder":
					case "y": 
						third = y;
						break;
					case "other":
					case "z":
						third = z;
						break;
					default:
						third = null;
				}
			}
			
			/*var rtnstr:String = "first: ";
			rtnstr += first?first.characterName:"N/A" ;
			rtnstr += " second: ";
			rtnstr += second?second.characterName:"N/A";
			rtnstr += " type: ";
			rtnstr += getNameByType(this.type);
			Debug.debug(this, rtnstr); */
			
			
			/*
			 * At this point only first has to be set. Any other bindings might
			 * not be valid depending on the type of the predicate. For example
			 * a CKBENTRY type could only have a first character variable
			 * specified and would work properly. If second or third are not set
			 * their value is set to null so the proper evaluation functions can
			 * determine how to hand the different cases of character variable
			 * specification.
			 */
			
			switch (this.type) 
			{
				case TRAIT:
					Debug.debug(this, "Traits cannot be subject to valuation.");
					break;
				case NETWORK:
					updateNetwork(first, second);
					break;
				case STATUS:
					updateStatus(first, second);
					break;
				case CKBENTRY:
					Debug.debug(this, "CKBENTRIES cannot be subject to valuation.");
					break;
				case SFDBLABEL:
					//Debug.debug(this, "SFDBLABELs cannot be subject to valuation.");
					break;
				case RELATIONSHIP:
					updateRelationship(first, second);
					break;
				case CURRENTSOCIALGAME:
					Debug.debug(this, "CURRENTSOCIALGAMEs cannot be subject to valuation.");
				default:
					Debug.debug(this, "preforming valuation a predicate without a recoginzed type.");
			}
			
		}
		
		/**
		 * Updates the social status state with a status predicate via valuation.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 */
		private function updateStatus(first:Character, second:Character):void {
			if (this.negated)
				first.removeStatus(this.status, second);
			else
				first.addStatus(this.status, second);
		}
		
		/**
		 * Updates the relationship state with a status predicate via valuation.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 */
		private function updateRelationship(first:Character, second:Character):void {
			var rel:RelationshipNetwork= RelationshipNetwork.getInstance();
			if (this.negated)
			{
				rel.removeRelationship(this.relationship, first, second);
				//rel.removeRelationship(this.relationship, second, first);
				//Debug.debug(this, "updateRelationship() " + RelationshipNetwork.getRelationshipNameByNumber(this.relationship) + "relationship removed.");
			}
			else
			{
				//Debug.debug(this, "updateRelationship() change reached." + this.toNaturalLanguageString(first.characterName, second.characterName,""));
				rel.setRelationship(this.relationship, first, second);
			}
		}
		
		/**
		 * Updates a social network according to the Predicate's parameters via
		 * valuation.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 */
		private function updateNetwork(first:Character, second:Character):void {
			var net:SocialNetwork;
			var firstID:int = first.networkID;
			var secondID:int;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var char:Character;
			
			
			if (second) 
				secondID = second.networkID;
			
			//get the proper singleton based on desired network type.
			if (this.networkType == SocialNetwork.BUDDY) 
				net = BuddyNetwork.getInstance();
			if (this.networkType == SocialNetwork.ROMANCE) 
				net = RomanceNetwork.getInstance();
			if(this.networkType == SocialNetwork.COOL)
				net = CoolNetwork.getInstance();
				
			switch (getOperatorByName(this.operator)) {
				case Predicate.ADD:
					net.addWeight(this.networkValue, first.networkID, second.networkID);
					break;
				case Predicate.SUBTRACT:
					net.addWeight( -this.networkValue, first.networkID, second.networkID);
					break;
				case Predicate.MULTIPLY:
					net.multiplyWeight(first.networkID, second.networkID, this.networkValue);
					break;
				case Predicate.ASSIGN:
					net.setWeight(first.networkID, second.networkID, this.networkValue);
					break;
				case Predicate.EVERYONEUP:
					for each (char in cif.cast.characters) {
						net.addWeight(this.networkValue, char.networkID, firstID);
					}
					break;
				case Predicate.ALLFRIENDSUP:
					for each (char in cif.cast.characters) {
						if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.FRIENDS, first, second)
							&& first.characterName != char.characterName)
							net.addWeight(this.networkValue, char.networkID, firstID);	
					}
					break;
				case Predicate.ALLDATINGUP:
					for each (char in cif.cast.characters) {
						if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.DATING, first, second)
							&& first.characterName != char.characterName)
							net.addWeight(this.networkValue, char.networkID, firstID);	
					}
					break;
				case Predicate.ALLENEMYUP:
					for each (char in cif.cast.characters) {
						if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.ENEMIES, first, second)
							&& first.characterName != char.characterName)
							net.addWeight(this.networkValue, char.networkID, firstID);	
					}
					break;
			}
		}
		
		/**********************************************************************
		 * Predicate evalutation functions.
		 *********************************************************************/
				 
		/**
		 * Evaluates the predicate for truth given the characters involved
		 * bound to the parameters. The process of evaluating truth depends
		 * on the type of the specific instance of the predicate.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 * @param	third Character variable of the third predicate parameter.
		 * @return True of the predicate evaluates to true. False if it does not.
		 */
		public function evaluate(x:Character, y:Character = null, z:Character = null, sg:SocialGame = null):Boolean {

			var first:CiF.Character;
			var second:CiF.Character;
			var third:CiF.Character;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//there is a third character we need to account for.
			var isThird:Boolean = false;
			var pred:Predicate;
			var rule:Rule;
			var intentIsTrue:Boolean = false;

			Predicate.evaluationCount++;
			
			//Debug.debug(this, "evaluate() x: " + (x?x.characterName:"unbound") + " y: " + (y?y.characterName:"unbound") + " sg: " + (sg?sg.name:"unbound") );
			
			
			//trace(Predicate.getNameByType(this.type));
			/**
			 * Need to determine if the predicate's predicate variables reference
			 * roles (initiator,responder), generic variables (x,y,z), or 
			 * characters (edward, karen).
			 */
			//if this.primary is not a reference to a character, determine if 
			//it is either a role or a generic variable
			if (!(first = cif.cast.getCharByName(this.primary))) {
				switch (this.getPrimaryValue()) {
					case "initiator":
					case "x":
						first = x;
						break;
					case "responder":
					case "y": 
						first = y;
						break;
					case "other":
					case "z":
						first = z;
						break;
					default:
						//trace("Predicate: the first variable was not bound to a character!");
						if(this.type != CURRENTSOCIALGAME)
							Debug.debug(this, "the first variable was not bound to a character!");
					//default first is not bound
				}
			}
			
			if (!(second = cif.cast.getCharByName(this.secondary))) {
				switch (this.getSecondaryValue()) {
					case "initiator":
					case "x":
						second = x;
						break;
					case "responder":
					case "y": 
						second = y;
						break;
					case "other":
					case "z":
						second = z;
						break;
					default:
						second = null;
				}
			}
			
			if (!(third = cif.cast.getCharByName(this.tertiary))) {
				switch (this.getTertiaryValue()) {
					case "initiator":
					case "x":
						third = x;
						isThird = true;
						break;
					case "responder":
					case "y": 
						third = y;
						isThird = true;
						break;
					case "other":
					case "z":
						third = z;
						isThird = true;
						break;
					default:
						isThird = false;
						third = null;
				}
			}
			
			
			
			
/*			var rtnstr:String = "first: ";
			rtnstr += first?first.characterName:"N/A" ;
			rtnstr += " second: ";
			rtnstr += second?second.characterName:"N/A";
			rtnstr += " type: ";
			rtnstr += getNameByType(this.type);
			Debug.debug(this, rtnstr); 
*/			
			
			/*
			 * At this point only first has to be set. Any other bindings might
			 * not be valid depending on the type of the predicate. For example
			 * a CKBENTRY type could only have a first character variable
			 * specified and would work properly. If second or third are not set
			 * their value is set to null so the proper evaluation functions can
			 * determine how to hand the different cases of character variable
			 * specification.
			 */
			
			 
			/**
			 * If isSFDB is true, we want to look over the Predicate's window 
			 * in the SFDB for this predicate's context. If found, the predicate
			 * is true. Otherwise, it is false.
			 * 
			 * This is the only evaluation needed for a Predicate with isSFDB
			 * being true. 
			 */
			if (this.isSFDB && this.type != Predicate.SFDBLABEL) {
				return evalIsSFDB(x, y, z, sg);
			}
			 
			/*
			 * If the predicate is intent, we want to check it against all of the 
			 * intent predicates in the intentent rule in the passed-in social game.
			 * If this predicate matches any predicate in any rule of the intent
			 * rule vector of the social game, we return true.
			 * 
			 * Intents can only be networks and relationships.
			 */
			if (this.intent) {
				//Debug.debug(this, "evaluate() in intent processing. sg: " + sg);
				if (this.type == Predicate.RELATIONSHIP) {
					if (!sg.intents) {
						Debug.debug(this, "evaluate(): intent predicate evaluation: the social game context has no intent");
					}else{
						for each(rule in sg.intents) {
							for each(pred in rule.predicates) {
								if (pred.relationship == this.relationship &&
									pred.primary == this.primary &&
									pred.secondary == this.secondary &&
									pred.negated == this.negated) {
									
									return true;
								}
							}
						}
					}
				}
				//is it a network
				else if (this.type == Predicate.NETWORK) {
					if (!sg.intents) {
						Debug.debug(this, "evaluate(): intent predicate evaluation: the social game context has no intent");
					}else{
						for each(rule in sg.intents) {
							for each(pred in rule.predicates) {
								if (pred.networkType == this.networkType &&
									pred.comparator == this.comparator &&
									pred.primary == this.primary &&
									pred.secondary == this.secondary &&
									pred.negated == this.negated) {
									
									return true;
								}
									
							}
						}
					}
				}
				//is it a sfdbLabel
				else if (this.type == Predicate.SFDBLABEL)
				{
					if (!sg.intents) {
						Debug.debug(this, "evaluate(): intent predicate evaluation: the social game context has no intent");
					}else{
						for each(rule in sg.intents) {
							for each(pred in rule.predicates) {
								if (pred.sfdbLabel == this.sfdbLabel &&
									pred.primary == this.primary &&
									pred.secondary == this.secondary &&
									pred.negated == this.negated) {
									
									return true;
								}
							}
						}
					}
				}
				/* We either have no predicate match to the sg's intent rules 
				 * or we are not a predicate type that can encompass intent. In
				 * either case, return false.
				 */
				return false;
			}
			 
			
			if (numTimesUniquelyTrueFlag) 
			{
				//Debug.debug(this, this.toString());
				var numTimesResult:Boolean = evalForNumberUniquelyTrue(first, second, third, sg);
				return (this.negated)? !numTimesResult : numTimesResult;
			}
	
			
			
			switch (this.type) 
			{
				case TRAIT:
					return this.negated ? !evalTrait(first) : evalTrait(first);
				case NETWORK:
					//trace("Going in here: "+this.toString() + " first: " + first.characterName + " second: " + second.characterName);
					//var isNetworkEvalTrue:Boolean = this.negated ? !evalNetwork(first, second) : evalNetwork(first, second);
					//Debug.debug(this, "evaluate() ^ returned " + isNetworkEvalTrue);
					return evalNetwork(first, second);
				case STATUS:
					//if (first == null) Debug.debug(this, "found it: "+this.toString());
					return this.negated ? !evalStatus(first, second) : evalStatus(first, second);
				case CKBENTRY:
					return evalCKBEntry(first, second);
				case SFDBLABEL:
					return evalSFDBLABEL(first, second, third);
				case RELATIONSHIP:
					//Debug.debug(this, "Going in here: "+this.toString() + " first: " + first.characterName);
					//Debug.debug(this, "Going in here: "+this.toString() + " second: " + second.characterName);
					return this.negated ? !evalRelationship(first, second) : evalRelationship(first, second);
				case CURRENTSOCIALGAME:
					if (!sg) return false;
					if (this.negated) {
						return this.currentGameName.toLowerCase() != sg.name.toLowerCase();
					}else {
						return this.currentGameName.toLowerCase() == sg.name.toLowerCase();
					}
				default:
					//trace(  "Predicate: evaluating a predicate without a recoginzed type.");
					Debug.debug(this, "evaluating a predicate without a recoginzed type of: " + this.type);
			}
			return false;
		}
		
		
		public function requiresThirdCharacter():Boolean
		{
			
			var thirdNeeded:Boolean = false;
			if (this.numTimesUniquelyTrueFlag) {
				switch(this.numTimesRoleSlot.toLowerCase()) {
					case "first":
						//if the first role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
						if (this.primary.toLowerCase() == "other") {
							return true;
						}
						break;
					case "second":
						//if the second role is an 'other', then return true.  Otherwise, we can move on to the next predicate.
						if (this.secondary.toLowerCase() == "other") {
							return true;
						}
						break;
					case "both":
						//if either the first or second role is an 'other', then return true.  Otherwise we move on to next predicate.
						if (this.primary.toLowerCase() == "other" || this.secondary.toLowerCase() == "other") {
							return true;
						}
						break;
				}
			}
			
			switch(this.getPrimaryValue()) {
				case "other":
				case "z":
					thirdNeeded = true;
				default:
			}
			switch(this.getSecondaryValue()) {
				case "other":
				case "z":
					thirdNeeded = true;
				default:
			}
			
			switch(this.getTertiaryValue()) {
				case "other":
				case "z":
					thirdNeeded = true;
				default:
			}
			
			if (thirdNeeded) {
				//Debug.debug(this, "requiresThirdCharacter() is true in predicate: " + this.toString() );
				//Debug.debug(this, "requiresThirdCharacter() " + this.getPrimaryValue() + " " + this.getSecondaryValue() + " " + this.getTertiaryValue() + " ");
				return true;
			}
			
			return false;
		}
		
		
		public function evaluatePredicateForInitiatorAndCast(initiator:Character, charsToUse:Vector.<Character> = null):Boolean
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
		 * Looks through the SFDB 
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 * @param	third Character variable of the third predicate parameter.
		 * @return True of the predicate evaluates to true. False if it does not.
		 */
		public function evalIsSFDB(x:Character, y:Character = null, z:Character = null, sg:SocialGame = null):Boolean {
			return CiFSingleton.getInstance().sfdb.isPredicateInHistory(this, x, y, z);
	
		}
		
		
		
		
		
		
		
		
		
		/**
		 * Evaluates the predicate for truth given the characters involved
		 * bound to the parameters and determines how many times the predicate is
		 * uniquely true. The process of evaluating truth depends
		 * on the type of the specific instance of the predicate and the number of times
		 * the predicate is uniquely true.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 * @param	third Character variable of the third predicate parameter.
		 * @return True of the predicate evaluates to true. False if it does not.
		 */
		public function evalForNumberUniquelyTrue(x:Character, y:Character = null, z:Character = null, sg:SocialGame = null):Boolean {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			var numTimesTrue:int = 0;
			
			var predTrue:Boolean = false;
			var primaryCharacterOfConsideration:Character;
			var secondaryCharacterOfConsideration:Character;
			
			if (!numTimesRoleSlot)
			{
				numTimesRoleSlot = "first";
				//TODO: Fix where the numTimesRoleSlot is unspecified. Author/Tool problem
			}
			
			switch(numTimesRoleSlot)
			{
				
				case "first":
					primaryCharacterOfConsideration = x;
					break;
				case "second":
					primaryCharacterOfConsideration = y;
					break;
				case "third":
					primaryCharacterOfConsideration = z;
					break;
				case "both":
					primaryCharacterOfConsideration = x;
					secondaryCharacterOfConsideration = y;
					break;
				default:
					//TODO: Address this hack fro where author or the tool didn't properly give the role
					primaryCharacterOfConsideration = x;
					numTimesRoleSlot = "first";
					Debug.debug(this, "evalForNumberUniquelyTrue() role slot not recognized: "+ numTimesRoleSlot);
			}
			
			if (numTimesRoleSlot == "both")
			{
				switch (this.type) 
				{
					case CKBENTRY:
						numTimesTrue = evalCKBEntryForObjects(primaryCharacterOfConsideration, secondaryCharacterOfConsideration).length;
						break;
					case SFDBLABEL:
						numTimesTrue = cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, secondaryCharacterOfConsideration, z, this.window,this).length;
						//Debug.debug(this, "numTimes(): primary ("+primaryCharacterOfConsideration.characterName + ") did a "+SocialFactsDB.getLabelByNumber(this.sfdbLabel)+" thing to secondary ("+ secondaryCharacterOfConsideration.characterName+") "+numTimesTrue+" times.");
						break;
					default:
						Debug.debug(this, "evalForNumberUniquelyTrue() Doesn't make sense consider 'both' role type for pred types not CKB or SFDB " + this.type);
				}
			}
			else
			{
				for each (var char:Character in cif.cast.characters)
				{
					
					//Debug.debug(this,"evalForNumberUniquelyTrue() "+this.toString());
					predTrue = false;
					//if (!primaryCharacterOfConsideration) return false;
					
					if (char.characterName != primaryCharacterOfConsideration.characterName)
					{
						switch (this.type) 
						{
							case TRAIT:
								predTrue = evalTrait(primaryCharacterOfConsideration);
								break;
							case NETWORK:
								if ("second" == numTimesRoleSlot)
								{
									predTrue = evalNetwork(char, primaryCharacterOfConsideration);	
								}
								else
								{								
									predTrue = evalNetwork(primaryCharacterOfConsideration, char);
									//Debug.debug(this, "evaluate() ^ returned " + isNetworkEvalTrue);
								}
								break;
							case STATUS:
								if ("second" == numTimesRoleSlot)
								{
									predTrue = evalStatus(char, primaryCharacterOfConsideration);
								}
								else
								{
									predTrue = evalStatus(primaryCharacterOfConsideration, char);
								}
								break;
							case CKBENTRY:
								predTrue = evalCKBEntry(primaryCharacterOfConsideration, char);
								break;
							case SFDBLABEL:
								if ("second" == numTimesRoleSlot)
								{
									//predTrue = evalSFDBLABEL(char, primaryCharacterOfConsideration, z);
									numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, char, primaryCharacterOfConsideration, null, this.window, this).length;
								}
								else
								{
									//predTrue = evalSFDBLABEL(primaryCharacterOfConsideration, char, z);
									numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, char, null, this.window, this).length;
								}
								break;
							case RELATIONSHIP:
								predTrue = evalRelationship(primaryCharacterOfConsideration, char);
								break;
							case CURRENTSOCIALGAME:
								//Debug.debug(this, "evalForNumberUniquelyTrue() Trying to print out the number of times a name of a social game is true doesn't make sense")
								predTrue = this.currentGameName.toLowerCase() == sg.name;
								break;
							default:
								//trace(  "Predicate: evaluating a predicate without a recoginzed type.");
								Debug.debug(this, "evaluating a predicate without a recoginzed type of: " + this.type);
						}
						if (predTrue) numTimesTrue++;
					}
				}
			}
			
			// This is a special case for where we want to count numTimesTrue for contexts labels that don't have the nonPrimary roile specified 
			if (this.type == Predicate.SFDBLABEL && this.numTimesUniquelyTrueFlag)
			{
				//commented out this because because it handles a case that doesn't make sense: i.e. sfdblabel having no from and only a to.
				//if ("second" == numTimesRoleSlot)
				//{
					//numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, null, primaryCharacterOfConsideration, null, this.window, this).length;
				//}
				//else 
				if ("first" == numTimesRoleSlot)
				{
					numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, null, null, this.window, this).length;
				}
			}
			
			if (numTimesTrue >= this.numTimesUniquelyTrue)
			{
				return true;
			}
			return false;
		}
		
		
		 /**
		 * Evaluates the predicate for truth given the characters involved
		 * bound to the parameters and determines how many times the predicate is
		 * uniquely true. The process of evaluating truth depends
		 * on the type of the specific instance of the predicate and the number of times
		 * the predicate is uniquely true. BUT here we keep track of who the characters are
		 * and store the resulting truth values in a dictionary, to reason over later.
		 * 
		 * @param	first Character variable of the first predicate parameter.
		 * @param	second Character variable of the second predicate parameter.
		 * @param	third Character variable of the third predicate parameter.
		 * @return True of the predicate evaluates to true. False if it does not.
		 */
		public function evalForNumberUniquelyTrueKeepChars(x:Character, y:Character = null, z:Character = null, sg:SocialGame = null):Dictionary {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var charDictionary:Dictionary = new Dictionary(); // will store the names of people who satisfy the requirements.
			var numTimesTrue:int = 0;
			
			var predTrue:Boolean = false;
			var primaryCharacterOfConsideration:Character;
			var secondaryCharacterOfConsideration:Character;
			
			if (!numTimesRoleSlot)
			{
				numTimesRoleSlot = "first";
				//TODO: Fix where the numTimesRoleSlot is unspecified. Author/Tool problem
			}
			
			switch(numTimesRoleSlot)
			{
				
				case "first":
					primaryCharacterOfConsideration = x;
					break;
				case "second":
					primaryCharacterOfConsideration = y;
					break;
				case "third":
					primaryCharacterOfConsideration = z;
					break;
				case "both":
					primaryCharacterOfConsideration = x;
					secondaryCharacterOfConsideration = y;
					break;
				default:
					//TODO: Address this hack fro where author or the tool didn't properly give the role
					primaryCharacterOfConsideration = x;
					numTimesRoleSlot = "first";
					Debug.debug(this, "evalForNumberUniquelyTrue() role slot not recognized: "+ numTimesRoleSlot);
			}
			
			if (numTimesRoleSlot == "both")
			{
				switch (this.type) 
				{
					case CKBENTRY:
						numTimesTrue = evalCKBEntryForObjects(primaryCharacterOfConsideration, secondaryCharacterOfConsideration).length;
						break;
					case SFDBLABEL:
						numTimesTrue = cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, secondaryCharacterOfConsideration, z, this.window,this).length;
						//Debug.debug(this, "numTimes(): primary ("+primaryCharacterOfConsideration.characterName + ") did a "+SocialFactsDB.getLabelByNumber(this.sfdbLabel)+" thing to secondary ("+ secondaryCharacterOfConsideration.characterName+") "+numTimesTrue+" times.");
						break;
					default:
						Debug.debug(this, "evalForNumberUniquelyTrue() Doesn't make sense consider 'both' role type for pred types not CKB or SFDB " + this.type);
				}
			}
			else
			{
				for each (var char:Character in cif.cast.characters)
				{
					
					//Debug.debug(this,"evalForNumberUniquelyTrue() "+this.toString());
					predTrue = false;
					//if (!primaryCharacterOfConsideration) return false;
					
					if (char.characterName != primaryCharacterOfConsideration.characterName)
					{
						switch (this.type) 
						{
							case TRAIT:
								predTrue = evalTrait(primaryCharacterOfConsideration);
								break;
							case NETWORK:
								if ("second" == numTimesRoleSlot)
								{
									predTrue = evalNetwork(char, primaryCharacterOfConsideration);	
								}
								else
								{								
									predTrue = evalNetwork(primaryCharacterOfConsideration, char);
									//Debug.debug(this, "evaluate() ^ returned " + isNetworkEvalTrue);
								}
								break;
							case STATUS:
								if ("second" == numTimesRoleSlot)
								{
									predTrue = evalStatus(char, primaryCharacterOfConsideration);
								}
								else
								{
									predTrue = evalStatus(primaryCharacterOfConsideration, char);
								}
								break;
							case CKBENTRY:
								predTrue = evalCKBEntry(primaryCharacterOfConsideration, char);
								break;
							case SFDBLABEL:
								if ("second" == numTimesRoleSlot)
								{
									//predTrue = evalSFDBLABEL(char, primaryCharacterOfConsideration, z);
									numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, char, primaryCharacterOfConsideration, null, this.window, this).length;
								}
								else
								{
									//predTrue = evalSFDBLABEL(primaryCharacterOfConsideration, char, z);
									numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, char, null, this.window, this).length;
								}
								break;
							case RELATIONSHIP:
								predTrue = evalRelationship(primaryCharacterOfConsideration, char);
								break;
							case CURRENTSOCIALGAME:
								//Debug.debug(this, "evalForNumberUniquelyTrue() Trying to print out the number of times a name of a social game is true doesn't make sense")
								predTrue = this.currentGameName.toLowerCase() == sg.name;
								break;
							default:
								//trace(  "Predicate: evaluating a predicate without a recoginzed type.");
								Debug.debug(this, "evaluating a predicate without a recoginzed type of: " + this.type);
						}
						if (predTrue) {
							numTimesTrue++; 
							charDictionary[char.characterName.toLowerCase()] = "true";
						}
						else { 
							charDictionary[char.characterName.toLowerCase()] = "false";
						}
						
					}
				}
			}
			
			// This is a special case for where we want to count numTimesTrue for contexts labels that don't have the nonPrimary roile specified 
			if (this.type == Predicate.SFDBLABEL && this.numTimesUniquelyTrueFlag)
			{
				//commented out this because because it handles a case that doesn't make sense: i.e. sfdblabel having no from and only a to.
				//if ("second" == numTimesRoleSlot)
				//{
					//numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, null, primaryCharacterOfConsideration, null, this.window, this).length;
				//}
				//else 
				if ("first" == numTimesRoleSlot)
				{
					numTimesTrue += cif.sfdb.findLabelFromValues(this.sfdbLabel, primaryCharacterOfConsideration, null, null, this.window, this).length;
				}
			}
			
			charDictionary["numTimesTrue"] = numTimesTrue; // a special index that stores this number.
			return charDictionary;
			
			if (numTimesTrue >= this.numTimesUniquelyTrue)
			{
				//return true;
				return null;
			}
			//return false;
			return null;
		}
		
		/**
		 * Returns true if the character in the first parameter has the trait
		 * noted in the trait field of this class.
		 * 
		 * @param first The character for which the existence of the trait is ascertained.
		 * @return True if the character has the trait. False if the trait is not present.
		 */
		private function evalTrait(first:CiF.Character):Boolean {
			if (first.hasTrait(this.trait))
				return true;
			return false;
		}

		
		/**
		 * This function is used to see if a predicate is used just to establish a character role in a rule or not.
		 * @return
		 */
		public function isCharNameTrait():Boolean
		{
			if (this.type == Predicate.TRAIT)
			{
				if (this.trait >= Trait.FIRST_NAME_NUMBER && this.trait <= Trait.LAST_NAME_NUMBER)
				{
					return true;
				}
			}
			return false;
		}
		
		
		 /** Returns true if the character in the first parameter has the relationship
		 * noted in the trait field of this class.
		 * 
		 * @param first The character for which the existence of the trait is ascertained.
		 * @return True if the character has the trait. False if the trait is not present.
		 */
		private function evalRelationship(first:Character, second:Character):Boolean {
			var sn:RelationshipNetwork = RelationshipNetwork.getInstance();
			//Debug.debug(this, "evalRelationship: " + first.characterName + " " + second.characterName + " " + this.toString());
			if (sn.getRelationship(this.relationship, first, second))
				return true;
			return false;
		}
		
		/** Returns true if the character in the first parameter has the relationship
		 * noted in the trait field of this class.
		 * 
		 * @param first The character for which the existence of the status is ascertained.
		 * @return True if the character has the status. False if the status is not present.
		 */
		private function evalStatus(first:Character, second:Character):Boolean {
			//Debug.debug(this, "evalStatus() 1=" + first.characterName + " 2=" + second.characterName + " " + this.toString());
			return first.hasStatus(this.status, second);
		}
		
		/**
		 * 
		 * @param	first
		 * @param	second
		 * @return
		 */
		private function evalNetwork(first:Character, second:Character):Boolean {
			
			var net:SocialNetwork;
			var firstID:int = first.networkID;
			var secondID:int;

			if (second) 
				secondID = second.networkID;
			
			
				
			//get the proper singleton based on desired network type. 	
			if (this.networkType == SocialNetwork.BUDDY) 
				net = BuddyNetwork.getInstance();
			if (this.networkType == SocialNetwork.ROMANCE) 
				net = RomanceNetwork.getInstance();
			if(this.networkType == SocialNetwork.COOL)
				net = CoolNetwork.getInstance();
			
			//Debug.debug(this, "evalNetwork(" + first.characterName + ", " + second.characterName + ") this: " + this + " netvalue: " + net.getWeight(firstID, secondID) );
				
			if (getNumberFromComparator(this.comparator) == LESSTHAN) {
				//need social network as class
				if (net.getWeight(firstID, secondID) < this.networkValue)
					return Util.xor(this.negated, true);
			}else if (getNumberFromComparator(this.comparator)== GREATERTHAN) {
				//need social network as class
				if (net.getWeight(firstID, secondID) > this.networkValue)
					return Util.xor(this.negated, true);
			}else if (getNumberFromComparator(this.comparator) == AVERAGEOPINION) {
				if (net.getAverageOpinion(firstID) > this.networkValue) {
					return Util.xor(this.negated, true);
				}
			}else if (getNumberFromComparator(this.comparator) == FRIENDSOPINION ||
						getNumberFromComparator(this.comparator) == DATINGOPINION ||
						getNumberFromComparator(this.comparator) == ENEMIESOPINION ) {
				//get the Cast singleton
				
				//know the person who is the obj of opinion
				//know the person's friends
				//get the id's of A's friends
				var cast:Cast = Cast.getInstance();
				var rel:RelationshipNetwork = RelationshipNetwork.getInstance();
				var sum:Number = 0.0;
				var relationshipCount:Number = 0.0;
				var i:int = 0;
				
				for each(var char:Character in cast.characters) {
					//first's friends opinion about second
					
					//are they first's friend? test example:
					//first is robert
					//second is karen
					if (char.characterName != first.characterName && char.characterName != second.characterName) {
						if(getNumberFromComparator(this.comparator) == FRIENDSOPINION) {
							if (rel.getRelationship(RelationshipNetwork.FRIENDS, char, first)) {
								//Debug.debug(this, char.characterName + "'s opinion used: " + net.getWeight(char.networkID, second.networkID), 5);
								sum += net.getWeight(char.networkID, second.networkID);
								relationshipCount++;
							}
						}else if(getNumberFromComparator(this.comparator) == DATINGOPINION) {
							if (rel.getRelationship(RelationshipNetwork.DATING, char, first)) {
								//Debug.debug(this, char.characterName + "'s opinion used: " + net.getWeight(char.networkID, second.networkID), 5);
								sum += net.getWeight(char.networkID, second.networkID);
								relationshipCount++;
							}
						}else if(getNumberFromComparator(this.comparator) == ENEMIESOPINION) {
							if (rel.getRelationship(RelationshipNetwork.ENEMIES, char, first)) {
								//Debug.debug(this, char.characterName + "'s opinion used: " + net.getWeight(char.networkID, second.networkID), 5);
								sum += net.getWeight(char.networkID, second.networkID);
								relationshipCount++;
							}
						}
						//if A's friend is the target, they don't count
					}
				}
				
				if (relationshipCount < 1) {
					return false;
				}
				
				//Debug.debug(this, "FriendsOpinion " + sum + " " + friendCount, 5);
				if(relationshipCount > 0.0) {
					if ( (sum / relationshipCount) < this.networkValue) {
						return Util.xor(this.negated, true);
					}
				}
			}
			//default return
			return Util.xor(this.negated, false);
		}
		
		
		private function evalCKBEntry(first:CiF.Character, second:CiF.Character):Boolean {
			//get instance of CKB
			var ckb:CulturalKB = CulturalKB.getInstance();
			var firstResults:Vector.<String>;
			var secondResults:Vector.<String>;
			var i:Number = 0;
			var j:Number = 0;
			
			if(!second) {			
			//determine if the single character constraints results in a match
				firstResults = ckb.findItem(first.characterName, this.firstSubjectiveLink, this.truthLabel);
				//Debug.debug(this, first.characterName + " " + this.firstSubjectiveLink + " " + this.truthLabel );
				return firstResults.length > 0;
			} else {			
				//Might want to push this functionality into the CKB
				//determine if the two character constraints result in a match
				//1. find first matches
				firstResults = ckb.findItem(first.characterName, this.firstSubjectiveLink, this.truthLabel);
				//2. find second matches
				secondResults = ckb.findItem(second.characterName, this.secondSubjectiveLink, this.truthLabel);
				//3. see if any of first's matches intersect second's matches.
				for (i = 0; i < firstResults.length ; ++i) {
					for (j = 0; j < secondResults.length; ++j) { 
						//Debug.debug(this, firstResults[i] + " and " + secondResults[j]);
						if (firstResults[i] == secondResults[j]) {
							//Debug.debug(this, "evalCKBEntry() "+this.toString());
							//Debug.debug(this, "evalCKBEntry() first: "+firstResults[i]+" second: "+secondResults[j]);
							return true;
						}
					}
				}
				return false;
			}
			return false;
		}
		
		
		/*
		public function justBecameTrue(initiator:Character=null,responder:Character=null,other:Character=null):Boolean
		{
			var cif:CiFSingleton = CiFSingleton.getInstance();
			if (cif.time == 1) return false;
			
			var isTrueNow:Boolean = this.evaluate(initiator,responder,other);
			if (!isTrueNow) return false;
			
			var lastTurnPred:Predicate = clone();// this.getOppositeOfPredicate();
			lastTurnPred.isSFDB = true;
			lastTurnPred.window = 1;
			if ((!lastTurnPred.evaluate(initiator, responder, other)) && !inStartState)
			{
				return true;
			}

			return false;
		}
		
		public function justBecameFalse(initiator:Character=null,responder:Character=null,other:Character=null):Boolean
		{
			if (CiFSingleton.getInstance().time == 1) return false;
			
			var isTrueNow:Boolean = this.evaluate(initiator,responder,other);
			if (isTrueNow) return false;
			
			var lastTurnPred:Predicate = clone();//this.getOppositeOfPredicate();
			lastTurnPred.isSFDB = true;
			lastTurnPred.window = 1;
			if (lastTurnPred.evaluate(initiator, responder, other))
			{
				return true;
			}
			return false;
		}		
		
		
		public function getOppositeOfPredicate():Predicate
		{
			var oppositePred:Predicate = this.clone();
			
			if (this.type == Predicate.RELATIONSHIP || this.type == Predicate.STATUS)
			{
				oppositePred.negated = !this.negated;
			}
			else if (this.type == Predicate.NETWORK)
			{
				if (this.operator == "lessthan")
				{
					oppositePred.operator = "greaterthan"
				}
				else if (this.operator == "greaterthan")
				{
					oppositePred.operator = "lessthan"
				}
			}
			else
			{
				Debug.debug(this,"getOppositeOfPredicate() Tried to get the opposite of a predicate that that isn't easy to do that for. Returned a clone instead of the opposite.");
			}
			
			return oppositePred;
		}
		*/
		
		/**
		 * This is similar to evalCKBEntry.  However, unlike evalCKBEntry, which
		 * only returns a boolean value if an object that fits the criteria exists
		 * or not, here we actually produce a list of all objects that DO fulfill
		 * the requirements, and then returns that list of objects as a vector.
		 * 
		 * @see evalCKBEntry
		 * 
		 * @param	first The First Character who holds an opinion on this ckb object
		 * @param	second The Second Character who holds an opinion on this ckb object
		 * @return
		 */
		public function evalCKBEntryForObjects(first:CiF.Character, second:CiF.Character):Vector.<String> {
			//get instance of CKB
			var ckb:CulturalKB = CulturalKB.getInstance();
			var firstResults:Vector.<String>;
			var secondResults:Vector.<String>;
			var intersectedResults:Vector.<String> = new Vector.<String>();
			var i:Number = 0;
			var j:Number = 0;
			
			if (!second) 
			{			
			//determine if the single character constraints results in a match
				firstResults = ckb.findItem(first.characterName, this.firstSubjectiveLink, this.truthLabel);
				//Debug.debug(this, "evalCKBEntryForObjects() " + first.characterName + " " + this.firstSubjectiveLink + " " + this.truthLabel );
				return firstResults;
			} 
			else 
			{			
				
				
				//Might want to push this functionality into the CKB
				//determine if the two character constraints result in a match
				//1. find first matches
				firstResults = ckb.findItem(first.characterName, this.firstSubjectiveLink, this.truthLabel);
				//Debug.debug(this,"evalCKBEntryForObjects() "+this.toString());
				
				
				if (secondSubjectiveLink == "")
				{
					return firstResults;
				}
				
				//Debug.debug(this, "OK, we just filled up first results: " + firstResults.toString());
				//2. find second matches
				secondResults = ckb.findItem(second.characterName, this.secondSubjectiveLink, this.truthLabel);
				//3. see if any of first's matches intersect second's matches.
				for (i = 0; i < firstResults.length ; ++i) 
				{					
					//Debug.debug(this, "Going through all of the first results... " + firstResults[i]);
					for (j = 0; j < secondResults.length; ++j) { 
						//Debug.debug(this, firstResults[i] + " and " + secondResults[j]);
						//Debug.debug(this, first.characterName+": "+ firstResults.length + " and " + second.characterName+": " +secondResults.length);
						if (firstResults[i] == secondResults[j]) 
						{
							intersectedResults.push(firstResults[i]);
							//Debug.debug(this, "evalCKBEntryForObjects() we found a mutual object that fits all requirements! " + firstResults[i]);
						}
					}
				}
				return intersectedResults;
			}
			return "WHAAA HOW DID WE GET HERE?!?!";
		}
		
		/**
		 * Evaluates the truth of the SFDBLabel type Predicate given a set of characters. This
		 * evaluation is different from most other predicates in that it is always based in 
		 * history. Every SFDBLabel type predicate looks back in the social facts database to
		 * see if the label of the predicate was true for the characters in the past. If there
		 * is a match in history, it is evaluated true.
		 * 
		 * Note: we currently do not allow for a third character to be used.
		 * 
		 * @param	first
		 * @param	second
		 * @param	third
		 * @return
		 */
		public function evalSFDBLABEL(first:Character, second:Character, third:Character):Boolean {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			//Debug.debug(this, "evalSFDBLABEL() result: " + cif.sfdb.findLabelFromValues(this.sfdbLabel, first, second, third, this.window).length + " toString: "+this.toString());
			
			//if it is a category of label
			if (this.sfdbLabel <= SocialFactsDB.LAST_CATEGORY_COUNT && this.sfdbLabel >= 0)
			{
				for each (var fromCategoryLabel:Number in CiF.SocialFactsDB.CATEGORIES[this.sfdbLabel])
				{
					if (cif.sfdb.findLabelFromValues(fromCategoryLabel, first, second, null, this.window,this).length > 0)
						return (this.negated)?false:true;					
				}
			}
			else
			{
				//normal look up
				if (cif.sfdb.findLabelFromValues(this.sfdbLabel, first, second, null, this.window, this).length > 0)
				{
					
					return (this.negated)?false:true;
				}
			}
			return (this.negated)?true:false;
		}

		/**
		 * Determines the character name bound to the first (primary) character variable role in this predicate given
		 * a context of characters in roles.
		 * @param	initiator
		 * @param	responder
		 * @param	other
		 * @return The name of the primary character associated with the predicate character variable and role context.
		 */
		public function primaryCharacterNameFromVariables(initiator:Character, responder:Character, other:Character):String {
			switch(this.getPrimaryValue()) {
				case "initiator":
					return initiator.characterName;
				case "responder":
					return responder.characterName;
				case "other":
					return other.characterName;
				case "":
					return "";
			}
			return this.primary;
		}

		/**
		 * Determines the character name bound to the second (secondary) character variable role in this predicate given
		 * a context of characters in roles.
		 * @param	initiator
		 * @param	responder
		 * @param	other
		 * @return The name of the secondary character associated with the predicate character variable and role context.
		 */
		public function secondaryCharacterNameFromVariables(initiator:Character, responder:Character, other:Character):String {
			switch(this.getSecondaryValue()) {
				case "initiator":
					return initiator.characterName;
				case "responder":
					return responder.characterName;
				case "other":
					return other.characterName;
				case "":
					return "";
			}
			return this.secondary;
		}
		
		/**
		 * Determines the character name bound to the third (tertiary) character variable role in this predicate given
		 * a context of characters in roles.
		 * @param	initiator
		 * @param	responder
		 * @param	other
		 * @return The name of the tertiary character associated with the predicate character variable and role context.
		 */
		public function tertiaryCharacterNameFromVariables(initiator:Character, responder:Character, other:Character):String {
			switch(this.getTertiaryValue()) {
				case "initiator":
					return initiator.characterName;
				case "responder":
					return responder.characterName;
				case "other":
					return other.characterName;
				case "":
					return "";
			}
			return this.tertiary;
		}
		
		/**********************************************************************
		 * Utility functions.
		 *********************************************************************/
		public function toString(): String{
			var returnstr:String = new String();
			var switchType:Number = this.type;
			
			switch(switchType) {
				case Predicate.TRAIT: 
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					returnstr += "trait(" + this.primary + ", " + Trait.getNameByNumber(this.trait) + ")";
					break;
				case Predicate.NETWORK:
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					returnstr += SocialNetwork.getNameFromType(this.networkType) + "Network(" + this.primary + ", " + this.secondary + ") " + this.comparator + " " + this.networkValue;
					break;
				case Predicate.STATUS:
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					var secondValue:String = "";
					if (this.status >= Status.FIRST_DIRECTED_STATUS) secondValue = this.secondary;
					returnstr += "status(" + this.primary + ", " + secondValue + ", " + Status.getStatusNameByNumber(this.status) + ")";
					break;
				case Predicate.CKBENTRY:
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					returnstr += "ckb(" + this.primary + ", " + this.firstSubjectiveLink + ", " + this.secondary + ", " + this.secondSubjectiveLink + ", " + this.truthLabel + ")";
					break;
					//sfdb not complete
				case Predicate.SFDBLABEL:
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					returnstr += "SFDBLabel(" + SocialFactsDB.getLabelByNumber(this.sfdbLabel) + "," + this.primary + "," + this.secondary;
					returnstr += "," + this.sfdbOrder + ")";
					break;
				case Predicate.RELATIONSHIP:
					returnstr = new String();
					if (this.negated) {
						returnstr += "~";
					}
					returnstr += "relationship(" + this.primary + ", " + this.secondary + ", " + RelationshipNetwork.getRelationshipNameByNumber(this.relationship) + ")";
					break;
				default:
					Debug.debug(this, "tried to make a predicate of unknown type a String.");
					return "";
			}
			if (isSFDB) returnstr = "[" + returnstr + " window(" + this.window +")]";
			if (intent) return "{" + returnstr + "}";
			return returnstr;

		}
		
		public function toXMLString(): String {
			var returnstr:String = new String();
			var common:String = "intent=\"" + this.intent + "\" isSFDB=\"" + this.isSFDB + "\" window=\"" + this.window +  "\"" + "numTimesUniquelyTrueFlag=\"" + this.numTimesUniquelyTrueFlag + "\"" + "numTimesUniquelyTrue=\"" + this.numTimesUniquelyTrue +  "\"" + "numTimesRoleSlot=\"" + this.numTimesRoleSlot +  "\" ";
			
			if (this.sfdbOrder > 0)
				common += "sfdbOrder=\"" + this.sfdbOrder + "\" ";

			if (this.description != "")
				common += "description=\"" + this.description + "\" ";
				
			switch(this.type) {
				case Predicate.TRAIT:
					returnstr = new String();
					returnstr += "<Predicate type=\"";
					returnstr += "trait\" trait=\"" + Trait.getNameByNumber(this.trait) + "\" first=\"" + this.first + "\" negated=\""  + this.negated + "\" " + common +"/>";
					break;
				case Predicate.NETWORK:
					returnstr = new String();
					returnstr += "<Predicate type=\"";
					returnstr += "network\" networkType=\"" + SocialNetwork.getNameFromType(this.networkType) + "\" first=\"" + this.first + "\" second=\"" + this.second + "\" comparator=\"" + this.comparator + "\" value=\"" + this.networkValue + "\" negated=\""  + this.negated + "\" " + common +"/>";
					break;
				case Predicate.STATUS:
					returnstr = new String();
					var secondValue:String = "";
					if (this.status >= Status.FIRST_DIRECTED_STATUS) secondValue = this.second;
					returnstr += "<Predicate type=\"";
					returnstr += "status\" status=\"" + Status.getStatusNameByNumber(this.status) + "\" first=\"" + this.first + "\" second=\"" + secondValue + "\" negated=\""  + this.negated + "\" " + common +"/>";
					break;
				case Predicate.CKBENTRY:
					returnstr = new String();
					returnstr += "<Predicate type=\"";
					returnstr += "CKBEntry\" first=\"" + this.first + "\" second=\"" + this.second + "\" firstSubjective=\"" + this.firstSubjectiveLink + "\" secondSubjective=\"" + this.secondSubjectiveLink + "\" label=\"" + this.truthLabel + "\" negated=\""  + this.negated + "\" " + common +"/>";
					break;
					//sfdb not complete
				case Predicate.SFDBLABEL:
					returnstr = new String();
					returnstr += "<Predicate type=\"";
					returnstr += "SFDB label\" first=\"" + this.first + "\" second=\"" + this.second + "\" label=\"" +SocialFactsDB.getLabelByNumber(this.sfdbLabel) + "\" negated=\""  + this.negated + "\"" + common + "/>";
					break;
				case Predicate.RELATIONSHIP:
					returnstr = new String();
					returnstr += "<Predicate type=\"";
					returnstr += "relationship\" first=\"" + this.first + "\" second=\"" + this.second + "\" relationship=\"" + RelationshipNetwork.getRelationshipNameByNumber(this.relationship) + "\" negated=\""  + this.negated + "\" " + common +"/>";
					break;
				default:
					Debug.debug(this, "toXMLString(): type not found: " + this.toString());
					return "";
			}
			return returnstr;
		}
		
		public function clone(): Predicate {
			var p:Predicate = new Predicate();
			p.type = this.type;
			p.trait = this.trait;
			p.description = this.description;
			p.primary = this.primary;
			p.secondary = this.secondary;
			p.tertiary = this.tertiary;
			p.networkValue = this.networkValue;
			p.comparator = this.comparator;
			p.operator = this.operator;
			p.relationship = this.relationship;
			p.status = this.status;
			p.networkType = this.networkType;
			p.firstSubjectiveLink = this.firstSubjectiveLink;
			p.secondSubjectiveLink = this.secondSubjectiveLink;
			p.truthLabel = this.truthLabel;
			p.negated = this.negated;
			p.window = this.window;
			p.isSFDB = this.isSFDB;
			p.sfdbLabel = this.sfdbLabel;
			p.intent = this.intent;
			p.numTimesUniquelyTrueFlag = this.numTimesUniquelyTrueFlag;
			p.numTimesUniquelyTrue = this.numTimesUniquelyTrue;
			p.numTimesRoleSlot = this.numTimesRoleSlot;
			p.sfdbOrder = this.sfdbOrder;
			return p;
		}
		/**
		 * This is a semantic equality function where select properties are
		 * tested for equality such that the two predicates have the same
		 * meaning.
		 * @param	x	First predicate to test for equality.
		 * @param	y	Second predicate to test for equality.
		 * @return 	True if the predicates have the same meaning or false if
		 * they do not.
		 */
		public static function equals(x:Predicate, y:Predicate):Boolean {
			if (x.type != y.type) return false;
			if (x.intent != y.intent) return false;
			if (x.description != y.description) return false;
			if (x.negated != y.negated) return false;
			if (x.isSFDB != y.isSFDB) return false;
			if (x.numTimesUniquelyTrueFlag != y.numTimesUniquelyTrueFlag) return false;
			if (x.numTimesUniquelyTrue != y.numTimesUniquelyTrue) return false;
			if (x.numTimesUniquelyTrueFlag)
			{
				// only check this if we have are a numTimesUniquelyTrue type predicate.
				// This helps get around a problem where a lot of the roles are set wrong.
				if (x.numTimesRoleSlot != y.numTimesRoleSlot) return false;
			}
			
			switch(x.type) {
				case Predicate.TRAIT:
					if (x.trait != y.trait) return false;
					if (x.primary != y.primary) return false;
					break;
				case Predicate.STATUS:
					if (x.status != y.status) return false;
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					break;
				case Predicate.RELATIONSHIP:
					if (x.relationship != y.relationship) return false;
					if (!((x.primary == y.primary) || (x.primary == y.secondary))) return false;
					if (!((x.secondary == y.primary) || (x.secondary == y.secondary))) return false;
					break;
				case Predicate.NETWORK:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.networkType != y.networkType) return false;
					if (x.networkValue != y.networkValue) return false;
					if (x.comparator!= y.comparator) return false;
					if (x.operator != y.operator) return false;
					break;
				case Predicate.CKBENTRY:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.firstSubjectiveLink!= y.firstSubjectiveLink) return false;
					if (x.secondSubjectiveLink!= y.secondSubjectiveLink) return false;
					if (x.truthLabel != y.truthLabel) return false;
					break;
				case Predicate.SFDBLABEL:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.sfdbLabel != y.sfdbLabel) return false;
					if (x.negated != y.negated) return false;
					if (x.sfdbOrder!= y.sfdbOrder) return false;
					break;
				default:
					Debug.debug(x, "equals(): unknown Predicate type checked for equality: " + x.type);
					return false;
			}
			return true;
		}
		
		/**
		 * Determines if the structures of two Predicates are equal where
		 * structure is every Predicate parameter other than the character 
		 * variables (primary, secondary, and tertiary) and isSFDB.
		 * 
		 * @param	x
		 * @param	y
		 * @return	True if the structures of the Predicate match or false if they do not.
		 */
		public static function equalsEvaluationStructure(x:Predicate, y:Predicate):Boolean {
			if (x.type != y.type) return false;
			if (x.intent != y.intent) return false;
			if (x.negated != y.negated) return false;
			//if (x.isSFDB != y.isSFDB) return false;
			if (x.numTimesUniquelyTrueFlag != y.numTimesUniquelyTrueFlag) return false;
			if (x.numTimesUniquelyTrue != y.numTimesUniquelyTrue) return false;
			if (x.numTimesRoleSlot != y.numTimesRoleSlot) return false;
			
			switch(x.type) {
				case Predicate.TRAIT:
					if (x.trait != y.trait) return false;
					break;
				case Predicate.STATUS:
					if (x.status != y.status) return false;
					break;
				case Predicate.RELATIONSHIP:
					if (x.relationship != y.relationship) return false;
					break;
				case Predicate.NETWORK:
					if (x.networkType != y.networkType) return false;
					if (x.networkValue != y.networkValue) return false;
					if (x.comparator!= y.comparator) return false;
					if (x.operator != y.operator) return false;
					break;
				case Predicate.CKBENTRY:
					if (x.firstSubjectiveLink!= y.firstSubjectiveLink) return false;
					if (x.secondSubjectiveLink!= y.secondSubjectiveLink) return false;
					if (x.truthLabel != y.truthLabel) return false;
					break;
				case Predicate.SFDBLABEL:
					if (x.sfdbLabel != y.sfdbLabel) return false;
					if (x.negated != y.negated) return false;
					break;
				default:
					Debug.debug(x, "structureEquals(): unknown Predicate type checked for equality: " + x.type);
					return false;
			}
			return true;
			
		}
		
		
		/**
		 * Determines if the structures of two Predicates are equal where
		 * structure is every Predicate parameter other than the character 
		 * variables (primary, secondary, and tertiary) and isSFDB.
		 * 
		 * This function is for comparing ordered rules (which represent change) 
		 * with effect change rules in SGs played in the past.
		 * 
		 * @param	x
		 * @param	y
		 * @return	True if the structures of the Predicate match or false if they do not.
		 */ 
		public static function equalsValuationStructure(x:Predicate, y:Predicate):Boolean {
			if (x.type != y.type) return false;
			if (x.intent != y.intent) return false;
			if (x.negated != y.negated) return false;
			//if (x.isSFDB != y.isSFDB) return false;
			if (x.numTimesUniquelyTrueFlag != y.numTimesUniquelyTrueFlag) return false;
			if (x.numTimesUniquelyTrue != y.numTimesUniquelyTrue) return false;
			if (x.numTimesRoleSlot != y.numTimesRoleSlot) return false;
			
			switch(x.type) {
				case Predicate.TRAIT:
					if (x.trait != y.trait) return false;
					break;
				case Predicate.STATUS:
					if (x.status != y.status) return false;
					break;
				case Predicate.RELATIONSHIP:
					if (x.relationship != y.relationship) return false;
					break;
				case Predicate.NETWORK:
					if (x.networkType != y.networkType) return false;
					//Ignore network value -- the type of change is enough.
					//if (x.networkValue != y.networkValue) return false;
					if (x.operator != y.operator) return false;
					break;
				case Predicate.CKBENTRY:
					if (x.firstSubjectiveLink!= y.firstSubjectiveLink) return false;
					if (x.secondSubjectiveLink!= y.secondSubjectiveLink) return false;
					if (x.truthLabel != y.truthLabel) return false;
					break;
				case Predicate.SFDBLABEL:
					if (x.sfdbLabel != y.sfdbLabel) return false;
					if (x.negated != y.negated) return false;
					break;
				default:
					Debug.debug(x, "structureEquals(): unknown Predicate type checked for equality: " + x.type);
					return false;
			}
			return true;
			
		}
		
		
		public static function deepEquals(x:Predicate, y:Predicate): Boolean {
			if (x.type != y.type) return false;
			if (x.trait != y.trait) return false;
			if (x.intent != y.intent) return false;
			if (x.description != y.description) return false;
			if (x.primary != y.primary) return false;
			if (x.secondary != y.secondary) return false;
			if (x.tertiary != y.tertiary) return false;
			if (x.networkValue != y.networkValue) return false;
			if (x.comparator != y.comparator) return false;
			if (x.operator != y.operator) return false;
			if (x.relationship != y.relationship) return false;
			if (x.status != y.status) return false;
			if (x.networkType != y.networkType) return false;
			if (x.firstSubjectiveLink != y.firstSubjectiveLink) return false;
			if (x.secondSubjectiveLink != y.secondSubjectiveLink) return false;
			if (x.truthLabel != y.truthLabel) return false;
			if (x.negated != y.negated) return false;
			if (x.window != y.window) return false;
			if (x.isSFDB != y.isSFDB) return false;
			if (x.sfdbLabel != y.sfdbLabel) return false;
			if (x.numTimesUniquelyTrueFlag != y.numTimesUniquelyTrueFlag) return false;
			if (x.numTimesUniquelyTrue != y.numTimesUniquelyTrue) return false;
			if (x.numTimesRoleSlot != y.numTimesRoleSlot) return false;
			if (x.sfdbOrder!= y.sfdbOrder) return false;
			return true;
		}
		
		public static function equalsForMicrotheoryDefinitionAndSocialGameIntent(x:Predicate, y:Predicate):Boolean {
			if (x.type != y.type) return false;
			//if (x.intent != y.intent) return false;
			if (x.negated != y.negated) return false;
			if (x.isSFDB != y.isSFDB) return false;
						
			if (x.numTimesUniquelyTrueFlag != y.numTimesUniquelyTrueFlag) return false;
			if (x.numTimesUniquelyTrue != y.numTimesUniquelyTrue) return false;
			if (x.numTimesRoleSlot != y.numTimesRoleSlot) return false;
			if (x.sfdbOrder!= y.sfdbOrder) return false;
			
			switch(x.type) {
				case Predicate.TRAIT:
					if (x.trait != y.trait) return false;
					if (x.primary != y.primary) return false;
					break;
				case Predicate.STATUS:
					if (x.status != y.status) return false;
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					break;
				case Predicate.RELATIONSHIP:
					if (x.relationship != y.relationship) return false;
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					break;
				case Predicate.NETWORK:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.networkType != y.networkType) return false;
					if (x.networkValue != y.networkValue) return false;
					if (x.comparator!= y.comparator) return false;
					if (x.operator != y.operator) return false;
					break;
				case Predicate.CKBENTRY:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.firstSubjectiveLink!= y.firstSubjectiveLink) return false;
					if (x.secondSubjectiveLink!= y.secondSubjectiveLink) return false;
					if (x.truthLabel != y.truthLabel) return false;
					break;
				case Predicate.SFDBLABEL:
					if (x.primary != y.primary) return false;
					if (x.secondary != y.secondary) return false;
					if (x.sfdbLabel != y.sfdbLabel) return false;
					if (x.negated != y.negated) return false;
					break;
				default:
					Debug.debug(x, "equals(): unknown Predicate type checked for equality: " + x.type);
					return false;
			}
			return true;
		}
		
		/**
		 * This function returns a natural language name of the given predicate.
		 * So, for example, instead of some weird scary code-looking implementation
		 * such as wants_to_pick_on(i->r), it would return something alone the lines of
		 * "Karen wants to pick on Robert"  I think, at least for this first pass, that
		 * we are not going to care about pronoun replacement, or anything along
		 * those lines!
		 * 
		 * @param	primary The actual name of the initiator (eg "Karen")
		 * @param	secondary The actual name of the responder (eg "Robert")
		 * @param	tertiary The actual name of the other (eg "Edward")
		 */
		public function toNaturalLanguageString(primary:String = "", secondary:String = "", tertiary:String = ""):String {
			var predicateName:String = getNameByType(this.type); // "network", "relationship", etc.
			var naturalLanguageName:String = "";
			//primary = makeFirstLetterUpperCase(primary);
			//secondary = makeFirstLetterUpperCase(secondary);
			//if (tertiary != null) tertiary = makeFirstLetterUpperCase(tertiary);
			//trace("predicate name = " + predicateName);
			if(!this.numTimesUniquelyTrueFlag){ // what follows is the 'normal' stuff -- we need to do something special if it is a num times uniquely true predicate.
				switch (predicateName){
					case "network":
						naturalLanguageName = networkToNaturalLanguage(primary, secondary , tertiary);
						break;
					case "relationship":
						naturalLanguageName = relationshipPredicateToNaturalLanguage(primary, secondary, tertiary);
						break;
					case "trait":
						naturalLanguageName = traitPredicateToNaturalLanguage(primary, secondary, tertiary);
						break;
					case "status":
						naturalLanguageName = statusPredicateToNaturalLanguage(primary, secondary, tertiary);
						break;
					case "CKB":
						naturalLanguageName = ckbPredicateToNaturalLanguage(primary, secondary, tertiary);
						break;
					case "SFDBLabel":
						naturalLanguageName = sfdbPredicateToNaturalLanguage(primary, secondary, tertiary);
						break;
					default:
						trace ("Unrecognized predicate type");
				}
			}
			else {
				if (predicateName == "CKB") naturalLanguageName = ckbPredicateToNaturalLanguage(primary, secondary, tertiary); // I handled this case originally!
				else naturalLanguageName = numTimesUniquelyTruePredicateToNaturalLanguage(primary, secondary, tertiary);
			}
			
			//Append SFDB Window information to the natural language predicate.
			var timeElapsed:String = "";
			if(this.isSFDB){
				if (this.window < 0) { // THIS IS BACKSTORY
					timeElapsed = " way back when";
				}
				else if (this.window == 0) { //It means it just has to have been true at some point.
					timeElapsed = "";
					if (secondary == "")
					{
						//timeElapsed = " new" + timeElapsed;
						timeElapsed = " " + timeElapsed;
					}
				}
				else if (this.window > 0 && this.window <= 5) {
					timeElapsed = " recently";
				}
				else if (this.window > 5 && this.window <= 10) {
					timeElapsed = " a little while ago";
				}
				else if (this.window > 10) {
					timeElapsed = " some time ago";
				}
			}
			naturalLanguageName += timeElapsed;
			
			//If we are dealing with something with an SFDB 'order' 
			//we just kind of append that to the end.
			if (this.sfdbOrder > 0) {
				naturalLanguageName += " "
				naturalLanguageName += sfdbOrderToNaturalLanguage();
			}
			
			naturalLanguageName += ".";
			return LineOfDialogue.preprocessLine(naturalLanguageName);
		}
		
		// Network line values (1-100)
		public function meansHigh(num:int):Boolean {
			if (num >= 60) {
				return true;
			}
			return false;
		}
		public function meansMedium(num:int):Boolean {
			if (num < 60 && num > 40) {
				return true;
			}
			return false;
		}
		public function meansLow(num:int):Boolean {
			if (num <= 40) {
				return true;
			}
			return false;
		}
		// Network change deltas (5-30 or so)
		public function changeIsSmall(num:int):Boolean {
			if (num <= 10) {
				return true;
			}
			return false;
		}
		public function changeIsMedium(num:int):Boolean {
			if (num > 10 && num < 25) {
				return true;
			}
			return false;
		}
		public function changeIsLarge(num:int):Boolean {
			if (num >= 25) {
				return true;
			}
			return false;
		}
		public function showDegreeAdj(num:int):String {
			if (changeIsSmall(num)) return "slightly ";
			else if (changeIsLarge(num)) return "much ";
			else return "";
		}
		
		/**
		 * Specifically handles the converting of a network into a natural language name
		 * (e.g. "BudNetHigh(i->r) is converted to "Karen feels strong feelings of buddy towards Responder"
		 * 
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the network
		 */
		public function networkToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String="Robert"):String {
			var naturalLanguageName:String = "";
			var otherPeoplesOpinion:String = "";
			
			//First, discover if the predicate is going to be low, medium, or high.
			const highThreshold:int = 66;
			const medThreshold:int = 50;
			const lowThreshold:int = 33;
			var isHigh:Boolean = false;
			var isLow:Boolean = false;
			var isNotHigh:Boolean = false;
			var isNotLow:Boolean = false;
			var isAggregateComparator:Boolean = false;
			
			var changeIsSmall:Boolean = false;
			var changeIsMedium:Boolean = false;
			var changeIsLarge:Boolean = false;
			
			/* COMPARATORS:
			//
			//greaterthan
			//lessthan
			//AverageOpinion
			//FriendsOpinion
			//DatingOpinion
			//EnemiesOpinion
			//+
			//-
			//DO WE USE THESE BOTTOM ONES EVER?
			//*
			//=
			//EveryoneUp
			//AllFriendsUp
			//AllDatingUp
			//AllEnemiesUp
			*/
			
			if (this.comparator == "DatingOpinion" || this.comparator == "FriendsOpinion" || this.comparator == "EnemiesOpinion" || this.comparator == "EnemyOpinion" || this.comparator == "AverageOpinion" || this.comparator == "EveryoneUp") isAggregateComparator = true;
			
			//Since the design tool does not restrict numeric values, we need to estimate whether the condition being asked for is based on values being high, medium, or low (which we approximate with the functions above. Then, we can determine whether something is restricted to being high or low, or being "not high" or "not low" (as in, if we want a value greater than low or the midpoint, all we know is we want something that isn't low.)
			if (meansHigh(this.networkValue) && this.comparator=="greaterthan") isHigh = true;
			else if (meansLow(this.networkValue) && this.comparator == "lessthan") isLow = true;
			else if (meansLow(this.networkValue) && this.comparator == "greaterthan") isNotLow = true;
			else if (meansMedium(this.networkValue) && this.comparator == "greaterthan") isNotLow = true;
			else if (meansHigh(this.networkValue) && this.comparator == "lessthan") isNotHigh = true;			
			else if (meansMedium(this.networkValue) && this.comparator == "lessthan") isNotHigh = true;
			else if (isAggregateComparator)
			{
				// These all assume you mean 'greater than'
				if (meansHigh(this.networkValue)) isHigh = true;
				else isNotLow = true;
			}
			else if (this.comparator == "+") { // this is a network change thing!
			
				switch(SocialNetwork.getNameFromType(this.networkType)) {
					case "buddy":
						naturalLanguageName = primary + " thinks " + secondary + " is a " + showDegreeAdj(this.networkValue) + "better buddy"; break;
					case "romance":
						naturalLanguageName = primary + " is " + showDegreeAdj(this.networkValue) + "more attracted to " + secondary; break;
					case "cool":
						naturalLanguageName = primary + " thinks " + secondary + " is " + showDegreeAdj(this.networkValue) + "cooler"; break;
				}
				return naturalLanguageName;
			}
			else if (this.comparator == "-") { // this is a network change thing!
				switch(SocialNetwork.getNameFromType(this.networkType)) {
					case "buddy":
						naturalLanguageName = primary + " thinks " + secondary + " is a " + showDegreeAdj(this.networkValue) + "worse buddy"; break;
					case "romance":
						naturalLanguageName = primary + " is " + showDegreeAdj(this.networkValue) + "less attracted to " + secondary; break;
					case "cool":
						naturalLanguageName = primary + " thinks " + secondary + " is " + showDegreeAdj(this.networkValue) + "less cool"; break;
				}
				return naturalLanguageName;
			}
			
			if (this.comparator == "DatingOpinion") otherPeoplesOpinion = " is dating someone who";
			else if (this.comparator == "FriendsOpinion") otherPeoplesOpinion = "'s friends";
			else if (this.comparator == "EnemiesOpinion") otherPeoplesOpinion = "'s enemies";
			else otherPeoplesOpinion = " knows people who";
			
			//Awesome, now I know if it is low, medium, or high.  Now I need to find out which network we are dealing with.
			switch(SocialNetwork.getNameFromType(this.networkType)) {
				case "buddy":
					if (isHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who likes " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " like " + secondary;
						else
							naturalLanguageName = primary + " likes " + secondary;
					}
					else if (isNotHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who doesn't especially like " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " don't especially like " + secondary;
						else
							naturalLanguageName = primary + " doesn't especially like " + secondary;
					}
					else if (isLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who dislikes " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " don't like " + secondary;
						else
							naturalLanguageName = primary + " dislikes " + secondary;
					}
					else if (isNotLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who's not on bad terms with " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " are not on bad terms with " + secondary;
						else
							naturalLanguageName = primary + " is not on bad terms with " + secondary;
					}
					// We don't guarantee this per se, but the code above should always set one of the four variables to true, so the below should hopefully never be run.
					else naturalLanguageName = "Unrecognized Buddy Value! Value is: " + this.networkValue + " comparator is: " + comparator;
					break;
				case "romance":
					if (isHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who's attracted to " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " are generally attracted to " + secondary;
						else
							naturalLanguageName = primary + " is attracted to " + secondary;
					}
					else if (isNotHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who's not attracted to " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " are generally not attracted to " + secondary;
						else
							naturalLanguageName = primary + " is not attracted to " + secondary;
					}
					else if (isLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who's not at all into " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " are generally not at all into " + secondary;
						else
							naturalLanguageName = primary + " is not at all into " + secondary;
					}
					else if (isNotLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who's not grossed out by " + secondary;
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " are generally not grossed out by " + secondary;
						else
							naturalLanguageName = primary + " is not grossed out by " + secondary;
					}
					else naturalLanguageName = "Unrecognized Romance Value! Value: " + this.networkValue + " comparator: " + comparator;
					break;
				case "cool":
					if (isHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who thinks " + secondary + " is totally cool";
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " think " + secondary + " is totally cool";
						else
							naturalLanguageName = primary + " thinks " + secondary + " is totally cool";
					}
					else if (isNotHigh) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who doesn't think " + secondary + " is that cool";
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " don't think " + secondary + " is that cool";
						else
							naturalLanguageName = primary + " doesn't think " + secondary + " is that cool";
					}
					else if (isLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who thinks " + secondary + " is seriously uncool";
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " think " + secondary + " is seriously uncool";
						else
							naturalLanguageName = primary + " thinks " + secondary + " is seriously uncool";
					}
					else if (isNotLow) {
						if (this.comparator == "DatingOpinion")
							naturalLanguageName = primary + " is dating someone who doesn't think " + secondary + " is uncool";
						else if (isAggregateComparator)
							naturalLanguageName = primary + "" + otherPeoplesOpinion + " don't generally think " + secondary + " is uncool";
						else
							naturalLanguageName = primary + " doesn't think " + secondary + " is uncool";
					}
					else naturalLanguageName = "Unrecognized Cool Value! Value is: " + this.networkValue + " comparator is: " + comparator;
					break;
				default:
					trace ("unrecognized network type (not buddy, not cool, not romance)");
				}	
			return naturalLanguageName;
		}
			
		/**
		 * Here is the function that creates the natural language
		 * version of a relationship.  As in "Karen and Edward are Dating"
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the relationship
		 */
		public function relationshipPredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			//We care about what type of network we are dealing with.
			var naturalLanguageName:String;
			var notString:String = "";
			var isString:String = "";
			var newString:String = "";
			
			if (this.negated == true) {
				notString = " not";
			}
			if (this.isSFDB) {
				isString = " was";
				newString = " new";
			}
			else {
				isString = " is";
			}
			
			switch(RelationshipNetwork.getRelationshipNameByNumber(this.relationship)) {
				case 'friends':
					if (this.isSFDB) {
						if (this.negated) {
							naturalLanguageName = primary + " doesn't make friends with " + secondary;
						} else {
							naturalLanguageName = primary + " makes a new friend";
							if (secondary != " someone") {
								naturalLanguageName = naturalLanguageName + " in " + secondary;
							}
						}
					} else {
						naturalLanguageName = primary + isString + notString + " friends with " + secondary;
					}
					break;
				case 'dating':
					if (this.isSFDB) {
						naturalLanguageName = primary + isString + notString + " in a new relationship with " + secondary;
					} else {
						naturalLanguageName = primary + isString + notString + " dating " + secondary;
					}
					break;
				case 'enemies':
					naturalLanguageName = primary + " and " + secondary + " are" + notString + newString + " enemies";
					break;
				default:
					naturalLanguageName = "unrecognized relationship (not friends, dating, or enemies)";
			}
			return naturalLanguageName;
		}
		
		/**
		 * @return If it is an intent, returns the intent ID, as defined as consts above. Other wise it returns -1
		 */
		public function getIntentType():int
		{
			if (!this.intent) return -1;
			
			if (this.type == Predicate.NETWORK)
			{
				if (this.networkType == SocialNetwork.BUDDY)
				{
					if (this.comparator == "+")
					{
						return Predicate.INTENT_BUDDY_UP;
					}
					else
					{
						return Predicate.INTENT_BUDDY_DOWN;
					}
				}
				else if (this.networkType == SocialNetwork.ROMANCE)
				{
					if (this.comparator == "+")
					{
						return Predicate.INTENT_ROMANCE_UP;
					}
					else
					{
						return Predicate.INTENT_ROMANCE_DOWN;
					}
				}
				else if (this.networkType == SocialNetwork.COOL)
				{
					if (this.comparator == "+")
					{
						return Predicate.INTENT_COOL_UP;
					}
					else
					{
						return Predicate.INTENT_COOL_DOWN;
					}
				}
			}
			else if (this.type == Predicate.RELATIONSHIP)
			{
				if (this.relationship == RelationshipNetwork.FRIENDS)
				{
					if (this.negated)
					{
						return Predicate.INTENT_END_FRIENDS;
					}
					else
					{
						return Predicate.INTENT_FRIENDS;
					}
				}
				else if (this.relationship == RelationshipNetwork.DATING)
				{
					if (this.negated)
					{
						return Predicate.INTENT_END_DATING;
					}
					else
					{
						return Predicate.INTENT_DATING;
					}	
				}
				else if (this.relationship == RelationshipNetwork.ENEMIES)
				{
					if (this.negated)
					{
						return Predicate.INTENT_END_ENEMIES;
					}
					else
					{
						return Predicate.INTENT_ENEMIES;
					}
				}
			}
			// if we get here, we weren't one of the accepted intents
			return -1;
		}
		
		public static function getIntentNameByNumber(intentID:int):String
		{
			switch(intentID)
			{
				case Predicate.INTENT_FRIENDS:
					return "intent(friends)";
				case Predicate.INTENT_END_FRIENDS:
					return "intent(end_friends)";
				case Predicate.INTENT_DATING:
					return "intent(dating)";
				case Predicate.INTENT_END_DATING:
					return "intent(end_dating)";
				case Predicate.INTENT_ENEMIES:
					return "intent(enemies)";
				case Predicate.INTENT_END_ENEMIES:
					return "intent(end_enemies)";
					
				case Predicate.INTENT_BUDDY_UP:
					return "intent(buddy_up)";
				case Predicate.INTENT_BUDDY_DOWN:
					return "intent(buddy_down)";
				case Predicate.INTENT_ROMANCE_UP:
					return "intent(romance_up)";
				case Predicate.INTENT_ROMANCE_DOWN:
					return "intent(romance_down)";
				case Predicate.INTENT_COOL_UP:
					return "intent(cool_up)";
				case Predicate.INTENT_COOL_DOWN:
					return "intent(cool_down)";
					
				default:
					return "";
			}
		}
		
		
		/**
		 * Here is the function that creates the natural language
		 * version of a trait.  As in "Karen is Shy"
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the relationship
		 */
		public function traitPredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			//We care about what type of trait we are dealing with.
			var naturalLanguageName:String;
			naturalLanguageName = primary;
			var notString:String = " ";
			if (this.negated) {
				notString = " not ";
			}
			
			var theTrait:int = this.trait;
			
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			if (theTrait <= Trait.LAST_CATEGORY_COUNT)
			{
				
				switch(theTrait) {
					case Trait.CAT_CHARACTER_FLAW:
						if(this.negated){
							naturalLanguageName += " does not have a character flaw";
						}
						else {
							naturalLanguageName += " has a character flaw";
						}
						break;
					case Trait.CAT_CHARACTER_VIRTUE:
						if(this.negated){
							naturalLanguageName += " does not have a character virtue";
						}
						else {
							naturalLanguageName += " has a character virtue";
						}
					break;
					case Trait.CAT_EXTROVERTED:
						if(this.negated){
							naturalLanguageName += " isn't extroverted";
						}
						else {
							naturalLanguageName += " is extroverted";
						}
					break;
					case Trait.CAT_INTROVERTED:
						if(this.negated){
							naturalLanguageName += " isn't introverted";
						}
						else {
							naturalLanguageName += " is introverted";
						}
					break;
					case Trait.CAT_JERK:
						if(this.negated){
							naturalLanguageName += " isn't a jerk";
						}
						else {
							naturalLanguageName += " is a jerk";
						}
					break;
					case Trait.CAT_NICE:
						if(this.negated){
							naturalLanguageName += " isn't nice";
						}
						else {
							naturalLanguageName += " is nice";
						}
					break;
					case Trait.CAT_SEXY:
						if(this.negated){
							naturalLanguageName += " isn't sexy";
						}
						else {
							naturalLanguageName += " is sexy";
						}
					break;
					case Trait.CAT_SHARP:
						if(this.negated){
							naturalLanguageName += " isn't sharp";
						}
						else {
							naturalLanguageName += " is sharp";
						}
					break;
					case Trait.CAT_SLOW:
						if(this.negated){
							naturalLanguageName += " isn't slow";
						}
						else {
							naturalLanguageName += " is slow";
						}
					break;
					default:
						Debug.debug(this, "not a category");
						break;
				}
				return naturalLanguageName;
				
				/*
				 * This is good, but it makes traits show up twice (e.g. Zack is arrogant (because he is arrogant) and Zack is arrogant (actually because
				 * he is a 'jerk', but it got flagged BECAUSE he was arrogant.  
				 * For now, lets say specific things for each category.
				//resolve which trait they actually have
				for each (var t:int in Trait.CATEGORIES[this.trait])
				{
					if (cif.cast.getCharByName(primary.toLowerCase()).hasTrait(t))
					{
						theTrait = t;
					}
				}*/
				
			}
			
			switch(theTrait) {
				case Trait.OUTGOING:
					naturalLanguageName += " is" + notString + "outgoing"; break;
				case Trait.SHY:
					naturalLanguageName += " is" + notString + "shy"; break;
				case Trait.ATTENTION_HOG:
					naturalLanguageName += " is" + notString + "an attention hog"; break;
				case Trait.IMPULSIVE:
					naturalLanguageName += " is" + notString + "impulsive"; break;
				case Trait.COLD:
					naturalLanguageName += " is" + notString + "cold";   break;
				case Trait.KIND:
					naturalLanguageName += " is" + notString + "kind"; break;
				case Trait.IRRITABLE:
					naturalLanguageName += " is" + notString + "irritable"; break;
				case Trait.LOYAL:
					naturalLanguageName += " is" + notString + "loyal"; break;
				case Trait.LOVING:
					naturalLanguageName += " is" + notString + "loving"; break;
				case Trait.SYMPATHETIC:
					naturalLanguageName += " is" + notString + "sympathetic"; break;
				case Trait.MEAN:
					naturalLanguageName += " is" + notString + "mean"; break;
				case Trait.CLUMSY:
					naturalLanguageName += " is" + notString + "clumsy"; break;
				case Trait.CONFIDENT:
					naturalLanguageName += " is" + notString + "confident"; break;
				case Trait.INSECURE:
					naturalLanguageName += " is" + notString + "insecure"; break;
				case Trait.MOPEY:
					naturalLanguageName += " is" + notString + "mopey"; break;
				case Trait.BRAINY:
					naturalLanguageName += " is" + notString + "brainy"; break;
				case Trait.DUMB:
					naturalLanguageName += " is" + notString + "dumb"; break;
				case Trait.DEEP:
					naturalLanguageName += " is" + notString + "deep"; break;
				case Trait.SHALLOW:
					naturalLanguageName += " is" + notString + "shallow"; break;
				case Trait.SMOOTH_TALKER:
					naturalLanguageName += " is" + notString + "a smooth talker"; break;
				case Trait.INARTICULATE:
					naturalLanguageName += " is" + notString + "inarticulate"; break;
				case Trait.SEX_MAGNET:
					naturalLanguageName += " is" + notString + "a sex magnet"; break;
				case Trait.AFRAID_OF_COMMITMENT:
					naturalLanguageName += " is" + notString + "afraid of commitment"; break;
				case Trait.DOMINEERING:
					naturalLanguageName += " is" + notString + "domineering"; break;
				case Trait.HUMBLE:
					naturalLanguageName += " is" + notString + "humble"; break;
				case Trait.TAKES_THINGS_SLOWLY:
					naturalLanguageName += (this.negated ? " does not take things slowly" : " takes things slowly"); break;
				case Trait.ARROGANT:
					naturalLanguageName += " is" + notString + "arrogant"; break;
				case Trait.DEFENSIVE:
					naturalLanguageName += " is" + notString + "defensive"; break;
				case Trait.HOTHEAD:
					naturalLanguageName += " is" + notString + "a hothead"; break;
				case Trait.PACIFIST:
					naturalLanguageName += " is" + notString + "a pacifist"; break;
				case Trait.RIPPED:
					naturalLanguageName += " is" + notString + "ripped"; break;
				case Trait.WEAKLING:
					naturalLanguageName += " is" + notString + "a weakling"; break;
				case Trait.FORGIVING:
					naturalLanguageName += " is" + notString + "forgiving"; break;
				case Trait.EMOTIONAL:
					naturalLanguageName += " is" + notString + "emotional"; break;
				case Trait.SWINGER:
					naturalLanguageName += " is" + notString + "a swinger"; break;
				case Trait.JEALOUS:
					naturalLanguageName += " is" + notString + "jealous"; break;
				case Trait.WITTY:
					naturalLanguageName += " is" + notString + "witty"; break;
				case Trait.SELF_DESTRUCTIVE:
					naturalLanguageName += " is" + notString + "self-destructive"; break;
				case Trait.OBLIVIOUS:
					naturalLanguageName += " is" + notString + "oblivious"; break;
				case Trait.VENGEFUL:
					naturalLanguageName += " is" + notString + "vengeful"; break;
				case Trait.COMPETITIVE:
					naturalLanguageName += " is" + notString + "competitive"; break;
				case Trait.STUBBORN:
					naturalLanguageName += " is" + notString + "stubborn"; break;
				case Trait.DISHONEST:
					naturalLanguageName += " is" + notString + "dishonest"; break;
				case Trait.HONEST:
					naturalLanguageName += " is" + notString + "honest"; break;
				case Trait.MALE:
					naturalLanguageName += " is" + notString + "male"; break;
				case Trait.FEMALE:
					naturalLanguageName += " is" + notString + "female"; break;
				case Trait.WEARS_A_HAT:
					naturalLanguageName += (this.negated ? "does not wear" : "wears") + " a hat"; break;
				case Trait.CARES_ABOUT_FASHION:
					naturalLanguageName += (this.negated ? "does not care" : "cares") + " about fashion"; break;
				case Trait.MUSCULAR:
					naturalLanguageName += " is" + notString + "muscular"; break;
				default:
					if (theTrait >= Trait.FIRST_NAME_NUMBER && theTrait <= Trait.LAST_NAME_NUMBER)
					{
						naturalLanguageName += " is" + notString + Trait.getNameByNumber(theTrait); break;
					}
					else
					{
						naturalLanguageName = "unrecognized trait";
						Debug.debug(this, "unrecognized eh: " + theTrait);
					}
			}
			return naturalLanguageName;
		}
		
		/**
		 * Turns a status predicate into a natural language
		 * sounding version (Karen is feeling Anxious)
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the relationship
		 */
		public function statusPredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			//We care about what type of trait we are dealing with.
			var naturalLanguageName:String;
			naturalLanguageName = primary;
			var notString:String = " ";
			var isString:String = " ";
			if (this.negated) {
				notString = " not ";
			}
			if (this.isSFDB) 
				isString = " was";
			else
				isString = " is";
			
			var theStatus:int = this.status;
			
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			if (theStatus <= Status.LAST_CATEGORY_COUNT)// && !(theStatus >= Status.FIRST_TO_IGNORE_NON_DIRECTED && theStatus < Status.FIRST_DIRECTED_STATUS))
			{
				//resolve which trait they actually have
				for each (var s:int in Status.CATEGORIES[this.status])
				{
					if (cif.cast.getCharByName(primary.toLowerCase()).getStatus(s))
					{
						theStatus = s;
					}
				}
			}
			
			
			switch(theStatus) {
				case Status.EMBARRASSED:
					naturalLanguageName += isString + notString + "feeling embarrassed"; break;
				case Status.CHEATER:
					naturalLanguageName += isString + notString + "a cheater"; break;
				case Status.SHAKEN:
					naturalLanguageName += isString + notString + "all shook up"; break;
				case Status.DESPERATE:
					naturalLanguageName += isString + notString + "desperate"; break;
				case Status.CLASS_CLOWN:
					naturalLanguageName += isString + notString + "the class clown"; break;
				case Status.BULLY:
					naturalLanguageName += isString + notString + "a bully"; break;
				case Status.LOVE_STRUCK:
					naturalLanguageName += isString + notString + "love-struck"; break;
				case Status.GROSSED_OUT:
					naturalLanguageName += isString + notString + "grossed out"; break;
				case Status.EXCITED:
					naturalLanguageName += isString + notString + "excited"; break;
				case Status.POPULAR:
					naturalLanguageName += isString + notString + "popular"; break;
				case Status.SAD:
					naturalLanguageName += isString + notString + "feeling sad"; break;
				case Status.ANXIOUS:
					naturalLanguageName += isString + notString + "feeling anxious"; break;
				case Status.HONOR_ROLL:
					naturalLanguageName += isString + notString + "on the honor roll"; break;
				case Status.LOOKING_FOR_TROUBLE:
					naturalLanguageName += isString + notString + "looking for trouble"; break;
				case Status.GUILTY:
					naturalLanguageName += isString + notString + "feeling guilty"; break;
				case Status.FEELS_OUT_OF_PLACE:
					if (this.negated) { 
						if (this.isSFDB){
							naturalLanguageName += "did not feel out of place";
						}
						else {
							naturalLanguageName += "does not feel out of place";
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += notString + " felt out of place"; 
						}
						else {
							naturalLanguageName += notString + " feels out of place"; 
						}
					}
					break;						
				case Status.CAT_FEELING_BAD:
					naturalLanguageName += isString + notString + "feeling bad"; break;
				case Status.CAT_FEELING_GOOD:
					naturalLanguageName += isString + notString + "feeling good"; break;
				case Status.CAT_FEELING_BAD_ABOUT_SOMEONE:
					naturalLanguageName += isString + notString + "feeling bad about someone"; break;
				case Status.CAT_FEELING_GOOD_ABOUT_SOMEONE:
					naturalLanguageName += isString + notString + "feeling good about someone"; break;
				case Status.CAT_REPUTATION_BAD:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not have a bad reputation";
						}
						else {
							naturalLanguageName += " does not have a bad reputation";
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " had a bad reputation"; 
						}
						else {
							naturalLanguageName += " has a bad reputation"; 
						}
					}
					break;
				case Status.CAT_REPUTATION_GOOD:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not have a good reputation";
						}
						else {
							naturalLanguageName += " does not have a good reputation";
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " had a good reputation"; 
						}
						else {
							naturalLanguageName += " has a good reputation"; 
						}
					}
					break;
				case Status.HEARTBROKEN:
					naturalLanguageName += isString + notString + "heartbroken"; break;
				case Status.CHEERFUL:
					naturalLanguageName += isString + notString + "feeling cheerful"; break;
				case Status.CONFUSED:
					naturalLanguageName += isString + notString + "confused"; break;
				case Status.LONELY:
					naturalLanguageName += isString + notString + "feeling lonely"; break;
				case Status.HOMEWRECKER:
					naturalLanguageName += isString + notString + "a homewrecker"; break;
				case Status.HAS_A_CRUSH_ON:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not have a crush on " + secondary;
						}
						else {
							naturalLanguageName += " does not have a crush on " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " had a crush on " + secondary; 
						}
						else {
							naturalLanguageName += " has a crush on " + secondary; 
						}
					}
					break;
				case Status.ANGRY_AT:
					naturalLanguageName += isString + notString + "angry at " + secondary; break;
				case Status.WANTS_TO_PICK_ON:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not want to pick on " + secondary;
						}
						else {
							naturalLanguageName += " does not want to pick on " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " wanted to pick on " + secondary; 
						}
						else {
							naturalLanguageName += " wants to pick on " + secondary; 
						}
					}
					break;
				case Status.ANNOYED_WITH:
					naturalLanguageName += isString + notString + "annoyed with " + secondary; break;
				case Status.SCARED_OF:
					naturalLanguageName += isString + notString + "scared of " + secondary; break;
				case Status.PITIES:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not pity " + secondary;
						}
						else {
							naturalLanguageName += " does not pity " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " pitied " + secondary; 
						}
						else {
							naturalLanguageName += " pities " + secondary; 
						}
					}
					break;
				case Status.ENVIES:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not envy " + secondary;
						}
						else {
							naturalLanguageName += " does not envy " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " envied " + secondary; 
						}
						else {
							naturalLanguageName += " envies " + secondary; 
						}
					}
					break;
				case Status.GRATEFUL_TOWARD:
					naturalLanguageName += isString + notString + " grateful toward " + secondary; break;
				case Status.TRUSTS:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not trust " + secondary;
						}
						else {
							naturalLanguageName += " does not trust " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " trusted " + secondary; 
						}
						else {
							naturalLanguageName += " trusts " + secondary; 
						}
					}
					
					break;
				case Status.FEELS_SUPERIOR_TO:
					if (this.negated) {
						if (this.isSFDB) {
							naturalLanguageName += " did not feel superior to " + secondary;
						}
						else {
							naturalLanguageName += " does not feel superior to " + secondary;
						}
					}
					else {
						if (this.isSFDB) {
							naturalLanguageName += " felt superior to " + secondary; 
						}
						else {
							naturalLanguageName += " feels superior to " + secondary; 
						}
					}
					break;
				case Status.CHEATING_ON:
					naturalLanguageName += isString + notString + "cheating on " + secondary; break;
				case Status.CHEATED_ON_BY:
					naturalLanguageName += isString + notString + "cheated on by " + secondary; break;
				case Status.HOMEWRECKED:
					if(this.negated){
						if (this.isSFDB) {
							naturalLanguageName += " did not homewreck " + secondary; break;
						}
						else {
							naturalLanguageName += " is not homewrecking " + secondary; break;
						}
					}
					else{
						if (this.isSFDB) {
							naturalLanguageName += " homewrecked " + secondary; break;
						}
						else {
							naturalLanguageName += " is homewrecking " + secondary; break;
						}
					}
				default:
					naturalLanguageName += " not a known status id = " + theStatus;
			}
			
			naturalLanguageName = naturalLanguageName.split("  ").join(" "); // if there are any double spaces, change it to just a single space.
			return naturalLanguageName;
		}
		
		/**
		 * 
		 * Turns a ckb thing into a natural language thing.
		 * I'm not exactly sure how to do this one, actually.  I think it will be interesting.
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the ckb
		 */
		public function ckbPredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			var naturalLanguageName:String = "";
			var amountOfThings:String = "";
			var gestaltTruth:String = "";
			var negatedString:String = "";
			if (negated) {
				negatedString = "it isn't the case that ";
			}

			//CKB((i,likes),(r,likes),cool) == I and R both like something cool
			//CKB((i,likes),(r,likes),) == I and R both like something
			//CKB((i,likes),(r,),cool) == I likes something cool
			//CKB((i,likes),(,),cool) == I likes something cool
			//CKB((i,likes),(,dislikes),cool) == I likes something cool that SOMEONE dislikes, maybe?
			
			gestaltTruth = this.truthLabel; // cool, lame, romantic, etc.
			if (gestaltTruth != "") gestaltTruth = " " + gestaltTruth;

			if ( this.firstSubjectiveLink != this.secondSubjectiveLink) {
				//PRIMARY AND SECONDARY DISAGREE
				
				//based on the num times uniquely true, it will use a different word to describe it!
				//But where do I handle negation?
				if (this.numTimesUniquelyTrue == 1 || this.numTimesUniquelyTrue == 0 ) amountOfThings = "something" + gestaltTruth;
				if (this.numTimesUniquelyTrue == 2) amountOfThings = "a couple" + gestaltTruth + " things";
				if (this.numTimesUniquelyTrue >= 3) amountOfThings = "a lot of" + gestaltTruth + " things";
				
				naturalLanguageName = negatedString + primary + " " + this.firstSubjectiveLink + " " + amountOfThings;
				if (secondary != "" && this.secondSubjectiveLink != "")
					naturalLanguageName += " that " + secondary + " " + this.secondSubjectiveLink;
			}
			else if (this.firstSubjectiveLink == this.secondSubjectiveLink) {
				//PRIMARY AND SECONDARY AGREE
				var theirFeeling:String;
				
				if (this.firstSubjectiveLink == "likes") theirFeeling = "like";
				else if (this.firstSubjectiveLink == "dislikes") theirFeeling = "dislike";
				else if (this.firstSubjectiveLink == "wants") theirFeeling = "want";
				else if (this.firstSubjectiveLink == "has") theirFeeling = "have";
	
				//based on the num times uniquely true, it will use a different word to describe it!
				if (this.numTimesUniquelyTrue == 1 || this.numTimesUniquelyTrue == 0 ) naturalLanguageName = negatedString + primary + " and " + secondary + " both " + theirFeeling + (gestaltTruth == "" ? " the same thing" : " something" + gestaltTruth);
				if (this.numTimesUniquelyTrue == 2) naturalLanguageName = negatedString + primary + " and " + secondary + " both " + theirFeeling + " a couple" + gestaltTruth + " things";
				if (this.numTimesUniquelyTrue >= 3) naturalLanguageName = negatedString + primary + " and " + secondary + " both " + theirFeeling + " lots of" + gestaltTruth + " things";
			}
			
			naturalLanguageName = naturalLanguageName.split("  ").join(" "); // if there are any double spaces, change it to just a single space.
			return naturalLanguageName;
		}

		
		/**
		 * 
		 * Turns a sfdb thing into a natural language thing.
		 * I'm not exactly sure how to do this one, actually.  I think it will be interesting.
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return The natural language name of the sfdb
		 */
		public function sfdbPredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			var naturalLanguageName:String = "";
			var timeElapsed:String = "";
			var label:int = this.sfdbLabel;
			
			var sfdbLabelType:String = SocialFactsDB.getLabelByNumber(label);
			if (SocialFactsDB.CAT_POSITIVE == label) {
				sfdbLabelType = "generally positive";
			}
			else if (SocialFactsDB.CAT_NEGATIVE == label){
				sfdbLabelType = "generally negative";
			}
			else if (SocialFactsDB.CAT_FLIRT == label){
				sfdbLabelType = "flirty";
			}
			
			//Going to try to move timeElapsed stuff to the outerloop.
			//naturalLanguageName = primary + " did something " + sfdbLabelType + " to " + secondary + " " + timeElapsed;
			if (sfdbLabelType == "misunderstood") {
				naturalLanguageName = primary + " did something that was misunderstood by " + secondary;
			} else if (sfdbLabelType == "failed romance") {
				naturalLanguageName = primary + " did something romantic that was rejected by " + secondary;
			} else if (sfdbLabelType == "lame") {
				naturalLanguageName = primary + " did something lame in front of " + secondary;
			} else if (sfdbLabelType == "embarrassing") {
				naturalLanguageName = primary + " did something embarrassing in front of " + secondary;	
			} else if (sfdbLabelType.search("_ACT") != -1) {
				naturalLanguageName = primary + " played part of a story sequence with " + secondary;
			}
			else {
				naturalLanguageName = primary + " did something " + sfdbLabelType + " to " + secondary;
			}
				
			if (primary == secondary || secondary == "") {
				//This is a case where the SFDB should only care about the primary person.
				//naturalLanguageName = primary + " did something " + sfdbLabelType + " " + timeElapsed;
				naturalLanguageName = primary + " did something " + sfdbLabelType;
				return naturalLanguageName;
			}
			
			naturalLanguageName = naturalLanguageName.split("  ").join(" "); // if there are any double spaces, change it to just a single space.
			naturalLanguageName = naturalLanguageName.replace(" .", "."); // replace an extra space before period with no space.
			
			return naturalLanguageName;
		}
		
		private function directedPluralNegatedFirst(strIfMultiple:String, strIfSingle:String, numTimes:int):String {
			var returnStr:String = " ";
			if (numTimes == 1) {
				returnStr += strIfSingle + " anybody";
			} else {
				returnStr += strIfMultiple + " fewer than " + numTimes + " people";
			}
			return returnStr;
		}
		
		private function directedPluralNegatedSecond(strIfMultiple:String, strIfSingle:String, numTimes:int):String {
			var returnStr:String = " ";
			if (numTimes == 1) {
				returnStr += "Nobody " + strIfSingle + " ";
			} else {
				returnStr += "Fewer than " + numTimes + " people " + strIfMultiple + " ";
			}
			return returnStr;
		}
		
		private function directedPluralNonNegatedSecond(strIfMultiple:String, strIfSingle:String, numTimes:int):String {
			var returnStr:String = " ";
			if (numTimes == 1) {
				returnStr += "Somebody " + strIfSingle + " ";
			} else {
				returnStr += "At least " + numTimes + " people " + strIfMultiple + " ";
			}
			return returnStr;
		}
		
		/**
		 * We need to do some special garbage if we are dealing with num times uniquely true predicates.
		 * Specifically, what we need to do is still go through each kind of predicate (because it is going
		 * to be special for each kind of predicate, relationship, network, etc).  and come up with special
		 * I think it might even be wildly different depending on who the role slot is.  Or, well, maybe
		 * only it is different if it is both.
		 * phrases for each one.
		 * @param	primary The actual name of the primary "Karen"
		 * @param	secondary The actual name of the secondary "Edward"
		 * @param	tertiary The actual name of the tertiary "Robert"
		 * @return  The natural language of the num times uniquely true predicate
		 */
		public function numTimesUniquelyTruePredicateToNaturalLanguage(primary:String = "Karen", secondary:String = "Edward", tertiary:String = "Robert"):String {
			var heroName:String = "";
			var naturalLanguageName:String = "";
			var numTimes:int = this.numTimesUniquelyTrue;
			var predicateName:String = getNameByType(this.type); // "network", "relationship", etc.
			var notString:String = "";
			var isHigh:Boolean = false;
			var isLow:Boolean = false;
			var isNotHigh:Boolean = false;
			var isNotLow:Boolean = false;
			
			var label:int = this.sfdbLabel;
			
			if (this.negated == true) {
				notString = " not";
			}
			var people:String = " people ";
			var isAre:String = " are ";
			var plurS:String = " ";
			var dont:String = " don't ";
			if (numTimes == 1) {
				people = " person ";
				isAre = " is ";
				plurS = "s ";
				dont = " doesn't ";
			}
			
			if (numTimesRoleSlot.toLowerCase() == "first") {
				heroName = primary;
			}
			else if (numTimesRoleSlot.toLowerCase() == "second") {
				heroName = secondary;
			}
			else if (numTimesRoleSlot.toLowerCase() == "both") {
				heroName = primary + " and " + secondary;
			}
			
			switch (predicateName) {
				case "network": // this one is hard because we need to worry about directionality.
				
						if (meansHigh(this.networkValue) && this.comparator=="greaterthan") isHigh = true;
						else if (meansLow(this.networkValue) && this.comparator == "lessthan") isLow = true;
						else if (meansLow(this.networkValue) && this.comparator == "greaterthan") isNotLow = true;
						else if (meansMedium(this.networkValue) && this.comparator == "greaterthan") isNotLow = true;
						else if (meansHigh(this.networkValue) && this.comparator == "lessthan") isNotHigh = true;			
						else if (meansMedium(this.networkValue) && this.comparator == "lessthan") isNotHigh = true;
				
						//let's think about it for a second.
						//let's say that 'first' is the role slot that we care about.
						//then we are interested in things like "First finds 5 people to be cool, or first finds 3 people to be buddis > 60"
						//If 'second' is the role slot that we care about, 
						//then we are interested in things like "5 people find second to be cool"
						//I don't think we need to worry about friend's average opinion for this? Maybe we do, I am going to not worry about it for right now.
						//OK, so, now too bad.
						if (numTimesRoleSlot.toLowerCase() == "first") {
							switch(SocialNetwork.getNameFromType(this.networkType)) {
							case "buddy":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "there " + isAre + " not even " + numTimes + people + " who " + heroName + " dislikes"; break;
									}
									else {
										naturalLanguageName = heroName + " dislikes at least " + numTimes + people; break;
									}	
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = heroName + " does not even like " + numTimes + people; break;
									}
									else {
										naturalLanguageName = heroName + " doesn't dislike at least " + numTimes + people; break;
									}
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "there" + isAre + "not even " + numTimes + people + " who " + heroName + " likes"; break;
									}
									else {
										naturalLanguageName = heroName + " likes at least " + numTimes + people; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = heroName + " doesn't dislike at least " + numTimes + people; break;
									}
									else {
										naturalLanguageName = heroName + " does not even like " + numTimes + people; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							case "romance":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "there" + isAre + "not even " + numTimes + people + " who " + heroName + " is attracted to"; break;
									}
									else {
										naturalLanguageName = heroName + " is actively unattracted to at least " + numTimes + people; break;
									}	
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = "there " + isAre + " not even  " + numTimes + people + " who do not turn " + heroName + " off"; break;
									}
									else {
										naturalLanguageName = "there " + isAre + " at least " + numTimes + people + " who do not turn " + heroName + " off"; break;
									}
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "there " + isAre + " not even " + numTimes + people + " who " + heroName + " is romantically interested in"; break;
									}
									else {
										naturalLanguageName = heroName + " is romantically interested in at least " + numTimes + people; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = "there " + isAre + " not even " + numTimes + people + "who do not turn " + heroName + " on"; break;
									}
									else {
										naturalLanguageName = "there " + isAre + " at least " + numTimes + people + "who do not turn " + heroName + " on"; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							case "cool":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "there" + isAre + "not even " + numTimes + people + "who " + heroName + " thinks" + isAre + "uncool"; break;
									}
									else {
										naturalLanguageName = heroName + " thinks at least " + numTimes + people + isAre + " uncool"; break;
									}	
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = heroName + " does not even think " + numTimes + people + isAre + " not uncool"; break;
									}
									else {
										naturalLanguageName = heroName + " thinks at least " + numTimes + people + isAre + " not uncool"; break;
									}
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "there " + isAre + " not even " + numTimes + people + "who " + heroName + " thinks " + isAre + "cool"; break;
									}
									else {
										naturalLanguageName = heroName + " thinks at least " + numTimes + people + isAre + "cool"; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = heroName + " thinks at least " + numTimes + people + isAre + "cool"; break;
									}
									else {
										naturalLanguageName = heroName + " does not even think " + numTimes + people + isAre + "cool"; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							}
						}
						else if (numTimesRoleSlot.toLowerCase() == "second") { // these are referring to there being someone who is the recipient of many opinions!
							switch(SocialNetwork.getNameFromType(this.networkType)) {
							case "buddy":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who dislike " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + " dislike " + heroName; break;
									}
									
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who don't dislike " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + " don't dislike " + heroName; break;
									}
									
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who like " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + " like " + heroName; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who " + isAre + " not good buddies with " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + isAre + " not good buddies with " + heroName; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							case "romance":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " turned off by " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + " people " + isAre + " turned off by " + heroName; break;
									}
									
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who" + isAre + "not turned off by " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + isAre + "turned off by " + heroName; break;
									}
									
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who" + isAre + " turned on by " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + isAre + "turned on by " + heroName; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who aren't turned on by " + heroName; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + isAre + "not turned on by " + heroName; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							case "cool":
								if (isLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who think" + plurS + heroName + " is totally uncool"; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + "think" + plurS + heroName + " is totally uncool"; break;
									}
									
								}
								else if (isNotLow) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who think" + plurS + heroName + " is not totally uncool"; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + "think" + plurS + heroName + " is not totally uncool"; break;
									}
									
								}
								else if (isHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who think" + plurS + heroName + " is cool"; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + "think" + plurS + heroName + " is cool"; break;
									}
								}
								else if (isNotHigh) {
									if (this.negated) {
										naturalLanguageName = "There" + isAre + "not even " + numTimes + people + " who " + dont + "think " + heroName + " is cool"; break;
									}
									else {
										naturalLanguageName = "At least " + numTimes + people + dont + "think " + heroName + " is cool"; break;
									}
								}
								else {
									naturalLanguageName = "problem with numTimesUniqelyTrue network predicate to Natural Language";
									break;
								}
							}
						}
					break;
				case "relationship": // I don't think we need to worry about the 'both' for this situation. This one is easy because we don't need to worry about directionality.
					var relationshipIsString:String = " is";
					var relationshipHasString:String = " has";
					if (this.isSFDB) {
						relationshipIsString = " was";
						relationshipHasString = " had";
					}
					switch(RelationshipNetwork.getRelationshipNameByNumber(this.relationship)) {
						case 'friends':
							if (this.negated) {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipHasString + " no friends"; break;
								} else {
									naturalLanguageName = heroName + relationshipIsString + " friends with fewer than " + numTimes + " people"; break;
								}
							}
							else {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipHasString + " a friend"; break;
								} else {
									naturalLanguageName = heroName + relationshipIsString + " friends with at least " + numTimes + " people"; break;
								}
							}
						case 'dating':
							if (this.negated) {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipIsString + " single"; break;
								} else {
									naturalLanguageName = heroName + relationshipIsString + " dating fewer than " + numTimes + " people"; break;
								}
							}
							else {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipIsString  + " dating someone"; break;
								} else {
									naturalLanguageName = heroName + relationshipIsString  + " dating at least " + numTimes + " people"; break;
								}
							}
						case 'enemies':
							if (this.negated) {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipHasString + " no enemies"; break;
								} else {
									naturalLanguageName = heroName + relationshipHasString + " less than " + numTimes + " enemies"; break;
								}
							}
							else {
								if (numTimes == 1) {
									naturalLanguageName = heroName + relationshipHasString  + " an enemy"; break;
								} else {
									naturalLanguageName = heroName + relationshipHasString  + " at least " + numTimes + " enemies"; break;
								}
							}
						default:
							naturalLanguageName = "unrecognized relationship (not friends, dating, or enemies)";
					}
					break;
				case "trait":
					// Pretty sure trait's can't be num times uniquely true thingermajiggers.
					Debug.debug(this, "trait's can't be num times uniquely true!");
					break;
				case "status": // we need to think about these guys a little bit too, because direction matters.
				//First of all, we only care about directed statuses.
				//Second of all, we either care about I have a crush on 10 people.
				//OR we care about 10 people have a crush on me.
				//Again, I don't think both comes into play here, which is kind of nice.
				//UMMMMMMMM What about "I was lonely 5 times?!!?!?!?!?!?!!?"
				//It seems like we DO need to worry about non-directed statuses, too!  But it is 'easier' than directed.
				//We don't care babout role in that case, and we only care if IsSFDB has been checked.
					var theStatus:int = this.status;
			
					var cif:CiFSingleton = CiFSingleton.getInstance();
					
					if (theStatus <= Status.LAST_CATEGORY_COUNT)
					{
						//resolve which trait they actually have
						for each (var s:int in Status.CATEGORIES[this.status])
						{
							if (cif.cast.getCharByName(heroName.toLowerCase()).getStatus(s))
							{
								theStatus = s;
							}
						}
					}
					
					naturalLanguageName = heroName;
					var pluralString:String = " at least " + numTimes + " times";
					var directedPluralNonNegated:String = " at least " + numTimes + " people";
					if (theStatus < Status.FIRST_DIRECTED_STATUS && this.isSFDB) { // I think we can assume that the initiator is the person we care about, and only care about the past (since we can't have multiple statuses in the present).
						if (numTimes == 1) {
							pluralString = "";
							directedPluralNonNegated = " someone";
						}
						if (numTimes == 2) {
							pluralString = " at least twice";
						}
						switch(theStatus){
							case Status.EMBARRASSED:
								if (this.negated) naturalLanguageName += " has got over feeling embarrassed" + pluralString;
								else naturalLanguageName += " has felt embarrassed" + pluralString;
								break;
							case Status.CHEATER:
								if (this.negated) naturalLanguageName += " has lost the reputation of being a cheater" + pluralString;
								else naturalLanguageName += " has been a cheater" + pluralString;
								break;
							case Status.SHAKEN:
								if (this.negated) naturalLanguageName += " has stopped feeling shaken" + pluralString;
								else naturalLanguageName += " has felt shaken" + pluralString;
								break;
							case Status.DESPERATE:
								if (this.negated) naturalLanguageName += " has stopped feeling desperate" + pluralString;
								else naturalLanguageName += " has felt desperate" + pluralString;
								break;
							case Status.CLASS_CLOWN:
								if (this.negated) naturalLanguageName += " has stopped feeling like the class clown" + pluralString;
								else naturalLanguageName += " has felt like the class clown" + pluralString;
								break;
							case Status.BULLY:
								if (this.negated) naturalLanguageName += " has stopped feeling like a bully" + pluralString;
								else naturalLanguageName += " has felt like a bully" + pluralString;
								break;
							case Status.LOVE_STRUCK:
								if (this.negated) naturalLanguageName += " has stopped feeling love struck" + pluralString;
								else naturalLanguageName += " has felt love struck" + pluralString;
								break;
							case Status.GROSSED_OUT:
								if (this.negated) naturalLanguageName += " has stopped feeling grossed out" + pluralString;
								else naturalLanguageName += " has felt grossed out" + pluralString;
								break;
							case Status.EXCITED:
								if (this.negated) naturalLanguageName += " has stopped feeling excited" + pluralString;
								else naturalLanguageName += " has felt excited" + pluralString;
								break;
							case Status.POPULAR:
								if (this.negated) naturalLanguageName += " has stopped being popular" + pluralString;
								else naturalLanguageName += " has been popular" + pluralString;
								break;
							case Status.SAD:
								if (this.negated) naturalLanguageName += " has stopped feeling sad" + pluralString;
								else naturalLanguageName += " has felt sad" + pluralString;
								break;
							case Status.ANXIOUS:
								if (this.negated) naturalLanguageName += " has stopped feeling anxious" + pluralString;
								else naturalLanguageName += " has felt anxious" + pluralString;
								break;
							case Status.HONOR_ROLL:
								if (this.negated) naturalLanguageName += " has been taken off the honor roll" + pluralString;
								else naturalLanguageName += " has been on the honor roll" + pluralString;
								break;
							case Status.LOOKING_FOR_TROUBLE:
								if (this.negated) naturalLanguageName += " has stopped looking for trouble" + pluralString;
								else naturalLanguageName += " has looked for trouble" + pluralString;
								break;
							case Status.GUILTY:
								if (this.negated) naturalLanguageName += " has stopped feeling guilty" + pluralString;
								else naturalLanguageName += " has felt guilty" + pluralString;
								break;
							case Status.FEELS_OUT_OF_PLACE:
								if (this.negated) naturalLanguageName += " has stopped feeling out of place" + pluralString;
								else naturalLanguageName += " has felt out of place" + pluralString;
								break;
							case Status.HEARTBROKEN:
								if (this.negated) naturalLanguageName += " has stopped feeling heartbroken" + pluralString;
								else naturalLanguageName += " has felt heartbroken" + pluralString;
								break;
							case Status.CHEERFUL:
								if (this.negated) naturalLanguageName += " has stopped feeling cheerful" + pluralString;
								else naturalLanguageName += " has felt cheerful" + pluralString;
								break;
							case Status.CONFUSED:
								if (this.negated) naturalLanguageName += " has stopped feeling confused" + pluralString;
								else naturalLanguageName += " has felt confused" + pluralString;
								break;
							case Status.LONELY:
								if (this.negated) naturalLanguageName += " has stopped feeling lonely" + pluralString;
								else naturalLanguageName += " has felt lonely" + pluralString;
								break;
							case Status.HOMEWRECKER:
								if (this.negated) naturalLanguageName += " has stopped being regarded as a homewrecker" + pluralString;
								else naturalLanguageName += " has been regarded as a homewrecker" + pluralString;
								break;
							default:
								naturalLanguageName += "numTimesUniquelyTrue predicate to string -- unrecognized undirected status";
						}
					}	
					else if(numTimesRoleSlot.toLowerCase() == "first"){ // we care about this person having a crush on lots of other people
						switch(theStatus) {
							case Status.HAS_A_CRUSH_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("has a crush on", "does not have a crush on", numTimes) + heroName;
								else naturalLanguageName += " has a crush on" + directedPluralNonNegated; 
								break;
							case Status.ANGRY_AT:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("is angry with", "is not angry with", numTimes) + heroName;
								else naturalLanguageName += " is angry with" + directedPluralNonNegated;
								break;
							case Status.WANTS_TO_PICK_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("wants to pick on", "does not want to pick on", numTimes) + heroName;
								else naturalLanguageName += " wants to pick on" + directedPluralNonNegated;
								break;
							case Status.ANNOYED_WITH:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("is annoyed with", "is not annoyed with", numTimes) + heroName;
								else naturalLanguageName += " is annoyed with" + directedPluralNonNegated; 
								break;
							case Status.SCARED_OF:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("is scared of", "is not scared of", numTimes) + heroName;
								else naturalLanguageName += " is scared of" + directedPluralNonNegated;
								break;
							case Status.PITIES:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("pities", "does not pity", numTimes) + heroName;
								else naturalLanguageName += " pities" + directedPluralNonNegated;
								break;
							case Status.ENVIES:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("envies", "does not envy", numTimes) + heroName;
								else naturalLanguageName += " envies" + directedPluralNonNegated;
								break;
							case Status.GRATEFUL_TOWARD:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("is grateful towards", "is not grateful towards", numTimes) + heroName;
								else naturalLanguageName += " is grateful towards" + directedPluralNonNegated;; 
								break;
							case Status.TRUSTS:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("trusts", "does not trust", numTimes) + heroName;
								else naturalLanguageName += " trusts" + directedPluralNonNegated;
								break;
							case Status.FEELS_SUPERIOR_TO:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("feels superior to", "does not feel superior to", numTimes) + heroName;
								else naturalLanguageName += " feels superior to" + directedPluralNonNegated; 
								break;
							case Status.CHEATING_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedFirst("is cheating on", "is not cheating on", numTimes) + heroName;
								else naturalLanguageName += " is cheating on" + directedPluralNonNegated; 
								break;
							default:
								naturalLanguageName += " not a known/directed status id = " + theStatus;
						}
					}
					else if (numTimesRoleSlot.toLowerCase() == "second") { // we care about other people having this opinion towards the responder.
						naturalLanguageName = ""; // we don't want to start with the person's name for these.
						switch(theStatus) {
							case Status.HAS_A_CRUSH_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("have a crush on", "has a crush on", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("have a crush on", "has a crush on", numTimes); 
								break;
							case Status.ANGRY_AT:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are angry at", "is angry at", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are angry at", "is angry at", numTimes); 
								break;
							case Status.WANTS_TO_PICK_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("wants to pick on", "wants to pick on", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("wants to pick on", "wants to pick on", numTimes); 
								break;
							case Status.ANNOYED_WITH:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are annoyed with", "is annoyed with", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are annoyed with", "is annoyed with", numTimes);  
								break;
							case Status.SCARED_OF:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are scared of", "is scared of", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("ared scared of", "is scared of", numTimes); 
								break;
							case Status.PITIES:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("pity", "pities", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("pity", "pities", numTimes); 
								break;
							case Status.ENVIES:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("envy", "envies", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("envy", "envies", numTimes); 
								break;
							case Status.GRATEFUL_TOWARD:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are grateful towards", "is grateful towards", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are grateful towards", "is grateful towards", numTimes); 
								break;
							case Status.TRUSTS:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("trust", "trusts", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("trust", "trusts", numTimes); 
								break;
							case Status.FEELS_SUPERIOR_TO:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("feel superior to", "feels superior to", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("feel superior to", "feels superior to", numTimes); 
								break;
							case Status.CHEATING_ON:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are cheating on", "is cheating on", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are cheating on", "is cheating on", numTimes); 
								break;
							case Status.CHEATED_ON_BY:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are being cheated on by", "is being cheated on", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are being cheated on by", "is being cheated on", numTimes); 
								break;
							case Status.HOMEWRECKED:
								if (this.negated) naturalLanguageName = directedPluralNegatedSecond("are homewrecking", "is homewrecking", numTimes);
								else naturalLanguageName = directedPluralNonNegatedSecond("are homewrecking", "is homewrecking", numTimes); 
								break;
							default:
								naturalLanguageName += " not a known/directed status id = " + theStatus;
						}
						naturalLanguageName += " " + heroName;
					}
					break;
				case "CKB": // OK, these require a little bit of thought too.
					//I think we definitely need to use the magic of variables here to shorten the amount of work.
					//And, also of important note, is that I believe this is the first time that 'both' is actually an important player.
					//But, fortunately, I don't think there is any distinction between the first and the second.
					//So, we could be interested in something that the primary person has an opinion on (e.g. primary has five things they like)
					//or the secondary person (e.g. secondary has five cool things they like)
					//or it could be explicitly both (there are five things that primary likes and secondary dislikes)
					
					//APPARANTLY I HANDLED THIS ALREADY FOR CKB IN THE NORMAL CKB PREDICATE THING!
					//SO I DON'T NEED TO WORRY ABOUT IT HERE!
					
					break;
				case "SFDBLabel":
					//OK, the last one!  Sweet!
					//this is the dooozy... because all three cases have to be treated seperately.
					//If first is selected -- we are interested in the initiator doing a lot of nice thngs.
					//if second is selected -- we are interested in nicet hings happening to second.
					//if both are selected -- we are interested in first doing nice things to second.
					//lets get started!
										
					var sfdbLabelType:String = SocialFactsDB.getLabelByNumber(label);
					var timeElapsed:String = "";
					if (SocialFactsDB.CAT_POSITIVE == label) {
						sfdbLabelType = "generally positive";
					}
					else if (SocialFactsDB.CAT_NEGATIVE == label){
						sfdbLabelType = "generally negative";
					}
					else if (SocialFactsDB.CAT_FLIRT == label){
						sfdbLabelType = "flirty";
					}
					
					notString = "at least ";
					if (negated) {
						notString = "fewer than ";
					}
					
					//Debug.debug(this, "label: " + label + " sfdbLabelType: " + sfdbLabelType);
					if (numTimesRoleSlot.toLowerCase() == "first") { // these are things that the initiator did -- we don't care to who!
						if (numTimes == 1 && negated) {
							naturalLanguageName = heroName + " hasn't done anything " + sfdbLabelType;
						} else if (numTimes == 1 && !negated) {
							naturalLanguageName = heroName + " did something " + sfdbLabelType;
						} else {
							naturalLanguageName = heroName + " did " + notString + numTimes + " " + sfdbLabelType + " things";// + timeElapsed;
						}
					}
					else if (numTimesRoleSlot.toLowerCase() == "second") { // these are things that happened to the responder -- we don't care who did them!
						if (numTimes == 1 && negated) {
							naturalLanguageName = "Nothing " + sfdbLabelType + " happened to " + heroName;
						} else if (numTimes == 1 && !negated) {
							naturalLanguageName = "Something " + sfdbLabelType + " happened to " + heroName;
						} else {
							naturalLanguageName = notString + numTimes + " " + sfdbLabelType + " things happened to " + heroName;// + timeElapsed;
						}
					}
					else if (numTimesRoleSlot.toLowerCase() == "both") { // these are things that happened to the responder -- we don't care who did them!
						if (numTimes == 1 && negated) {
							naturalLanguageName = heroName + " hasn't done anything " + sfdbLabelType + " to " + secondary;
						} else if (numTimes == 1 && !negated) {
							naturalLanguageName = heroName + " did something " + sfdbLabelType + " to " + secondary;
						} else {
							naturalLanguageName = primary + " did " + notString + numTimes + " " + sfdbLabelType + " things to " + secondary;// + timeElapsed;
						}
						
					}
					else {
						naturalLanguageName = "poorly specified role slot when dealing with sfdb labels to natural language name";
					}
					break;
				default:
					trace ("Unrecognized predicate type");
				
			}
			return naturalLanguageName;
		}
		
		
		/**
		 * This function is the easiest of the easiest.
		 * It looks at the value of the sfdbOrder value
		 * and simply returns an english string that describes it. At least
		 * at first.  We may change it to be smarter later on, but it is good enough for now.
		 * @return
		 */
		public function sfdbOrderToNaturalLanguage():String {
			switch(sfdbOrder) {
				case 1: return "first";
				case 2: return "second";
				case 3: return "third";
				case 4: return "fourth";
				case 5: return "fifth";
				case 6: return "sixth";
				case 7: return "seventh";
				case 8: return "eighth";
				case 9: return "ninth";
				case 10: return "tenth";
				default: return "after a lot of other delicate stuff fell into place, too!";
			}
		}
		
		//Given a string (firUpp), it makes the first letter of that string upper case.
		//Perfect for fixing people's names!
		public function makeFirstLetterUpperCase(firUpp:String):String {
			if(firUpp){
				if (firUpp.length == 0) return "";
				return firUpp.charAt(0).toUpperCase() + firUpp.substring(1, firUpp.length);
			}
			else {
				return "";
			}
		}
		
	}
		

	
	
}