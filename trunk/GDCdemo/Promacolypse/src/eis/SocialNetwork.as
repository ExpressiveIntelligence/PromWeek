package eis
{
	import flash.events.WeakFunctionClosure;
	/**
	 * ...
	 * @author Ben*
	 * This is Version 0.2 of a SocialNetwork, a bi-directional graph.
	 * As of 1/28/2010, the intended goal of a SocialNetwork is to 
	 * represent degrees of a given relationship between all of the
	 * characters in the game space -- each node representing a character
	 * and each edge representing the strength of the given relationship.
	 * Example relationships might be general "friendship", "romantic interest"
	 * or "authenticity/respect."
	 * 
	 */
	public class SocialNetwork
	{
		public static const RELATIONSHIP:int 	= 1;
		public static const ROMANCE:int			= 2;
		public static const AUTHENTICITY:int 	= 3;
		
		/** ------------ Constructor ----------
		*Builds a SocialNetwork, represented by a two dimensional associative array
		* The first index represents the character who holds the opinion. The second
		* index represents the character that the opinion is about.  The value is
		* is the actual weight.  It accepts the total number of characters in the game
		* as input.
		* */
		public function SocialNetwork(numChars:int) 
		{
			network = new Array(numChars); 
			var i:int;
			var j:int;
			for (i = 0; i < numChars; i++) {
				network[i] = new Array(numChars);
				for (j = 0; j < numChars; j++) {
						network[i][j] = 0;
				}
			}
		}
		
	
		// --------------- Properties -----------
		public var network:Array;
		//public var network:Vector.<CharacterNode> = new Vector.<CharacterNode>();
		
		// --------------- Methods --------------
		/**
		 * setWeight
		 * INPUT: char1 -- the ID of the starting node, char2 -- ID of the end node,
		 *        weight -- the amount the weight should change by
		 * POSTCONDITION: The edge from char1 to char2 has changed by weight amount.
		 */
		public function setWeight(char1:int, char2:int, weight:int):void {
			var numEdges:int = network.length;
			network[char1][char2] = weight;
		}
		
		public function addWeight(weight:int, char1:int, char2:int):void {
			network[char1][char2] += weight;
			if (network[char1][char2] > 100) {
				network[char1][char2] = 100;
			}
			if (network[char1][char2] < 0) {
				network[char1][char2] = 0;
			}
			
		}
		
		/**
		 * getWeight
		 * INPUT: char1 -- ID of char who has opinions, char2 -- ID of char who is recipient,
		 * POSTCONDITION: returns the weight from char1 to char2
		 */
		public function getWeight(char1:int, char2:int):int {
			return network[char1][char2];
		}
		
		/**
		 * getAverageOpinion
		 * Returns the average weight of every character in the space towards the selected individual
		 * INPUT: char -- the id character to receive the average opinion of
		 * POSTCONDITION: returns the average opinion.
		 */
		public function getAverageOpinion(charID:int):int {
			var opinionTotal:int = 0;
			var numChars:int = network.length;
			for (var i:int = 0; i < numChars; i++) {
				if (i != charID) {
					opinionTotal += network[i][charID];
				}
			}
			return (opinionTotal / (numChars - 1)); // charID's opinion does not count!
		}
		
		/**
		 * getRelationshipsAboveThreshold returns a vector of ints, representing the characterIDs
		 * of the characters with whom charID has weight with higher than the threshold. This is good
		 * if you want a list of high relationships between an individual.
		 * @param	charID The character who has the relationships
		 * @param	threshold The threshold that must be passed for the relationship to be added
		 */
		public function getRelationshipsAboveThreshold(charID:int, threshold:int):Vector.<int> {
			var idsAboveThreshold:Vector.<int> = new Vector.<int>;
			for (var i:int = 0; i < network.length; i++) {
				if ( i != charID) { // don't look at yourself
					if (network[charID][i] > threshold)
						idsAboveThreshold.push(i);
				}
			}
			return idsAboveThreshold;
		}
		
		/**
		 * toString
		 * Simply returns a string representation of the social network.
		 */
		public function toString():void {
			var i:int;
			var j:int;
			var output:String;
			output = "\nCurrent Values of this Social Net: \n";
			for (i = 0; i < network.length; i++) {
				for (j = 0; j < network.length; j++) {
					if(i != j)
						output += "\nCharacter " + i + " has " + network[i][j] + " weight towards character " + j;
					else
						output += "\nCharacter does not have affinity for themself";
					
				}
				output += "\n";
			}
			trace(output);
		}
	}
}