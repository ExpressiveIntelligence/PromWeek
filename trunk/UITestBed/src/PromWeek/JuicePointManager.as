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
		//private var gameEngine:GameEngine;
		private var cif:CiFSingleton;
		
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
		
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION:int = 35; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_STRONG:int = 35; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_MEDIUM:int = 25; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_REL_WEAK:int = 20; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_WEAK:int = 15; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_MEDIUM:int = 20; // shift clicking on a social game.
		public const COST_FOR_OPPOSITE_RESPONDER_REACTION_NET_STRONG:int = 25; // shift clicking on a social game.
		public const COST_FOR_NON_TOP_SOCIAL_GAME:int = 10; // picking a social game from the drop down menu.
		public const COST_FOR_UNLOCKING_RESPONDER_MOTIVE:int = 6;
		public const COST_FOR_UNLOCKING_SG_OUTCOME:int = 15;
		public const COST_FOR_UNLOCKING_FORECAST:int = 5;
		
		public static function getInstance():JuicePointManager {
			return _instance;
		}
		
		//Change Response
		public function activateOppositeResponderReaction(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext, isFreebie:Boolean = false):Boolean 
		{
			return true;
		}
		
		
		//Question mark
		public function handleResponderMotiveUnlock(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext):Boolean 
		{
			return true;
		}
		
		
		public function handleOutcomeUnlock(initName:String, respondName:String, whichGame:String, sgc:SocialGameContext):Boolean {
			return true;
		}
		
		public function getCostForSwitchOutcome(sgc:SocialGameContext):Number
		{
			return 30;
		}
		
		
		public function handleNonTopSocialGameSelection(juiceCost:int, init:String, respond:String, game:String):Boolean {
			return true;
		}
		
		public function computeJuicePointCostOfNonTopSG(highestScoredGame:int, thisVolition:int):int 
		{
			return 20;
		}
	}

}