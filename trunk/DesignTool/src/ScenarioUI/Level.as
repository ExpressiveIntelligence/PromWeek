package ScenarioUI 
{
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.ParseXML;
	import CiF.Predicate;
	import CiF.Rule;
	
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
		
		public function Level() {
			//init elements
			this.title = "untitled";
			this.description = "default description";
			this.cast = new Vector.<Character>();
			this.goalRules = new Vector.<Rule>();
			this.cif = CiFSingleton.getInstance();
			this.boundCharacterNames = new Vector.<String>();
			this.timeLimit = 10; //default time limit for levels
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
			
			}else if (!isConjunction) {
				for each(firstChar in this.cast) {
					if (!this.isCharacterNameBound(firstChar.characterName)){
					
						for each(secondChar in this.cast) {
							//Debug.debug(this, "evaluateGoals() firstChar:  " +firstChar.characterName + " secondChar: " + secondChar.characterName);
							if (!this.isCharacterNameBound(secondChar.characterName) && firstChar.characterName != secondChar.characterName){
								for each(rule in this.goalRules) {
									//Debug.debug(this, "evaluateGoals() evaluating rule: " + rule.toString());
									isGoalSatisfied = rule.evaluate(firstChar, secondChar);
									if (isGoalSatisfied) break;
								}	
							}
						}
					}else {
						for each(secondChar in this.cast) {
							if (isCharacterNameBound(secondChar.characterName)) {
								//firstchar and secondchar are passed in but will be ignored.
								for each(rule in this.goalRules) {
									isGoalSatisfied = rule.evaluate(firstChar, secondChar);
									//Debug.debug(this, "evaluateGoals() evaluating rule: " + rule.toString());
									isGoalSatisfied = rule.evaluate(firstChar, secondChar);
									if (isGoalSatisfied) break;
								}
							}
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
			
			for each(var charXML:XML in levelXML.Cast.CharacterName) {
				this.cast.push(cif.cast.getCharByName(charXML.toString().toLowerCase()));
			}
			
			for each (var ruleXML:XML in levelXML.GoalRules..Rule) {
				this.goalRules.push(ParseXML.ruleParse(ruleXML));
			}
			
			this.findExplicitlyNamedCharactersInGoalRules();
		}
				
	}

}