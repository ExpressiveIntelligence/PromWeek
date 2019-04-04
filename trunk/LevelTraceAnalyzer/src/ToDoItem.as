package  
{
	import CiF.*;
	import flash.utils.getTimer;
	import flashx.textLayout.utils.CharacterUtil;
	import flash.utils.Dictionary;

	public class ToDoItem
	{
		public static const BECAME_TRUE:int = 1;
		public static const BECAME_FALSE:int = -1;
		
		/**
		 * This is the set of strings that can appear between levels if this todo item's condition rule is sufficiently completed
		 */
		public var tidbits:Vector.<TidBit>;
		
		/**
		 * This rule tells us whether we have completed the goal for this todo item
		 */
		public var condition:Rule;
		
		public var hasNeedsToBeTheSamePerson:Boolean = false;
		
		/**
		 * For predicates that require responders and/or others, this will keep track of 
		 * the truth values of the predicates of the index in the vector.
		 * 
		 * The index of the dictionaries will be "responderName otherName" and it will hold
		 * either nothing, true or false. Nothing and false mean that the predicate is not true
		 * for those two characters, and true means that it is true.
		 * 
		 * This is all usefull for figuring out when things become true and false
		 */
		public var predTruthValuesPerResponderOtherPair:Vector.<Dictionary>;
		
		/**
		 * The list of predicates truth values
		 */
		public var predTruthValues:Vector.<Boolean>;
		
		/**
		 * the list of predicates values for num times uniquely true
		 */
		public var predNumTimesTrue:Vector.<Number>;
		
		//public var gameEngine:PromWeek.GameEngine;
		public var cif:CiFSingleton = CiFSingleton.getInstance();
		
		/**
		 * Some clever authored name to describe the ToDoItem
		 */
		public var name:String;
		public var goalHint:String = "There are no hints for this goal.";
		
		public function ToDoItem()
		{
			this.tidbits = new Vector.<TidBit>();
			this.condition = new Rule();
			
			//this.predTruthValuesPerResponderOtherPair = new Vector.<Dictionary>();
			
			//gameEngine = PromWeek.GameEngine.getInstance();
		}
		
		
		public function evaluateCondition(storyLeadCharacter:String):Boolean
		{
			var initiator:Character = cif.cast.getCharByName(storyLeadCharacter);
			
			for each (var responder:Character in cif.cast.characters)
			{
				if (this.condition.requiresThirdCharacter())
				{
					for each (var other:Character in cif.cast.characters)
					{
						if (this.condition.evaluate(initiator, responder, other))
						//if (this.pseudoEvaluate(initiator, responder, other))
						{
							return true;
						}
					}
				}
				else
				{
					if (this.condition.evaluate(initiator, responder))
					//if (this.pseudoEvaluate(initiator, responder))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Very similar to the evalute function inside of CiF, but will call a special function
		 * for 'numTimesUniquelyTrue' predicates (that will record for WHO the predicate is true for).
		 * @param	initiator
		 * @param	responder
		 * @param	other
		 * @param	sg
		 * @return
		 */
		/*
		public function pseudoEvaluate(initiator:Character, responder:Character, other:Character = null):Boolean {
			this.condition.lastTrueCount = 0;
			var p:Predicate;
			var p1:Predicate;
			
			//if there is a time ordering dependency in this rule, use the evaluateTimeOrderedRule() pipeline.
			
			if (0 < this.condition.highestSFDBOrder()) {
				//Debug.debug(this, "evaluate() this.highestSFDBOrder of the rule: " + this.highestSFDBOrder());
				return this.condition.evaluateTimeOrdedRule(initiator, responder, other);
			}
			
			for each (p in this.condition.predicates) {
				//Debug.debug(this, "evaluating predicate of type: " + Predicate.getNameByType(p.type), 0);
				var startTime:Number = getTimer();
				if(!p.numTimesUniquelyTrueFlag){ // not a num times uniquely true... behave normally!
					if (!p.evaluate(initiator, responder, other, null)) {
						Predicate.evalutionComputationTime += getTimer() - startTime;

						return false;
					}
					Predicate.evalutionComputationTime += getTimer() - startTime;
					++this.condition.lastTrueCount;
				}
				else {
					handleNumTimesUniquelyTruePredicate(p, initiator, responder, other);
				}
			}
			return true;
		}
		/*
		/*
		public function handleNumTimesUniquelyTruePredicate(p:Predicate, x:Character, y:Character = null, z:Character = null, sg:SocialGame = null):Boolean {
			var first:CiF.Character;
			var second:CiF.Character;
			var third:CiF.Character;
			//there is a third character we need to account for.
			var isThird:Boolean = false;
			var pred:Predicate;
			var rule:Rule;
			var intentIsTrue:Boolean = false;
			if (!(first = cif.cast.getCharByName(p.primary))) {
				switch (p.getPrimaryValue()) {
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
						if(p.type != Predicate.CURRENTSOCIALGAME)
							Debug.debug(this, "the first variable was not bound to a character!");
					//default first is not bound
				}
			}
				
			if (!(second = cif.cast.getCharByName(p.secondary))) {
				switch (p.getSecondaryValue()) {
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
				
			if (!(third = cif.cast.getCharByName(p.tertiary))) {
				switch (p.getTertiaryValue()) {
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
				
			if (p.isSFDB && p.type != Predicate.SFDBLABEL) {
				Debug.debug(this, "I bet I need a special new evaluation function here, too.");
				return p.evalIsSFDB(x, y, z, sg); // probably need a special new evaluation function here, too.
			}
			
			if (p.numTimesUniquelyTrueFlag) 
			{
				//Debug.debug(this, this.toString());
				var numTimesResult:Boolean; //= evalForNumberUniquelyTrue(first, second, third, sg);
				if (x) var xName:String = x.characterName;
				if (y) var yName:String = y.characterName;
				if (z) var zName:String = z.characterName;
				Debug.debug(this, "\n\nnow here is where I actually DO my special new evaluation function for predicate: " + p.toNaturalLanguageString(xName, yName, zName));
				var dictionary:Dictionary = new Dictionary(); // in real life want like a vector of these or something.
				dictionary = p.evalForNumberUniquelyTrueKeepChars(x, y, z, sg);

				for (var k:String in dictionary) {
					  var value:String=dictionary[k];
					  var key:String = k;
					  Debug.debug(this, "key is: " + key + " and value is: " + value);
				}
				
				return (p.negated)? !numTimesResult : numTimesResult;
			}
			
			return false; // hope we don't get here?
		}
		*/
	}
}