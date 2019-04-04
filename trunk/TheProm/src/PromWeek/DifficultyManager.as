package PromWeek 
{
	
	import CiF.Cast;
	import CiF.Character;
	import CiF.Debug;
	import CiF.GameScore;
	import CiF.RelationshipNetwork;
	import CiF.Rule;
	import CiF.SocialFactsDB;
	import CiF.SocialGame;
	import flash.utils.Dictionary;
	import CiF.SocialGameContext;
	import CiF.Predicate;
	import CiF.CiFSingleton;
	import flashx.textLayout.utils.CharacterUtil;
	
	/**
	 * ...
	 * @author Ben*
	 * 
	 * This is a file meant to create a singleton -- the 'difficultyManager' singleton -- that will
	 * keep track and govern all relevant information about the current difficulty level.
	 * 
	 * In it's original conception, we have the following vision for what difficulty will be:
	 * 
	 * There will be 4 difficulty levels: Easy, Medium, Hard, and Expert.
	 * 
	 * Hard will be what the game 'actually' is, i.e. the charater's volitions and based entirely on 
	 * what CiF states they should be.
	 * 
	 * Easy and Medium will have modifiers that will assist the player accomplish various goals.  These
	 * modifiers can influence a variety of gameplay features, including how many juice points received
	 * after a social game, the 'line' that separates an accept from a reject (i.e. hard mode is '0', but 
	 * in easier modes it may be -5 to encourage characters to generally accept things), or could even
	 * involve reasoning over the social game and seeing if it helps accomplish one of the campaign goals
	 * (and increasing the probability of it succeeding, lending some procedural power to the metaphor of
	 * the characters themselves actually WANT to be accomplishing these things).
	 * 
	 * Expert is much like Easy and Medium, but it makes life MORE difficult for the player.  This will
	 * undoubtedly lead to additional fun.
	 */
	public class DifficultyManager
	{
		
		private static var _instance:DifficultyManager = new DifficultyManager();
		private var gameEngine:GameEngine;
		private var cif:CiFSingleton;
		
		// this number needs to be set in juiceBar!
		
		public const EASY_ID:int = 1;
		public const MEDIUM_ID:int = 2;
		public const HARD_ID:int = 3;
		public const EXPERT_ID:int = 4;
		
		//volitionThresholds!
		private const EASY_INITIATOR_VOLITION_THRESHOLD:int = -10;
		private const MEDIUM_INITIATOR_VOLITION_THRESHOLD:int = -5;
		private const HARD_INITIATOR_VOLITION_THRESHOLD:int = 0;
		private const EXPERT_INITIATOR_VOLITION_THRESHOLD:int = 5;
		
		private const EASY_RESPONDR_VOLITION_THRESHOLD:int = -10;
		private const MEDIUM_RESPONDER_VOLITION_THRESHOLD:int = -5;
		private const HARD_RESPONDER_VOLITION_THRESHOLD:int = 0;
		private const EXPERT_RESPONDER_VOLITION_THRESHOLD:int = 5;
		
		//Boosts for Initiator Volitions
		//The story lead will get a boost to playing games WITH specific people that accomplish goals.
		//The amount by which they are boosted depends on the mode.
		private const EASY_INITIATOR_GOAL_BOOST:int = 15;
		private const MEDIUM_INITIATOR_GOAL_BOOST:int = 5;
		private const HARD_INITIATOR_GOAL_BOOST:int = 0;
		private const EXPERT_INITIATOR_GOAL_BOOST:int = -5;
		
		//Initiator Boost Multiplier
		//If there are certain things coming into play (for example, you have to date someone popular
		//you get a Bonus to initiating a date with someone who is popular, more so than if they are just some normal non-popular person.
		//this multiplier is PER thing (i.e. if you have to be friends, enemies, and dating the same person, if there is someone who you are
		//friends with, you get a .5 bonus to become either enemies or dating with that person, but if you are friends AND dating them, then you get a 
		//1 times bonus.
		private const EASY_INITIATOR_GOAL_BOOST_MULTIPLIER:Number = 0.5;
		private const MEDIUM_INITIATOR_GOAL_BOOST_MULTIPLIER:Number = 0.25;
		private const HARD_INITIATOR_GOAL_BOOST_MULTIPLIER:Number = 0.0;
		private const EXPERT_INITIATOR_GOAL_BOOST_MULTIPLIER:Number = 0.0;
		
		//Boosts for Responder Volitions
		//If it is a game that the story lead character WANTS to play with someone else to satisfy a goal (e.g. date someone popular)
		//give the responder a little bit of a boost to make them more likely to accept.
		//Note that this is in addition to the responder volition thresholds specified above, so if the volition thresholds have gone down a little bit,
		//AND the responder gets this boost to volition, it is as if they are getting a double boost!  Pretty cool, huh?
		private const EASY_RESPONDER_ACCEPT_GOAL_BOOST:int = 10;
		private const MEDIUM_RESPONDER_ACCEPT_GOAL_BOOST:int = 5;
		private const HARD_RESPONDER_ACCEPT_GOAL_BOOST:int = 0;
		private const EXPERT_RESPONDER_ACCEPT_GOAL_BOOST:int = 0;
		
		
		private var toDoItemCompletedWithThisCharacter:Dictionary;
		
		/**
		 * This should have indexing of the form:
			 * inititatorName-responderName-gameName
			 * (where everything is lowercase).
			 * the value that is stored here should be the amount that the game should be boosted by.
		 */
		private var responderBoostForInitResponderPair:Dictionary;
		
		private var currentDifficulty:int;
		
		public var easyDescription:String = "Characters are very enthusiastic to accomplish campaign goals, and the Social Influence Points flow like juice.";
		public var mediumDescription:String = "Characters get a small boost to any exchange that would accomplish a campaign goal, and Social Influence Points are plentiful.";
		public var hardDescription:String = "This is TRUE SOCIAL PHYSICS mode! Character behavior is based solely on the social state, with no adjustments made for campaign goals!";
		public var expertDescription:String = "Oh those surly teenagers... Characters are generally more likely to reject intents, and Social Influence Points are hard to come by. Good luck!  Have fun!";
		
		public function DifficultyManager() 
		{
			gameEngine = GameEngine.getInstance();
			cif = CiFSingleton.getInstance();
			currentDifficulty = HARD_ID;
		}
		
		public static function getInstance():DifficultyManager {
			return _instance;
		}
		
		/**
		 * This function is meant to be called after intent has been computed (i.e. every character knows
		 * what games they want to play with every other character).  It looks at who the story lead chaaracter
		 * is (which is stored in gameEngine), and goes through all of the games that that person wants to play
		 * with every other person, and it gives the game a boost if it would help accomplish a goal
		 * (for example, if you have the goal of dating monica, any dating games towards monica are going to
		 * get a boost)
		 * 
		 * Note how this is DIFFERENT than adjusting whether or not the responder is going to accept the advances or not.
		 * This is only adjusting the games the initiator wants to play in the first place.  Another function will be done
		 * that adjusts the responder's accept or reject of the intent based on difficulty.
		 */
		public function encourageStoryLeadCharacterToAccomplishGoalsBasedOnDifficulty():void {
			//Ok, so, how to do this.
			//I think we want to do this:
			//Loop throgh the story lead character's prospective memory.
			var leadName:String = gameEngine.currentStory.storyLeadCharacter;
			var leadCharacter:Character = cif.cast.getCharByName(leadName);
			
			//Debug.debug(this, "----------------------------------");
			//Debug.debug(this, "lead character's prospective memory:");
			//Debug.debug(this, leadCharacter.prospectiveMemory);
			
			//Ok, great, so now we HAVE the lead character's prospective memory.
			//Let's loop through it and adjust some of the score values!
			//These score values will get boosts if they are for games that help accomplish goals.
			//And they get bigger boosts the more specific they are.
			//So, for example, if the rule is "just dating someone", then they would get a small boost to play dating games.
			//If it is "dating Monica", then maybe ONLY you would get a boost to dating Monica (traits == definites??? NAMES == definites... yeah)
			//If it is "dating someone popular", then all dating games get a boost, but if the person is popular than you get a bonus boost.
			
			//ALSO -- maybe connected to this, maybe a separate thing, is keeping track of who you are CLOSEST to completing
			//certain goals with, e.g. in Oswald's 'it's complicated', see if you are already friends and enemies with someon (like Nicholas)
			//and then that gives you a bigger boost to wanting to complete the dating part of the goal with him.
			//Maybe only applies to "they are the same someone" rules?
			//the way taht 'they are the same someone' works I think *will* be useful for this, but is a little less straight forward
			//then I would like... essentially, anything that refers to responders OR others in rules have to be consistent,
			//UNLESS they are responders/others inside of a numTimesUniquelyTrue predicate, in which case they are ignored,
			//UNLESS UNLESS the numTimesRoleSlot is 'both'.
			//Still, as a first pass, I think checking to see if it is a 'they are the same someone', and if it is, maybe running
			//the current potential canidate through all the rules and seeing how many of them they satisfy?
			
			//Uhh, why is "Delcare War" returning NaN?
			
			//First, let's see how good of a job we do just identifying which games need to get a boost based on something simple (say, intents).
			//Let's do this via looping through the todolist.
			toDoItemCompletedWithThisCharacter = new Dictionary();
			responderBoostForInitResponderPair = new Dictionary(); // for storing responder boosts.
			for each(var toDoItem:ToDoItem in gameEngine.currentStory.todoList) {

				if (toDoItem.evaluateCondition()) {
					//OK... if the to do item has already been satisfied, let's NOT waste our time increasing
					//the initiator's desire to do things.
					continue;
				}
				
				//OMG I think this kind of works.
				//This is my makeshift attempt to get a sense as to how MANY of the predicates you satisfy with
				//the current given person.  So, for example, in Oswald's campaign with the "it's complicated", it 
				//successfully stops TWICE here for Nicholas (because he satisfies two predicates, friends and enemies)
				//and ONCE for Lucas (he and Oswals are just enemies).
				//The thought is that this is going to be used to give you EXTRA boosts to do things (i.e. if normally you would get a + 5 boost, maybe you get a +5*3 boost or something.
				//(i.e. you will get an EXTRA boost to volition to date Nicholas, because you are almost completing everything with him already)
				//And also, maybe, since you've alreaady satisfied some of the predicates with him, specifically DON'T boost volition
				//for things like, friending or enemey-ing Nicholas.  Maybe also don't bother doing anything with rules that are
				//already completed as well.
				
				
				var toDoItemIterator:int = 0;
				
				if(toDoItem.hasNeedsToBeTheSamePerson){
					for each(var tempToDoPred:Predicate in toDoItem.condition.predicates) {
						if(tempToDoPred.primary == "responder" || tempToDoPred.secondary == "responder" || tempToDoPred.primary == "other" || tempToDoPred.second == "other"){
							for each(var otherChar:Character in gameEngine.currentLevel.cast) {
								if(otherChar.characterName.toLowerCase() != gameEngine.currentStory.storyLeadCharacter.toLowerCase()){
									if (tempToDoPred.evaluate( cif.cast.getCharByName(gameEngine.currentStory.storyLeadCharacter), otherChar, otherChar)) {
										//if (toDoItem.name.toLowerCase() == "it's complicated"){
											//Debug.debug(this, "Ok, hey, well, at least we got here once, at least, right?");
											toDoItemCompletedWithThisCharacter[otherChar.characterName.toLowerCase() + "-" + toDoItem.name + "-" + toDoItemIterator] = true;
										//}
									}
									else {
										toDoItemCompletedWithThisCharacter[otherChar.characterName.toLowerCase() + "-" + toDoItemIterator] = false;
									}
								}
							}
						}
						toDoItemIterator++;
					}
				}
				
				
				//WHY DOES EDWARD GET A BOOST FOR BREAKING UP WITH MAVE IN THE BRIGHT SIDE!?!?
				//I think this might be the ONLY THING THAT IS A PROBLEM MAYBE!!!!!!
				//MAYBEEEEEE
				
				toDoItemIterator = 0;
				for each(var toDoPred:Predicate in toDoItem.condition.predicates) {
					//Debug.debug(this, "Ok, this is the value of the toDoPredicate we're looking at");
					
					//we are only going to give boosts to things that involve the story lead character
					//e.g. Lil's "Emo Angel" (get Lucas and Phoebe to date) DOESN'T get a boost to volition because it doesn't involve Lil.
					var shouldGetABoost:Boolean = false; // used to help us determine whether or not we should bother giving anything a boost based on this predicate.
					if (toDoPred.primary.toLowerCase() == "initiator") shouldGetABoost = true; // if the primary person is the story lead character, give a boost
					if (toDoPred.primary.toLowerCase() == leadName.toLowerCase()) shouldGetABoost = true; // if the primary person is the story lead character, give a boost
					if (toDoPred.secondary.toLowerCase() == "initiator") shouldGetABoost = true; // if the secondary person is the story lead character, give a boost
					if (toDoPred.second.toLowerCase() == leadName.toLowerCase()) shouldGetABoost = true; // if the secondary person is the story lead character, give a boost
					
					if (!shouldGetABoost) continue;
					//Ok, here we are looping through each predicate of every to do item. Great!
					//Now we want to loop through all social games and see if there is a 'match' and if so, give the social game a boost.
					//Where 'match' means that playing that social game is likely to assist you in accomplishing a story goal.
					for each(var gameScore:GameScore in leadCharacter.prospectiveMemory.scores) {
						if (gameScore.score == -100) continue; // this means that preconditions didn't match up. Don't let them do it! Just skip it!
						//Debug.debug(this, "New game score. Initiator: " + gameScore.initiator + " Responder: " + gameScore.responder + " game is: " + gameScore.name + " score is: " + gameScore.score);
						
						var currentSocialGame:SocialGame = cif.socialGamesLib.getByName(gameScore.name);
						for each(var intentRule:Rule in currentSocialGame.intents) { // probably only one intent rule, but I think you have to do the loop anwyay.
							for each( var intentPred:Predicate in intentRule.predicates) {
								//OK, so now we are looking at the intent predicates of the social game.
								//Let's switch case this bad boy up, and use that to determine whether it should get a boost based on the current to-do item!
								switch(intentPred.getIntentType()) {
									
									case Predicate.INTENT_FRIENDS:
										//Debug.debug(this, "Intent start friends! Is that true? the social game is: " + currentSocialGame.name);
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.NICE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.CAT_POSITIVE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);										}
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.FRIENDS)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										
										break;
									case Predicate.INTENT_END_FRIENDS:
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.FRIENDS, true)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.CAT_NEGATIVE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_DATING:
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.DATING)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_END_DATING:
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.DATING, true)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_ENEMIES:
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.ENEMIES)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.CAT_NEGATIVE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_END_ENEMIES:
										if (checkRelationshipMatch(toDoPred, gameScore.responder, RelationshipNetwork.ENEMIES, true)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_BUDDY_UP:
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.NICE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.CAT_POSITIVE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_BUDDY_DOWN:
										if (checkSFDBLabelMatch(toDoPred, gameScore.responder, SocialFactsDB.CAT_NEGATIVE)) {
											boostGameScore(gameScore, currentSocialGame, toDoItem, toDoItemIterator);
										}
										break;
									case Predicate.INTENT_ROMANCE_UP:
										//Debug.debug(this, "Intent romance up! Is that true? the social game is: " + currentSocialGame.name);
										break;
									case Predicate.INTENT_ROMANCE_DOWN:
										//Debug.debug(this, "Intent romance down! Is that true? the social game is: " + currentSocialGame.name);
										break;
									case Predicate.INTENT_COOL_UP:
										//Debug.debug(this, "Intent romance up! Is that true? the social game is: " + currentSocialGame.name);
										break;
									case Predicate.INTENT_COOL_DOWN:
										//Debug.debug(this, "Intent romance down! Is that true? the social game is: " + currentSocialGame.name);
										break;
									default:
										//Debug.debug(this, "haven't defined this intent type yet. Is that good: " + currentSocialGame.name);
										break;
								}
							}
						}
					}
					toDoItemIterator++;
				}
			}
		}
		
		/**
		 * If we've successfully discovered a gamescore that should get a 'boost' (because it matches a story lead character and a responder
		 * that is relevant to some goal), this function handles what that boost should be.
		 * @param	gameScore the gameScore that represents the game from the initiator to the responder that we care about.
		 * @param	sg the socialGame representation of the game specified by the gameScore
		 * @param	toDoItem the relevant toDoItem that is encouraging us to give this game a boost.
		 */
		private function boostGameScore(gameScore:GameScore, sg:SocialGame, toDoItem:ToDoItem, toDoItemIterator:int):void {
			//Only do this check if the to-do item has the needs for same person.
			//Otherwise assume that you give things boosts as normal.
			var amountOfOtherPredicatesWhichAreTrue:int = 0;
				var debugString:String = "MATCH! The game was " + sg.name + " from " + gameScore.initiator + " to " + gameScore.responder 
				+ " and the toDoItem was " + toDoItem.name + " (intent was " + Predicate.getIntentNameByNumber(sg.intents[0].predicates[0].getIntentType()) + ")";
			if(toDoItem.hasNeedsToBeTheSamePerson){
				if (toDoItemCompletedWithThisCharacter[gameScore.responder.toLowerCase() + "-" + toDoItem.name + "-" + toDoItemIterator]) {
					//Debug.debug(this, "OK! I believe that this specific goal was already completed with this specific other character! Don't give them a boost! game was " + gameScore.name);
					//Debug.debug(this, "ALREADY SATISFIED. to do item: " + toDoItem.name + " responder: " + gameScore.responder + " iterator is: " + toDoItemIterator);
					debugString += " NOT BOOSTED.";
					//Debug.debug(this, debugString);
					return;
				}
				else {
					//Debug.debug(this, "NOT SATISFIED. to do item: " + toDoItem.name + " responder: " + gameScore.responder + " iterator is: " + toDoItemIterator);
					//Debug.debug(this, "OK! I believe that this specific predicate is NOT satisfied! We need to look AT the dictionary to tally up the other predicates that this person has made to get a sense as to how much progress has been made on THIS goal with THIS 'responder' game was " + gameScore.name);
					debugString += " BOOST!";
					//**THIS is not quite working yet. Um. I don't know why. check the 'getnumberofpredicates..." function.
					amountOfOtherPredicatesWhichAreTrue = getNumberOfPredicatesInToDoItemThatAreTrue(gameScore, toDoItem);
					debugString += " -- number of other predicates which are true: " + amountOfOtherPredicatesWhichAreTrue + " -- ";
				}
			}
			else { // boost things as normal!
				debugString += " NORMAL BOOST";
				//Debug.debug(this, debugString );
			}
			
			debugString += " toDoItemIterator: " + toDoItemIterator;
			var initBoost:int = calculateInitiatorBoost(amountOfOtherPredicatesWhichAreTrue);
			
			//Used to index the responder boost dictionary.
			var responderBoostDictionaryIndexString:String = gameScore.initiator.toLowerCase() + "-" + gameScore.responder.toLowerCase() + "-" + gameScore.name.toLowerCase();
			var responderBoost:int = getResponderBoost();
			responderBoostForInitResponderPair[responderBoostDictionaryIndexString] = responderBoost;
			
			
			//OK -- when I next come back, uncomment the code that allows you to change your difficulty setting!!!
			//OK, like, a month later, I did that! Now I need to figure out how to actually change the 
			//value of the intents, I believe... I think I need to change something in prospective memory!
			//Maybe it is just as easy as changing the value of the 'score' field inside of the game score?
			
			debugString += " init boost: " + initBoost + " responderBoost: " + responderBoost + " currentDifficulty: " + difficultyToString() + " gameScorePreBoost: " + gameScore.score + " gameScorePostBoost: " + (gameScore.score + initBoost);
			gameScore.score += initBoost;
			
			
			//Debug.debug(this, debugString);
			

		}
		
		//Maybe want to change this to a PERCENTAGE instead of a straight up number.
		private function getNumberOfPredicatesInToDoItemThatAreTrue(gs:GameScore, toDoItem:ToDoItem):int {
			var trueCount:int = 0;
			for (var i:int = 0; i < toDoItem.condition.predicates.length; i++) {
				if (toDoItemCompletedWithThisCharacter[gs.responder.toLowerCase() + "-" + toDoItem.name + "-" + i]) {
					trueCount++;
				}
			}
			return trueCount;
		}
		
		/**
		 * This function calculates how much we should boost the initior's desire to play a certain social game.
		 * It assumes that other functions have already done the heavy lifting of discovering WHICH game we are looking at
		 * and WHO we are playing it with, and HOW many other predicates in a toDoItem are true, and all this does is 
		 * some simple math to discover the multipler, and the base boosting amount, and multiples the two numbers together.
		 * @param	amountOfTruePredicates An assumption that this function makes is that we've already discovered an interesting toDoItem that potentially has OTHER parts of it satisfied, which makes the desire to satisfy THIS part of it all the greater.
		 * @return the amount that we should increase the character's volition to play a social game.
		 */
		private function calculateInitiatorBoost(amountOfTruePredicates:int = 0):Number {
			var multipler:Number = getMultiplier(amountOfTruePredicates);
			var baseBoost:int = 0;
			switch(currentDifficulty) {
				case EASY_ID: baseBoost = EASY_INITIATOR_GOAL_BOOST; break;
				case MEDIUM_ID: baseBoost = MEDIUM_INITIATOR_GOAL_BOOST; break;
				case HARD_ID: baseBoost = HARD_INITIATOR_GOAL_BOOST; break;
				case EXPERT_ID: baseBoost = EXPERT_INITIATOR_GOAL_BOOST; break;
				default: baseBoost = 0;
			}
			
			return Math.floor(baseBoost * multipler);
			
		}
		
		/**
		 * This is a simple function that returns the value of the initiator goal boost, based on the
		 * current difficulty
		 * @return the value of the initiator goal boost.
		 */
		private function getInitaitorGoalBoost():Number {
			switch(currentDifficulty) {
				case EASY_ID: return EASY_INITIATOR_GOAL_BOOST;
				case MEDIUM_ID: return MEDIUM_INITIATOR_GOAL_BOOST;
				case HARD_ID: return HARD_INITIATOR_GOAL_BOOST;
				case EXPERT_ID: return EXPERT_INITIATOR_GOAL_BOOST;
				default: return 0;
			}
		}
		
		/**
		 * Simply returns the amount that the responder is going to get a boost to their score to accept a social game which
		 * is going to satisfy a story goal, by looking at what the current difficulty is and returning the appropriate value.
		 * @return the amount to boost the responder's score
		 */
		private function getResponderBoost():Number {
			var returnValue:int = 0;
			switch(currentDifficulty) {
				case EASY_ID: returnValue = EASY_RESPONDER_ACCEPT_GOAL_BOOST; break;
				case MEDIUM_ID: returnValue = MEDIUM_RESPONDER_ACCEPT_GOAL_BOOST; break;
				case HARD_ID: returnValue = HARD_RESPONDER_ACCEPT_GOAL_BOOST; break;
				case EXPERT_ID: returnValue = EXPERT_RESPONDER_ACCEPT_GOAL_BOOST; break;
				default: returnValue = 0;
			}
			return returnValue;
		}
		
		public function getResponderBoostFromDictionary(init:String, responder:String, gameName:String):int {
			return responderBoostForInitResponderPair[init.toLowerCase() + "-" + responder.toLowerCase() + "-" + gameName.toLowerCase()];
		}
		
		/**
		 * Given the 'amount of true predicates' from a toDoItem (i.e. you have to date someone popular, and the person you are looking at IS popular), figure
		 * out how much of a multiplier boost you should get to your volition bonus (i.e. you are going to generally want to date everyone more, but you are
		 * especially going to want to date popular people more!)
		 * @param	amountOfTruePredicates the number of predicates (asssuming it came fro a toDoItem) that are true.
		 * @return the multiplier to use on the 'base initiator goal boost'
		 */
		private function getMultiplier(amountOfTruePredicates:int):Number {
			//amount of true predicates will likely range from 0 to 2.
			var amountToMultiplyBy:Number;
			switch(currentDifficulty) {
				case EASY_ID: amountToMultiplyBy = EASY_INITIATOR_GOAL_BOOST_MULTIPLIER; break;
				case MEDIUM_ID: amountToMultiplyBy = MEDIUM_INITIATOR_GOAL_BOOST_MULTIPLIER; break;
				case HARD_ID: amountToMultiplyBy = HARD_INITIATOR_GOAL_BOOST_MULTIPLIER; break;
				case EXPERT_ID: amountToMultiplyBy = EXPERT_INITIATOR_GOAL_BOOST_MULTIPLIER; break;
				default: amountToMultiplyBy = HARD_INITIATOR_GOAL_BOOST_MULTIPLIER; break;
			}
			
			//At the very least, we want the multiplier to be one
			//But then also multiply by the number of true predicates.
			//(might have to re-evalute this if we go from a strict number of 'amountOfTruePredicates' to
			//the ratio of the number of true predicates in the toDo item over the total number of predicates in teh to do item).
			return (1 + amountOfTruePredicates * amountToMultiplyBy);
			
		}
		
		/**
		 * 
		 * Just a small helper function to see if a 'to do predicate' (i.e. a predicate that represets a bit of a campaign goal
		 * from a todolist) 'matches' the specified sfdb label.  If the to do predicate isn't an SFDBLabel type, then it returns false.
		 * It will also return false if there the requested sfdblabel is NOT the type of label that actually lives inside of the 
		 * to do pred.
		 * 
		 * @param	toDoPredicate a predicate that represents a part of a task that must be accomplished for a goal
		 * @param	sfdbLabel a number representing an sfdb label, using constants from CiF.SocialFactsDB (e.g. SocialFactsDB.NICE)
		 * @return  true if the specified sfdb label matches.  False if it does not match, or the To Do Predicate is not of type SFDBLabel.
		 */
		private function checkSFDBLabelMatch(toDoPred:Predicate, responder:String, sfdbLabel:Number):Boolean {
			//Debug.debug(this, "inside of sfdb label match..");
			
			//This might be overly naive, BUT...
			//
			if (toDoPred.second.toLowerCase() == "other" || toDoPred.second.toLowerCase() == "responder" || toDoPred.second == "") {  } // don't do anything
			else if (toDoPred.second.toLowerCase() != responder.toLowerCase()) return false; // wanted a specific person, but got the wrong specific person.
			
			if (toDoPred.type == Predicate.SFDBLABEL) {
				if (toDoPred.sfdbLabel == sfdbLabel) {
					//Debug.debug(this, "We have an SFDB predicate match! sfdb that was matched was: " + SocialFactsDB.getLabelByNumber(sfdbLabel));
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * Just a small helper function to see if a 'to do predicate' (i.e. a predicate that represets a bit of a campaign goal
		 * from a todolist) 'matches' the specified relationship.  If the to do predicate isn't a relationship type, then it returns false.
		 * It will also return false if there the requested relationship is NOT the type of label that actually lives inside of the 
		 * to do pred.
		 * 
		 * @param	toDoPredicate a predicate that represents a part of a task that must be accomplished for a goal
		 * @param	relationship a number representing a relationship, using constants from CiF.RelationshipNetwork (e.g. SocialFactsDB.DATING)
		 * @return  true if the specified relationship matches.  False if it does not match, or the To Do Predicate is not of type Relationship.
		 */
		private function checkRelationshipMatch(toDoPred:Predicate, responder:String, relationship:Number, isEndingRelationship:Boolean=false):Boolean {
			//Debug.debug(this, "inside of relationship match...");
			
			//This might be overly naive, BUT...
			//
			if (toDoPred.second.toLowerCase() == "other" || toDoPred.second.toLowerCase() == "responder") { } // don't do anything
			else if (toDoPred.second.toLowerCase() != responder.toLowerCase()) return false; // wanted a specific person, but got the wrong specific person.
			
			if (toDoPred.type == Predicate.RELATIONSHIP) {
				if (toDoPred.relationship == relationship) {
					//Debug.debug(this, "We have an Relationship Predicate match! relationship that was matched was: " + RelationshipNetwork.getRelationshipNameByNumber(relationship));
					if (isEndingRelationship) { // we need to so some additional logic here to make sure that we capture situations where we are trying to END relationships.
						if (toDoPred.negated) return true; // if the predicate is 'negated' then this is a situation where we want to return true.
						if (toDoPred.numTimesUniquelyTrueFlag && toDoPred.numTimesUniquelyTrue == 1) return false; // this is a situation where you want to have 0 friends.
						return false;
					}
					else {
						if(!toDoPred.negated)
							return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * adjustDifficulty takes in the id value of what the new difficulty 
		 * should be, and changes the value of the difficulty manager's 
		 * current difficulty level accordingly. Also creates a difficulty
		 * context and stores it in the SFDB.
		 * @param	newDifficulty the new value of the difficulty.  For example, if EASY_ID is passed in, the game will now be set to easy mode.
		 * 
		 */
		public function setDifficulty(newDifficulty:int):void {
			var oldDifficulty:int = currentDifficulty;
			currentDifficulty = newDifficulty;
			createDifficultyContext(oldDifficulty);
			gameEngine.hudGroup.difficultySelectionMenu.unofficialDifficulty = newDifficulty;
			Debug.debug(this, "DifficultyManager --> adjustDifficulty() adjusting difficulty to: " + this.difficultyToString());
		}
		
		/**
		 * Creates a difficulty context, and inserts it into the SFDB.
		 */
		public function createDifficultyContext(oldDifficulty:int=-1):void {
			var difficultyContext:DifficultyContext = new DifficultyContext();
			difficultyContext.oldDifficultyID = oldDifficulty;
			difficultyContext.newDifficultyID = currentDifficulty;
			difficultyContext.newInitiatorVolitionThreshold = getVolitionThreshold("initiator");
			difficultyContext.newResponderVolitionThreshold = getVolitionThreshold("responder");
			difficultyContext.newInitiatorGoalBoost = getInitaitorGoalBoost();
			difficultyContext.newInitiatorGoalBoostMultiplier = (getMultiplier(0))
			difficultyContext.newResponderAcceptGoalBoost = getResponderBoost();
			difficultyContext.time = cif.time;
			
			cif.sfdb.addContext(difficultyContext);
			//Debug.debug(this, "Here is what the SFDB looks like: " + cif.sfdb.toXMLString());
		}
		
		/**
		 * returns the value of current difficulty.
		 */
		public function getDifficulty():int {
			return currentDifficulty;
		}
		
		/**
		 * Looks at the value of currentDifficulty, and returns a new volition threshold based on the result.
		 * Generally speaking, if the difficulty is EASIER this number will be LOWER (working under the assumption
		 * that generally speaking life is easier when people accept your intents, and we are LOWERING the bar
		 * of entry for intent acceptance), and will be HIGHER with HARDER difficulties.
		 * @param responderOrInitiator if 'initiator', then we are dealing with the initiator's intent to play a social game. If 'responder', then this is the responders volition to accept a social game. No other values return valid results.
		 * @return
		 */
		public function getVolitionThreshold(responderOrInitiator:String):int {
			var isInitiator:Boolean;
			if (responderOrInitiator.toLowerCase() == "initiator") isInitiator = true;
			else if (responderOrInitiator.toLowerCase() == "responder") isInitiator = false;
			else {
				Debug.debug(this, "getVolitionThreshold() unrecognized type passed in! Only 'responder' or 'initiator' are acceptable values");
				return HARD_INITIATOR_VOLITION_THRESHOLD;
			}
			switch(currentDifficulty) {
				case EASY_ID:
					if(isInitiator) return EASY_INITIATOR_VOLITION_THRESHOLD;
					else return EASY_RESPONDR_VOLITION_THRESHOLD
					break;
				case MEDIUM_ID:
					if (isInitiator) return MEDIUM_INITIATOR_VOLITION_THRESHOLD;
					else return MEDIUM_RESPONDER_VOLITION_THRESHOLD
					break;
				case HARD_ID:
					if (isInitiator) return HARD_INITIATOR_VOLITION_THRESHOLD;
					else return HARD_RESPONDER_VOLITION_THRESHOLD
					break;
				case EXPERT_ID:
					if (isInitiator) return EXPERT_INITIATOR_VOLITION_THRESHOLD;
					else return EXPERT_RESPONDER_VOLITION_THRESHOLD
					break;
				default:
					Debug.debug(this, "adjustVolitionThreshold() unrecognized current difficulty!");
					if (isInitiator) return HARD_INITIATOR_VOLITION_THRESHOLD;
					else return HARD_RESPONDER_VOLITION_THRESHOLD
					break;
			}
		}
		
		/**
		 * Looks at the value of currentDifficulty and returns a string version
		 * of the difficulty level (e.g. easy, medium, hard, etc.)
		 * @return A string version of the difficulty.
		 */
		public function difficultyToString():String {
			switch(currentDifficulty) {
				case EASY_ID:
					return "easy";
					break;
				case MEDIUM_ID:
					return "medium";
					break;
				case HARD_ID:
					return "hard";
					break;
				case EXPERT_ID:
					return "expert";
					break;
				default:
					return "unrecognized difficulty!"
					break;
			}
		}
	}

}