package PromWeek 
{
	
	import CiF.Debug;
	import flash.utils.Dictionary;
	import CiF.SocialGameContext;
	import CiF.Predicate;
	import CiF.CiFSingleton;
	
	/**
	 * ...
	 * @author Ben*
	 * 
	 * YAAAAAHHAAAA!!  It took us a couple years, but after all this time, we've realized that the
	 * ONE TRUE PATH to PROM WEEK PERFECTION doesn't lie in a fancy pants AI system or beautiful, hand drawn art.
	 * The solution is something far more elegant, beautiful, and simple than we could have ever thought possible.
	 * 
	 * It's Juice Points, of course.
	 * 
	 * Juice Points refer to what might typically be called "Magic Points" in other games -- with enough JP accumulated,
	 * the player can cast a variety of magic (juicy) spells.  Things like make characters play games that they normally
	 * wouldn't want to play with each other.  Or make characters accept a game when they would otherwise reject it.
	 * The sky is the limit in terms of what mystical powers Juice Points can give for us!
	 */
	public class JuicePointManager
	{
		
		private static var _instance:JuicePointManager = new JuicePointManager();
		private var gameEngine:GameEngine;
		private var cif:CiFSingleton;
		private var dm:DifficultyManager;
		
		// this number needs to be set in juiceBar!
		public var DEFAULT_INITIAL_JUICE_POINTS:int = 50;
		public var currentJuicePoints:int = DEFAULT_INITIAL_JUICE_POINTS; // The amount of juice points the user currently has.
		public var DEFAULT_JUICEPOINT_INCREMENT_RATE:int = 10;
		public var DEFAULT_JUICEPOINT_DECREMENT_RATE:int = 10;
		public const MAX_JUICE_POINTS:int = 100;
		
		public const HINT_RESPONDER_MOTIVE:int = 1;
		public const HINT_SG_OUTCOME:int = 2;
		public const HINT_FORECAST:int = 3;
		public const HINT_NEW_RESPONDER_REACTION:int = 4;
		
		public const INTENT_SCORE_LOCK_THRESHOLD:int = 10; // shift clicking on a social game.
		
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION:int = 35; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_STRONG:int = 35; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_MEDIUM:int = 25; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_WEAK:int = 20; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_WEAK:int = 15; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_MEDIUM:int = 20; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_STRONG:int = 25; // shift clicking on a social game.
		public const COST_FOR_NON_TOP_SOCIAL_GAME:int = 10; // picking a social game from the drop down menu.
		public const COST_FOR_UNLOCKING_RESPONDER_MOTIVE:int = 15;//note, this used to be 6, but I made it a bunch higher because we give a lot more info now
		public const COST_FOR_UNLOCKING_SG_OUTCOME:int = 15;
		public const COST_FOR_UNLOCKING_FORECAST:int = 5;
		
		public var playedNonTopSG:Boolean = false;
		
		public var unlockedResponderMotives:Dictionary;
		public var unlockedForecasts:Dictionary;
		public var unlockedSGOutcomes:Dictionary;
		public var unlockedOppositeResponderReactions:Dictionary;
		public var unlockedNonTopSocialGames:Dictionary;
		
		public var currentStateOfResponderReaction:Dictionary;
		public var isResponderReactionOpposite:Dictionary;
		
		public function JuicePointManager() 
		{
			gameEngine = GameEngine.getInstance();
			cif = CiFSingleton.getInstance();
			dm = DifficultyManager.getInstance();
			unlockedResponderMotives = new Dictionary();
			unlockedSGOutcomes = new Dictionary();
			unlockedForecasts = new Dictionary();
			unlockedOppositeResponderReactions = new Dictionary();
			currentStateOfResponderReaction = new Dictionary();
			isResponderReactionOpposite = new Dictionary();
			unlockedNonTopSocialGames = new Dictionary();
			
			// init juice bar!
		}
		
		public static function getInstance():JuicePointManager {
			return _instance;
		}
		
		/**
		 * Adds the specified amount of juice points to the player's current juice point total.
		 * if nothing is passed in, it will increment at the rate specified inside of the
		 * JuicePointManager's DEFAULT_JUICEPOINT_INCREMENT_RATE variable
		 * @param	jpToAdd the number of juice points to add
		 */
		public function addJuicePoints(jpToAdd:int = -999):void {
			if (gameEngine.hudGroup.juiceBar.animating) return
			jpToAdd = adjustAddOrSubtractJuicePointsBasedOnDifficulty(jpToAdd, true);
			if (jpToAdd == -999) {
				jpToAdd = DEFAULT_JUICEPOINT_INCREMENT_RATE;
			}
			if (jpToAdd + currentJuicePoints > MAX_JUICE_POINTS) {
				currentJuicePoints = MAX_JUICE_POINTS;
			}
			else {
				currentJuicePoints += jpToAdd; 
			}
			// OLD CODE!
			//gameEngine.hudGroup.currentJuicePointRect.width = getRectangleWidthBasedOnJuicePoints();
			//gameEngine.hudGroup.juiceBar.setCursor(currentJuicePoints);
			//gameEngine.hudGroup.juiceBar.toolTip = "Social Influence Points";
			//gameEngine.hudGroup.juiceBar.toolTip += "(most recent = add, current juice=" + currentJuicePoints + " just added: " + jpToAdd + ")";
			gameEngine.hudGroup.juiceBar.add(jpToAdd)
			gameEngine.hudGroup.topBar.juiceBar.add(jpToAdd)
			
			//Debug.debug(this, "just added: " + jpToAdd + " juicepoints, total is now at: " + currentJuicePoints);
		}
		
		/**
		 * Subtracts the specified amount of juice points to the player's current juice point total.
		 * if nothing is passed in, it will decrement at the rate specified inside of the
		 * JuicePointManager's DEFAULT_JUICEPOINT_DECREMENT_RATE variable
		 * @param	jpToSubtract the number of juice points to subtract
		 */
		public function subtractJuicePoints(jpToSubtract:int = -999):void {
			if (gameEngine.hudGroup.juiceBar.animating) return
			if (jpToSubtract == -999) {
				jpToSubtract = DEFAULT_JUICEPOINT_DECREMENT_RATE;
			}
			if (currentJuicePoints - jpToSubtract < 0) {
				currentJuicePoints = 0
			}
			else {
				currentJuicePoints -= jpToSubtract;
			}
			// OLD CODE!
			//gameEngine.hudGroup.currentJuicePointRect.width = getRectangleWidthBasedOnJuicePoints();
			//gameEngine.hudGroup.juiceBar.setCursor(currentJuicePoints);
			//gameEngine.hudGroup.juiceBar.toolTip = "Social Influence Points";
			//gameEngine.hudGroup.juiceBar.toolTip += "(most recent = subtract, current juice=" + currentJuicePoints + " just subtracted: " + jpToSubtract + ")";
			gameEngine.hudGroup.juiceBar.subtract(jpToSubtract)
			gameEngine.hudGroup.topBar.juiceBar.subtract(jpToSubtract)
			
			//Debug.debug(this, "just removed: " + jpToSubtract + " juicepoints, total is now at: " + currentJuicePoints);
		}
		
		/**
		 * Sets the specified amount of juice points to be the player's current juice point total.
		 * 
		 * @param	jpToAdd the number of juice points to add
		 */
		public function setJuicePoints(newTotal:int):void {
			if (gameEngine.hudGroup.juiceBar.animating) return
			
			
			if (newTotal > currentJuicePoints) {
				gameEngine.hudGroup.juiceBar.add(newTotal - currentJuicePoints);
				gameEngine.hudGroup.topBar.juiceBar.add(newTotal - currentJuicePoints);
			}
			else if (newTotal < currentJuicePoints) {
				gameEngine.hudGroup.juiceBar.subtract(currentJuicePoints - newTotal);
				gameEngine.hudGroup.topBar.juiceBar.subtract(currentJuicePoints - newTotal);
			}
			
			currentJuicePoints = newTotal;
			gameEngine.hudGroup.juiceBar.setCursor(currentJuicePoints);
			gameEngine.hudGroup.topBar.juiceBar.setCursor(currentJuicePoints);
			//gameEngine.hudGroup.juiceBar.toolTip = "Social Influence Points";
			//gameEngine.hudGroup.juiceBar.toolTip += "(most recent = set current juice=" + currentJuicePoints + ")";

			// OLD CODE!
			//gameEngine.hudGroup.currentJuicePointRect.width = getRectangleWidthBasedOnJuicePoints();
			//gameEngine.hudGroup.juiceBar.add(jpToAdd)
			
			//Debug.debug(this, "just added: " + jpToAdd + " juicepoints, total is now at: " + currentJuicePoints);
		}
		
		/**
		 * This function returns how long the width of the rectangle should be
		 * in the hudGroup that represents the amount of juice points the 
		 * user currently possesses.  It will be some function of the 
		 * current juice points.
		 * @return the width to be assigned to the currentJuicePoint Rect inside
		 * of the hudgroup.
		 */
		public function getRectangleWidthBasedOnJuicePoints():int {
			return currentJuicePoints; // it is a simple function for now!  Will undoubtedly need to be more complex later!
		}
		
		/**
		 * unlocks a hint, marking it so that the user doesn't have to pay for it a second time.
		 * @param	initiatorName name of the initiator
		 * @param	responderName name of the responder
		 * @param	socialGameName name of the social game.
		 */
		public function unlockHint(initiatorName:String, responderName:String, socialGameName:String, typeOfHint:int):void {
			var indexString:String = initiatorName.toLowerCase() +"-" + responderName.toLowerCase() +"-" + socialGameName.toLowerCase();
			//Debug.debug(this, "unlockHint() index: " + indexString);
			switch(typeOfHint) {
				case HINT_RESPONDER_MOTIVE:
					//Debug.debug(this, "unlockHint() unlocking responder motive: " + indexString);
					unlockedResponderMotives[indexString] = true;
					break;
				case HINT_SG_OUTCOME:
					//Debug.debug(this, "unlockHint() unlocking sg outcome: " + indexString);
					unlockedSGOutcomes[indexString] = true;
					break;
				case HINT_FORECAST:
					unlockedForecasts[indexString] = true;
					break;
				case HINT_NEW_RESPONDER_REACTION:
					unlockedOppositeResponderReactions[indexString] = true;
					break;
				default:
					Debug.debug(this, "unlockHint() unrecognized typeOfHint");
			}

		}
		
		/**
		 * Checks to see if a specific hint is unlocked for the current turn, where a hint is defined by
		 * the initiator, the responder, and the name of the game the hint is for.
		 * @param	initiatorName the name of the initiator
		 * @param	responderName the name of the responder
		 * @param	socialGameName the name of the social game
		 * @return true if the hint has been unlocked.  false otherwise.
		 */
		public function isHintUnlocked(initiatorName:String, responderName:String, socialGameName:String, typeOfHint:int):Boolean {
			var indexString:String = initiatorName.toLowerCase() +"-" + responderName.toLowerCase() +"-" + socialGameName.toLowerCase();
			//Debug.debug(this, "isHintUnlocked: " + indexString);
			switch(typeOfHint) {
				case HINT_RESPONDER_MOTIVE:
					if (unlockedResponderMotives[indexString]) {
						return true;
					}
					else {
						return false;
					}
					break;
				case HINT_SG_OUTCOME:
					if (unlockedSGOutcomes[indexString]) {
						return true;
					}
					else {
						return false;
					}
					break;
				case HINT_FORECAST:
					if (unlockedForecasts[indexString]) {
						//Debug.debug(this, "yes! forecast was unlocked!");
						return true;
					}
					else {
						//Debug.debug(this, "no, forecast was not unlocked!");
						return false;
					}
				case HINT_NEW_RESPONDER_REACTION:
					if (unlockedOppositeResponderReactions[indexString]) return true;
					else return false;
				default:
					Debug.debug(this, "isHintUnlocked() unrecognized typeOfhint!");
					return false;
			}
			return false; // should never get here.
		}
		
		//Clears the hint dictionary -- should be called after every turn.
		public function clearHints():void {
			this.unlockedResponderMotives = new Dictionary();
			this.unlockedSGOutcomes = new Dictionary();
			this.unlockedForecasts = new Dictionary();
			this.unlockedOppositeResponderReactions = new Dictionary();
			this.currentStateOfResponderReaction = new Dictionary();
			this.isResponderReactionOpposite = new Dictionary();
			this.unlockedNonTopSocialGames = new Dictionary();
		}
		
		public function getCostForSwitchOutcome(sgc:SocialGameContext):Number
		{
			var whichGame:String = sgc.gameName;
			var motivationString:String = gameEngine.getIntensityOfDesireToDoWhatTheCharacterDid("responder", sgc);
			var isRelTypeGame:Boolean = false;
			if (cif.socialGamesLib.getByName(whichGame).intents[0].predicates[0].type == Predicate.RELATIONSHIP)
			{
				isRelTypeGame = true;
			}
			if (isRelTypeGame)
			{
				if (motivationString == "strong")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_STRONG, false);
				}
				else if (motivationString == "medium")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_MEDIUM, false);
				}
				else if (motivationString == "weak")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_WEAK, false);
				}
			}
			else
			{
				if (motivationString == "strong")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_STRONG, false);
				}
				else if (motivationString == "medium")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_MEDIUM, false);
				}
				else if (motivationString == "weak")
				{
					return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_WEAK, false);
				}
			}
			return adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION, false);
		}
		
		public function activateOppositeResponderReaction(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext, isFreebie:Boolean = false):Boolean {
			var dictionaryIndex:String = initName.toLowerCase() + "-" + respondName.toLowerCase() + "-" + whichGame.toLowerCase();
			
			var costForThisSwitch:Number = getCostForSwitchOutcome(sgc);
			
			
			//if (currentJuicePoints < COST_FOR_OPPOSITE_RESPONDER_REACTION && !isFreebie) {
			if (currentJuicePoints < costForThisSwitch && !isFreebie) {
				//Debug.debug(this, "Oops, you don't have enough juice points! You only have: " + currentJuicePoints + " and you need " + COST_FOR_OPPOSITE_RESPONDER_REACTION);
				return false;
			}
			else {
				
				var juiceContext:JuiceContext = new JuiceContext();
				juiceContext.type = JuiceContext.TYPE_SWITCH_OUTCOME;
				juiceContext.gameName = whichGame;
				juiceContext.initiator = initName;
				juiceContext.responder = respondName;
				juiceContext.time = cif.time;
				
				//Debug.debug(this, "magic power activated! spending a bunch of juice points!");
				unlockHint(initName, respondName, whichGame, HINT_NEW_RESPONDER_REACTION);
				var motivationString:String = gameEngine.getIntensityOfDesireToDoWhatTheCharacterDid("responder", sgc);
				var isRelTypeGame:Boolean = false;
				if (cif.socialGamesLib.getByName(whichGame).intents[0].predicates[0].type == Predicate.RELATIONSHIP)
				{
					isRelTypeGame = true;
				}
				if (isRelTypeGame)
				{
					if (motivationString == "strong")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_STRONG, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_STRONG, false);
					}
					else if (motivationString == "medium")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_MEDIUM, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_MEDIUM, false);
					}
					else if (motivationString == "weak")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_WEAK, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_WEAK, false);
					}
				}
				else
				{
					if (motivationString == "strong")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_STRONG, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_STRONG, false);
					}
					else if (motivationString == "medium")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_MEDIUM, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_MEDIUM, false);
					}
					else if (motivationString == "weak")
					{
						if(!isFreebie) subtractJuicePoints(adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_WEAK, false));
						juiceContext.cost = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_WEAK, false);
					}
				}
				
				isResponderReactionOpposite[dictionaryIndex] = true;
				if (sgc.responderScore < dm.getVolitionThreshold("responder")) {
					currentStateOfResponderReaction[dictionaryIndex] = "Accept"; // it is now the OPPOSITE of what it wold have been
					juiceContext.newResponse = "accept";
				}
				else {
					currentStateOfResponderReaction[dictionaryIndex] = "Reject"; // it is now the OPPOSITE of what it wold have been
					juiceContext.newResponse = "reject";
				}
				cif.sfdb.addContext(juiceContext);
				return true;
			}
		}
		
		public function switchResponderReaction(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext):String {
			var dictionaryIndex:String = initName.toLowerCase() + "-" + respondName.toLowerCase() + "-" + whichGame.toLowerCase();
			isResponderReactionOpposite[dictionaryIndex] = !isResponderReactionOpposite[dictionaryIndex]; // flip it!
			if(currentStateOfResponderReaction[dictionaryIndex].toLowerCase() == "accept"){
				// it is now the OPPOSITE of what it wold have been
				currentStateOfResponderReaction[dictionaryIndex] = "Reject";

				
				return "Reject";
			}
			else if (currentStateOfResponderReaction[dictionaryIndex].toLowerCase() == "reject") {
				currentStateOfResponderReaction[dictionaryIndex] = "Accept"; // it is now the OPPOSITE of what it wold have been
				return "Accept";
			}
			else {
				Debug.debug(this, "switchResponderReaction() unrecognized reaction type!");
				return "unrecognized!";
			}
		}
		
		public function isResponderReactionNegated(initName:String, respondName:String, whichGame:String):Boolean {
			var dictionaryIndex:String = initName.toLowerCase() + "-" + respondName.toLowerCase() + "-" + whichGame.toLowerCase();
			return isResponderReactionOpposite[dictionaryIndex];
			/*
			if (sgc.responderScore < 0) {
				//it SHOULD BE REJECTED.  SO, if the value inside of our 'current state' dictionary is REJECT then that means that we want to play the game NORMAL
				if (currentStateOfResponderReaction[dictionaryIndex].toLowerCase() == "reject") {
					return false; // it should be rejected, and it is rejected.  Therefore, we DON"T want an opposite reaction
				}
				else {
					return true;
				}
			}
			else {
				//it SHOULD BE ACCEPTED.  SO, if the value inside of our 'current state' dictionary is ACCEPT that means that we want to play the game NORMAL.
				if (currentStateOfResponderReaction[dictionaryIndex].toLowerCase() == "accept") { 
					return false; // it should be accepted, and it is accepted.  Therefore, we DON"T want an opposite reaction
				}
				else {
					return true;
				}
			}
			*/
		}
		
		/**
		 * To be called at the end of a turn
		 * increments juice points, and clears all of the hints.
		 */
		public function endOfTurnHandler():void {
			clearHints();
			
			if (playedNonTopSG) {
				playedNonTopSG = false; // give them the benefit of the doubt for the next time.
				return; // if they have used a non-top five social game, prevent them from getting more juice!
			}
			
			if (!gameEngine.negateResponderScore) { 
				addJuicePoints();
				return;
			}
			else {
				return; // if responder score is negated, it means they used a power--they don't get rewarded for that!
			}
		}
		
		/**
		 * handles unlocking a responder motive, given the id of a social game button.
		 * @param	whichButton the id of a social game button within the social game button ring that we wish to unlock a responder motive hint for.
		 */
		public function handleResponderMotiveUnlock(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext):Boolean {
			var type:int = HINT_RESPONDER_MOTIVE;
			var adjustedCostForResponderMotive:int = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_UNLOCKING_RESPONDER_MOTIVE, false);
			if (!isHintUnlocked(initName, respondName, whichGame, type)) {
				if (currentJuicePoints >= adjustedCostForResponderMotive) {
					//Debug.debug(this, "RESPONDER MOTIVE UNLOCK SUCCESS");
					unlockHint(gameEngine.primaryAvatarSelection, gameEngine.secondaryAvatarSelection, whichGame, type);
					subtractJuicePoints(adjustedCostForResponderMotive);
					/*
					if (whichButton == 0)
						//gameEngine.hudGroup.socialGameButtonRing.unlockResponderMotive0Button.enabled = false;
					if (whichButton == 1)
						//gameEngine.hudGroup.socialGameButtonRing.unlockResponderMotive1Button.enabled = false;
					if (whichButton == 2)
						//gameEngine.hudGroup.socialGameButtonRing.unlockResponderMotive2Button.enabled = false;
					if (whichButton == 3)
						//gameEngine.hudGroup.socialGameButtonRing.unlockResponderMotive3Button.enabled = false;
					if (whichButton == 4)
					//	gameEngine.hudGroup.socialGameButtonRing.unlockResponderMotive4Button.enabled = false;
					*/
					
					var juiceContext:JuiceContext = new JuiceContext();
					juiceContext.type = JuiceContext.TYPE_BUY_MOTIVES;
					juiceContext.gameName = whichGame;
					juiceContext.initiator = initName;
					juiceContext.responder = respondName;
					juiceContext.time = cif.time;
					juiceContext.cost = adjustedCostForResponderMotive;
					cif.sfdb.addContext(juiceContext);
					
					
					return true;
				}
				else {
					Debug.debug(this, "NOT ENOUGH JUICE for RESPONDER MOTIVE");
					return false;
				}
				
			}
			else {
				//Debug.debug(this, "RESPONDER MOTIVE UNLOCKED");
				return true;
			}
		}
		
		public function handleOutcomeUnlock(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext):Boolean {
			//var whichGame:String = gameEngine.hudGroup.socialGameButtonRing.socialGameButtons[whichButton].gameName;
			var type:int = HINT_SG_OUTCOME;
			var adjustedCost:int = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_UNLOCKING_SG_OUTCOME, false);
			if (!isHintUnlocked(initName, respondName, whichGame, type)) {
				if (currentJuicePoints >= adjustedCost) {
					//Debug.debug(this, "OUTCOME UNLOCK SUCCESS");
					unlockHint(initName, respondName, whichGame, type);
					subtractJuicePoints(adjustedCost);
					
					if (VisibilityManager.getInstance().useOldInterface)
					{
						if (sgc.responderScore >= dm.getVolitionThreshold("responder")) {
							//gameEngine.hudGroup.sgInfoWindow.predictionValues.text = "Accept"
							gameEngine.hudGroup.megaUI.sgInfo.predictionLabel.text = "Accept";
						}
						else {
							//gameEngine.hudGroup.sgInfoWindow.predictionValues.text = "Reject"
							gameEngine.hudGroup.megaUI.sgInfo.predictionLabel.text = "Reject";
						}
					}
					
					var juiceContext:JuiceContext = new JuiceContext();
					juiceContext.type = JuiceContext.TYPE_BUY_RESULTS;
					juiceContext.gameName = whichGame;
					juiceContext.initiator = initName;
					juiceContext.responder = respondName;
					juiceContext.time = cif.time;
					juiceContext.cost = adjustedCost;
					cif.sfdb.addContext(juiceContext);
					
					
					return true;
					
					
					//gameEngine.hudGroup.socialGameButtonRing.socialGameButtons[whichButton].updateStateBasedOnGameName(gameEngine.hudGroup.socialGameButtonRing.socialGameButtons[whichButton].gameName)
					
					/*
					if (whichButton == 0)
						//gameEngine.hudGroup.socialGameButtonRing.unlockSGOutcome0Button.enabled = false;
					if (whichButton == 1)
						//gameEngine.hudGroup.socialGameButtonRing.unlockSGOutcome1Button.enabled = false;
					if (whichButton == 2)
						//gameEngine.hudGroup.socialGameButtonRing.unlockSGOutcome2Button.enabled = false;
					if (whichButton == 3)
						//gameEngine.hudGroup.socialGameButtonRing.unlockSGOutcome3Button.enabled = false;
					if (whichButton == 4)
						//gameEngine.hudGroup.socialGameButtonRing.unlockSGOutcome4Button.enabled = false;
						*/
				}
				else {
					Debug.debug(this, "NOT ENOUGH JUICE for OUTCOME");
					return false;
				}
			}
			else {
				//Debug.debug(this, "OUTCOME ALREADY UNLOCKED");
				return false;
			}
		}
		
		public function handleForecastUnlock(initName:String, respondName:String, gameName:String, sgc:SocialGameContext):Boolean {
			if (isHintUnlocked(initName, respondName, gameName, HINT_FORECAST)) {
				//Then we are done! It is unlocked already!
				return true;
			}
			
			var adjustedForecastJuiceCost:int = adjustAddOrSubtractJuicePointsBasedOnDifficulty(COST_FOR_UNLOCKING_FORECAST, false);
			
			if (currentJuicePoints < adjustedForecastJuiceCost) {
					Debug.debug(this, "Not Enough Juice! You need a total of " + adjustedForecastJuiceCost + " juice points!");
					return false;
			}
			else {
				subtractJuicePoints(adjustedForecastJuiceCost);
				unlockHint(initName, respondName, gameName, HINT_FORECAST);
				var forecastDictionary:Dictionary = new Dictionary()
				//gameEngine.hudGroup.sgInfoWindow.forecastAccept.visible = true;
				//gameEngine.hudGroup.sgInfoWindow.forecastReject.visible = true;
				//gameEngine.hudGroup.sgInfoWindow.forecastFailureLabel.visible = true;
				//gameEngine.hudGroup.sgInfoWindow.forecastSuccessLabel.visible = true;
				//gameEngine.hudGroup.sgInfoWindow.unlockInitForecastButton.visible = false;
				
				switch(cif.socialGamesLib.getByName(gameName).intents[0].predicates[0].getIntentType()) {
					case Predicate.INTENT_BUDDY_UP:
						//Debug.debug(this, "intent buddy up!");
						forecastDictionary = SocialGameButton.forecastIntentBuddyUp(sgc);
						break;
					case Predicate.INTENT_BUDDY_DOWN:
						//Debug.debug(this, "intent buddy down!");
						forecastDictionary = SocialGameButton.forecastIntentBuddyDown(sgc);
						break;
					case Predicate.INTENT_ROMANCE_UP:
						//Debug.debug(this, "intent romance up!");
						forecastDictionary = SocialGameButton.forecastIntentRomanceUp(sgc);
						break;
					case Predicate.INTENT_ROMANCE_DOWN:
						//Debug.debug(this, "intent romance down!");
						forecastDictionary = SocialGameButton.forecastIntentRomanceDown(sgc);
						break;
					case Predicate.INTENT_COOL_UP:
						//Debug.debug(this, "intent cool up!");
						forecastDictionary = SocialGameButton.forecastIntentCoolUp(sgc);
						break;
					case Predicate.INTENT_COOL_DOWN:
						//Debug.debug(this, "intent cool down!");
						forecastDictionary = SocialGameButton.forecastIntentCoolDown(sgc);
						break;
					case Predicate.INTENT_FRIENDS:
						//Debug.debug(this, "intent start friends!");
						forecastDictionary = SocialGameButton.forecastIntentFriends(sgc);
						break;
					case Predicate.INTENT_END_FRIENDS:
						//Debug.debug(this, "intent end friends!");
						forecastDictionary = SocialGameButton.forecastIntentStopFriends(sgc);
						break;
					case Predicate.INTENT_DATING:
						//Debug.debug(this, "intent start dating (my CRAZY thing) cif time is: " + cif.time );
						forecastDictionary = SocialGameButton.forecastIntentDating(sgc);
						break;
					case Predicate.INTENT_END_DATING:
						//Debug.debug(this, "intent stop dating!");
						forecastDictionary = SocialGameButton.forecastIntentStopDating(sgc);
						break;
					case Predicate.INTENT_ENEMIES:
						//Debug.debug(this, "intent start enemies!");
						forecastDictionary = SocialGameButton.forecastIntentEnemies(sgc);
						break;
					case Predicate.INTENT_END_ENEMIES:
						//Debug.debug(this, "intent stop enemies!");
						forecastDictionary = SocialGameButton.forecastIntentStopEnemies(sgc);
						break;
					default:
						Debug.debug(this, "unrecognized intent!");
						break;
				}
				
				/*
				gameEngine.hudGroup.sgInfoWindow.forecastAccept.text = forecastDictionary["accept"];
				gameEngine.hudGroup.sgInfoWindow.forecastReject.text = forecastDictionary["reject"];
				*/
				
				//gameEngine.hudGroup.megaUI.sgInfo.forecastAccept.text = forecastDictionary["accept"];
				//gameEngine.hudGroup.megaUI.sgInfo.forecastReject.text = forecastDictionary["reject"];
				
				return true;
				
			}
			return false; // don'tthink it should get here.
		}
		
		public function handleNonTopSocialGameSelection(juiceCost:int, init:String, respond:String, game:String):Boolean {
			//Debug.debug(this, "I think we just selected this: " + gameEngine.hudGroup.socialGameButtonRing.sgDropdown.selectedItem);
			
			if (currentJuicePoints < juiceCost) {
				Debug.debug(this, "Not Enough Juice! You need a total of " + juiceCost + " juice points!");
				return false;
			}
			else {
				subtractJuicePoints(juiceCost);
				var dictionaryIndex:String = init.toLowerCase() + "-" + respond.toLowerCase() + "-" + game.toLowerCase();
				unlockedNonTopSocialGames[dictionaryIndex] = true;
				var juiceContext:JuiceContext = new JuiceContext();
				juiceContext.type = JuiceContext.TYPE_BUY_GAME;
				juiceContext.gameName = game;
				juiceContext.initiator = init;
				juiceContext.responder = respond;
				juiceContext.time = cif.time;
				juiceContext.cost = juiceCost;
				cif.sfdb.addContext(juiceContext);
				return true;
			}
			
			return false; // hopefully it should never get here.
		}
		
		//Returns true if the game has already been unlocked between this initiator responder pair.
		//false otherwise
		public function isNonTopGameUnlocked(init:String, respond:String, game:String):Boolean {
			var dictionaryIndex:String = init.toLowerCase() + "-" + respond.toLowerCase() + "-" + game.toLowerCase();
			if (unlockedNonTopSocialGames[dictionaryIndex]) {
				return true;
			}
			else {
				return false;
			}
		}
		
		/**
		 * Figures out how expensive it should be to unlock a new social game,
		 * based on how much they want to play it, and based on how badly they want to play their TOP social game.
		 * @param	highestScoredGame how much they want to play the top-most game!
		 * @param	thisVolition how much they want to play the game that we are computing the JP cost for
		 * @return the cost, in juice points, of unlocking this new game.
		 */
		public function computeJuicePointCostOfNonTopSG(highestScoredGame:int, thisVolition:int):int {
			var distanceFromTop:int = highestScoredGame - thisVolition; // thisVolition will ALWAYS be lower than highestScoredGame (thus difference is alwaays positive).
			var returnValue:Number = distanceFromTop * 2;
			if (returnValue > 100)
				returnValue = 100; // make sure that things don't cost more than 100!
				
			returnValue = adjustAddOrSubtractJuicePointsBasedOnDifficulty(returnValue, false)
			return returnValue;
		}
		
		/**
		 * This function is called within addJuicePoints or subtract Juice Points, and adjusts the amount that things are going
		 * to be adjusted based on the current difficulty level. Generally speaking, the easier the mode, the MORE juice points
		 * you'll have.  That is to say, things that give you juice points give you MROE juice points, and things that take
		 * AWAY juice points take away LESS juice points. And vice versa for harder modes.
		 * @param	jpToAdd the original number.  In 'hard' mode, this number will go unchanged.
		 * @param	isAdding if true, then we are referring to a situation where we are increasing the players juice points.  If false, then it is a situation where the juice point sum goes down.
		 * @return The new number that we are actually goingn to adjust the current juice point total by.
		 */
		public function adjustAddOrSubtractJuicePointsBasedOnDifficulty(jpToAdd:int, isAdding:Boolean):int {
			var EASY_RATE:Number = 2.0; // give them DOUBLE juice points, or reduce the rate by half!
			var MEDIUM_RATE:Number = 1.5; // give them 150 percent juice points!
			var HARD_RATE:Number = 1.0; // don't change anything! Everything is just normal!
			var EXPERT_RATE:Number = 0.5; // give them LESS juice points.  or INCREASE the cost of things.
			
			if (isAdding) { // We are adding juice points!  in easy mode, give them LOTS of juice points! in expert mode, give them LESS juice points!
				if (jpToAdd == -999)
					jpToAdd = DEFAULT_JUICEPOINT_INCREMENT_RATE; // sometimes we maybe didn't pass something in! Deal with that!
					
				switch(dm.getDifficulty()) {
					case dm.EASY_ID:
						return jpToAdd * EASY_RATE // give them DOUBLE juice points!
						break;
					case dm.MEDIUM_ID:
						return jpToAdd * MEDIUM_RATE;
						break;
					case dm.HARD_ID:
						return jpToAdd * HARD_RATE;
						break;
					case dm.EXPERT_ID:
						return jpToAdd * EXPERT_RATE;
						break;
					default:
						return jpToAdd;
						break;
				}
			}
			else { // we are subtracting juice points!  In easy mode, subtract only a FEW juice points! In expert mode, make it more expensive!
				if (jpToAdd == -999)
					jpToAdd = DEFAULT_JUICEPOINT_DECREMENT_RATE; // sometimes we maybe didn't pass something in! Deal with that!
			}
					
				switch(dm.getDifficulty()) {
					case dm.EASY_ID:
						return jpToAdd / EASY_RATE;
						break;
					case dm.MEDIUM_ID:
						return jpToAdd / MEDIUM_RATE;
						break;
					case dm.HARD_ID:
						return jpToAdd / HARD_RATE;
						break;
					case dm.EXPERT_ID:
						return jpToAdd / EXPERT_RATE;
						break;
					default:
						return jpToAdd;
						break;
			}
		}
	}

}