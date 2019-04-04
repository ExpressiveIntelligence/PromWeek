package PromWeek 
{
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.ParseXML;
	import CiF.Predicate;
	import CiF.Rule;
	import flash.utils.Dictionary;
	import flashx.textLayout.utils.CharacterUtil;

	/**
	 * The level class represents an individual level or scenario that is part
	 * of a story. Setting, on stage cast, title, description, and the rules
	 * that comprise the goal of the level are all encapsulated in this class.
	 * 
	 * Goal evaluateion: We need the capability to specific specific characters
	 * in the goal rules. If a character is specified in any of the rules, they
	 * cannot be bound to any open variables when evaluating the rules.
	 * 
	 * Open questions: do we want to consider each rule in it's own context or
	 * to we want specified characters and binding contexts to be valid when 
	 * evaluating all rules in the goal rule set? The latter seems to make a bit
	 * more sense.
	 * 
	 * NOTE: Stories and levels are The Prom specific -- this means they need
	 * be treated differently than the other XML-based assets (setting and
	 * library). This means the XML loading and authoring need to be done in 
	 * different venues -- CiF for libraries and states and The Prom for stories,
	 * levels. Endings are still up for debate.
	 */
	public class Level {
		
		/**
		 * The title of the level.
		 */
		public var title:String;
		
		/**
		 * The english description of the level.
		 */
		public var description:String;
		
		/**
		 * The name of the level's setting.
		 */
		public var settingName:String;
		
		/**
		 * The cast for this level.
		 */
		public var cast:Vector.<Character>;
		 
		/**
		 * The rules that comprise the goal/success conditions of the level.
		 */
		public var goalRules:Vector.<Rule>;
		
		/**
		 * 
		 */
		public var endable:Boolean = false;
		
		/**
		 * Local, private reference to CiF.
		 */
		private var cif:CiFSingleton;
		
		/**
		 * The names of the characters statically referenced in any of the
		 * goal rules. These characters should not be rebound when evaluating
		 * the goal rule set.
		 */
		private var boundCharacterNames:Vector.<String>;
		
		/**
		 * The number of rounds the player initially has to finish the level.
		 */
		public var timeLimit:Number;
		
		public var isSandbox:Boolean = false;
		
		/**
		 * True if the initial location of the camera is procedurally placed
		 * by the game engine. False and the camera is positioned according to
		 * the cameraX and cameraY attributes of <Level>.
		 */
		public var useDefinedCameraPosition:Boolean;
		
		/**
		 * The initial position of the camera loaded from level's XML description.
		 */
		public var cameraX:Number;
		public var cameraY:Number;
		
		/**
		 * True if the initial position of the cast should be procedurally generated
		 * by the game engine or false if the positions should be taken from the 
		 * <CharacterName positionX="" positionY=""> tag attributes in the level's
		 * cast description.
		 */
		public var useDefinedCastPositions:Boolean;
		
		/**
		 * The amount of zoom the camera should have when the level first begins.
		 */
		public var startZoom:Number
		
		/**
		 *  The index of what tip we want to show when the player first starts up a level.
		 * -1 means that it doesn't matter (will just be random).
		 */
		public var startTipIndex:String;
		/**
		 * The initial character position as state in the level's XML description.
		 */
		public var characterPositionsX:Dictionary;
		public var characterPositionsY:Dictionary;
		
		/**
		 * If true, then check the value of tutorialScript to see which tutorial file we need to read from
		 */
		public var isTutorial:Boolean;
		/**
		 * the name of the script file that has the tutorial we want to play at the start of this level.
		 */
		public var tutorialScriptName:String
		
		public function Level() {
			//init elements
			this.title = "untitled";
			this.description = "default description";
			this.cast = new Vector.<Character>();
			this.goalRules = new Vector.<Rule>();
			this.cif = CiFSingleton.getInstance();
			this.boundCharacterNames = new Vector.<String>();
			this.startTipIndex = "";
			this.timeLimit = 10; //default time limit for levels
			this.characterPositionsX = new Dictionary()
			this.characterPositionsY = new Dictionary()			
		}
		
		/**
		 * Evaluates the goals of the the level with regards to two specific
		 * characters in the context of the current CiF state and level cast.
		 * 
		 * @param 	isConjunction	True if the rules in goalRules are to be conjunctively evaluated. False if they are disjunctively evaluated.
		 * @return	True if the goals were satisfied either conjunctively or disjunctively.
		 */
		public function evaluateGoals(isConjunction:Boolean = false):Boolean {
			//who are the characters that we cannot bind to variables?
			//this gets values
			//for each (var status:Object in this.statuses) {
			
			//this gets the keys
			//for (var key:Object in this.statuses) {
			
			var isGoalSatisfied:Boolean = false;
			var rule:Rule;
			var firstChar:Character;
			var secondChar:Character;
			
			//Debug.debug(this, "evaluateGoals() rules to evaluate:  " + this.goalRules.length);
			//Debug.debug(this, "evaluateGoals() level.cast.length:  " + this.cast.length);
			
			if (isConjunction) {
			
			}else if (!isConjunction) { // OK, so we know that we are dealing with a disjunction -- that means characters need to be bound on the individual RULE level, not the CHARACTER
				for each(firstChar in this.cast) {
					//if (!this.isCharacterNameBound(firstChar.characterName)) { // the 'firstChar' character doesn't show up explicitly in any of the predicates in any of teh goal rules for this level. BELIEVE WE DO NOT NEED WHEN DEALING WITH DISJUNCTIONS
					//Debug.debug(this, "first character name is not bound");
				
					for each(secondChar in this.cast) {
						//Debug.debug(this, "evaluateGoals() firstChar:  " +firstChar.characterName + " secondChar: " + secondChar.characterName);
						//if (!this.isCharacterNameBound(secondChar.characterName) && firstChar.characterName != secondChar.characterName){ //second char is not bound and second char is different from first char.
						if (firstChar.characterName != secondChar.characterName) {
							for each(rule in this.goalRules) {
								if (!isCharacterNameBoundInSpecificRule(firstChar.characterName, rule)
								&& !isCharacterNameBoundInSpecificRule(secondChar.characterName, rule)) {
									Debug.debug(this, "evaluateGoals() First char and second char both are not bound in this rule --  firstChar:  " +firstChar.characterName + " secondChar: " + secondChar.characterName);
								//Now here, we do care about whether or not either the firstChar or the secondChar is bound within the goal, so we do need to have a check here.
									//Debug.debug(this, "evaluateGoals() evaluating rule: " + rule.toString());
									if (firstChar.characterName.toLowerCase() == "gunter" && secondChar.characterName.toLowerCase() == "kate") {
										Debug.debug(this, "evaluateGoals() evaluating rule: " + rule.toString());
									}
									isGoalSatisfied = rule.evaluate(firstChar, secondChar);
									if (isGoalSatisfied) {
										//break;
										if (firstChar.characterName.toLowerCase() == "gunter" && secondChar.characterName.toLowerCase() == "kate") {
											Debug.debug(this, "goal between gunter and kate was TRUE! WE SHOULD BE DONE! " + rule.toString());
											for each (var predicateGuy:Predicate in rule.predicates) {
												if (predicateGuy.evaluate(firstChar, secondChar)) {
													Debug.debug(this, "This predicate evaled to true: " + predicateGuy.toString());
												}
												else {
													Debug.debug(this, "This predicate evaled to false: " + predicateGuy.toString());
												}
											}
										}
										return true;
									}
									else {
										if (firstChar.characterName.toLowerCase() == "gunter" && secondChar.characterName.toLowerCase() == "kate") {
											Debug.debug(this, "goal between gunter and kate was false " + rule.toString());
											for each (predicateGuy in rule.predicates) {
												if (predicateGuy.evaluate(firstChar, secondChar)) {
													Debug.debug(this, "This predicate evaled to true: " + predicateGuy.toString());
												}
												else {
													Debug.debug(this, "This predicate evaled to false: " + predicateGuy.toString());
												}
											}
										}
									}
								}	
								else {
									//Debug.debug(this, "first character IS bound");
									if(isCharacterNameBoundInSpecificRule(firstChar.characterName, rule)){
										for each(secondChar in this.cast) {
											//if (isCharacterNameBound(secondChar.characterName)) {
											if(isCharacterNameBoundInSpecificRule(secondChar.characterName, rule)){
												//firstchar and secondchar are passed in but will be ignored.
												for each(rule in this.goalRules) {
													isGoalSatisfied = rule.evaluate(firstChar, secondChar);
													//Debug.debug(this, "evaluateGoals() evaluating rule: " + rule.toString());
													//isGoalSatisfied = rule.evaluate(firstChar, secondChar);
													if (isGoalSatisfied) {
														return true;
														//break;
													}
												}
											}
											else {
												//Debug.debug(this, "NO DOING ANYTHING HERE, first: " + firstChar.characterName + " secondChar: " + secondChar.characterName);
											}
										}
									}
								}
							}
						}
						else {
							//Debug.debug(this, "NO DOING ANYTHING HERE, first: " + firstChar.characterName + " secondChar: " + secondChar.characterName);
						}
					}
				}
			}
			//Debug.debug(this, "evaluateGoals() returned " + isGoalSatisfied);
			return isGoalSatisfied;
		}
		
		
		/**
		 * Determines if any two character pairs in the level statisfy the level's rules.
		 * 
		 * @param	isConjunction True if the rules in goalRules are to be conjunctively evaluated. False if they are disjunctively evaluated.
		 */
		//public function evaluateGoalsForAllInLevel(isConjunction:Boolean = false):Boolean {
			//return false;
		//}
		
		
		/**
		 * Determines and stores any explicitly-referenced characters in any of the goal rules.
		 * Stores the names of these bound characters in this.boundCharacterNames.
		 **/
		private function findExplicitlyNamedCharactersInGoalRules():void {
			var predBoundCharNames:Vector.<String>;
			var name:String;
			var addToBoundList:Boolean = false;
			var nameInList:String;
			
			//This is good for any rules that are going to be evaluated Conjunctively, but not as good
			//for rules that are evaluated disjunctively.
			//This creates a big list of all of the characters in any of the goal rules -- however, based on
			//how this gets used later, I think we actually only want the names of characters in all of the predicates in a specific 
			//rule.
			for each(var rule:Rule in this.goalRules) {
				for each(var pred:Predicate in rule.predicates) {
					predBoundCharNames = pred.getBoundCharacterNames();
					for each (name in predBoundCharNames) {
						addToBoundList = true;
						for each (nameInList in this.boundCharacterNames) {
							if (name.toLowerCase() == nameInList.toLowerCase())
								addToBoundList = false;
						}
						if (addToBoundList)
							this.boundCharacterNames.push(name);
					}
				}
			}
			//Debug.debug(this, "level name: " + this.title);
			//Debug.debug(this, "findExplicitlyNamedCharactersInGoalRules() this.boundCharacterNames: ");
			//for each (nameInList in this.boundCharacterNames) 
				//Debug.debug(this, "findExplicitlyNamedCharactersInGoalRules() * " + nameInList);
		}
		
		/**
		 * Determines if a character name represents a character that is
		 * explicitly bound in the goal rule set.
		 * @param	name	Name of the character to check.
		 * @return	True if the character is bound, false if not.
		 */
		private function isCharacterNameBound(name:String):Boolean {
			for each(var nameInList:String in this.boundCharacterNames)
				if (nameInList.toLowerCase() == name.toLowerCase())
					return true;
			return false;
		}
		
		/**
		 * This function takes in a goal rule and a character name.  If the character name appears in
		 * any of the predicates of the goal rule, then it returns true.  Otherwise, it returns false.
		 * @param	name the name of the character
		 * @param	rule the rule that we are checking to see if the character is bound within
		 * @return true if the character's name is bound, false otherwise.
		 */
		private function isCharacterNameBoundInSpecificRule(name:String, rule:Rule):Boolean {
			var nameIterator:String;
			var predBoundCharNames:Vector.<String>;
			for each(var pred:Predicate in rule.predicates) {
				predBoundCharNames = pred.getBoundCharacterNames();
				for each (nameIterator in predBoundCharNames) {
					if (nameIterator.toLowerCase() == name.toLowerCase()) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * This function takes in a goal rule and two character names.  If both names appears in
		 * any of the predicates of the goal rule, then it returns true.  Otherwise, it returns false.
		 * @param	nameOne the name of one of the characters
		 * @param	nameTwo the name of the second character
		 * @param	rule the rule that we are checking to see if the character is bound within
		 * @return true if the character's name is bound, false otherwise.
		 */
		private function isPairOfCharactersBoundInSpecificRule(nameOne:String, nameTwo:String, rule:Rule):Boolean {
			var nameIterator:String;
			var predBoundCharNames:Vector.<String>;
			var haveSeenFirst:Boolean = false;
			var haveSeenSecond:Boolean = false;
			for each(var pred:Predicate in rule.predicates) {
				predBoundCharNames = pred.getBoundCharacterNames();
				for each (nameIterator in predBoundCharNames) {
					if (nameIterator.toLowerCase() == nameOne.toLowerCase()) {
						haveSeenFirst = true;
					}
					if (nameIterator.toLowerCase() == nameTwo.toLowerCase()) {
						haveSeenSecond = true;
					}
				}
				if (haveSeenFirst && haveSeenSecond) {
					return true;
				}
			}
			if (haveSeenFirst && haveSeenSecond) {
				return true;
			}
			return false;
		}
		
		/**
		 * Determines if a character name represents a character that is
		 * a member of the cast for this level
		 * @param	name Name of the character to check.
		 * @return True if the character is in this level. False if not.
		 */
		public function isCharacterInThisLevel(name:String):Boolean {
			for each (var castMember:Character in this.cast) {
				if (castMember.characterName.toLowerCase() == name.toLowerCase()) {
					return true; // we found a match!
				}
			}
			return false;
		}
		
		/**
		 * After a CiF state reset, the old character instances are no longer linked with
		 * the CiF state. A side effect from this behavior is that the references to characters
		 * in each level's cast are pointing to invalid character references. This function
		 * fetches new character references from CiF's newly updated cast.
		 */
		public function refreshCast():void {
			var newCast:Vector.<Character> = new Vector.<Character>();
			for each(var c:Character in this.cast) {
				if(c)
					newCast.push(cif.cast.getCharByName(c.characterName))
			}
			this.cast = newCast;
		}
		
		
		/**********************************************************************
		 * Utility functions.
		 *********************************************************************/
		
		/**
		 * Implementation of a standard toString function.
		 * @return
		 */
		public function toString():String {
			return this.toXML().toXMLString();
		}
		
		
		/**
		 * Maps the level to XML and returns an XML object containing the mapping.
		 * @return	An XML representation of the level.
		 */
		public function toXML():XML {
			var returnXML:XML;
			
			returnXML = <Level title={this.title} timeLimit={this.timeLimit} endable={this.endable}></Level>;
			returnXML.appendChild(<Description>{this.description}</Description>);
			returnXML.appendChild(<Setting>{this.settingName}</Setting>);
			returnXML.appendChild(<Cast/>);
			returnXML.appendChild(<GoalRules/>);
			
			for each (var c:Character in this.cast) {
				returnXML.Cast.appendChild(<CharacterName>{c.characterName}</CharacterName>);
			}
			
			for each (var rule:Rule in this.goalRules) {
				returnXML.GoalRules.appendChild(rule.toXML());
			}
			
			return returnXML;
			
		}
		
		/**
		 * Translates <Level> XML objects to the elements of this instantiation
		 * of the level class.
		 * 
		 * @param	levelXML	An XML representation of a level.
		 */
		public function loadFromXML(levelXML:XML):void {
			
			this.title = (levelXML.@title.toString())?levelXML.@title:"untitled";
			this.endable = (levelXML.@endable.toString() == "true")?true:false;
			this.timeLimit = (levelXML.@timeLimit.toString())?levelXML.@timeLimit:10;
			this.description = (levelXML.Description.toString())?levelXML.Description:"undescribed";
			this.settingName = (levelXML.Setting.toString())?levelXML.Setting:"no setting";
			
			this.useDefinedCastPositions = (levelXML.@useDefinedCastPositions.toString().toLowerCase()=="true")?true:false;
			this.useDefinedCameraPosition = (levelXML.@useDefinedCameraPosition.toString().toLowerCase()=="true")?true:false;
			this.cameraX = levelXML.@cameraX;
			this.cameraY = levelXML.@cameraY;
			this.startZoom = levelXML.@cameraZoom;
			this.isTutorial = (levelXML.@isTutorial.toString() == "true")?true:false;;
			this.tutorialScriptName = (levelXML.@tutorialScript.toString())?levelXML.@tutorialScript:"";
			
			this.startTipIndex = (levelXML.@startTip.toString())?levelXML.@startTip:"";  
			
			for each(var charXML:XML in levelXML.Cast.CharacterName) {
				this.cast.push(cif.cast.getCharByName(charXML.toString()));
				this.characterPositionsX[charXML.toString()] = charXML.@startX;
				this.characterPositionsY[charXML.toString()] = charXML.@startY;
				this.characterPositionsX[charXML.toString().toLowerCase()] = charXML.@startX;
				this.characterPositionsY[charXML.toString().toLowerCase()] = charXML.@startY;
				//Debug.debug(this, "loadFromXML() charXML: " + charXML.@startX);
			}
			
			for each (var ruleXML:XML in levelXML.GoalRules..Rule) {
				this.goalRules.push(ParseXML.ruleParse(ruleXML));
			}
			
			this.findExplicitlyNamedCharactersInGoalRules();
		}
				
	}

}