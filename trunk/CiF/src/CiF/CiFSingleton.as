package CiF 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flashx.textLayout.utils.CharacterUtil;

	/**
	 * The CiF class is the entry point to Comme il Faut. An instance of this
	 * class will be the main interface point for a system to leverage CiF.
	 * 
	 * <p>This class is a singleton. </p>
	 * 
	 */
	//static var buddyNetwork:BuddyNetwork;
	public class CiFSingleton
	{
		private static var _instance:CiFSingleton = new CiFSingleton();
		public var relationshipNetwork:RelationshipNetwork;
		public var buddyNetwork:BuddyNetwork;
		public var romanceNetwork:RomanceNetwork;
		public var coolNetwork:CoolNetwork;
		public var ckb:CulturalKB;
		public var sfdb:SocialFactsDB;
		public var socialGamesLib:SocialGamesLib;

		public var isInPromToolPreviewMode:Boolean = false;
		
		/*Normally we DON'T want Trigger games to be included in the list of social games.
		 * However, when dealing with the design tool or library merger, for examples, we DO
		 * actually want them to still show up (e.g. when we are saving a new file, we want/need to have those games!
		 * This variable is true if they ARE inserted into the vector of social games, false otherwise.
		 * */
		public var shouldTriggerGamesBeIncludedInSocialGames:Boolean = false; 
		
		/**
		 * this will always hold the last other that the last responder used while deciding accept/reject
		 * it should only be referenced immediately after play game
		 */
		public var lastResponderOther:Character;
		
		public var useMicrotheoryCache:Boolean = true;
		public var microtheoryCache:Dictionary;
		
		public var cast:Cast;
		/**
		 * The microtheories for this specification of CiF.
		 */
		public var microtheories:Vector.<Microtheory>;
		
		/**
		 * The library of social status updates
		 */
		public var socialStatusUpdates:Vector.<SocialStatusUpdateEntry>;
		public var socialStatusUpdatesNotInLevel:Vector.<SocialStatusUpdateEntry>;
		
		
		/*
		 * Used for computing the network line length
		 */ 
		public var intentsTotalPos:Array;
		public var intentsTotalNeg:Array;
		 
		/**
		 * The current time of the simulation.
		 */
		public var _time:int = 0;
		/**
		 * The current context of CiF. This will primarily be in a 
		 * SocialGameContext but can be in a TriggerContext during the SFDB
		 * trigger processing phase or a StatusContext when evaluating the 
		 * removal of statuses from characters.
		 */
		private var currentContext:SFDBContext;
		
		
		
		public function CiFSingleton() {
			if (_instance != null) {
				throw new Error("CiFSingleton (Constructor): " + "Cast can only be accessed through CiFSingleton.getInstance()");
			}
			this.intentsTotalPos = new Array(Predicate.NUM_INTENT_TYPES);
			this.intentsTotalNeg = new Array(Predicate.NUM_INTENT_TYPES);
			for (var i:int = 0; i < Predicate.NUM_INTENT_TYPES; i++)
			{
				this.intentsTotalPos[i] = new Number(0);
				this.intentsTotalNeg[i] = new Number(0);
			}
			
			this.relationshipNetwork = RelationshipNetwork.getInstance();
			this.buddyNetwork = BuddyNetwork.getInstance();
			this.romanceNetwork = RomanceNetwork.getInstance();
			this.coolNetwork = CoolNetwork.getInstance();
			this.ckb = CulturalKB.getInstance();
			this.socialGamesLib = SocialGamesLib.getInstance();
			this.cast = Cast.getInstance();
			this.sfdb = SocialFactsDB.getInstance();
			this.currentContext = new SocialGameContext();
			this.microtheories = new Vector.<Microtheory>();
			this.socialStatusUpdates = new Vector.<SocialStatusUpdateEntry>();
			this.socialStatusUpdatesNotInLevel = new Vector.<SocialStatusUpdateEntry>();
		}
		
		public static function getInstance():CiFSingleton {
			return _instance;
		}
		
		
		/**********************************************************************
		 * Initializers
		 *********************************************************************/
		
		/**
		 * Re-initializes the networks a value of 0 for all edges.
		 */
		public function resetNetworks():void {
			this.relationshipNetwork.initialize(this.cast.characters.length);
			this.buddyNetwork.initialize(this.cast.characters.length);
			this.romanceNetwork.initialize(this.cast.characters.length);
			this.coolNetwork.initialize(this.cast.characters.length);
		}
		
		public function clearProspectiveMemory():void {
			Debug.debug(this, "##CLEAR PROSPECTIVE MEMORY##");
			for each (var character:Character in this.cast.characters)
				character.prospectiveMemory = new ProspectiveMemory();
		}
		
		/**
		 * Evaluates the change of all non-backstory social game context entries
		 * in the SFDB in game time order. Triggers are ran after each context is
		 * valuated.
		 */
		public function valuateHistory():void {
			var i:int = this.sfdb.contexts.length - 1;
			var context:SFDBContext;
			var sgc:SocialGameContext;
			var tc:TriggerContext;
			
			//reset social game effect's last seen times.
			this.resetLastSeenTimes()
			
			for (; i > 0; --i) {
				if (this.sfdb.contexts[i].isSocialGame()) {
					context = this.sfdb.contexts[i]
					if(context.isSocialGame()){
						sgc = this.sfdb.contexts[i] as SocialGameContext;
						if (!sgc.isBackstory) {
							var e:Effect = this.socialGamesLib.getByName(sgc.gameName).getEffectByID(sgc.effectID);
							//evaluate the effect's change rule
							sgc.getChange().valuation(this.cast.getCharByName(sgc.initiator), this.cast.getCharByName(sgc.responder), this.cast.getCharByName(sgc.other));
							
							if (e.lastSeenTime < sgc.getTime())
								e.lastSeenTime = sgc.getTime()
						}
					}else if (context.isTrigger()) {
						tc = context as TriggerContext
						tc.getChange().valuation(this.cast.getCharByName(tc.initiator), this.cast.getCharByName(tc.responder), this.cast.getCharByName(tc.other));
					}
				}
			}
			//we want the simulation to be in the next time step after the last history event.
			this.time = this.sfdb.getLatestContextTime() + 1;
		}
		
		/**
		 * Resets the last seen times on the social game's effects.
		 */
		public function resetLastSeenTimes():void {
			for each(var sg:SocialGame in this.socialGamesLib.games) {
				for each(var e:Effect in sg.effects) {
					e.lastSeenTime = -1;
				}
			}
		}
		
		/**********************************************************************
		 * Intent formation.
		 *********************************************************************/
		
		/**
		 * Performs intent planning for a single character. This process scores
		 * all possible social games for all other characters and stores the 
		 * score in the character's prospective memory.
		 * 
		 * 
		 * @param	character The subject of the intent formation process.
		 */
		public function formIntentOld(character:Character):void {
			//for each other player
			var gameScore:GameScore;
			//Debug.debug(this, "formIntent(): " + character.characterName +" is forming intent");
			var char:Character;
			//keeps track of the maxiumum true IR rules of the IRSs ran to find
			//a third character.
			var score:Number = 0;
			var maxTrueRuleCount:int = 0;
			var currentScore:Number = 0;
			//the other to use when all cases of other being passed in and a
			//third character being needed when one is not provided.
			var trueOther:Character;
			
			
			//Debug.level = -1;
			
			//clear the prospective memory before the next round
			character.prospectiveMemory = new ProspectiveMemory();

			for each (var potentialResponder:Character in cast.characters) {
				var start:int = getTimer();
				
				if (potentialResponder.characterName != character.characterName) {

					//invalidate the last microtheory scores now that a new cast is present
					//invalidateMicrotheories();
					
					/* To save the re-evaluation of many predicates in microtheory rules, 
					 * score all MT rules for this cast other than the intent predicates.
					 * 
					 * As microtheory rules are considered in a per-socialgame context, 
					 * the rule's intent is compared to the social game's intent. If the
					 * intents match and the non-intent predicates all evaluated to true,
					 * we add the rule's weight to the running total.
					 */
					
					//Score non-intent predicates in all microtheories with the current cast.
					//scoreMicrotheoriesWithoutIntent(character, potentialResponder);
					
					for each(var sg:SocialGame in this.socialGamesLib.games) {
						
						//score the microtheories between the two characters before 
						
						//see if the game has valid preconditions
						//Debug.debug(this, "formIntent(): checking preconditions for '" + sg.name + "' with " +potentialResponder.characterName+ " - " + sg.checkPreconditions(character, potentialResponder));
						//Debug.debug(this, "formIntent(): checking preconditions for '" + sg.name + "' with " +potentialResponder.characterName);
						//determine if we need to find a third character
						score = 0;
						maxTrueRuleCount = 0;
						currentScore = 0;
						trueOther = null;
						
						if (sg.thirdParty)
						{
							for each (var potentialPatsy:Character in this.cast.characters) {
								if (!((potentialPatsy.characterName.toLowerCase() == character.characterName.toLowerCase())
									|| (potentialPatsy.characterName.toLowerCase() == potentialResponder.characterName.toLowerCase()))) {
									if (sg.patsyRule.evaluate(character, potentialResponder, potentialPatsy))
									{
										if (sg.checkPreconditions(character, potentialResponder, potentialPatsy))
										{
											currentScore = scoreInitiatorWithMicrotheories(sg, character, potentialResponder, potentialPatsy);
											gameScore = new GameScore();
											if (sg.thirdPartyTalkAboutSomeone)
											{	
												gameScore.initiator = character.characterName;
												gameScore.responder = potentialPatsy.characterName;
												gameScore.other = potentialResponder.characterName;
											}
											else
											{	
												gameScore.initiator = character.characterName;
												gameScore.responder = potentialResponder.characterName;
												gameScore.other = potentialPatsy.characterName;
											}
											gameScore.score = currentScore;
											gameScore.name = sg.name;
											character.prospectiveMemory.scores.push(gameScore);
										}
									}
								}
							}
						}
						else if (sg.thirdForIntentFormation()) {
							gameScore = new GameScore();
							
							for each (char in this.cast.characters) 
							{
								if (char.characterName.toLowerCase() != character.characterName.toLowerCase() &&
									char.characterName.toLowerCase() != potentialResponder.characterName.toLowerCase()) {
									if (sg.checkPreconditions(character, potentialResponder, char))
									{
										currentScore = scoreInitiatorWithMicrotheories(sg, character, potentialResponder, char);
										if (currentScore > gameScore.score)
										{
											trueOther = char;
											gameScore.initiator = character.characterName;
											gameScore.responder = potentialResponder.characterName;
											gameScore.other = char.characterName;
											gameScore.score = currentScore;
											gameScore.name = sg.name;
										}
									}
								}
							}
							if (gameScore.score > 0)
							{
								character.prospectiveMemory.scores.push(gameScore);
							}							
						}
						else 
						{

							if(sg.checkPreconditions(character, potentialResponder)) {
								score = scoreInitiatorWithMicrotheories(sg, character, potentialResponder);
								
								gameScore = new GameScore();
								gameScore.initiator = character.characterName;
								gameScore.responder = potentialResponder.characterName;
								gameScore.score = score;
								gameScore.name = sg.name;
								character.prospectiveMemory.scores.push(gameScore);
							}
						}
					}
				}
				//Debug.debug(this, "formIntent() intent formation done in " + (getTimer() - start) + "ms between " + character.characterName + " and " + potentialResponder.characterName);
			}
		}
		
		public function formIntentForAll(activeInitiatorAndResponderCast:Vector.<Character> = null, activeOtherCast:Vector.<Character>=null):void {
			clearProspectiveMemory();
			var castToUse:Vector.<Character> = (activeInitiatorAndResponderCast)?activeInitiatorAndResponderCast:this.cast.characters;
			for each (var char:Character in castToUse) {
				this.formIntent(char, activeInitiatorAndResponderCast, activeOtherCast);
			}
		}
		
		/**
		 * Performs intent planning for a single character. This process scores
		 * all possible social games for all other characters and stores the 
		 * score in the character's prospective memory.
		 * 
		 * @param	initiator 	The subject of the intent formation process.
		 * @param	activeCast	An optional cast of characters that can be responders.
		 */
		public function formIntent(initiator:Character, activeInitiatorAndResponderCast:Vector.<Character> = null, activeOtherCast:Vector.<Character>=null,setOfGames:Vector.<SocialGame> = null ):void {
			//if a level cast was passed in, use it. Otherwise, use the general cast
			var possibleResponders:Vector.<Character> = (activeInitiatorAndResponderCast)?activeInitiatorAndResponderCast:this.cast.characters;
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			var currentSetOfSocialGames:Vector.<SocialGame> = (setOfGames)?setOfGames:this.socialGamesLib.games;
			for each (var responder:Character in possibleResponders) {
				var start:int = getTimer();
				
				if (responder.characterName != initiator.characterName) 
					formIntentForSocialGames(initiator, responder, possibleOthers,currentSetOfSocialGames);
				
				Debug.debug(this, "formIntent() intent formation done in " + (getTimer() - start) + "ms between " + initiator.characterName + " and " + responder.characterName);
			}
		}
		
		/**
		 * Forms intent for all social games between two characters. If any of
		 * the social games requires a third party, it is handled properly. As
		 * with the other form intent functions, only intents that result in
		 * volition scores greater than 0 are added to the initiator's
		 * perspective memory.
		 * 
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 */
		public function formIntentForSocialGames(initiator:Character, responder:Character, activeOtherCast:Vector.<Character> = null, setOfGames:Vector.<SocialGame> = null ):void {
			var sg:SocialGame;
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			var currentSetOfSocialGames:Vector.<SocialGame> = (setOfGames)?setOfGames:this.socialGamesLib.games;
			
			// 3-17-11 2:07pm I have confirmed that this only happends once per form intent.
			
			for each (sg in currentSetOfSocialGames) {
				formIntentForASocialGame(sg, initiator, responder, possibleOthers);
			}
		}

		public function formIntentForASocialGame(sg:SocialGame, initiator:Character, responder:Character, activeOtherCast:Vector.<Character> = null):void {
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			//if (sg.thirdParty) {
				//formIntentWithPatsy(sg, initiator, responder, possibleOthers);
			//}
			//else 
			//{
			
			formIntentThirdParty(sg, initiator, responder, possibleOthers);
			//}
			/*
			else if (sg.thirdForIntentFormation()) {
				formIntentThirdParty(sg, initiator, responder, possibleOthers);
			} else {
				formIntentNoThird(sg, initiator, responder);
			}*/
		}
		
		public function getResponderScore(sg:SocialGame, initiator:Character, responder:Character, activeOtherCast:Vector.<Character> = null):Number
		{
			var score:Number = 0.0;
			var potentialOther:Character;
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			
			//score the social games
			score += sg.scoreGame(initiator, responder, possibleOthers,true);
			
			//score the MTs
			// LOOK UP responder's intent to play sg with initiator
			if (responder.prospectiveMemory.intentScoreCache[initiator.networkID][sg.intents[0].predicates[0].getIntentType()] != ProspectiveMemory.DEFAULT_INTENT_SCORE)
			{
				score += responder.prospectiveMemory.intentScoreCache[initiator.networkID][sg.intents[0].predicates[0].getIntentType()];
			}
			
			return score;
		}
		
		
		/**
		 * Forms the intents, each consisting of a gameScore, between an initiator, 
		 * responder,and an other determined by this function. The other is chosen
		 * first by permissibility (does he/she satisfy the preconditions of the
		 * game) and then by desirability (highest volition score). The chosen other
		 * is then placed along with the social game, initiator, and responder 
		 * in a game score which is stored in the initiator's perspective memory.
		 * 
		 * @param	sg			The social game to contextualize the intent formation.
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 */
		public function formIntentThirdParty(sg:SocialGame, initiator:Character, responder:Character, activeOtherCast:Vector.<Character> = null):void 
		{
			var score:Number = 0;
			var potentialOther:Character;
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			var gameScore:GameScore;

			var singleScore:Number;
		
			//score the social games
			if (sg.checkPreconditionsVariableOther(initiator, responder, possibleOthers))
			{
				score += sg.scoreGame(initiator, responder, possibleOthers);
				
				//score the MTs - Use cached value if one exists
				//if (initiator.prospectiveMemory.intentScoreCache.length == 0) {
					//initiator.prospectiveMemory.initializeIntentScoreCache();
				//}
				//if (!initiator.prospectiveMemory.intentScoreCache[responder.networkID]) {
					//initiator.prospectiveMemory.initializeIntentScoreCache();
				//}
				if (initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
				{
					singleScore = scoreAllMicrotheoriesForType(sg, initiator, responder, possibleOthers);
					initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = singleScore;
					score += singleScore;
				}
				else
				{
					score += initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()];
				}
			}
			else
			{
				//this means there's no way in heck that we are going to play this game. We don't even pass the precondition!
				score = -100;
			}
			
			// create the game score
			gameScore = new GameScore();
			gameScore.score = score;
			gameScore.name = sg.name;
			gameScore.initiator = initiator.characterName;
			gameScore.responder = responder.characterName;
			initiator.prospectiveMemory.scores.push(gameScore);
		}
		
		/**
		 * Scores all microtheories for either "initiator" or "responder"
		 * 
		 * @param	type
		 * @param	sg
		 * @param	initiator
		 * @param	responder
		 * @param	activeOtherCast
		 * @return
		 */
		public function scoreAllMicrotheoriesForType(sg:SocialGame, initiator:Character, responder:Character,activeOtherCast:Vector.<Character> = null):Number
		{
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;

			var totalScore:Number = 0.0;
			
			for each (var theory:Microtheory in this.microtheories)
			{
				totalScore += theory.scoreMicrotheoryByType(initiator, responder, sg,possibleOthers);
			}
			return totalScore;
		}
		

		
		/**
		 * Forms the intents, each consisting of a gameScore, between an initiator, 
		 * responder, and 0 to length of cast combinations with the specified
		 * social game. Each potential patsy is considered in combination with the
		 * given initiator and responder. If the score with the patsy is greater than
		 * 0, a game score representation of that specific set of characters, the social
		 * game, and the volition score are stored in the initiator's prospective memory.
		 * 
		 * @param	sg			The social game to contextualize the intent formation.
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 */
		public function formIntentWithPatsy(sg:SocialGame, initiator:Character, responder:Character, activeOtherCast:Vector.<Character>=null):void {
			var gameScore:GameScore;
			var score:Number = 0;
			var potentialPatsy:Character;
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:this.cast.characters;
			
			for each (potentialPatsy in possibleOthers) {
				if (!((potentialPatsy.characterName.toLowerCase() == initiator.characterName.toLowerCase())
					|| (potentialPatsy.characterName.toLowerCase() == responder.characterName.toLowerCase()))) {
					if (sg.patsyRule.evaluate(initiator, responder, potentialPatsy)) {
						if (sg.checkPreconditions(initiator, responder, potentialPatsy)) {
							score = scoreInitiatorWithMicrotheories(sg, initiator, responder, potentialPatsy,possibleOthers);
							if(score > 0) {
								gameScore = new GameScore();
								
								if (sg.thirdPartyTalkAboutSomeone) {	
									gameScore.initiator = initiator.characterName;
									gameScore.responder = potentialPatsy.characterName;
									gameScore.other = responder.characterName;
								}else{	
									gameScore.initiator = initiator.characterName;
									gameScore.responder = responder.characterName;
									gameScore.other = potentialPatsy.characterName;
								}
								gameScore.score = score;
								gameScore.name = sg.name;
								initiator.prospectiveMemory.scores.push(gameScore);
							}
						}
					}
				}
			}
		}
		
		/**
		 * Forms intent between characters in the initiator, responder,
		 * and an explicitly-named other roles for a specific social game.
		 * This results in a game score being placed into
		 * the initiator's prospective memory if the score was greater than 0.
		 * 
		 * @param	sg			The social game to be scored.
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 * @param	other		The character in the other role.
		 */
		public function formIntentExplicitThirdParty(sg:SocialGame, initiator:Character, responder:Character, other:Character, otherCast:Vector.<Character> = null):void {
			var gameScore:GameScore;
			var score:Number = 0;
			
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			if(sg.checkPreconditions(initiator, responder, other)) {
				score = scoreInitiatorWithMicrotheories(sg, initiator, responder, other, possibleOthers);
				if(score > 0) { //only put games possible to play in the prospective memory.
					gameScore = new GameScore();
					gameScore.initiator = initiator.characterName;
					gameScore.responder = responder.characterName;
					gameScore.other = other.characterName;
					gameScore.score = score;
					gameScore.name = sg.name;
					initiator.prospectiveMemory.scores.push(gameScore);
				}
			}
		}
		
		/**
		 * Forms intent between characters in the initiator and responder 
		 * roles for a specific social game. No other/third party is
		 * considered. This results in a game score being placed into
		 * the initiator's prospective memory if the score was greater
		 * than 0.
		 * 
		 * @param	sg			The social game to be scored.
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 */
		public function formIntentNoThird(sg:SocialGame, initiator:Character, responder:Character):void {
			var gameScore:GameScore;
			var score:Number = 0;
			
			if(sg.checkPreconditions(initiator, responder)) {
				score = scoreInitiatorWithMicrotheories(sg, initiator, responder);
				if(score > 0) { //only put games possible to play in the prospective memory.
					gameScore = new GameScore();
					gameScore.initiator = initiator.characterName;
					gameScore.responder = responder.characterName;
					gameScore.score = score;
					gameScore.name = sg.name;
					initiator.prospectiveMemory.scores.push(gameScore);
				}
			}
		}
		
		public function formIntentByName(characterName:String):void {
			this.formIntent(cast.getCharByName(characterName));
		}
		
		
		/**
		 * Figures out how important each predicate was in the initiator's desire to play a game
		 * 
		 * @param	sg			The social game context.
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 * @param	other		The other character.
		 * @return	A vector of influence rules where each rule has only one p[redicate and the weight on
		 * 			on the rule is the percent that the rule contributed to the initiator wanting
		 * 			to play that game.
		 */
		public function getPredicateRelevance(sgc:SocialGameContext, initiator:Character, responder:Character, other:Character = null,forRole:String = "initiator",otherCast:Vector.<Character> = null, mode:String = "positive"):Vector.<RuleRecord>
		{
			var sg:SocialGame = this.socialGamesLib.getByName(sgc.gameName);
			
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			//other = this.getSalientOther(sg, initiator, responder, possibleOthers);
			var testFlag:Boolean = false;

			var theory:Microtheory;
			var ir:InfluenceRule;
			var i:int;
			
			var tmpString:String;
			
			var c:Character;
			var totalScore:Number = 0;
			var totalPosScore:Number = 0;
			var totalNegScore:Number = 0;
			
			//go through all relevant rules and store them in an array
			var relevantRuleRecords:Vector.<RuleRecord> = new Vector.<RuleRecord>();
			var relevantPosRuleRecords:Vector.<RuleRecord> = new Vector.<RuleRecord>();
			var relevantNegRuleRecords:Vector.<RuleRecord> = new Vector.<RuleRecord>();
			var infRule:InfluenceRule;
			var pred:Predicate
			
			var otherPred:Predicate;
			var ruleRecord:RuleRecord;
			var relevantRuleRecord:RuleRecord;

			var ruleRecordIntent:int;
			var ruleRecordIntentIndex:int;
			
			var newRuleRecord:RuleRecord;
			
			
			// look through the ruleRecords and pull out the important ones
			// add the MT definitions to the influence rules
			if (forRole == "initiator")
			{
				for each (ruleRecord in initiator.prospectiveMemory.ruleRecords)
				{
					if (ruleRecord.initiator == initiator.characterName && ruleRecord.responder == responder.characterName)
					{
						if (ruleRecord.type == RuleRecord.SOCIAL_GAME_TYPE)
						{
							if (ruleRecord.name == sg.name)
							{
								newRuleRecord = ruleRecord.clone();
								//just screwing around making sg influence rules not matter as much by half
								newRuleRecord.influenceRule.weight = newRuleRecord.influenceRule.weight/2
								// add the SGs precondition preds to infRule?
								//if (sg.preconditions.length > 0)
								//{
									//for each (pred in sg.preconditions[0].predicates)
									//{
										//newRuleRecord.influenceRule.predicates.push(pred);
									//}
								//}
								if (newRuleRecord.influenceRule.weight < 0)
								{
									totalNegScore += newRuleRecord.influenceRule.weight;
									relevantNegRuleRecords.push(newRuleRecord);
								}
								else
								{
									
									totalPosScore += newRuleRecord.influenceRule.weight;
									relevantPosRuleRecords.push(newRuleRecord);
								}
								totalScore += newRuleRecord.influenceRule.weight/2;
								relevantRuleRecords.push(newRuleRecord);
								//relevantRules.push(infRule);
							}
						}
						else if (ruleRecord.type == RuleRecord.MICROTHEORY_TYPE)
						{
							ruleRecordIntentIndex = ruleRecord.influenceRule.findIntentIndex();
							
							if (ruleRecordIntentIndex < 0)
							{
								Debug.debug(this, "setDebugInfo() Microtheory " + ruleRecord.name + " has a rule without an intent: " + ruleRecord.influenceRule.toString());
							}
							else
							{
								ruleRecordIntent = ruleRecord.influenceRule.predicates[ruleRecordIntentIndex].getIntentType();
								if (sg.intents[0].predicates[0].getIntentType() == ruleRecordIntent)
								{
									newRuleRecord = ruleRecord.clone();
									// add the MTs definition to the rule
									theory = this.getMicrotheoryByName(ruleRecord.name);
									for each (pred in theory.definition.predicates)
									{
										newRuleRecord.influenceRule.predicates.push(pred.clone());
									}
									
									if (newRuleRecord.influenceRule.weight < 0)
									{
										totalNegScore += newRuleRecord.influenceRule.weight;
										relevantNegRuleRecords.push(newRuleRecord);
									}
									else
									{
										totalPosScore += newRuleRecord.influenceRule.weight;
										relevantPosRuleRecords.push(newRuleRecord);
									}
									totalScore += newRuleRecord.influenceRule.weight;
									relevantRuleRecords.push(newRuleRecord);
									//relevantRules.push(infRule);
								}
							}
						}
					}
				}
			}
			else if (forRole == "responder")
			{
				for each (ruleRecord in responder.prospectiveMemory.ruleRecords)
				{
					if (ruleRecord.initiator == responder.characterName && ruleRecord.responder == initiator.characterName)
					{
						if (ruleRecord.type == RuleRecord.MICROTHEORY_TYPE)
						{	
							ruleRecordIntentIndex = ruleRecord.influenceRule.findIntentIndex();
							
							if (ruleRecordIntentIndex < 0)
							{
								Debug.debug(this, "setDebugInfo() Microtheory " + ruleRecord.name + " has a rule without an intent: " + ruleRecord.influenceRule.toString());
							}
							else
							{
								ruleRecordIntent = ruleRecord.influenceRule.predicates[ruleRecordIntentIndex].getIntentType();
								if (sg.intents[0].predicates[0].getIntentType() == ruleRecordIntent)
								{
									newRuleRecord = ruleRecord.clone();
									
									//swap the roles of the rule record to reflect the fact that this is for the responder and the rule recprd
									//was formed while the responder was forming intent and thus they were the initiator, but now they are the responder
									//newRuleRecord.initiator = responder.characterName;
									//newRuleRecord.responder = initiator.characterName;
									
									// add the MTs definition to the rule
									theory = this.getMicrotheoryByName(ruleRecord.name);
									for each (pred in theory.definition.predicates)
									{
										newRuleRecord.influenceRule.predicates.push(pred.clone());
									}
									
									if (newRuleRecord.influenceRule.weight < 0)
									{
										totalNegScore += newRuleRecord.influenceRule.weight;
										relevantNegRuleRecords.push(newRuleRecord);
									}
									else
									{
										totalPosScore += newRuleRecord.influenceRule.weight;
										relevantPosRuleRecords.push(newRuleRecord);
									}
									//Debug.debug(this, "there is a responder mt consideration: " + ruleRecord.influenceRule.toString());
									totalScore += newRuleRecord.influenceRule.weight;
									relevantRuleRecords.push(newRuleRecord);
									//relevantRules.push(infRule);
								}
							}
						}
					}
				}
				for each (ruleRecord in responder.prospectiveMemory.responseSGRuleRecords)
				{
					if (ruleRecord.initiator == initiator.characterName && ruleRecord.responder == responder.characterName)
					{
						if (ruleRecord.type == RuleRecord.SOCIAL_GAME_TYPE)
						{
							if (ruleRecord.name == sg.name)
							{
								newRuleRecord = ruleRecord.clone();
								//just screwing around making sg influence rules not matter as much by half
								newRuleRecord.influenceRule.weight = newRuleRecord.influenceRule.weight / 2;
								
								// for some reason, I need to swap these... I'm not 100% sure why. But it works, OK?!?!
								newRuleRecord.influenceRule.reverseInitiatorAndResponderRoles();
								
								// add the SGs precondition preds to infRule?
								//if (sg.preconditions.length > 0)
								//{
									//for each (pred in sg.preconditions[0].predicates)
									//{
										//newRuleRecord.influenceRule.predicates.push(pred);
									//}
								//}
								if (newRuleRecord.influenceRule.weight < 0)
								{
									totalNegScore += newRuleRecord.influenceRule.weight;
									relevantNegRuleRecords.push(newRuleRecord);
								}
								else
								{
									totalPosScore += newRuleRecord.influenceRule.weight;
									relevantPosRuleRecords.push(newRuleRecord);
								}
								totalScore += newRuleRecord.influenceRule.weight;
								relevantRuleRecords.push(newRuleRecord);
								//relevantRules.push(infRule);
							}
						}
					}
				}
			}
			
			var shouldAddToPredicateRelevance:Boolean;
			var HOW_IMPORTANT_EFFECT_CONDITIONS_ARE:Number = 25;
			if (forRole == "responder" && mode == "reject")
			{
				HOW_IMPORTANT_EFFECT_CONDITIONS_ARE *= -1;
			}
			//now we need to go thorugh all predicates in the effect condition and create rule records for them
			for each (pred in sg.getEffectByID(sgc.effectID).condition.predicates)
			{
				//make sure to only add it to the right predicate relevance, this is connected to forRole
				shouldAddToPredicateRelevance = true;
				if (pred.type == Predicate.TRAIT)
				{
					//if this trait pred isn't about the person we are computing relevnace, and the trait isn't the sort of thing that has to do with reputation
					if (forRole != pred.primary)
					{
						if (!Trait.isTraitInCategory(pred.trait, Trait.CAT_REPUTATION))
						{
							if (pred.trait != Trait.CAT_JERK)
							{
								shouldAddToPredicateRelevance = false;
							}
						}
					}
				}
				else if (pred.type == Predicate.STATUS)
				{
					//if this trait pred isn't about the person we are computing relevnace, and the status isn't the sort of thing that has to do with reputation
					if (forRole != pred.primary)
					{
						if(!Status.isStatusInCategory(pred.trait, Status.CAT_REPUTATION_BAD) && !Status.isStatusInCategory(pred.trait, Status.CAT_REPUTATION_GOOD))
						{
							shouldAddToPredicateRelevance = false;
						}
					}
				}
				else if (pred.type == Predicate.NETWORK)
				{
					if (pred.primary != forRole)
					{
						shouldAddToPredicateRelevance = false;
					}
				}
				else if (pred.type == Predicate.RELATIONSHIP)
				{
					//in these cases, it is likely these were just to catch weird cases and aren't worth reporting
					if (pred.negated)
					{
						shouldAddToPredicateRelevance = false;
					}
				}
				else if (pred.type == Predicate.SFDBLABEL)
				{
					//in this case, there probably needs to be some sort of switching. Like... hmmmmmm, I'm not sure... all iI know is that the roles gor swapped sometime when they shouldn't have one time.
				}
				
				if (pred.negated)
				{
					shouldAddToPredicateRelevance = false;
				}
				
				
				if (shouldAddToPredicateRelevance)
				{
					newRuleRecord = new RuleRecord();
					infRule = new InfluenceRule();
					infRule.predicates.push(pred.clone());
					infRule.weight = (HOW_IMPORTANT_EFFECT_CONDITIONS_ARE / sg.getEffectByID(sgc.effectID).condition.length) as Number;
					newRuleRecord.influenceRule = infRule;
					newRuleRecord.initiator = sgc.initiator;
					newRuleRecord.responder = sgc.responder;
					newRuleRecord.other = sgc.other;
					newRuleRecord.type = RuleRecord.SOCIAL_GAME_TYPE;
					newRuleRecord.name = "sg effect condition";
					relevantRuleRecords.push(newRuleRecord);
					if (forRole == "responder")
					{
						// for some reason, I need to swap these... I'm not 100% sure why. But it works, OK?!?!
						newRuleRecord.influenceRule.reverseInitiatorAndResponderRoles();
					}
					if (newRuleRecord.influenceRule.weight < 0)
					{
						totalNegScore += newRuleRecord.influenceRule.weight;
						relevantNegRuleRecords.push(newRuleRecord);
					}
					else
					{
						totalPosScore += newRuleRecord.influenceRule.weight;
						relevantPosRuleRecords.push(newRuleRecord);
					}
					totalScore += newRuleRecord.influenceRule.weight;
				}
			}
			
			
			// at this point, relevantRuleRecords holds all the info we are interested in
			
			//now go through all relevantRuleRecords and break them into their predicate pieces (each as its own rule record)
			var uniquePredicateRuleRecords:Vector.<RuleRecord> = new Vector.<RuleRecord>();
			var presentInUniquePredicateRuleRecords:Boolean;
			var testPredRuleRecord:RuleRecord;
			var numIntents:int;
			for each (relevantRuleRecord in relevantRuleRecords)
			{
				//before we can determine the number of predicates in relevantRuleRecord, we need to know how many "intent" type preds to *not* include in the count
				numIntents = 0;				
				for each (var pred1:Predicate in relevantRuleRecord.influenceRule.predicates)
				{
					if (pred1.intent)
					{
						numIntents++;
					}
				}
				for each (pred in relevantRuleRecord.influenceRule.predicates)
				{
					presentInUniquePredicateRuleRecords = false
					if (!pred.intent) 
					{
						// do not count preds that are the "second half" of medium networks
						if (!(pred.comparator == Predicate.getCompatorByNumber(Predicate.LESSTHAN)
							&& pred.networkValue == 67))
						{
							//if this predicate has not been seen yet. To determine this, we need to go through all of uniquePredicateRuleRecords
							for each (ruleRecord in uniquePredicateRuleRecords)
							{
								// if we already that the record in uniquePredicateRuleRecords (which requires the other to be the same! We don't use RuleRecord.equals because the weights of the inf rules might not be the same)
								if (Predicate.equals(pred, ruleRecord.influenceRule.predicates[0]) && relevantRuleRecord.other == ruleRecord.other)
								{
									presentInUniquePredicateRuleRecords = true;
									//Debug.debug(this,"predRelevance() " + testPredRule.weight);
									ruleRecord.influenceRule.weight += relevantRuleRecord.influenceRule.weight / ((relevantRuleRecord.influenceRule.predicates.length - numIntents) as Number);
								}
							}
							if (!presentInUniquePredicateRuleRecords)
							{
								newRuleRecord = new RuleRecord();
								infRule = new InfluenceRule();
								infRule.predicates.push(pred.clone());
								infRule.weight = relevantRuleRecord.influenceRule.weight / ((relevantRuleRecord.influenceRule.predicates.length - numIntents) as Number);
								newRuleRecord.influenceRule = infRule;
								newRuleRecord.initiator = relevantRuleRecord.initiator;
								newRuleRecord.responder = relevantRuleRecord.responder;
								newRuleRecord.other = relevantRuleRecord.other;
								newRuleRecord.type = relevantRuleRecord.type;
								newRuleRecord.name = relevantRuleRecord.name;
								uniquePredicateRuleRecords.push(newRuleRecord);
							}
						}
					}
				}
			}
			
			totalScore = 0;
			var uniquePredicateRuleRecordsToReturn:Vector.<RuleRecord> = new Vector.<RuleRecord>();
			for each (ruleRecord in uniquePredicateRuleRecords)
			{
				if (forRole == "responder" && mode == "reject")
				{
					if (ruleRecord.influenceRule.weight < 0)
					{
						//if we are looking for responder reject rules, we want the highest negative
						ruleRecord.influenceRule.weight = Math.abs(ruleRecord.influenceRule.weight);
						uniquePredicateRuleRecordsToReturn.push(ruleRecord);
						totalScore += ruleRecord.influenceRule.weight;
					}
				}
				else if (ruleRecord.influenceRule.weight > 0)
				{
					uniquePredicateRuleRecordsToReturn.push(ruleRecord);
					totalScore += ruleRecord.influenceRule.weight;
				}
			}
			
			uniquePredicateRuleRecordsToReturn.sort(compPos);
			
			//now that we have the influence rules we need to normalize the weights.
			//Debug.debug(this, "getInitiatorPredicateRelevance() Relevance of Initiator Predicates for "+initiator.characterName+" playing "+sg.name+" with "+responder.characterName+":");
			for each (ruleRecord in uniquePredicateRuleRecordsToReturn)
			{
				ir = ruleRecord.influenceRule;
				ir.weight = Math.round(ir.weight / totalScore * 100);
			}

			return uniquePredicateRuleRecordsToReturn;
		}
		
		public function compPos(x:RuleRecord, y:RuleRecord):Number 
		{
			if (x.influenceRule.weight < y.influenceRule.weight)
			{
				return 1.0;
			}
			else if (x.influenceRule.weight > y.influenceRule.weight)
			{
				return -1.0;
			}
			else
			{
				return 0;
			}
		}
		public function compNeg(x:RuleRecord, y:RuleRecord):Number 
		{
			if (x.influenceRule.weight > y.influenceRule.weight)
			{
				return 1.0;
			}
			else if (x.influenceRule.weight < y.influenceRule.weight)
			{
				return -1.0;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Evaluates all the predicates of all the microtheories rules given a
		 * cast with the exclusion of intent predicates. The results are stored
		 * in the rule. This excludes the evaluation of all rules that require
		 * a thrid party.
		 * 
		 * @param	sg			The social game context
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 */
		
		public function scoreMicrotheoriesWithoutIntent(initiator:Character, responder:Character):void {
			var theory:Microtheory;
			var ir:InfluenceRule;
			var c:Character;
			
			
			for each (theory in this.microtheories) {
				for each(ir in theory.initiatorIRS.influenceRules) {
					if (ir.requiresThirdCharacter()) {
						//loop through all characters that are not I or R, determine truth, and score.
						for each (c in this.cast.characters) {
							if (c.characterName != initiator.characterName && c.characterName != responder.characterName) {
								if (ir.evaluateAllNonIntent(initiator, responder, c)) {
									ir.allButIntentTrue = true;
									ir.evaluatedWeight += ir.weight;
								}else {
									ir.allButIntentTrue = false;
									ir.evaluatedWeight = 0;
								}
							}
						}
					}else {
						if (ir.evaluateAllNonIntent(initiator, responder)) {
							ir.allButIntentTrue = true;
							ir.evaluatedWeight += ir.weight;
						}else {
							ir.allButIntentTrue = false;
							ir.evaluatedWeight = 0;
						}
					}
					//ir.allButIntentTrue = ir.evaluateAllNonIntent(initiator, responder);
				}
			}
		}
		
		
		public function inititializeMicrotheoryCache():void
		{
			this.microtheoryCache = new Dictionary();
		}
		
		
		/**
		 * Scores the initiator's influence rules including those rules 
		 * specifed in microtheories.
		 * 
		 * @param	sg			The social game context.
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 * @param	other		The other character.
		 * @return	The initiator's volitions score.
		 */
		public function scoreInitiatorWithMicrotheories(sg:SocialGame, initiator:Character, responder:Character, other:Character = null,otherCast:Vector.<Character> = null):Number {
			var totalScore:Number = 0.0;
			var theory:Microtheory;
			
			var ruleRecord:RuleRecord;
			
			var ir:InfluenceRule;
			var intentPred:Predicate;
			
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			/**
			 * When counting rules with others that could be true many times, 
			 * this variable will contain true if the rule was satisfied 1 time or more.
			 */
			var isTrue:Boolean = false;
			/**
			 * The total weight of a rule that could be true multiple times.
			 */
			var runningIRTotal:Number = 0.0;
			var currentMTScore:Number = 0.0;
			var c:Character;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			//Debug.debug(this, "scoreInitiatorWithMicrotheories() sg: " + sg.name);
			
			//Invalidate the previous microtheories' scores.
			//invalidateMicrotheories();
			var cacheIndex:String = initiator.characterName + responder.characterName + sg.intents[0].generateRuleName();
			var wentThroughMTs:Boolean = false;
			
			//score the microtheory for this intent if we haven't done so yet.
			//if (initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
			//{
				wentThroughMTs = true;
				for each(theory in this.microtheories) 
				{
					currentMTScore = 0.0;

					//if (other && theory.name == "Someone macking on your S.O." && sg.name == "Insult")
					//{
						//if (initiator.characterName == "Zack" && responder.characterName == "Buzz" && other.characterName == "Cassie")
						//{
							//Debug.debug(this,"scoreInitiatorWithMicrotheories() The spot I'm looking for.");
						//}
					//}
					
					
					if (theory.definition.evaluate(initiator, responder, other, sg)) 
					{
						//if (other && theory.name == "Someone macking on your S.O." && sg.name == "Insult")
						//{
							//if (initiator.characterName == "Zack" && responder.characterName == "Buzz" && other.characterName == "Cassie")
							//{
								//Debug.debug(this,"scoreInitiatorWithMicrotheories() The spot I'm looking for.");
							//}
						//}

						theory.initiatorIRS.lastScores = new Vector.<Number>();
						theory.initiatorIRS.lastTruthValues = new Vector.<Boolean>();
						
						/* 
						 * Here we decouple the intent of a microtheory rule from the other predicates
						 * to help reduce the number of evaluations we perform during intent formation.
						 */
						
						for each (ir in theory.initiatorIRS.influenceRules) 
						{
							var pass:Boolean = false; //allows the rule to pass if there's no intent
							var intentIndex:Number = ir.findIntentIndex();
							runningIRTotal = 0.0;
							
							if (intentIndex < 0) pass = true;
							else if (ir.predicates[intentIndex].evaluate(initiator, responder, other, sg)) pass = true;
							
							if (pass) 
							{
								//if the rule has not been evaluated sans intent predicate, do it now
								if (!ir.evaluated) {
									if (ir.requiresThirdCharacter()) {
										//third character required in a MT rule -- for each possible third party
										//in the cast, evaluate the rule and add the weight to the rule total if true.
										for each (c in possibleOthers) {
											if (c.characterName != initiator.characterName && c.characterName != responder.characterName) {
												if (ir.evaluateAllNonIntent(initiator, responder, c)) {
													ruleRecord = new RuleRecord();
													ruleRecord.type = RuleRecord.MICROTHEORY_TYPE;
													ruleRecord.name = theory.name;
													ruleRecord.influenceRule = ir.clone() as InfluenceRule;
													ruleRecord.initiator = initiator.characterName;
													ruleRecord.responder = responder.characterName;
													ruleRecord.other = c.characterName;
													initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
													ir.allButIntentTrue = true;
													ir.evaluatedWeight += ir.weight;
												}else {
													ir.allButIntentTrue = false;
													ir.evaluatedWeight = 0;
												}
											}
										}
									}else {
										//evaluateion sans intent predicate for no third character
										if (ir.evaluateAllNonIntent(initiator, responder)) {
											ruleRecord = new RuleRecord();
											ruleRecord.type = RuleRecord.MICROTHEORY_TYPE;
											ruleRecord.name = theory.name;
											ruleRecord.influenceRule = ir.clone() as InfluenceRule;
											ruleRecord.initiator = initiator.characterName;
											ruleRecord.responder = responder.characterName;
											initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
											ir.evaluatedWeight = ir.weight;
											ir.allButIntentTrue = true;
										}else {
											ir.evaluatedWeight = 0.0;
											ir.allButIntentTrue = false;
										}
									}
								}
								//at this point we have a rule with true intent and all non-intent predicates are true
								if (ir.allButIntentTrue) {
									runningIRTotal += ir.evaluatedWeight;
									theory.initiatorIRS.lastScores.push(runningIRTotal)
									theory.initiatorIRS.lastTruthValues.push(true);
								}else {
									//the intent is true but the conjunction of the other predicates is false
									theory.initiatorIRS.lastScores.push(0.0)
									theory.initiatorIRS.lastTruthValues.push(false);
								}
							} else {
								//the ir is false because the intent is false.
								theory.initiatorIRS.lastScores.push(0.0)
								theory.initiatorIRS.lastTruthValues.push(false);
							}

							totalScore += theory.initiatorIRS.lastScores[theory.initiatorIRS.lastScores.length - 1];
							
							// if the intent score cache hasn't bees set yet, set it to zero
							if (initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
							{
								initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = 0;
							}
							if (initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
							{
								initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = 0;
							}
							
							if (theory.initiatorIRS.lastScores[theory.initiatorIRS.lastScores.length - 1] >= 0)
							{
								initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] += theory.initiatorIRS.lastScores[theory.initiatorIRS.lastScores.length - 1]
							}
							else
							{
								initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] += theory.initiatorIRS.lastScores[theory.initiatorIRS.lastScores.length - 1]
							}
							
							currentMTScore += theory.initiatorIRS.lastScores[theory.initiatorIRS.lastScores.length - 1];
							
						}
						theory.lastScore = currentMTScore;
						theory.lastScoreValid = true;
						//Debug.debug(this, "scoreInitiatorWithMicrotheories() rescored currentMTScore: " + currentMTScore + " totalScore: " + totalScore + " truthCount: " + theory.initiatorIRS.truthCount);
					}
					else
					{
						theory.initiatorIRS.lastScores = new Vector.<Number>();
						theory.initiatorIRS.lastTruthValues = new Vector.<Boolean>();
						//fill the last truth values with all false
						for (var i:int = 0; i < theory.initiatorIRS.influenceRules.length; i++)
						{
							theory.initiatorIRS.lastScores.push(0.0);
							theory.initiatorIRS.lastTruthValues.push(false);
							theory.lastScore = 0.0;
							theory.lastScoreValid = true;
						}
						//Debug.debug(this, "scoreInitiatorWithMicrotheories() false currentMTScore: " + currentMTScore + " totalScore: " + totalScore);
					}	
				}
				if (useMicrotheoryCache)
				{
					//set the microtheory value into the prospective memory the the initiator
					if (totalScore > initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()])
					{
						initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = totalScore;
					}
					//this.microtheoryCache[cacheIndex] = totalScore;
				}
			//}

			//now that we've dealt with the MT, add the score of the SG
			if (useMicrotheoryCache)
			{
				totalScore = initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] + sg.getInitiatorScore(initiator, responder, other, sg);
				//totalScore = this.microtheoryCache[cacheIndex] + sg.getInitiatorScore(initiator, responder, other, sg);
				//totalScore = this.microtheoryCache[cacheIndex] + sg.getInitiatorScore(initiator, responder, other, sg);
			}
			else
			{
				totalScore += sg.getInitiatorScore(initiator, responder, other, sg);
			}
			return totalScore;
		}
		
		/**
		 * Scores the responders's influence rules including those rules 
		 * specifed in microtheories.
		 * 
		 * @param	sg			The social game context.
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 * @param	other		The other character.
		 * @return	The initiator's volitions score.
		 */
		public function scoreResponderWithMicrotheories(sg:SocialGame, initiator:Character, responder:Character, other:Character = null,otherCast:Vector.<Character> = null):Number {
			var totalScore:Number = 0;
			var theory:Microtheory;
			var ir:InfluenceRule;
			
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			/**
			 * When counting rules with others that could be true many times, 
			 * this variable will contain true if the rule was satisfied 1 time or more.
			 */
			var isTrue:Boolean = false;
			/**
			 * The total weight of a rule that could be true multiple times.
			 */
			var runningIRTotal:Number = 0.0;
			var c:Character;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//if the MT requires a third party and other is passed in as null, we need to pick a third character
			
			//var cacheIndex:String = initiator.characterName + responder.characterName + sg.name;
			var cacheIndex:String = initiator.characterName + responder.characterName + sg.intents[0].generateRuleName();
			//Debug.debug(this,"CacheString: " + cacheIndex);
			//if (!microtheoryCache[cacheIndex])
			if (initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
			{
				for each(theory in this.microtheories)
				{
					theory.responderIRS.lastScores = new Vector.<Number>();
					theory.responderIRS.lastTruthValues = new Vector.<Boolean>();
					//trace(theory.definition.evaluate(responder, initiator, other, sg) + " " + theory.name+" "+theory.definition.toString()+ " " + " from: " +responder.characterName + " to: "+initiator.characterName);
					
					
					// Only need to swap in the definition!
					if (theory.definition.evaluate(responder,initiator, other, sg)) 
					{	
						for each (ir in theory.responderIRS.influenceRules) {
							runningIRTotal = 0.0;
							isTrue = false;
							if (ir.requiresThirdCharacter()) {
								//loop through all characters that are not I or R, determine truth, and score.
								for each (c in possibleOthers) {
									if (c.characterName != initiator.characterName && c.characterName != responder.characterName) {
										if (ir.evaluate(initiator, responder,c, sg)) {
											runningIRTotal += ir.weight;
											isTrue = true;
										}
									}
								}
								theory.responderIRS.lastScores.push(runningIRTotal);
								theory.responderIRS.lastTruthValues.push(isTrue);
							}
							else if (ir.evaluate(initiator,responder, null, sg)) {
								runningIRTotal += ir.weight;
								theory.responderIRS.lastScores.push(runningIRTotal);
								theory.responderIRS.lastTruthValues.push(true);
								theory.responderIRS.truthCount += 1;
							}else {
								theory.responderIRS.lastScores.push(0.0);
								theory.responderIRS.lastTruthValues.push(false);
							}
							
							totalScore += theory.responderIRS.lastScores[theory.responderIRS.lastScores.length - 1];
							
							

							
							// if the intent score cache hasn't bees set yet, set it to zero
							if (initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
							{
								initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = 0;
							}
							if (initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] == ProspectiveMemory.DEFAULT_INTENT_SCORE)
							{
								initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = 0;
							}
							
							// add the weight of this true rule to the correct intent score cache
							if (theory.responderIRS.lastScores[theory.responderIRS.lastScores.length - 1] >= 0)
							{
								initiator.prospectiveMemory.intentPosScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] += theory.responderIRS.lastScores[theory.responderIRS.lastScores.length - 1]
							}
							else
							{
								initiator.prospectiveMemory.intentNegScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] += theory.responderIRS.lastScores[theory.responderIRS.lastScores.length - 1]
							}
						}
					}
					else
					{
						
						//fill the last truth values with all false
						for (var i:int = 0; i < theory.responderIRS.influenceRules.length; i++)
						{
							theory.responderIRS.lastScores.push(0.0);
							theory.responderIRS.lastTruthValues.push(false);
						}
					}
				}
				if (useMicrotheoryCache)
				{
					//this.microtheoryCache[cacheIndex] = totalScore;
					initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] = totalScore;
				}
			}			
			
			//score the game's rules
			//totalScore += sg.getResponderScore(initiator, responder, other, sg);
			if (this.useMicrotheoryCache)
			{
				//totalScore = this.microtheoryCache[cacheIndex] + sg.getResponderScore(initiator, responder, other, sg);
				
				totalScore = initiator.prospectiveMemory.intentScoreCache[responder.networkID][sg.intents[0].predicates[0].getIntentType()] + sg.getResponderScore(initiator, responder, other, sg);
				
			}
			else
			{
				totalScore += sg.getResponderScore(initiator, responder, other, sg);
			}
			
			return totalScore;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * Scores the responders's influence rules including those rules 
		 * specifed in microtheories.
		 * 
		 * @param	sg			The social game context.
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 * @param	other		The other character.
		 * @return	The initiator's volitions score.
		 */
		public function scoreResponderToPatsyWithMicrotheories(sg:SocialGame, initiator:Character, responder:Character, other:Character = null, otherCast:Vector.<Character> = null):Number {
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			var totalScore:Number = 0;
			var theory:Microtheory;

			var budUpIntentSG:SocialGame = new SocialGame();
			var intentRule:Rule = new Rule();
			var budUpPred:Predicate = new Predicate();
			budUpPred.intent = true;
			budUpPred.setNetworkPredicate("responder", "initiator", "+", 0, SocialNetwork.BUDDY);
			intentRule.predicates.push(budUpPred);
			budUpIntentSG.intents.push(intentRule);
			
			for each(theory in this.microtheories) 
			{
				//here is where some role reversal happens
				if (theory.definition.evaluate(responder, other, null, budUpIntentSG)) 
				{
					totalScore += theory.responderIRS.scoreRules(responder, other, null, budUpIntentSG);
				}
				else
				{
					theory.responderIRS.lastScores = new Vector.<Number>();
					theory.responderIRS.lastTruthValues = new Vector.<Boolean>();
					//fill the last truth values with all false
					for (var i:int = 0; i < theory.responderIRS.influenceRules.length; i++)
					{
						theory.responderIRS.lastScores.push(0.0);
						theory.responderIRS.lastTruthValues.push(false);
					}
				}
			}
			
			return totalScore;
		}
		
		/**
		 * Invalidates the last score of the microtheories.
		 * 
		 * This is used when the context of characters has change from the last
		 * time the microtheories were evaluated.
		 */
		public function invalidateMicrotheories():void {
			for each (var theory:Microtheory in this.microtheories) {
				theory.lastScore = 0.0;
				theory.lastScoreValid = false;
			}
		}
		
		
		/**********************************************************************
		 * Social game play.
		 *********************************************************************/		
		
		public function playGameByName(gameName:String, initiator:Character, responder:Character, other:Character = null, otherCast:Vector.<Character> = null):void 
		{
			var context:SocialGameContext = this.playGame(socialGamesLib.getByName(gameName), initiator, responder, other,otherCast);
		}
		
		public function playGame(sg:SocialGame, initiator:Character, responder:Character, other:Character = null, otherCast:Vector.<Character> = null, levelCast:Vector.<Character> = null, negateResponderScore:Boolean=false, acceptThreshold:int=0, responderBoost:int=0, forcedInstantiation:int=-1):SocialGameContext 
		{				
			//The fact that other was ever passed in at all is an artifact of cif from days long gone.  
			//NOW we figure out who the other is in THIS function, when we call 'getSalientOtherAndEffect'
			//Since other part of this function (playGame) depend on other being null, we are going
			//to just set it to null here explicitly (since passing in, say, an instantiated yet 'blank' character with no name
			//will cause issues and heartbreak).
			other = null; 
			
			if (!levelCast)
			{
				Debug.debug(this, "playGame() You need to pass in a level cast!!! ERROR!!!");
			}
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			//get responder IRS score
			var highestSaliencyEffect:Effect;
			//var highestSaliencyCount:int = -1;
			var socialGameContext:SocialGameContext = new SocialGameContext();
			var score:Number=0;
			//character itertator
			var char:Character;
			//keeps track of the maxiumum true IR rules of the IRSs ran to find
			//a third character.
			var maxTrueRuleCount:int = 0;
			var currentScore:Number = 0;
			//true if the game was accept, false if it was a reject
			var acceptGameIntent:Boolean = true;
			//iterator for finding the SFDB label predicates
			var pred:Predicate;
			
			//if no other was needed, go ahead and set the other as the one that the initiator used
			/*
			if (!trueOther)
			{
				for each (var gameScore:GameScore in initiator.prospectiveMemory.scores)
				{
					if (gameScore.responder.toLowerCase() == responder.characterName.toLowerCase()
						&& gameScore.name.toLowerCase() == sg.name.toLowerCase())
					{
						//Debug.debug(this,"************* True other being manually set to initiator's other");
						trueOther = this.cast.getCharByName(gameScore.other);
					}
				}
			}
			*/
			
			
			//if (sg.thirdPartyGetSomeoneToDoSomethingForYou)
			//{
				//FIXME Take the magic ratios outta here!!!
				//Debug.debug(this,"playGame() We aren't going in here are we?");
				//score = 0.7 * scoreResponderWithMicrotheories(sg, initiator, responder, trueOther, possibleOthers) + 0.3 * scoreResponderToPatsyWithMicrotheories(sg, initiator, trueOther, responder, possibleOthers);
			//}
			//else
			//{
			//score = scoreResponderWithMicrotheories(sg, initiator, responder, trueOther, possibleOthers);
			//}
			
			// get the responder score
			score = this.getResponderScore(sg, initiator, responder, possibleOthers);
			score += responderBoost;
			
			if (score >= acceptThreshold) acceptGameIntent = true;
			else acceptGameIntent = false;
			
			if (negateResponderScore) acceptGameIntent = !acceptGameIntent; //hee hee!  If they use a magic power, reverse whether the game is accepted or rejected!
			
			var otherAndEffect:Dictionary = this.getSalientOtherAndEffect(sg, acceptGameIntent, initiator, responder, possibleOthers, levelCast, forcedInstantiation);
			
			//var errorEvent:Error = new Error("StackTrace");
			//Debug.debug(this, "playGame() " + errorEvent.getStackTrace());
			
			
			//the other to use when all cases of other being passed in and a
			//third character being needed when one is not provided.
			var trueOther:Character;
			//determine if we need to find a third character
			if (!other && sg.thirdForSocialGamePlay()) {
				trueOther = otherAndEffect["other"];
			}else {
				trueOther = other;
			}
			
			//TODO: sort of a hack. I want this in GameEngine... this is part of separating playGame and changeSocialState
			this.lastResponderOther = trueOther;
			
			// this is ineffiicient because we are looking through all others and all effects again (which we already did above in getSalientOther)
			// want to return other and effect in getSalientOther, but you can't... fix later!
			highestSaliencyEffect = otherAndEffect["effect"];//this.getSalientEffect(sg, acceptGameIntent, initiator, responder, trueOther);

			//TODO: CRASHES HERE IF THE GAME DOESN"T USE CKB!!!
			if (highestSaliencyEffect.hasCKBReference()) {
				socialGameContext.chosenItemCKB = pickAGoodCKBObject(initiator, responder, trueOther, highestSaliencyEffect.getCKBReferencePredicate());
			}
			
			socialGameContext.gameName = sg.name;
			
			socialGameContext.effectID = highestSaliencyEffect.id;
			socialGameContext.initiator = initiator.characterName;
			socialGameContext.responder = responder.characterName;
			
			
			//Debug.debug(this, "changeSocialState() highest saliency effect: " + highestSaliencyEffect.toString());
			//Debug.debug(this, "changeSocialState() hasSFDBLabel: " + highestSaliencyEffect.hasSFDBLabel());

			if (highestSaliencyEffect.hasSFDBLabel()) {
				//Debug.debug(this, "changeSocialState() highestSaliencyEffect.change: " + highestSaliencyEffect.change.toString()); 
				for each (pred in highestSaliencyEffect.change.predicates) {
					//Debug.debug(this, "changeSocialState() change has SFDBLabel. Predicate considered: " + pred.toString());
					if (Predicate.SFDBLABEL == pred.type) {
						var label:SFDBLabel = new SFDBLabel();
						label.to = pred.secondaryCharacterNameFromVariables(initiator, responder, trueOther);
						label.from = pred.primaryCharacterNameFromVariables(initiator, responder, trueOther);
						label.type = SocialFactsDB.getLabelByNumber(pred.sfdbLabel);
						socialGameContext.SFDBLabels.push(label);
						//Debug.debug(this, "changeSocialState() adding a SFDBLabel to the SocialGameContext: " + label.toString()); 
					}
				}
				
				//TODO look for all labels and create the label data structures and add them to the context
				//var sfdbPred:Predicate = highestSaliencyEffect.getSFDBLabelPredicate();
				//socialGameContext.label = SocialFactsDB.getLabelByNumber(sfdbPred.sfdbLabel);
				//socialGameContext.labelArg1 = getCharacterFromRole(sfdbPred.primary,initiator,responder,trueOther);
				//if (sfdbPred.secondary)
				//{
					//socialGameContext.labelArg2 = getCharacterFromRole(sfdbPred.secondary,initiator,responder,trueOther);
				//}
			}
			
			//if(other)
			socialGameContext.other = (trueOther)?trueOther.characterName:"";
			socialGameContext.time = this.time;
			
			if(socialGameContext.gameName != "FORECAST") //only score games for the initiator that don't have anything to do with forecasts.
				socialGameContext.initiatorScore = initiator.prospectiveMemory.getGameScoreByGameName(sg.name,responder).score;
			socialGameContext.responderScore = score;

			return socialGameContext;
		}
		
		
		public function changeSocialState(socialGameContext:SocialGameContext,otherCast:Vector.<Character> = null):void
		{
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			
			var char:Character;
			
			var sg:SocialGame = this.socialGamesLib.getByName(socialGameContext.gameName);
			var highestSaliencyEffect:Effect = sg.getEffectByID(socialGameContext.effectID);
			
			var initiator:Character = this.cast.getCharByName(socialGameContext.initiator);
			var responder:Character = this.cast.getCharByName(socialGameContext.responder);
			var other:Character = this.cast.getCharByName(socialGameContext.other);
			
			highestSaliencyEffect.change.valuation(initiator, responder, other);
			
			//set the last seen time to now so that it won't be used again very soon
			highestSaliencyEffect.lastSeenTime = this.time;
			
			this.sfdb.addContext(socialGameContext);
			
			//update all of the status to be one turn older now that we've chosen salient effects
			//in other words, the status lives "through" this spot in cif.time
			//and new statuses are not decremented yet, as they start on the next time step.
			for each (char in possibleOthers) 
			{
				//for now, just update the possible others (i.e. people whoa ren't present don't change)
				for each (var status:Status in char.statuses) 
				{
					if (status.remainingDuration <= 1) 
					{
						//var sc:StatusContext = new StatusContext();
						var pred:Predicate = new Predicate();
						pred.setStatusPredicate(char.characterName, status.directedToward, status.type, true);
						var directedToward:Character = this.cast.getCharByName(status.directedToward);
						pred.valuation(char, directedToward);
						
						var statusContext:StatusContext = new StatusContext();
						statusContext.time = this.time;
						statusContext.negated = true;
						statusContext.statusType = status.type;
						statusContext.to = this.cast.getCharByName(status.directedToward);
						statusContext.from = char;
						this.sfdb.addContext(statusContext);
						
						//make a trigger context for this change in state
						//var trigger:Trigger = new Trigger();
						//trigger.id = Trigger.STATUS_TIMEOUT_TRIGGER_ID;
						//var changeRule:Rule = new Rule();
						//changeRule.predicates.push(pred);
						//var triggerContext:TriggerContext = trigger.makeTriggerContext(this.time, char, directedToward, null);
						//triggerContext.statusTimeoutChange = changeRule
						//this.sfdb.addContext(triggerContext);
					}
				}
				
				//decrement status counters of all players
				char.updateStatusDurations(1);
			}
			
			//now that we have changed the state, updated statuses, we should run the triggers
			//for now, triggers will happen *at the same cif time* as the change that caused them to trigger
			//
			//NOTE: I think the status.remainingTime should not be updated until after this call, to be consistent, but
			// that would require not updating the status.time's that were made the case from triggers and.... well, no. Not now.
			// the down side to this is that some statuses will have been made no more, that should probably be considered in the triggers
			this.sfdb.runTriggers(possibleOthers);
			//this.sfdb.runTriggers();
			
			//if (CONFIG::InstrumentRules) {
				//Debug.debug(this, "changeState() instrumented rule print: " + InstrumentedInfluenceRule.ruleHistoryToString());
				//Debug.debug(this, "changeState() instrumented rule MT dump: " + InstrumentedInfluenceRule.dumpMicrotheoryStatesToXML("Kate", "Nicholas"));
			//}
			
			//increment system time after the context has been added
			this.time++;
		}
		
		
		
		
		public function getCharacterFromRole(roleName:String, initiator:Character, responder:Character, other:Character):String
		{
			if (roleName == "initiator")
			{
				return initiator.characterName;
			}
			else if (roleName == "responder")
			{
				return responder.characterName;
			}
			else if (roleName == "other")
			{
				return other.characterName;
			}
			else
			{
				Debug.debug(this, "getCharacterFromRole() roleName does not match a role")
				return "";
			}
		}
		
		
		
		
		public function getSalientOtherAndEffect(sg:SocialGame, accepted:Boolean, initiator:Character, responder:Character, otherCast:Vector.<Character> = null, levelCast:Vector.<Character> = null, forcedInstantiationID:int=-1):Dictionary 
		{
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			if (!levelCast)
			{
				levelCast = possibleOthers;
			}
			
			var possibleSalientEffects:Vector.<Effect> = new Vector.<Effect>(); 
			var possibleSalientOthers:Vector.<Character> = new Vector.<Character>(); 
			
			var char:Character;
			var castMember:Character;
			var castMemberPresent:Boolean = false;
			
			var instantiation:Instantiation;
			
			var genericEffect:Effect; // used to store a generic effect, just to make sure that we have ONE option!
			
			
			//find all valid effects
			//--make sure to go through all others
			for each (var effect:Effect in sg.effects)
			{
				if (effect.isAccept == accepted)
				{
					if (effect.condition.predicates.length == 0) genericEffect = effect; // store the generic effect for later, just in case we need it.
					//only look at this effect if we don't care about forcing an instantiation, OR if we do force an instantiation, this effect matches the forced instantiation id.
					if( forcedInstantiationID == -1 || effect.instantiationID == forcedInstantiationID){
						if (effect.requiresThirdCharacter())
						{
							for each (char in possibleOthers)
							{
								castMemberPresent = false;
								if (char.characterName != initiator.characterName && char.characterName != responder.characterName)
								{
									//make sure the character is in the level if the instantiation requires him to be
									instantiation = sg.getInstantiationById(effect.instantiationID);
									if (instantiation.requiresOtherToPerform())
									{
										//See if the other is in the level
										for each (castMember in levelCast) 
										{
											if (castMember.characterName == char.characterName) 
											{
												castMemberPresent = true; // we found a match!
											}
										}
									}
									else
									{
										castMemberPresent = true;
									}
									
									//if we have passed the check that the character is in the level (or it doesn't matter if they are or not)
									if (castMemberPresent)
									{
										/*
										if (effect.instantiationID == 27) {
											Debug.debug(this, "Dealing with 'prom carol' debugging... should be the 'reminisce' first act");
										}
										*/
										//check to see if this i,r,o group satisfies the condition
										if (effect.condition.evaluate(initiator, responder, char,sg))
										{
											possibleSalientEffects.push(effect);
											possibleSalientOthers.push(char);
										}
									}
								}
							}
						}
						else
						{
							// this is the case where we don't care about the other
							if (effect.condition.evaluate(initiator, responder,null,sg))
							{
								possibleSalientEffects.push(effect);
								possibleSalientOthers.push(null);
							}					
						}
					}
				}
			}
			
			if (forcedInstantiationID != -1 && possibleSalientEffects.length == 0) {
				// if we got here, then we WANT to force an instantiation BUT we somehow screwed up and the effect conditions of the instantiation are no longer true.
				//In this case, just use the generic effect that we stored for this very purpose!
				possibleSalientEffects.push(genericEffect);
				possibleSalientOthers.push(null);
			}
			
			//go through all valid effects and choose the ones that have the highest salience score
			//at this point, we know all effects and others are valid
			var mostSalientOther:Character;
			var mostSalientEffect:Effect;
			var maxSaliency:int = -1000;
			var mostSalientOthers:Vector.<Character>;
			var mostSalientEffects:Vector.<Effect>;
			for (var i:int = 0; i < possibleSalientEffects.length; i++ )
			{
				//Debug.debug(this, "" + sg.name + " effect id is: " + possibleSalientEffects[i].id + " and is linked to instantiation: " + possibleSalientEffects[i].instantiationID + " score was: " + possibleSalientEffects[i].salienceScore);
				possibleSalientEffects[i].scoreSalience();
				//Debug.debug(this, "Same thing after score salience: Social game: " + sg.name + " effect id is: " + possibleSalientEffects[i].id + " and is linked to instantiation: " + possibleSalientEffects[i].instantiationID + " score was: " + possibleSalientEffects[i].salienceScore);
				if (maxSaliency < possibleSalientEffects[i].salienceScore)
				{
					maxSaliency = possibleSalientEffects[i].salienceScore;
					mostSalientEffect = possibleSalientEffects[i];
					mostSalientOther = possibleSalientOthers[i];
					mostSalientOthers = new Vector.<Character>();
					mostSalientOthers.push(possibleSalientOthers[i]);
					mostSalientEffects = new Vector.<Effect>();
					mostSalientEffects.push(possibleSalientEffects[i]);
				}
				else if (maxSaliency == possibleSalientEffects[i].salienceScore)
				{
					mostSalientOthers.push(possibleSalientOthers[i]);
					mostSalientEffects.push(possibleSalientEffects[i]);
				}
			}
			
			var randomIndex:int = Util.randRange(0, mostSalientEffects.length - 1);
			
			var returnDictionary:Dictionary = new Dictionary();
			returnDictionary["effect"] = mostSalientEffects[randomIndex];//mostSalientEffect;
			returnDictionary["other"] = mostSalientOthers[randomIndex];//mostSalientOther;
			return returnDictionary;
		}
		
		
		/**
		 * Returns a third character that makes the highest number of effect
		 * condition predicates evalute true.
		 * @param	sg			The social game to reason over.
		 * @param 	accepted	Whether the game was accepted or rejected
		 * @param	initiator	The character in the initiator role.
		 * @param	responder	The character in the responder role.
		 * @return	The most salient other.
		 */
		/*
		public function getSalientOtherAndEffect(sg:SocialGame, accepted:Boolean, initiator:Character, responder:Character, otherCast:Vector.<Character> = null, levelCast:Vector.<Character> = null):Dictionary 
		{
			var possibleOthers:Vector.<Character> = (otherCast)?otherCast:this.cast.characters;
			
			var char:Character;
			var trueOther:Character;
			var currentScore:int;
			var maxSaliency:int = -1000;
			var score:int;
			var salientEffect:Effect;
			
			var instantiation:Instantiation;
			var castMember:Character			
			var castMemberPresent:Boolean = false;
			var mostSalientEffect:Effect;
			
			if (!sg.thirdForSocialGamePlay())
			{
				salientEffect = getSalientEffect(sg, accepted, initiator, responder);
				
				if (maxSaliency < salientEffect.salienceScore)
				{
					maxSaliency = salientEffect.salienceScore;
					mostSalientEffect = salientEffect;
				}
			}
			else
			{
				for each (char in possibleOthers) 
				{
					castMemberPresent = false;
					if (!((char.characterName.toLowerCase() == initiator.characterName.toLowerCase())
						|| (char.characterName.toLowerCase() == responder.characterName.toLowerCase())))
					{
						salientEffect = getSalientEffect(sg, accepted, initiator, responder, char);
						instantiation = sg.getInstantiationById(salientEffect.instantiationID);
						
						if (maxSaliency < salientEffect.salienceScore)
						{
							//Check to see if the instantiation we are conisdering requires that the other is present in the level
							if (instantiation.requiresOtherToPerform())
							{
								//See if the other is in the level
								for each (castMember in levelCast) 
								{
									if (castMember.characterName == char.characterName) {
										castMemberPresent = true; // we found a match!
									}
								}
								if (castMemberPresent)
								{
									//update most awesome effect and other because other is in the level
									maxSaliency = salientEffect.salienceScore;
									trueOther = char;
									mostSalientEffect = salientEffect;
								}
							}
							else
							{
								//This is if the other doesn't have to be in the level
								maxSaliency = salientEffect.salienceScore;
								trueOther = char;
								mostSalientEffect = salientEffect;
							}
						}
					}
				}
			}
			
			var returnDictionary:Dictionary = new Dictionary();
			returnDictionary["effect"] = mostSalientEffect;
			returnDictionary["other"] = trueOther;
			return returnDictionary;
		}
		*/
		/**
		 * Returns the effect with the highest saliency given a social game
		 * and full character parameterization
		 * @param	sg			The social game containing the Effects to check.
		 * @param	initiator	The initiator.
		 * @param	responder	The responder.
		 * @param	other		The other.
		 * @return	Highest saliency effect.
		 */
		public function getSalientEffect(sg:SocialGame, accepted:Boolean, initiator:Character, responder:Character, other:Character=null):Effect {
			var highestSaliencyCount:int = -1;
			var highestSaliencyNumber:int = -100000;
			var highestSaliencyEffect:Effect;
			
			for each(var e:Effect in sg.effects) {
				if (e.evaluateCondition(initiator, responder, other) && e.isAccept == accepted) 
				{
					//Debug.debug(this, "playGame(): condition true for effect: " + e.id + " " + e.toString());
					e.scoreSalience();
					if (e.salienceScore >= highestSaliencyNumber) {
						
						//Debug.debug(this, "getSalientEffect() Highest " +e.condition.length+" "+ e.toString());
						highestSaliencyNumber = e.salienceScore;
						//highestSaliencyCount = e.condition.length;
						highestSaliencyEffect = e;
					}
				}
				//Debug.debug(this, "getSalientEffect() effect id "+e.id);
			}
			if(!highestSaliencyEffect)
				Debug.debug(this, "getSalientEffect() the social game had no effects when looking for the most salient effect. social game name: " + sg.name, 1);
			return highestSaliencyEffect;
		}
		
		/**
		 * Smartly chooses a CKB object from those specified by the parameterized
		 * characters and CKBENTRY predicate.
		 * @param	initiator		The character in the role of initiator.
		 * @param	responder		The character in the role of responder.
		 * @param	ckbPredicate	The CKBENTRY type Predicate holding the 
		 * constraints on sought-after CKB objects.
		 * @return	The name of the chosen CKB object.
		 */
		public function pickAGoodCKBObject(initiator:Character, responder:Character, other:Character, ckbPredicate:Predicate):String {
			var first:Character = this.cast.getCharByName(ckbPredicate.primaryCharacterNameFromVariables(initiator, responder, other));
			var second:Character = this.cast.getCharByName(ckbPredicate.secondaryCharacterNameFromVariables(initiator, responder, other));
			var potentialCKBObjects:Vector.<String> = ckbPredicate.evalCKBEntryForObjects(first, second);
			//return a randon one for now.
			var ckbIndex:Number = Math.floor(Math.random() * potentialCKBObjects.length);
			
			//Debug.debug(this,"pickAGoodCKBObject() ckbIndex: " + ckbIndex + " howMany: " + potentialCKBObjects.length);
			
			return potentialCKBObjects[ckbIndex];
		}
		
		/**********************************************************************
		 * Performance Realization
		 *********************************************************************/
		 
		public function instantiationFromContext(context:SocialGameContext):Instantiation {
			var sg:SocialGame = this.socialGamesLib.getByName(context.gameName);
			var instantiationID:Number = sg.getEffectByID(context.effectID).instantiationID;
			return sg.getInstantiationById(instantiationID);
		}

		/**
		 * Maps the string representations of the role-generic (aka still have
		 * tags) to a vector of locutions -- prepping the dialog for performance
		 * realization.
		 */
		public function prepareLocutions():void {
			for each (var sg:SocialGame in socialGamesLib.games) {
				for each (var e:Effect in sg.effects)
				{
					//Debug.debug(this, "prepareLocutions() "+e.referenceAsNaturalLanguage);
					e.locutions = Util.createLocutionVectors(e.referenceAsNaturalLanguage);
				}
				for each (var inst:Instantiation in sg.instantiations) {
					//deals with ToC's
					inst.toc1.locutions = Util.createLocutionVectors(inst.toc1.rawString);
					inst.toc2.locutions = Util.createLocutionVectors(inst.toc2.rawString);
					inst.toc3.locutions = Util.createLocutionVectors(inst.toc3.rawString);
										
					for each (var lod:LineOfDialogue in inst.lines) {
						//Debug.debug(this, "prepareLocutions() for game " + sg.name);
						lod.initiatorLocutions = Util.createLocutionVectors(lod.initiatorLine);
						lod.responderLocutions = Util.createLocutionVectors(lod.responderLine);
						lod.otherLocutions = Util.createLocutionVectors(lod.otherLine);
						//Debug.debug(this, "prepareLocutions(): initiatior loction count for line: " + lod.initiatorLocutions.length);
					}
				}
			}
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		 
		/**
		 * Virtual setter for time.
		 */
		public function set time(t:int):void {
			//var e:Error = new Error();
			//Debug.debug(this, "set time() time=" + t + " " + e.getStackTrace());
			this._time = t;
		}
		 
		/**
		 * Virtual getter for time.
		 */
		public function get time():int {
			return this._time;
		}
		
		/**
		 * Seaches the microtheories in CiF and tries to find a name match.
		 * @param	name	The name to search for.
		 * @return	A matching Microtheory or null if no match is found.
		 */
		public function getMicrotheoryByName(name:String):Microtheory {
			for each (var theory:Microtheory in this.microtheories) {
				if (theory.name.toLowerCase() == name.toLowerCase()) {
					return theory;
				}
			}
			return null;
		}
		
		/**
		 * Finds the index of a microtheory of a certain name.
		 * @param	name	The name to search for.
		 * @return	The index of the matching microtheory or -1 if no match.
		 */
		public function getMicrotheoryIndexByName(name:String):int{
			var i:uint = 0;
			for (i = 0; i < this.microtheories.length; ++i) {
				if (name.toLowerCase() == this.microtheories[i].name.toLowerCase()) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * Resets CiF's data structures to a default state.
		 */
		public function defaultState():void {
			//Populate the cast with some defaults for test purposes.
			
			this.cast.characters = new Vector.<Character>();
			var robert:Character  = new Character();
			var karen:Character = new Character();
			var lily:Character = new CiF.Character();

			//var cast:Cast = Cast.getInstance();
			robert.setName( "Robert" );
			karen.setName("Karen");
			lily.setName("Lily");

			robert.networkID = 0;
			karen.networkID = 1;
			lily.networkID = 2;
			
			this.cast.addCharacter(robert);
			this.cast.addCharacter(karen);
			this.cast.addCharacter(lily);
			
			//set traits
			
			//Debug.debug(this, "hi");
			
			this.relationshipNetwork.initialize(this.cast.characters.length);
			this.buddyNetwork.initialize(this.cast.characters.length);
			this.romanceNetwork.initialize(this.cast.characters.length);
			this.coolNetwork.initialize(this.cast.characters.length);
			
			//add some social games to the social game library
			
			var traitPred:Predicate;
			var relationshipPred:Predicate;
			var statusPred:Predicate;
			var ckbPred:Predicate;
			var networkPred:Predicate;
			var sfdbPred:Predicate;
			
			var brag:SocialGame = new SocialGame();
			traitPred = new Predicate();
			relationshipPred = new Predicate();
			statusPred = new Predicate();
			ckbPred = new Predicate();
			networkPred = new Predicate();
			sfdbPred = new Predicate();
			
			traitPred.setTraitPredicate("initiator", Trait.CONFIDENT, false);
			networkPred.setNetworkPredicate("initiator", "responder", "greaterthan", 40, SocialNetwork.BUDDY);
			ckbPred.setCKBPredicate("initiator", "responder", "likes", "dislikes", "cool");
			relationshipPred.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.DATING, true);
			
			
			//add some social games to the social game library
			
			
			brag.name = "Brag";
			var p:Predicate = new Predicate();
			
			/*
			var r2:Rule = new Rule();
			var r3:Rule = new Rule();
			var r4:Rule = new Rule();
			var r5:Rule = new Rule();
			*/
			
			//preconditions
			//<Predicate type="SFDB label" first="initiator" second="initiator" label="cool" negated="false" isSFDB="true" window="0"/>
			var r:Rule = new Rule();
			p.setSFDBLabelPredicate("initiator", "initiator", SocialFactsDB.COOL);
			r.predicates.push(p.clone());
			brag.preconditions.push(r.clone());
			
			/*
			p.setTraitPredicate("initiator", Trait.CONFIDENCE);
			r.predicates.push(p.clone());
			brag.preconditions.push(r.clone());
			*/
			
			/*
			p.setTraitPredicate("initiator", Trait.ATTENTIONHOG);
			r2.predicates.push(p.clone());
			brag.preconditions.push(r2.clone());
			*/
			
			/*
			p.setNetworkPredicate("initiator", "responder", "greaterthan", 39);
			r3.predicates.push(p.clone());
			brag.preconditions.push(r3.clone());
			*/
			
			/*
			p.setNetworkPredicate("initiator", "responder", "lessthan", 40, SocialNetwork.BUDDY, true);
			r4.predicates.push(p.clone());
			brag.preconditions.push(r4.clone());
			*/
			
			/*
			p.setTraitPredicate("initiator", Trait.HUMBLE, true);
			r5.predicates.push(p.clone());
			brag.preconditions.push(r.clone());
			*/
			
			
			//initiator IRS
			var ir:InfluenceRule = new InfluenceRule();
			
			p.setTraitPredicate("initiator", Trait.CONFIDENT);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = 20;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			
			p.setTraitPredicate("initiator", Trait.ATTENTION_HOG);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = 10;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			
			p.setNetworkPredicate("initiator", "responder", "greaterthan", 39, SocialNetwork.BUDDY);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = 10;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			
			p.setNetworkPredicate("initiator", "responder", "lessthan", 40, SocialNetwork.BUDDY);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = -10;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			
			p.setTraitPredicate("initiator", Trait.HUMBLE);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = -20;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			
			
			trace("-------------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			
			//RESPONDER INFUENCE RULE SET
			p.setTraitPredicate("initiator", Trait.SMOOTH_TALKER);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = 20;
			brag.responderIRS.influenceRules.push(ir.clone());
			
			ir = new InfluenceRule();
			p.setNetworkPredicate("responder", "initiator", "greaterthan", 39);
			ir.predicates.push(p.clone());
			ir.weight = 10;
			brag.responderIRS.influenceRules.push(ir.clone());
			
			p.setTraitPredicate("responder", Trait.HUMBLE);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = -30;
			brag.responderIRS.influenceRules.push(ir.clone());
			
			ir = new InfluenceRule();
			//p.setStatusPredicate("responder", Status.getStatusNameByNumber(Status.JEALOUS));
			p.setStatusPredicate("responder", "initiator", Status.ENVIES);
			ir.predicates.push(p.clone());
			ir.weight = -20;
			brag.responderIRS.influenceRules.push(ir.clone());

			//EFFECTS
			var e:Effect = new Effect();
			e.isAccept = true;
			p.setNetworkPredicate("responder", "initiator", "+", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			e.id = 1;
			e.referenceAsNaturalLanguage = "%i% bragged about pizza";
			brag.effects.push(e.clone());
			
			/**
			 * effect with SFDBLABEL in it:
			 * II::Accept&&YwasAPartOftheCoolAct(X)->CoolUp(Y->X)&&BuddyUp(Y->X)
			 */
			
			e = new Effect();
			e.isAccept = false;
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			e.id = 3;
			e.referenceAsNaturalLanguage = "%i% was not so cool at %CKB_((i,dislikes),(r,dislikes),(mean))%";
			brag.effects.push(e.clone());
			
			e = new Effect();
			e.isAccept = false;
			e.condition.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			e.change.predicates.push(p.clone());
			e.id = 4;
			e.referenceAsNaturalLanguage = "%r% was jealous about %ip% %CKB_((i,dislikes),(r,dislikes),(mean))%";
			brag.effects.push(e.clone());
			
			e = new Effect();
			e.isAccept = false;
			p.setTraitPredicate("responder", Trait.HUMBLE);
			e.condition.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.BUDDY);
			e.change.predicates.push(p.clone());
			e.id = 5;
			e.referenceAsNaturalLanguage = "%i% was totally humble about %CKB_((i,dislikes),(r,dislikes),(mean))%";
			brag.effects.push(e.clone());
			
			//instantiations
			//I(Flavorless Accept)
			
			var inst:Instantiation = new Instantiation();
			var lod:LineOfDialogue = new LineOfDialogue();
			inst.id = 1;
			
			lod.lineNumber = 0;
			lod.initiatorLine = "Hey %r%";
			lod.responderLine = "";
			lod.otherLine = "";
			lod.primarySpeaker = "initiator";
			lod.initiatorBodyAnimation = "accuse";
			lod.initiatorFaceAnimation = "happy";
			lod.responderBodyAnimation = "accuse";
			lod.responderFaceAnimation = "happy";
			lod.otherBodyAnimation = "accuse";
			lod.otherFaceAnimation = "happy";
			lod.time = 5;
			lod.initiatorIsThought = false;
			lod.responderIsThought = false;
			lod.otherIsThought = false;
			lod.initiatorIsPicture = false;
			lod.responderIsPicture = false;
			lod.otherIsPicture = false;
			lod.initiatorAddressing = "responder";
			lod.responderAddressing = "initiator";
			lod.otherAddressing = "initiator";
			lod.isOtherChorus = false;

			inst.lines.push(lod);
			
			var lod1:LineOfDialogue = new LineOfDialogue();
			lod1.lineNumber = 1;
			lod1.initiatorLine = "";
			lod1.responderLine = "Oh, hi %i%";
			lod1.otherLine = "";
			lod1.primarySpeaker = "initiator";
			lod1.initiatorBodyAnimation = "accuse";
			lod1.initiatorFaceAnimation = "happy";
			lod1.responderBodyAnimation = "accuse";
			lod1.responderFaceAnimation = "happy";
			lod1.otherBodyAnimation = "accuse";
			lod1.otherFaceAnimation = "happy";
			lod1.time = 5;
			lod1.initiatorIsThought = false;
			lod1.responderIsThought = false;
			lod1.otherIsThought = false;
			lod1.initiatorIsPicture = false;
			lod1.responderIsPicture = false;
			lod1.otherIsPicture = false;
			lod1.initiatorAddressing = "responder";
			lod1.responderAddressing = "initiator";
			lod1.otherAddressing = "initiator";
			lod1.isOtherChorus = false;
			
			inst.lines.push(lod1);
			
			var lod2:LineOfDialogue = new LineOfDialogue();
			lod2.lineNumber = 2;
			lod2.initiatorLine = "How's it going?";
			lod2.responderLine = "";
			lod2.otherLine = "";
			lod2.primarySpeaker = "initiator";
			lod2.initiatorBodyAnimation = "accuse";
			lod2.initiatorFaceAnimation = "happy";
			lod2.responderBodyAnimation = "accuse";
			lod2.responderFaceAnimation = "happy";
			lod2.otherBodyAnimation = "accuse";
			lod2.otherFaceAnimation = "happy";
			lod2.time = 5;
			lod2.initiatorIsThought = false;
			lod2.responderIsThought = false;
			lod2.otherIsThought = false;
			lod2.initiatorIsPicture = false;
			lod2.responderIsPicture = false;
			lod2.otherIsPicture = false;
			lod2.initiatorAddressing = "responder";
			lod2.responderAddressing = "initiator";
			lod2.otherAddressing = "initiator";
			lod2.isOtherChorus = false;
			
			inst.lines.push(lod2);
			
			var lod3:LineOfDialogue = new LineOfDialogue();
			lod3.lineNumber = 3;
			lod3.initiatorLine = "";
			lod3.responderLine = "Good.  What did you do this weekend?";
			lod3.otherLine = "";
			lod3.primarySpeaker = "initiator";
			lod3.initiatorBodyAnimation = "accuse";
			lod3.initiatorFaceAnimation = "happy";
			lod3.responderBodyAnimation = "accuse";
			lod3.responderFaceAnimation = "happy";
			lod3.otherBodyAnimation = "accuse";
			lod3.otherFaceAnimation = "happy";
			lod3.time = 5;
			lod3.initiatorIsThought = false;
			lod3.responderIsThought = false;
			lod3.otherIsThought = false;
			lod3.initiatorIsPicture = false;
			lod3.responderIsPicture = false;
			lod3.otherIsPicture = false;
			lod3.initiatorAddressing = "responder";
			lod3.responderAddressing = "initiator";
			lod3.otherAddressing = "initiator";	
			lod3.isOtherChorus = false;
			
			inst.lines.push(lod3);
			
			var lod4:LineOfDialogue = new LineOfDialogue();
			lod4.lineNumber = 4;
			lod4.initiatorLine = "Just a %SFDB_(i, cool)%";
			lod4.responderLine = "";
			lod4.otherLine = "";
			lod4.primarySpeaker = "initiator";
			lod4.initiatorBodyAnimation = "accuse";
			lod4.initiatorFaceAnimation = "happy";
			lod4.responderBodyAnimation = "accuse";
			lod4.responderFaceAnimation = "happy";
			lod4.otherBodyAnimation = "accuse";
			lod4.otherFaceAnimation = "happy";
			lod4.time = 5;
			lod4.initiatorIsThought = false;
			lod4.responderIsThought = false;
			lod4.otherIsThought = false;
			lod4.initiatorIsPicture = false;
			lod4.responderIsPicture = false;
			lod4.otherIsPicture = false;
			lod4.initiatorAddressing = "responder";
			lod4.responderAddressing = "initiator";
			lod4.otherAddressing = "initiator";
			lod4.isOtherChorus = false;
			
			inst.lines.push(lod4);
			
			var lod5:LineOfDialogue = new LineOfDialogue();
			lod5.lineNumber = 5;
			lod5.initiatorLine = "";
			lod5.responderLine = "Oh wow! That's amazing! I didn't even know you could even do that!  That sounds awesome!";
			lod5.otherLine = "";
			lod5.primarySpeaker = "initiator";
			lod5.initiatorBodyAnimation = "accuse";
			lod5.initiatorFaceAnimation = "happy";
			lod5.responderBodyAnimation = "accuse";
			lod5.responderFaceAnimation = "happy";
			lod5.otherBodyAnimation = "accuse";
			lod5.otherFaceAnimation = "happy";
			lod5.time = 5;
			lod5.initiatorIsThought = false;
			lod5.responderIsThought = false;
			lod5.otherIsThought = false;
			lod5.initiatorIsPicture = false;
			lod5.responderIsPicture = false;
			lod5.otherIsPicture = false;
			lod5.initiatorAddressing = "responder";
			lod5.responderAddressing = "initiator";
			lod5.otherAddressing = "initiator";
			lod5.isOtherChorus = false;
				
			inst.lines.push(lod5);
			
			
			inst.id = 1;
			brag.instantiations.push(inst.clone());
			
			
			
			//II (Accept with better results)
		
			//III (Reject flavorless)
			
			//IV (Based in Jealousy)
			
			//V(Reject based on humility)
			
			
			//Debug.debug(this, "bye");
			
			
			//Add our game to the social games library!
			//this.socialGamesLib.addGame(brag);
			
			//SFDB
			//p.setStatusPredicate("Edward", "Karen", Status.HAS_A_CRUSH_ON);
			//var sc:StatusContext = new StatusContext();
			//sc.time = 0;
			//sc.predicate = p.clone();
			//this.sfdb.contexts.push(sc);
			
			
			
		}
		
		/**
		 * Clears all CiF data structures.
		 */
		public function clear():void {
			this.cast.characters = new Vector.<Character>();
			this.resetNetworks();
			this.microtheories = new Vector.<Microtheory>();
			this.socialGamesLib.games = new Vector.<SocialGame>();
			this.ckb.propsSubjective = new Vector.<Proposition>();
			this.ckb.propsTruth = new Vector.<Proposition>();
			this.sfdb.contexts = new Vector.<SFDBContext>();
			
			//Maybe this belongs somewhere else, such as default, or in individual test cases.
			/*
			var robert:Character = new Character();
			var karen:Character = new Character();
			var lily:Character = new Character();
			
			var cast:Cast = Cast.getInstance();
			this.cast.characters.push(robert);
			this.cast.characters.push(karen);
			this.cast.characters.push(lily);
			*/
			
		}
		
		public function toString():String {
			//trace( Util.variablesToString(this));
			return "cif, yo!";
		}
		
		public function toXMLString():String {
			var xmlString:String = "";
			xmlString += this.cast.toXMLString();
			xmlString += this.sfdb.toXMLString();
			xmlString += this.buddyNetwork.toXMLString();
			xmlString += this.coolNetwork.toXMLString();
			xmlString += this.romanceNetwork.toXMLString();
			//xmlString += this.statusNetwork.toXMLString();
			xmlString += this.relationshipNetwork.toXMLString();
			xmlString += "<Microtheories>\n";
			for each (var mt:Microtheory in this.microtheories)
				xmlString += mt.toXMLString();
			xmlString += "</Microtheories>\n";	
			xmlString += this.socialGamesLib.toXMLString();
			xmlString += this.ckb.toXMLString();
			xmlString = "<CiFState time=" + (sfdb.getLatestContextTime() + 1) +">\n" + xmlString + "\n</CiFState>";
			xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" + xmlString;
			return xmlString;
		}

		public function librariesToXMLString():String {
			var xmlString:String = "";
			xmlString += this.socialGamesLib.toXMLString();
			xmlString += "<Microtheories>\n";
			for each (var mt:Microtheory in this.microtheories)
				xmlString += mt.toXMLString();
			xmlString += "</Microtheories>\n";	
			
/*			xmlString += "<Triggers>\n";
			for each (var trigger:Trigger in this.sfdb.triggers)
				xmlString += trigger.toXMLString();
			xmlString += "</Triggers>\n";
			xmlString += "<StoryTriggers>\n";
			for each (var storyTrigger:Trigger in this.sfdb.storyTriggers)
				xmlString += storyTrigger.toXMLString();
			xmlString += "</StoryTriggers>\n";*/
			
			xmlString = "<CiFLibraries>\n" + xmlString + "\n</CiFLibraries>";
			xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" + xmlString;
			return xmlString;
		}
		
		public function stateToXMLString():String {
			var xmlString:String = "";
			xmlString += this.cast.toXMLString();
			xmlString += this.sfdb.toXMLString();
			xmlString += this.buddyNetwork.toXMLString();
			xmlString += this.coolNetwork.toXMLString();
			xmlString += this.romanceNetwork.toXMLString();
			xmlString += this.relationshipNetwork.toXMLString();
			xmlString += this.ckb.toXMLString();
			xmlString = "<CiFState>\n" + xmlString + "\n</CiFState>";
			xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" + xmlString;
			return xmlString;
		}
		
		public function toXML():XML {
			return new XML(this.toXMLString());
			//var xmlString:String = "";
			//xmlString += this.cast.toXMLString();
			//xmlString += this.sfdb.toXMLString();
			//xmlString += this.buddyNetwork.toXMLString();
			//xmlString += this.coolNetwork.toXMLString();
			//xmlString += this.romanceNetwork.toXMLString();
			//xmlString += this.statusNetwork.toXMLString();
			//xmlString += this.relationshipNetwork.toXMLString();
			//xmlString += this.microtheories
			//xmlString += this.socialGamesLib.toXMLString();
			//xmlString += this.ckb.toXMLString();
			//xmlString = "<CiFState>\n" + xmlString + "\n</CiFState>";
			//xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" + xmlString;
			//return new XML(xmlString);
		}
		
		public function printXMLString():void {
			/*
				this.cast = Cast.getInstance();
				this.sfdb = SocialFactsDB.getInstance();
				this.buddyNetwork = BuddyNetwork.getInstance();
				this.coolNetwork = CoolNetwork.getInstance();
				this.romanceNetwork = RomanceNetwork.getInstance();
				this.statusNetwork = StatusNetwork.getInstance();
				this.relationshipNetwork = RelationshipNetwork.getInstance();
				this.socialGamesLib = SocialGamesLib.getInstance();
				this.ckb = CulturalKB.getInstance();
				*/
				Debug.debug(this, this.cast.toXMLString());
				Debug.debug(this, this.sfdb.toXMLString());
				Debug.debug(this, this.buddyNetwork.toXMLString());
				Debug.debug(this, this.coolNetwork.toXMLString());
				Debug.debug(this, this.romanceNetwork.toXMLString());
				//Debug.debug(this, this.statusNetwork.toXMLString());
				Debug.debug(this, this.relationshipNetwork.toXMLString());
				Debug.debug(this, this.socialGamesLib.toXMLString());
				Debug.debug(this, this.ckb.toXMLString());
		}
		
		/**
		 * This is an exact duplicate of the parseCiFState local function from
		 * getStateFromXML(). Instead of loading the xml from an external via
		 * URLLoaders, we'll let MXML do the heavy lifting by creating a fx:XML
		 * object in the fx:Declarations tag. 
		 * @param	cifInput
		 * @param	append		True if any of the additive, authored parts of CiF
		 * are to be appended to existing entries. False removes existing content
		 * and then adds only content in cifInput.
		 */
		public function parseCiFState(cifInput:XML, append:Boolean=true):void {
			this.time = (cifInput.@time.toString().length > 0) ? cifInput.@time: 0;
			var cifComponents:XMLList = cifInput.children();
			for each (var component:XML in cifComponents) {
				if (component.name() == "Cast") {
					this.cast = Cast.getInstance();
					
					if (!append || !this.cast.characters)
						this.cast.characters = new Vector.<Character>();
					
					ParseXML.castParse(component);
					
					//var castMembers:XMLList = component.children();
					//for each(var person:XML in castMembers) { // go through every character		
						//this.cast.characters.push(ParseXML.characterParse(person).clone());
					//}
					//Debug.debug(this, "The Cast Has Been Parsed!:\n" + this.cast.toXMLString());
				}
				
				else if (component.name() == "Microtheories") {
					
					if (!append || !this.microtheories) {
						Debug.debug(this, "parseCiFState() nuking mts.");
						this.microtheories = new Vector.<Microtheory>();
					}
					ParseXML.microtheoryParse(component);
					//Debug.debug(this, "parseCiFState() Microtheories have been parsed: " + this.microtheories[0].toXMLString());
				}
				
				else if (component.name() == "SFDB") {
					this.sfdb = SocialFactsDB.getInstance();
					if (!append || !this.sfdb.contexts)
						this.sfdb.contexts = new Vector.<SFDBContext>();
					var sfdbContexts:XMLList = component.children();
					for each(var context:XML in sfdbContexts) {
						//Debug.debug(this, "parseCiFState() SFDB component. current sfdb context: " + context.toXMLString());
						var c:SFDBContext = ParseXML.SFDBContextParse(context);
						if(c)
							this.sfdb.addContext(c);
					}
					
					//Debug.debug(this, "parseCiFState() SFDB component. Parsed components: " + this.sfdb.toXMLString());
					
					this.sfdb.contexts.sort(this.sfdb.sortDescendingTime);
				
					
					/*for (var k:int = 0; k < sfdb.contexts.length; k++) {
						//trace ("inside the for loop");
						if (sfdb.contexts[k].isSocialGame() == true) 
						{
							//trace ("inside the if statement");
							//trace(sfdb.contexts[k].toXMLString());
						}
					}*/
					
					
						//Debug.debug(this, "The SFDB Has Been Parsed!:\n" + this.sfdb.toXMLString());
				}
				
				else if (component.name() == "Triggers") {
					//Debug.debug(this, "parseCiFState() trigger xml to parse: " + component.toXMLString());
					this.sfdb.triggers = ParseXML.parseTriggers(component);
					//Debug.debug(this, "parseCiFState() triggers have been parsed!");
				}
				
				else if (component.name() == "Network") {
					if (component.attribute("type") == "buddy") {
						ParseXML.buddyNetworkParse(component);
						//this.buddyNetwork = BuddyNetwork.getInstance();
						//Debug.debug(this, "The Buddy Network Has Been Parsed!:\n" + this.buddyNetwork.toXMLString());
					}
					if (component.attribute("type") == "cool") {
						ParseXML.coolNetworkParse(component);
						//this.coolNetwork = CoolNetwork.getInstance();
						//Debug.debug(this, "The Cool Network Has Been Parsed!:\n" + this.coolNetwork.toXMLString());
					}
					if (component.attribute("type") == "romance") {						
						ParseXML.romanceNetworkParse(component);
						//this.romanceNetwork = RomanceNetwork.getInstance();
						//Debug.debug(this, "The Romance Network Has Been Parsed!:\n" + this.romanceNetwork.toXMLString());
					}
				}
				
				else if (component.name() == "Statuses") {
					ParseXML.statusesParse(component);
				}
				
				else if (component.name() == "Relationships") {
					ParseXML.relationshipNetworkParse(component);
					//this.relationshipNetwork = RelationshipNetwork.getInstance();
					//Debug.debug(this, "The Relationship Network Has Been Parsed!:\n" + this.relationshipNetwork.toXMLString());
				}
				
				else if (component.name() == "SocialGameLibrary") {
					this.socialGamesLib = SocialGamesLib.getInstance();
					if (!append || !this.socialGamesLib.games)
						this.socialGamesLib.games = new Vector.<SocialGame>();
					
					ParseXML.addGameToLibrary(component); // This function is oddly named... it actually adds ALL games to library.
					
					//Debug.debug(this, "The Social Game Library has been parsed!\n" + this.socialGamesLib.toXMLString());
				}
				
				else if (component.name() == "CulturalKB") {
					this.ckb = CulturalKB.getInstance();
					if (!append || !this.ckb.propsSubjective)
						this.ckb.propsSubjective = new Vector.<Proposition>();
					if (!append || !this.ckb.propsTruth)
						this.ckb.propsTruth = new Vector.<Proposition>();
					
					ParseXML.loadCKBXML(component);
					
					//Debug.debug(this, "The Cultural KB has been parsed!\n" + this.ckb.toXMLString());
				}
				
				else { // ran into something that I don't think we should have!
					Debug.debug(this, "MYSTERY COMPONENT? WHAT THE HECK ARE YOU?");
					Debug.debug(this, component.name());
				}
			}
			
			
		}
		
		/**
		 * getStateFromXML() will take an XML file and fill in all of CiF's major data structures (SocialNetworks, SFDB, CKB, the Cast, and Social Games).
		 * @param	url	The URL of the state or library xml file.
		 */
		public function getStateFromXMLfile(url:String):void {
			
			var xmlLoader:URLLoader = new URLLoader();
			var xmlData:XML = new XML();
			
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest(url));
			
			
			function LoadXML(e:Event):void {
				xmlData = new XML(e.target.data);
				parseCiFState(xmlData);
				Debug.debug(this, "getStateFromXMLfile: loaded file from " + url + ".");
				//var cif:CiFSingleton = CiFSingleton.getInstance();
				//cif.printXMLString();
			}
		}
	}

}