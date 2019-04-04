package CiF 
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * Character specific prosespective memory. This needs to be cleared each round.
	 */
	public class ProspectiveMemory
	{
		public var scores:Vector.<GameScore>;
		
		/**
		 * Vector of all rules that evaluated to true while forming intent
		 */
		public var ruleRecords:Vector.<RuleRecord>;
		
		public var responseSGRuleRecords:Vector.<RuleRecord>;
		
		/**
		 * A two dimensional array where intentScoreCache[x][y] where x is a character id and y refers to the intent id
,		 * 
		*/
		public var intentScoreCache:Array;
		public var intentPosScoreCache:Array;
		public var intentNegScoreCache:Array;
		
		public var cif:CiFSingleton = CiFSingleton.getInstance();
		
		public static const DEFAULT_INTENT_SCORE:Number = -1000;
		
		
		public function ProspectiveMemory() {
			this.scores = new Vector.<GameScore>();
			this.ruleRecords = new Vector.<RuleRecord>();
			this.responseSGRuleRecords = new Vector.<RuleRecord>();
			this.initializeIntentScoreCache();
		}
		
		/**
		 * Initializes the intentCache, which is what stores the total score for an intent
		 * This is used for both performace increases and for the network line length calculations
		 * 
		 */
		public function initializeIntentScoreCache():void 
		{
			var numChars:int = cif.cast.characters.length;
			this.intentScoreCache = new Array(numChars);
			this.intentPosScoreCache = new Array(numChars);
			this.intentNegScoreCache = new Array(numChars);
			var i:int;
			var j:int;
			for (i = 0; i < numChars; i++) 
			{
				this.intentScoreCache[i] = new Array(Predicate.NUM_INTENT_TYPES);
				this.intentPosScoreCache[i] = new Array(Predicate.NUM_INTENT_TYPES);
				this.intentNegScoreCache[i] = new Array(Predicate.NUM_INTENT_TYPES);
				for (j = 0; j < Predicate.NUM_INTENT_TYPES; j++) 
				{
					this.intentScoreCache[i][j] = new Number(ProspectiveMemory.DEFAULT_INTENT_SCORE);
					this.intentPosScoreCache[i][j] = new Number(ProspectiveMemory.DEFAULT_INTENT_SCORE);
					this.intentNegScoreCache[i][j] = new Number(ProspectiveMemory.DEFAULT_INTENT_SCORE);
				}
			}
		}
		
		public function getIntentScore(typeOfIntent:int, responder:Character):Number
		{
			return this.intentScoreCache[responder.networkID][typeOfIntent];
		}
		
		
		/**
		 * Returns the higested scored games in prospective memory.
		 * 
		 * @param	count The number of the highest scored games to return.
		 * @return The highest scored games.
		 */
		public function getHighestGameScores(count:Number = 5) : Vector.<GameScore> {
			if (this.scores.length < count) count = this.scores.length;
			return this.scores.sort(this.scoreCompare).slice(0, count);
		}
		

		/**
		 * Returns the game score object that corresponds to the gameName given
		 * 
		 * @param	gameName
		 * @return
		 */
		public function getGameScoreByGameName(gameName:String,responder:Character):GameScore
		{
			for each (var gs:GameScore in this.scores)
			{
				if (gs.name == gameName && gs.responder == responder.characterName)
				{
					return gs;
				}
			}
			return null;
		}
		
		
		/**
		 * Searches the prospective memory for the highest game scores WRT
		 * another character.
		 * @param	charName	The name of the other character.
		 * @param	count		The number of game scores to return.
		 * @return	The returned scores.
		 */
		public function getHighestGameScoresTo(charName:String, count:Number = 5, minVolition:Number = -9999):Vector.<GameScore> {
			var scoresTo:Vector.<GameScore> = new Vector.<GameScore>();
			var counted:int = 0;
			for each (var score:GameScore in this.scores) 
			{
				if ((score.responder.toLowerCase() == charName.toLowerCase()) && score.score >= minVolition) {
					scoresTo.push(score);
					counted++;
				}
			}
			return scoresTo.sort(this.scoreCompare).slice(0, (counted < count)?counted:count);
		}
		
		private function scoreCompare(x:GameScore, y:GameScore):Number {
			return y.score - x.score;
		}
		
		public function clone(): ProspectiveMemory {
			var pm:ProspectiveMemory = new ProspectiveMemory();
			pm.scores = new Vector.<GameScore>();
			for each(var g:GameScore in this.scores) {
				pm.scores.push(g.clone());
			}

			
			var numChars:int = this.intentScoreCache.length;
			pm.intentScoreCache = new Array(numChars); 
			var i:int;
			var j:int;
			for (i = 0; i < numChars; i++) 
			{
				pm.intentScoreCache[i] = new Array(this.intentScoreCache[i].length);
				for (j = 0; j < this.intentScoreCache[i].length; j++) 
				{
					pm.intentScoreCache[i][j] = this.intentScoreCache[i][j];
					pm.intentPosScoreCache[i][j] = this.intentPosScoreCache[i][j];
					pm.intentNegScoreCache[i][j] = this.intentNegScoreCache[i][j];
				}
			}
			
			
			
			
			return pm;
		}
	
		public function toString():String {
			var result:String = "Prospective Memory\n"
			for each (var g:GameScore in this.scores) {
				result += "\t" + g.toString() + "\n";
			}
			
			return result;
		}
		
		public static function equals(x:GameScore, y:GameScore): Boolean {
			if (x.name != y.name) return false;
			if (x.initiator != y.initiator) return false;
			if (x.responder != y.responder) return false;
			if (x.score != y.score) return false;
			return true;
		}
	}
}

