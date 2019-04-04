package ScenarioUI 
{
	import CiF.GameScore;
	import flash.geom.Vector3D;
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.ParseXML;
	import CiF.Predicate;
	import CiF.Rule;
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
		//public var endings:Vector.<Ending>;
		
		//public var gameEngine:GameEngine;
		
		public function Story() 
		{
			this.levels = new Vector.<Level>();
			//this.endings = new Vector.<Ending>();
			this.title = "untitled";
			this.description = "undescribed";
			
			//gameEngine = GameEngine.getInstance();
		}
		
		/**
		 * More or less copied from Level.as
		 * Evaluates the goals of the the STORY with regards to two specific
		 * characters in the context of the current CiF state and level cast.
		 * The difference is that we are figuring out if an ENDING is satisfied, as
		 * in the ending to the entire game, not just the ending of a single level
		 * 
		 * @param 	isConjunction	Don't really know what this means.
		 * @return	True if the goals were satisfied either conjunctively or disjunctively.
		 */
/*		public function evaluateEndingPreconditions(cast:Vector.<Character>, isConjunction:Boolean = false):Boolean {

			
			var isGoalSatisfied:Boolean = false;
			var rule:Rule;
			var firstChar:Character;
			var secondChar:Character;
			var thirdChar:Character;
			var ending:Ending;
			
			var endingAlreadyExists:Boolean;
			
			//Debug.debug(this,"evaluateEndingPreconditions() TESTING ENDINGS!!!");
			
			
			//REMOVING ALL OF THE 'CHARACGTER BOUND' STUFF FROM HERE
			//BUT IT STILL LIVES INSIDE OF LEVEL.AS IF WE EVER NEED IT BACK
			if (isConjunction) {
				
			}else if (!isConjunction) {
				for each(firstChar in cast) {
					for each(secondChar in cast) {
						if (firstChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase())
							for each(thirdChar in cast) {
								if (thirdChar.characterName.toLowerCase() != firstChar.characterName.toLowerCase() && thirdChar.characterName.toLowerCase() != secondChar.characterName.toLowerCase())
								{
									for each(ending in this.endings){
										for each(rule in ending.preconditions) {
											//trace ("first char: " + firstChar.characterName + " second char: " + secondChar.characterName + " third char: " + thirdChar.characterName + " ending: " + rule.name);
											isGoalSatisfied = rule.evaluate(firstChar, secondChar, thirdChar);
											if (isGoalSatisfied) {
												endingAlreadyExists = false;
												for each (var endingButton:SocialGameButton in gameEngine.hudGroup.endingButtons)
												{
													if (endingButton.label == ending.name)
													{
														endingAlreadyExists = true;
													}
												}
												
												if (!endingAlreadyExists)
												{
													Debug.debug(this, "evaluateGoals() returned " + isGoalSatisfied);
													Debug.debug(this, "evaluateGoals() ending unlocked: " + ending.name);
													ending.firstName = firstChar.characterName;
													ending.secondName = secondChar.characterName;
													ending.thirdName = thirdChar.characterName;
													gameEngine.hudGroup.addEndingButton(ending.name);
													return isGoalSatisfied;
												}
											}
										}	
									}
								}
							}
					}
				}
			}
			return false;
		}
*/		
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
			
/*			returnXML.appendChild(<Endings/>);
			for each (var e:Ending in this.endings)
			{
				returnXML.appendChild(e.toXMLString());
			}
*/			
			return returnXML;
		}
		
		/**
		 * Translates <Story> XML objects to the elements of this instantiation
		 * of the Story class.
		 * @param	storyXML
		 */
		public function loadFromXML(storyXML:XML):void {
			var level:Level;
			//var ending:Ending;
			this.title = (storyXML.@title.toString())?storyXML.@title:"untitled";
			this.description = (storyXML.Description.toString())?storyXML.Description:"undescribed";
			for each (var levelXML:XML in storyXML.Levels..Level) {
				level = new Level();
				level.loadFromXML(levelXML);
				this.levels.push(level);
			}
			
		/*	for each (var endingXML:XML in storyXML.Endings..Ending) {
				ending = new Ending();
				ending.loadFromXML(endingXML);
				ending.prepareLocutions();
				
				this.endings.push(ending);
			}*/
		}
		
	}
}