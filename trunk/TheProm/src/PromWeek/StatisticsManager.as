package PromWeek 
{
	
	import CiF.SocialGameContext;
	import CiF.Rule;
	import CiF.Predicate;
	import CiF.Effect;
	import CiF.CiFSingleton;
	import CiF.SocialGamesLib;
	import CiF.SocialGame;
	import flash.utils.Dictionary;
	import CiF.RelationshipNetwork;
	
	/**
	 * This is meant to keep track of various statistics throughout gameplay 
	 * (e.g. how many times the user clicked, or how many new friendships were made).
	 * In real life, we'll probably want to initialize this based on their previous performance
	 * that we've stored in a database.
	 * @author Ben*
	 */
	public class StatisticsManager
	{
		
		public const CURRENT_LEVEL_START_DATING_INDEX:String = "currentstartdating";
		public const TOTAL_START_DATING_INDEX:String = "startdatingtotal";
		public const CURRENT_LEVEL_STOP_DATING_INDEX:String = "currentstopdating";
		public const TOTAL_STOP_DATING_INDEX:String = "stopdatingtotal";
		
		public const CURRENT_LEVEL_START_FRIENDS_INDEX:String = "currentstartfriends";
		public const TOTAL_START_FRIENDS_INDEX:String = "startfriendstotal";
		public const CURRENT_LEVEL_STOP_FRIENDS_INDEX:String = "currentstopfriends";
		public const TOTAL_STOP_FRIENDS_INDEX:String = "stopfriendstotal";
		
		public const CURRENT_LEVEL_START_ENEMIES_INDEX:String = "currentstartenemies";
		public const TOTAL_START_ENEMIES_INDEX:String = "startenemiestotal";
		public const CURRENT_LEVEL_STOP_ENEMIES_INDEX:String = "currentstopenemies";
		public const TOTAL_STOP_ENEMIES_INDEX:String = "stopenemiestotal";
		
		private const NUMBER_OF_NON_INDIRECT_GAMES_BEFORE_REMINDER:int = 4;
		
		public var numberOfGoalsCompleted:int; // maybe we want to give them an achievement for completing X goals or something!
		public var numberOfLevelsCompleted:int; // maybe we want to give them an achievement for completing X levels or something!
		public var indirectGamesPlayed:int; // Keeps track of the number of games played that did not star the main character.
		public var playedSeveralGamesWithoutIndirection:Boolean; // gets set to true if they've played several games without using the main character.
		public var closedTheIndirectGamesPlayedWindow:Boolean; //if they close the window, make it so that it doesn't show up again.
		
		private static var _instance:StatisticsManager = new StatisticsManager();
		private var cif:CiFSingleton;
		private var sgLib:SocialGamesLib;
		private var gameEngine:GameEngine;
		
		public var endingsSeen:Dictionary = new Dictionary();
		public var goalsSeen:Dictionary = new Dictionary();
		public var tutorialsDone:Dictionary = new Dictionary();
		public var campaignsUnlocked:Dictionary = new Dictionary();
		
		public var relationshipStats:Dictionary; // has information like "number of times start dating" and "number of times end dating"
		
		public var endingXML:XML; // Has the information read in from the DATABASE pertaining to which endings the user has already seen! 
		public var endingDataString:String;
		public var goalXML:XML; // Has the information read in from the DATABASE pertaining to which goals the user has already seen! 
		public var goalDataString:String;
		
		public function StatisticsManager() 
		{
			if (_instance != null) {
				throw new Error("StatisticsManager (Constructor): " + "Cast can only be accessed through StatisticsManager.getInstance()");
			}
			cif = CiFSingleton.getInstance();
			sgLib = SocialGamesLib.getInstance();
			gameEngine = GameEngine.getInstance();
			relationshipStats = new Dictionary();
			goalsSeen = new Dictionary();
			initializeStats();
		}
		
		public static function getInstance():StatisticsManager {
			return _instance;
		}
		
		
		public function getNumberOfGoalsSeen():int
		{
			var len:int = 0;
			for each (var item:* in this.goalsSeen)
				if (item != "mx_internal_uid")
					len++;
			return len;
		}
		
		
		/**
		 * This function is to be called when the player has played one round of a social game between
		 * characters.  It handles updating a variety of statistics, such as looking at the effect changes
		 * of the game that was just played, or looking to see who the characters were that played the game.
		 * @param	sgc the social game context of the game that was just played.
		 */
		public function endOfTurnHandler(sgc:SocialGameContext):void {
			var sg:SocialGame = sgLib.getByName(sgc.gameName);

			//Update any statistics that are based on predicates in the effect change of the game that just played.
			for each(var effectChangePredicate:Predicate in sg.getEffectByID(sgc.effectID).change.predicates) {
				switch (effectChangePredicate.type) {
					case Predicate.RELATIONSHIP: 
						relationshipPredicateHandler(effectChangePredicate);
					break;
				}
			}
			
			//Check to see if the main character was involved in the game
			var mainCharacter:String = gameEngine.currentStory.storyLeadCharacter.toLowerCase();
			if (sgc.initiator.toLowerCase() != mainCharacter && sgc.responder.toLowerCase() != mainCharacter) {
				//if the initiator AND the responder was not the main character, then it WAS indirect (we don't care about other--main character can be that and it is still indirect).
				indirectGamesPlayed++;
			}
			
			//Check to see how many games they've played without indirection
			if (indirectGamesPlayed == 0 && cif.time >= NUMBER_OF_NON_INDIRECT_GAMES_BEFORE_REMINDER && !closedTheIndirectGamesPlayedWindow) 
				playedSeveralGamesWithoutIndirection = true;
			else 
				playedSeveralGamesWithoutIndirection = false;
		}
		
		/**
		 * Things that should be 
		 */
		public function endOfLevelHandler():void {
			numberOfLevelsCompleted++;
			
			for (var key:String in relationshipStats) { // k is the key!  The index!
				 switch(key) {
					 case CURRENT_LEVEL_START_DATING_INDEX:
					 case CURRENT_LEVEL_STOP_DATING_INDEX:
					 case CURRENT_LEVEL_START_FRIENDS_INDEX:
					 case CURRENT_LEVEL_STOP_FRIENDS_INDEX:
					 case CURRENT_LEVEL_START_ENEMIES_INDEX:
					 case CURRENT_LEVEL_STOP_ENEMIES_INDEX:
					 relationshipStats[key] = 0; // Zero it out!  Reset the counter!
				 }
			}
		}
		
		public function relationshipPredicateHandler(pred:Predicate):void {
			var negatedString:String = "start";
			var relationshipString:String = "";
			if (pred.negated) negatedString = "stop"; 
			switch(pred.relationship) {
				case RelationshipNetwork.DATING:
					relationshipString = "dating";
					break;
				case RelationshipNetwork.FRIENDS:
					relationshipString = "friends";
					break;
				case RelationshipNetwork.ENEMIES:
					relationshipString = "enemies";
					break;
				default:
					relationshipString = "unrecognizedRelationship"
					break;
			}
			var index:String = negatedString + relationshipString;
			relationshipStats["current"+index] += 1; // increment the 'this turn only' occurence by one.
			relationshipStats[index+"total"] += 1; // increment the total occurences by one
		}
		
		/**
		 * Returns a string that is meant to be stuffed into the text box on the 
		 * level results screen.  Maybe we want the contents of this string to be
		 * based on what we find to be the most interesting!
		 * @return
		 */
		public function createEndOfLevelResultString():String {
			var returnString:String = "";
			//returnString += "Number of friendships started in this level: " + relationshipStats[CURRENT_LEVEL_START_FRIENDS_INDEX];
			//returnString += "\nNumber of friendships ended in this level: " + relationshipStats[CURRENT_LEVEL_STOP_FRIENDS_INDEX];
			//returnString += "\nNumber of relationship started in this level: " + relationshipStats[CURRENT_LEVEL_START_DATING_INDEX];
			//returnString += "\nNumber of relationships ended in this level: " + relationshipStats[CURRENT_LEVEL_STOP_DATING_INDEX];
			//returnString += "\nPairs of enemies forged in this level: " + relationshipStats[CURRENT_LEVEL_START_ENEMIES_INDEX];
			//returnString += "\nNumber of olive branches accepted in this level: " + relationshipStats[CURRENT_LEVEL_STOP_ENEMIES_INDEX];
			
			returnString += "\nNumber of friendships started this week: " + relationshipStats[TOTAL_START_FRIENDS_INDEX];
			returnString += "\nNumber of friendships ended this week: " + relationshipStats[TOTAL_STOP_FRIENDS_INDEX];
			returnString += "\nNumber of relationship started this week: " + relationshipStats[TOTAL_START_DATING_INDEX];
			returnString += "\nNumber of relationships ended this week: " + relationshipStats[TOTAL_STOP_DATING_INDEX];
			returnString += "\nPairs of enemies forged this week: " + relationshipStats[TOTAL_START_ENEMIES_INDEX];
			returnString += "\nNumber of olive branches accepted this week: " + relationshipStats[TOTAL_STOP_ENEMIES_INDEX];
			
			return returnString;
		}
		
		/**
		 * In 'real life' we will probably populate these things by looking in a database
		 * based on their player ID.  For now, lets just set everything to 0, or some other equally
		 * hard-coded value!
		 */
		public function initializeStats():void {
			relationshipStats[CURRENT_LEVEL_START_FRIENDS_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_FRIENDS_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_START_DATING_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_DATING_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_START_ENEMIES_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_ENEMIES_INDEX] = 0;
			
			relationshipStats[TOTAL_START_FRIENDS_INDEX] = 0;
			relationshipStats[TOTAL_STOP_FRIENDS_INDEX] = 0;
			relationshipStats[TOTAL_START_DATING_INDEX] = 0;
			relationshipStats[TOTAL_STOP_DATING_INDEX] = 0;
			relationshipStats[TOTAL_START_ENEMIES_INDEX] = 0;
			relationshipStats[TOTAL_STOP_ENEMIES_INDEX] = 0;
			
			numberOfLevelsCompleted = 0;
			indirectGamesPlayed = 0;
			playedSeveralGamesWithoutIndirection = false;
			closedTheIndirectGamesPlayedWindow = false;
			
			for each(var story:Story in gameEngine.stories) {
				var storyString:String = story.storyLeadCharacter + "-" + story.title;
				if (story.islocked) {
					campaignsUnlocked[storyString] = false;
				}
				else {
					campaignsUnlocked[storyString] = true;
				}
			}
			
		}
		
		/**
		 * Resets the stats used for the end-of-story display.
		 */
		public function resetRelationshipStats():void {
			relationshipStats[CURRENT_LEVEL_START_FRIENDS_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_FRIENDS_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_START_DATING_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_DATING_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_START_ENEMIES_INDEX] = 0;
			relationshipStats[CURRENT_LEVEL_STOP_ENEMIES_INDEX] = 0;
			
			relationshipStats[TOTAL_START_FRIENDS_INDEX] = 0;
			relationshipStats[TOTAL_STOP_FRIENDS_INDEX] = 0;
			relationshipStats[TOTAL_START_DATING_INDEX] = 0;
			relationshipStats[TOTAL_STOP_DATING_INDEX] = 0;
			relationshipStats[TOTAL_START_ENEMIES_INDEX] = 0;
			relationshipStats[TOTAL_STOP_ENEMIES_INDEX] = 0;
		}
		
		/**
		 * This function looks at the amount of endings that have been seen, and goes through
		 * every story in the game engine... if the amount of endings seen is greater than or equal
		 * to the number of endings needed to unock the campaign, 'unlock' the campaign in the 
		 * dictionary.
		 */
		public function unlockCampaigns():void {
			//First, get the number of endings seen.
			var endings:int = 0;
			var goals:int = 0;
			for each(var didWeSeeIt:Boolean in endingsSeen) {
				if (didWeSeeIt) endings++;
			}
			
			for each(didWeSeeIt in this.goalsSeen) {
				if (didWeSeeIt) goals++;
			}
			
			//OK, now we want to go through all of the stories and see the pre-requisite number of endings needed to get it.
			for each(var story:Story in gameEngine.stories) {
				if (story.islocked) { // only bother if it is a 'locked' story
					if (!this.campaignsUnlocked[story.storyLeadCharacter +"-" + story.title]) { // only bother if we HAVEN'T already unlocked it
						if (goals >= story.toUnlock) {
							// Great!  Unlock this sucker!
							this.campaignsUnlocked[story.storyLeadCharacter + "-" + story.title] = true;
							//Utility.log(this, "unlockCampaigns() unlocking story: " + story.storyLeadCharacter + "-" + story.title)
						}
					}
				}
			}
			
			
			
		}
		
		/**
		 * Takes the XML returned from the backend and unlocks the appriopriate dictionary entries
		 * in this.goalsSeen. This should be called and processed before we get to the story selection
		 * screen.
		 * @param	goalsUnlocked XML from the backend in the following form:
		 * 	<user>
			  <uuid>TEST_ID</uuid>
			  <goal>Doug-Big Buddy Doug</goal>
			  <goal>Doug-Kinda Mean Dude</goal>
			  <goal>Doug-Last Minute Date</goal>
			  <goal>Doug-Super Nice Guy</goal>
			</user>
		 */
		public function unlockGoalsFromXML(goalsUnlocked:XML):void {
			if (!this.goalsSeen)
				this.goalsSeen = new Dictionary();
				
			var goalsInXML:Dictionary = new Dictionary();
			
			for each(var goalXML:XML in goalsUnlocked..goal) {
				goalsInXML[goalXML.toString()] = true;
			}
			
			for (var key:String in this.goalsSeen) {
				//if the goal is in the local storage and not in the xml, we need to send it to the server
				if (!goalsInXML[key]) {
					gameEngine.getBackend().sendGoalSeen(null, key);
				}
			}
			
			for each(goalXML in goalsUnlocked..goal) {
				this.goalsSeen[goalXML.toString()] = true
				//Utility.log(this, "unlockGoalsFromXML() unlocking goal: " + goalXML.toString())
			}
			
			//if the goal is in the XML (aka on the server) and not stored locally, we're good
			
			//OK--let's make sure we update the goals completed text here!
			gameEngine.hudGroup.storySelectionScreen.updateGoalsSeenText();
			this.unlockCampaigns()
		}
		
	}
	


}