package CiF 
{
	/**
	 * The GameScore class holds the results of a social game score by a
	 * potential initiator for a potentional responder. This class is meant to
	 * be used by a character's prospective memory to store that character's
	 * intent to play varios social games. 
	 * 
	 * <p>This class consists of the name of the game scored, the name of the
	 * initiator, the name of the responder and the score assigned to the 
	 * characters/game combination.</p>
	 * 
	 * @see CiF.ProspectiveMemory
	 */
	public class GameScore
	{
		/**
		 * The name of the scored social game.
		 */
		public var name:String;
		/**
		 * The name of the potential initiator.
		 */
		public var initiator:String;
		/**
		 * The name of the potential responder.0
		 */
		public var responder:String;
		/**
		 * The name of the potential other.
		 */
		public var other:String;
		/**
		 * The score assigned to the initiator/responder/game combination.
		 */
		public var score:Number;
		
		public function GameScore() {
			this.name = "";
			this.initiator = "";
			this.responder = ""
			this.other = "";
			this.score = 0;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toString():String {
			return "CiF::GameScore: " + this.name + " " + this.initiator + " " + this.responder + " " + this.other + " " + this.score;
		}	
		
		public function toXMLString():String {
			return "<GameScore name=\"" + name + "\" initiator=\"" + initiator + "\" responder=\"" + responder + "\" other=\"" + other + "\" score=\"" + score + "\" />";
		}	
		
		public function clone(): GameScore {
			var g:GameScore = new GameScore();
			g.name = this.name;
			g.initiator = this.initiator;
			g.responder = this.responder;
			g.other = this.other;
			g.score = this.score;
			return g;
		}
		
		public static function equals(x:GameScore, y:GameScore): Boolean {
			if (x.name != y.name) return false;
			if (x.initiator != y.initiator) return false;
			if (x.responder != y.responder) return false;
			if (x.other != y.other) return false;
			if (x.score != y.score) return false;
			return true;
		}
	}
}