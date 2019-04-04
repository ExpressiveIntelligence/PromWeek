package PromWeek 
{
	import CiF.GameScore;
	import CiF.Locution;
	import CiF.Util;
	import flash.geom.Vector3D;
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.ParseXML;
	import CiF.Predicate;
	import CiF.Rule;
	import flash.utils.Dictionary;
	/**
	 * This class defines a story in The Prom. A story consists of a sequence
	 * of levels, a title, a description, and various display extras.
	 * @author Josh
	 */
	public class Story 
	{
		/**
		 * The levels of the story in appearance order.
		 */
		public var levels:Vector.<Level>;
		
		/**
		 * The story's title.
		 */
		public var title:String;
		
		/**
		 * The story's description.
		 */
		public var description:String;
		
		/**
		 * The story's endings
		 */
		public var endings:Vector.<Ending>;
		
		/**
		 * The person the story is about
		 */
		public var storyLeadCharacter:String;
		 
		/**
		 * This keeps track of whether of not we should list this in the story selection screen or not
		 */
		public var shouldDisplay:Boolean;
		
		public var gameEngine:GameEngine;
		
		/**
		 * ToDo items are all the goals that the player can strive for
		 */
		public var todoList:Vector.<ToDoItem>;
		
		/**
		 * This will be for keeping the location of the stories
		 */
		public var storySelectionLocation:int = 20;
		
		/**
		 * Temporary until otherwise noted whether the story is a tutorial or not
		 */
		public var istutorial:Boolean;
		
		/**
		 * If true, it flags the story as a quick play story.
		 * We may, though not necessarily, want to treat quick play stories
		 * differently than how we treat other stories (we don't want them showing up on the
		 * campaign screen, for example).
		 */
		public var isQuickPlay:Boolean
		
		/**
		 * In quick play mode, we want there to be only a small amount of social games available.
		 * This number can change from quick play level to quick play level. So, for example, in level 1,
		 * there may only be a single social game that you can play.  And in level 2, maybe you can play 3.
		 */
		public var quickPlayNumberOfGamesAvailable:Number
		
		
		/**
		 * This is a string that will contain the description of the level goal that needs to be
		 * achieved for a quick play level.  It gets stored in it's own special thing because
		 * we want to be able to leverage the 'icons inside of text' magic that we first
		 * discovered for tutorials back in the day.
		 */
		public var quickPlayDescription:String
		
		/**
		 * The string that appears when you complete a quickplay challenge!
		 */
		public var quickPlayEndingDescription:String
		
		/**
		 * The name of the 'next' challenge after this one in quickplay mode -- should reference the  'title'
		 * attribute of the particular story we care about.  If the next challenge is named
		 * 'NONE', then it is assumed that we have reached the end of quickplay mode, and we are ready to
		 * move on.
		 */
		public var nextChallengeName:String
		
		/**
		 * This is how you know how many endings have to be seen in order to unlock something.
		 */
		public var toUnlock:int;
		
		/**
		 * Denotes whether story is locked or not
		 */
		public var islocked:Boolean;
		
		/**
		 * String to access the dictionary location of the tutorial screenshot
		 */
		public var tutorialScreenShot:String;
		
		/**
		 * A vector of 'ForcedSG's -- each one of these represents a game that we INSIST that the
		 * characters need to be able to play with each other.  Intended to only be used in 
		 * quickplay mode.
		 */
		public var forcedSGs:Vector.<ForcedSG>
		
		/**
		 * This variable was added when we introduced 'quick play' tutorials, which depend on separate start states.
		 * This enables us to have a unique start state per story.
		 * If left blank or unspecified, it will just use the default start state.
		 */
		public var startState:String;
		 
		public function Story() 
		{
			this.todoList = new Vector.<ToDoItem>();
			
			this.levels = new Vector.<Level>();
			this.endings = new Vector.<Ending>();
			forcedSGs = new Vector.<ForcedSG>();
			this.title = "untitled";
			this.description = "undescribed";
			
			gameEngine = GameEngine.getInstance();
		}
		
		/**
		 * More or less copied from Level.as
		 * Evaluates the goals of the the STORY with regards to two specific
		 * characters in the context of the current CiF state and level cast.
		 * The difference is that we are figuring out if an ENDING is satisfied, as
		 * in the ending to the entire game, not just the ending of a single level
		 * 
		 * @param 	isConjunction	if true, it means that the preconditions should be evaluated conjuctively (ANDed), false it means they should be evaluated disjunctively (ORed)
		 * @return	True if the goals were satisfied either conjunctively or disjunctively.
		 */
		public function evaluateEndingPreconditions(cast:Vector.<Character>, isConjunction:Boolean = false):Boolean 
		{
			var isGoalSatisfied:Boolean = false;
			var isRuleSatisfied:Boolean = false;
			var rule:Rule;
			var firstChar:Character;
			var secondChar:Character;
			var thirdChar:Character;
			var ending:Ending;
			
			var endingAlreadyExists:Boolean;
			var atLeastEndingWasFound:Boolean = false;
			var requiresThird:Boolean;
			var secondThirdPairForEnding:Dictionary;
			//Debug.debug(this,"evaluateEndingPreconditions() TESTING ENDINGS!!!");

			
			//REMOVING ALL OF THE 'Character BOUND' STUFF FROM HERE
			//BUT IT STILL LIVES INSIDE OF LEVEL.AS IF WE EVER NEED IT BACK
			//Ok, well, now it is a long time later... 
			//I'm pretty sure the character bound stuff inside of level.as was broken anyway, so that works out well for us, actually!
			
			if (isConjunction) {
				
			}else if (!isConjunction) {
				//for each(firstChar in cast) {
				firstChar = CiFSingleton.getInstance().cast.getCharByName(gameEngine.currentStory.storyLeadCharacter);
				for each(ending in this.endings)
				{
					ending.firstName = firstChar.characterName;
					requiresThird = false;
					for each(rule in ending.preconditions) 
					{
						if (!requiresThird)
						{
							requiresThird = rule.requiresThirdCharacter();
						}
					}
					ending.secondThirdPairs = new Vector.<Dictionary>();
					
					for each(secondChar in cast) 
					{
						if (firstChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase()) 
						{
							if (requiresThird)
							{
								for each(thirdChar in cast) 
								{
									if (thirdChar.characterName.toLowerCase() != firstChar.characterName.toLowerCase() && thirdChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase())
									{
										isGoalSatisfied = true;
										for each(rule in ending.preconditions) 
										{
											isRuleSatisfied = rule.evaluate(firstChar, secondChar, (requiresThird)?thirdChar:null);
											if (!isRuleSatisfied) 
												isGoalSatisfied=false
										}
										
										if (isGoalSatisfied) 
										{
											secondThirdPairForEnding = new Dictionary();
											secondThirdPairForEnding["responder"] = secondChar.characterName;
											secondThirdPairForEnding["other"] = thirdChar.characterName;
											ending.secondThirdPairs.push(secondThirdPairForEnding);
											atLeastEndingWasFound = true;
											
											gameEngine.possibleEndings.push(ending);
										}
									}
								}
							}
							else
							{
								isGoalSatisfied = true;
								for each(rule in ending.preconditions) 
								{
									isRuleSatisfied = rule.evaluate(firstChar, secondChar);
									if (!isRuleSatisfied) 
										isGoalSatisfied=false
								}
								if (isGoalSatisfied) 
								{
									secondThirdPairForEnding = new Dictionary();
									secondThirdPairForEnding["responder"] = secondChar.characterName;
									ending.secondThirdPairs.push(secondThirdPairForEnding);
									atLeastEndingWasFound = true;
									
									gameEngine.possibleEndings.push(ending);
								}
							}
						}
					}
				}
			}
			return atLeastEndingWasFound;
			//return false;
		}
		
		/**
		 * Evaluates the ToDoItems/goals of the the STORY with regards to two specific
		 * characters in the context of the current CiF state and level cast.
		 * 
		 * @param 	isConjunction	if true, it means that the preconditions should be evaluated conjuctively (ANDed), false it means they should be evaluated disjunctively (ORed)
		 * @return	True if the goals were satisfied either conjunctively or disjunctively.
		 */
		public function evaluateToDoItems(cast:Vector.<Character>, isConjunction:Boolean = false):Vector.<ToDoItem>
		{
			var isGoalSatisfied:Boolean = false;
			var rule:Rule;
			var firstChar:Character;
			var secondChar:Character;
			var thirdChar:Character;
			//var ending:Ending;
			var item:ToDoItem
			
			var itemAlreadyExists:Boolean;
			var atLeastItemWasFound:Boolean = false;
			
			var itemsFulfilled:Vector.<ToDoItem> = new Vector.<ToDoItem>;
			
			//Debug.debug(this,"evaluateEndingPreconditions() TESTING ENDINGS!!!");
			
			
			//REMOVING ALL OF THE 'Character BOUND' STUFF FROM HERE
			//BUT IT STILL LIVES INSIDE OF LEVEL.AS IF WE EVER NEED IT BACK
			//Ok, well, now it is a long time later... 
			//I'm pretty sure the character bound stuff inside of level.as was broken anyway, so that works out well for us, actually!
			
			if (isConjunction) {
				
			}else if (!isConjunction) {
				//for each(firstChar in cast) {
				firstChar = CiFSingleton.getInstance().cast.getCharByName(gameEngine.currentStory.storyLeadCharacter);
				for each(secondChar in cast) 
				{
					if (firstChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase()) 
					{
						for each(thirdChar in cast) 
						{
							if (thirdChar.characterName.toLowerCase() != firstChar.characterName.toLowerCase() && thirdChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase())
							{
								for each(item in this.todoList)
								{
									rule = item.condition
									var requiresThird:Boolean = rule.requiresThirdCharacter();
									isGoalSatisfied = rule.evaluate(firstChar, secondChar, (requiresThird)?thirdChar:null);
									if (isGoalSatisfied) 
									{
										itemAlreadyExists = false;
										for each (var i:ToDoItem in itemsFulfilled)
										{
											if (i.name == item.name)
											{
												itemAlreadyExists = true;
											}
										}
										
										if (!itemAlreadyExists)
										{
											Debug.debug(this, "evaluateToDoItems() returned " + isGoalSatisfied);
											Debug.debug(this, "evaluateToDoItems() item unlocked: " + item.name);
											itemsFulfilled.push(item)
										}
										
									}
									
								}
							}
						}
					}
				}
				//}
			}
			return itemsFulfilled

		}
		
		/**********************************************************************
		 * Utility functions.
		 *********************************************************************/

		public function toString():String {
			return "";
		}
		
		public function toXML():XML 
		{
			var returnXML:XML;
			
			returnXML = <Story title={this.title} />;
			returnXML.appendChild(<Description>{this.description}</Description>);
			returnXML.appendChild(<Levels/>);
			
			for each (var l:Level in this.levels) {
				returnXML.Levels.appendChild(l.toXML());
			}
			
			returnXML.appendChild(<Endings/>);
			for each (var e:Ending in this.endings)
			{
				returnXML.appendChild(e.toXMLString());
			}
			
			return returnXML;
		}
		
		/**
		 * Translates <Story> XML objects to the elements of this instantiation
		 * of the Story class.
		 * @param	storyXML
		 */
		public function loadFromXML(storyXML:XML):void {
			var level:Level;
			var ending:Ending;
			this.title = (storyXML.@title.toString())?storyXML.@title:"untitled";
			this.storyLeadCharacter = (storyXML.@storyLeadCharacter.toString())?storyXML.@storyLeadCharacter:"no lead";
			this.nextChallengeName = (storyXML.@nextChallengeName.toString())?storyXML.@nextChallengeName:"NONE";
			this.description = (storyXML.Description.toString())?storyXML.Description:"undescribed";
			this.quickPlayDescription = (storyXML.QuickPlayDescription.text())?storyXML.QuickPlayDescription.text():"undescribed";
			this.quickPlayEndingDescription = (storyXML.QuickPlayEndingDescription.text())?storyXML.QuickPlayEndingDescription.text():"undescribed";
			this.istutorial = (storyXML.@isTutorial.toString() == "true")?true:false;
			this.isQuickPlay = (storyXML.@isQuickPlay.toString() == "true")?true:false;
			this.quickPlayNumberOfGamesAvailable = (storyXML.@numberOfQuickPlaySGAvailable.toString())?storyXML.@numberOfQuickPlaySGAvailable:10;
			this.islocked = (storyXML.@locked.toString() == "false")?false:true;
			this.startState = (storyXML.@startState.toString())?storyXML.@startState:"";
			if (storyXML.@shouldDisplay)
			{
				this.shouldDisplay = (storyXML.@shouldDisplay.toString() == "false")?false:true;
			}
			this.toUnlock = (storyXML.@toUnlock);
			//Debug.debug(this, "this is the value of toUnlock: " + toUnlock);
			this.tutorialScreenShot = (storyXML.@screenShot.toString())?storyXML.@screenShot:"undescribed";
			
			for each (var forcedSGXML:XML in storyXML.ForcedSGs..ForcedSG) {
				var forcedSG:ForcedSG = new ForcedSG();
				forcedSG.loadFromXML(forcedSGXML);
				this.forcedSGs.push(forcedSG);
			}
			
			for each (var levelXML:XML in storyXML.Levels..Level) {
				level = new Level();
				level.loadFromXML(levelXML);
				this.levels.push(level);
			}
			
			for each (var todoListXML:XML in storyXML..ToDoList)
			{
				var todoItem:ToDoItem;
				var tidbit:TidBit;
				for each (var todoItemXML:XML in todoListXML..ToDoItem)
				{
					todoItem = new ToDoItem();
					
					for each (var goalDescriptionXML:XML in todoItemXML..GoalDescription)
					{
						todoItem.goalDescription = goalDescriptionXML.@words;
					}
					
					
					for each (var conditionXML:XML in todoItemXML..Condition)
					{
						for each (var ruleXML:XML in conditionXML..Rule)
						{
							todoItem.condition = ParseXML.ruleParse(ruleXML);
							//todoItem.condition.sortBySFDBOrder();
						}
						
						for each (var taskNaturalLanguageXML:XML in conditionXML..taskNaturalLanguage)
						{
							todoItem.taskNaturalLanguageWords.push(taskNaturalLanguageXML.@words.toString());
						}
					}
					
					//initialize the predTruthValuesPerResponderOtherPair dictionaries
					
					todoItem.name = todoItemXML.@name;
					todoItem.goalHint = (todoItemXML.@goalHint)?todoItemXML.@goalHint:"";
					for each (var tidbitXML:XML in todoItemXML..TidBit)
					{
						tidbit = new TidBit();
						tidbit.originalTemplateString = tidbitXML.@text;
						tidbit.locutions = Util.createLocutionVectors(tidbit.originalTemplateString);
						todoItem.tidbits.push(tidbit);
					}
					this.todoList.push(todoItem);
				}
			}
			
			for each (var endingXML:XML in storyXML.Endings..Ending) {
				ending = new Ending();
				ending.loadFromXML(endingXML, this.todoList);
				
				ending.prepareLocutions();
				
				this.endings.push(ending);
			}
			
			
			
			
			
			
		}
	}
}