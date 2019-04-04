package CiF
{
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
		/**
		 * The number of distinct social networks.
		 */
		public static const NETWORK_COUNT:Number = 3;
		 
		public static const BUDDY:Number 	= 0;
		public static const ROMANCE:Number	= 1;
		public static const COOL:Number 	= 2;
		
		public static const DEFAULT_NETWORK_VALUE:Number = 40;
		public static const DEFAULT_BUDDY_VALUE:Number = 40;
		public static const DEFAULT_ROMANCE_VALUE:Number = 20;
		public static const DEFAULT_COOL_VALUE:Number = 40;
		
		public var type:Number;
		
		public static var minRange:Number = 0;
		public static var maxRange:Number = 100;
		
		// --------------- Properties -----------
		public var network:Array;
		//public var network:Vector.<CharacterNode> = new Vector.<CharacterNode>();
		
		/** ------------ Constructor ----------
		*Builds a SocialNetwork, represented by a two dimensional associative array
		* The first index represents the character who holds the opinion. The second
		* index represents the character that the opinion is about.  The value is
		* is the actual weight.  It accepts the total number of characters in the game
		* as input.
		* */
		public function SocialNetwork() 
		{

		}
		
		/**
		 * Returns a string representation of the name of the network type.
		 * 
		 * @param	networkType	The number of the network type.
		 * @return	The String translation of the network type or the empty
		 * string if the networkType argument does not correspond to a network
		 * type value.
		 */
		public static function getNameFromType(networkType:Number):String {
			switch (networkType) {
				case SocialNetwork.BUDDY:
					return "buddy";
				case SocialNetwork.ROMANCE:
					return "romance";
				case SocialNetwork.COOL:
					return "cool";
				default:
					return "";
			}
		}
		
		public static function setRange(min:Number, max:Number):void {
			minRange = min;
			maxRange = max;
		}
		
		/**
		 * Returns the Number representation of a network type given a the name
		 * of the network type as a String.
		 * 
		 * @param	name	The name of the network type.
		 * @return The Number translation of the network type name string or -1
		 * if the string did not correspond to a network type name.
		 */
		public static function getTypeFromName(name:String):Number {
			switch (name.toLowerCase()) {
				case "buddy":
					return SocialNetwork.BUDDY;
				case "romance":
					return SocialNetwork.ROMANCE;
				case "cool":
					return SocialNetwork.COOL;
				default:
					return -1;
			}
		}
		
		/**
		 * Initializes the SocialNetwork's properties given the number of
		 * characters in the social network.
		 * 
		 * @param	numChars The number of characters to be included in the
		 * SocialNetwork.
		 */
		public function initialize(numChars:int):void {
			network = new Array(numChars); 
			var i:int;
			var j:int;
			for (i = 0; i < numChars; i++) {
				network[i] = new Array(numChars);
				for (j = 0; j < numChars; j++) {
						//network[i][j] = 0;
						//this.network[i][j] = new Number(Util.randRange(DEFAULT_NETWORK_VALUE - 10, DEFAULT_NETWORK_VALUE + 10));
						//this.network[i][j] = new Number(DEFAULT_NETWORK_VALUE);
						if (this.type == SocialNetwork.BUDDY)
						{
							this.network[i][j] = SocialNetwork.DEFAULT_BUDDY_VALUE;
						}
						else if (this.type == SocialNetwork.ROMANCE)
						{
							this.network[i][j] = SocialNetwork.DEFAULT_ROMANCE_VALUE;
						}
						else if (this.type == SocialNetwork.COOL)
						{
							this.network[i][j] = SocialNetwork.DEFAULT_COOL_VALUE;
						}
						
				}
			}
		}
		
		// --------------- Methods --------------
		/**
		 * setWeight
		 * INPUT: char1 -- the ID of the starting node, char2 -- ID of the end node,
		 *        weight -- the amount the weight should change by
		 * POSTCONDITION: The edge from char1 to char2 has changed by weight amount.
		 */
		public function setWeight(char1:int, char2:int, weight:Number):void {
			//var numEdges:int = network.length;
			Debug.debug(this, "setWeight() char1: " + char1 + " char2: " + char2 + " weight: " + weight, 5);
			/*if(weight > maxRange) network[char1][char2] = maxRange;
			else if(weight < minRange) network[char1][char2] = minRange;
			else */
			network[char1][char2] = weight;
		}
		
		public function multiplyWeight(char1:int, char2:int, factor:Number):void {
			network[char1][char2] *= factor;
			if (network[char1][char2] > maxRange) network[char1][char2] = maxRange;
			if (network[char1][char2] < minRange) network[char1][char2] = minRange;
		}
		
		public function addWeight(weight:Number, char1:int, char2:int, isStatusNet:Boolean=false):void {
			network[char1][char2] += weight;
			if(!isStatusNet) {
				if (network[char1][char2] > maxRange) {
					network[char1][char2] = maxRange;
				}
				if (network[char1][char2] < minRange) {
					network[char1][char2] = minRange;
				}
			}			
		}
		
		/**
		 * getWeight
		 * INPUT: char1 -- ID of char who has opinions, char2 -- ID of char who is recipient,
		 * POSTCONDITION: returns the weight from char1 to char2
		 */
		public function getWeight(char1:int, char2:int):int {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//Debug.debug(this, "getWeight() char1: " + cif.cast.getCharByID(char1).characterName);
			//Debug.debug(this,"getWeight() char2: " + cif.cast.getCharByID(char2).characterName);
			return network[char1][char2];
		}
		
		/**
		 * getAverageOpinion
		 * Returns the average weight of every character in the space towards the selected individual
		 * INPUT: char -- the id character to receive the average opinion of
		 * POSTCONDITION: returns the average opinion.
		 */
		public function getAverageOpinion(charID:int):Number {
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
		public function getRelationshipsAboveThreshold(charID:int, threshold:Number):Vector.<Number> {
			var idsAboveThreshold:Vector.<Number> = new Vector.<Number>;
			for (var i:Number = 0; i < network.length; i++) {
				if ( i != charID) { // don't look at yourself
					if (network[charID][i] > threshold)
						idsAboveThreshold.push(i);
				}
			}
			return idsAboveThreshold;
		}
		
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		/**
		 * toString
		 * Simply returns a string representation of the social network.
		 */
		public function toString():String {
			var i:int;
			var j:int;
			var output:String;
			output = "\nCurrent Values of this Social Net: \n";
			for (i = 0; i < network.length; i++) {
				for (j = 0; j < network.length; j++) {
					output += "\t" + this.network[i][j];
				}
				output += "\n";
			}
			return output;
		}
		
		public function toXMLString():String {
			var returnstr:String = new String();
			var theCast:Cast;
			theCast = Cast.getInstance();
			returnstr += "<Network type=\"" + getNameFromType(this.type) + "\" numChars=\"" + this.network.length + "\">\n";
			for (var i:Number = 0; i < theCast.length; ++i) {
				for (var j:Number = 0; j < theCast.length; ++j) {
					if (i != j) {
						returnstr += "<edge from=\"" + i + "\" to=\"" + j + "\" value=\"" + this.network[i][j] + "\" />\n";
					}
				}
			}
			returnstr += "</Network>";
			return returnstr;
		}
		
		public function clone(): SocialNetwork {
			var s:SocialNetwork = new SocialNetwork();
			s.type = this.type;
			s.network = Util.cloneArray(this.network) as Array;
			return s;
		}
		
		public static function equals(x:SocialNetwork, y:SocialNetwork): Boolean {
			if (x.network.length != y.network.length) return false;
			for (var i:Number = 0; i < x.network.length; ++i) {
				for (var j:Number = 0; j < x.network.length; ++j) {
					if (x.network[i][j] != y.network[i][j]) return false;
				}
			}
			if (x.type != y.type) return false;
			return true;
		}
	}
}