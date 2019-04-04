package PromWeek 
{
	import CiF.Character;
	import CiF.Predicate;
	import CiF.Rule;
	import CiF.SFDBContext;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class DifficultyContext implements SFDBContext 
	{
		/**
		 * What they changed the difficulty FROM. Comes from Difficulty Manager
		 */
		public var oldDifficultyID:int;
		/**
		 * What they changed the difficulty TO. Comes from Difficulty manager.
		 */
		public var newDifficultyID:int;
		
		/**
		 * The new initiator volition threshold -- games must be above this score in order to appear
		 * within the social game button ring.
		 */
		public var newInitiatorVolitionThreshold:int;
		
		/**
		 * The new responder 'volition threshold' AKA responder accept threshold.  The responder's score
		 * must be above this value for the game to be 'accepted'
		 */
		public var newResponderVolitionThreshold:int;
		
		/**
		 * This is how much bonus volition a character will have for wanting to play social games that satisfy 
		 * campaign goals.
		 */
		public var newInitiatorGoalBoost:int;
		 
		/**
		 * This is a multiplier that additional affects how much the initiator wants to play games that satisfy
		 * campaign goals. e.g. if you want to date someone popular, you get a bonus for wanting to date EVERYONE
		 * in general, but you get an extra bonus for wanting to date someone who is already popular. This 'extra bonus'
		 * is encapsulated into this multiplier.
		 */
		public var newInitiatorGoalBoostMultiplier:Number;
		
		/**
		 * In addition to the accept threshold changing, if the game satisfies a campaign goal, responders will be
		 * more inclined to just want to accept these games in general.
		 */
		public var newResponderAcceptGoalBoost:int;
		
		public var time:int;
		
		public static var order:int = 0;
		private var order:int;	
		
		public function DifficultyContext() 
		{
			this.order = DifficultyContext.order++;
		}
		
		public function getChange():Rule { return null; }
		
		public function getTime():int { return this.time; }
		
		public function isSocialGame():Boolean { return false; }
		
		public function isJuice():Boolean { return false; }
		
		public function isTrigger():Boolean { return false; }
		
		public function isDifficulty():Boolean { return true; }
		
		public function isStatus():Boolean { return false; }
		
		public function isPredicateInChange(p:Predicate, x:Character, y:Character, z:Character):Boolean
		{
			return false;
		}
		
		public function toXML():XML 
		{
			
			var outXML:XML;
			outXML = < DifficultyContext oldDifficultyID = { this.oldDifficultyID } 
				newDifficultyID = { this.newDifficultyID } 
				newInitiatorVolitionThreshold = { this.newInitiatorVolitionThreshold } 
				newResponderVolitionThreshold = { this.newResponderVolitionThreshold } 
				newInitiatorGoalBoost = { this.newInitiatorGoalBoost }
				newInitiatorGoalBoostMultiplier = { this.newInitiatorGoalBoostMultiplier }
				newResponderAcceptGoalBoost = {this.newResponderAcceptGoalBoost }
				order = { this.order } 
				time={this.time}  /> ;

			
			return outXML;
		}

		public function toXMLString():String 
		{
			return this.toXML().toXMLString();
		}
		
		
		public function loadFromXML(difficultyContextXML:XML):SFDBContext
		{
			var difficultyContext:DifficultyContext = new DifficultyContext();
			difficultyContext.oldDifficultyID = (difficultyContextXML.@oldDifficultyID.toString())?difficultyContextXML.@oldDifficultyID: -1;
			difficultyContext.newDifficultyID = (difficultyContextXML.@newDifficultyID.toString())?difficultyContextXML.@newDifficultyID: -1;
			difficultyContext.newInitiatorVolitionThreshold = (difficultyContextXML.@newInitiatorVolitionThreshold.toString())?difficultyContextXML.@newInitiatorVolitionThreshold: -1;
			difficultyContext.newResponderVolitionThreshold = (difficultyContextXML.@newResponderVolitionThreshold.toString())?difficultyContextXML.@newResponderVolitionThreshold: -1;
			difficultyContext.newInitiatorGoalBoost = (difficultyContextXML.@newInitiatorGoalBoost.toString())?difficultyContextXML.@newInitiatiorGoalBoost: -1;
			difficultyContext.newInitiatorGoalBoostMultiplier = (difficultyContextXML.@newInitiatorGoalBoostMultiplier.toString())?difficultyContextXML.@newInitiatorGoalBoostMultiplier: -1;
			difficultyContext.newResponderAcceptGoalBoost = (difficultyContextXML.@newResponderAcceptGoalBoost.toString())?difficultyContextXML.@newResponderAcceptGoalBoost: -1;
			difficultyContext.order = (difficultyContextXML.@order.toString())?difficultyContextXML.@order: -1;
			difficultyContext.time = (difficultyContextXML.@time.toString())?difficultyContextXML.@time: -1;

			return difficultyContext;
		}
		
		
	}

}