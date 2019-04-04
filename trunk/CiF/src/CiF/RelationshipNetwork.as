package CiF 
{
	/**
	 * This class holds a separate instance of the SocialNetwork class for each
	 * of our social relationshipes. If the entry in that network is non-zero, we 
	 * that relationship is considered true between the two characters. If the number
	 * is zero, the relationship is not true.
	 * 
	 * Relationshipes are not consider exclusive in this implementations (edward and
	 * lily can be friends and enemies simultaneously). When a relationship is set
	 * or removed, entries are removed transitively.
	 * 
	 * @usage var sn:RelationshipNetwork = new RelationshipNetwork(characterCount);
	 * sn.setRelationship(RelationshipNetwork.DATING, lily, edward);
	 * sn.removeRelationship(RelationshipNetwork.DATING, edward, lily);
	 * 
	 * @usage var sn:RelationshipNetwork = RelationshipNetwork.getInstance();
	 * sn.initialize(3);
	 * sn.setRelationship(RelationshipNetwork.DATING, a, b);
	 * trace(sn.getRelationship(RelationshipNetwork.DATING, a, b));
	 * trace(sn);
	 * 
	 * @see CiF.SocialNetwork
	 * 
	 */
	public final class RelationshipNetwork extends SocialNetwork
	{
		private static var _instance:RelationshipNetwork = new RelationshipNetwork();
		
		//bit masks to distinguish relationships from on another in an integer representation.
		public static const FRIENDS:Number = 0;
		public static const DATING:Number = 1;
		public static const ENEMIES:Number = 2;
		
		public static const RELATIONSHIP_COUNT:Number = 3;
		
		
		public function RelationshipNetwork() {
			
			if (_instance != null) {
				throw new Error("RelationshipNetwork can only be accessed through RelationshipNetwork.getInstance");
			}
		}

		public static function getInstance():RelationshipNetwork {
			return _instance;
		}

		/**
		 * Returns a relationship name when called with a relationship constant.
		 * 
		 * @param	n	A relationship numeric representation.
		 * @return The String representation of the relationship denoted by the first
		 * parameter or an empty string of the number did not match a relationship.
		 */
		public static function getRelationshipNameByNumber(n:Number):String {
			switch(n) {
				case RelationshipNetwork.FRIENDS:
					return "friends";
				case RelationshipNetwork.DATING:
					return "dating";
				case RelationshipNetwork.ENEMIES:
					return "enemies";
				default:
					return "";
			}
		}
		/**
		 * Overridden as the default value of relationships should be 0 as
		 * the RelationshipNetwork values are interpreted differently than
		 * the other SocialNetworks.	
		 * 
		 * Initializes the RelationNetwork's properties given the number of
		 * characters in the social network.
		 * 
		 * @param	numChars The number of characters to be included in the
		 * RelationshipNetwork.
		 */
		override public function initialize(numChars:int):void {
			network = new Array(numChars); 
			var i:int;
			var j:int;
			for (i = 0; i < numChars; i++) {
				network[i] = new Array(numChars);
				for (j = 0; j < numChars; j++) {
						//network[i][j] = 0;
						//this.network[i][j] = new Number(Util.randRange(DEFAULT_NETWORK_VALUE - 10, DEFAULT_NETWORK_VALUE + 10));
						this.network[i][j] = new Number(0);
				}
			}
		}
		
		/**
		 * Returns the string name of a relationship given the number representation
		 * of that relationship.
		 *  
		 * @param	name	The name of the relationship.
		 * @return The number that corresponds to the name of the relationship
		 * or -1 if the name did not match a relationship.
		 */
		public static function getRelationshipNumberByName(name:String):Number {
			switch(name.toLowerCase()) {
				case "friends":
					return RelationshipNetwork.FRIENDS;
				case "dating":
					return RelationshipNetwork.DATING;
				case "enemies":
					return RelationshipNetwork.ENEMIES;
				default:
					return -1;
			}
		}
		
		/**
		 * Sets a relationship from the character playing role A to the
		 * character playing role B. If the relationship a reciprocal one (i.e
		 * dating, friends or enemies), the network values are set
		 * bidirectionally. If the relationship is a directed one, it is set in the
		 * direction of A to B.
		 * 
		 * 
		 * @param	Relationship The Relationship value for the Relationship to be added.
		 * @param	a The Character for which the Relationship is true.
		 * @param	b The Character that is the object of the Relationship.
		 */
		public function setRelationship(relationship:Number, a:Character, b:Character):void {
			//Debug.debug(this, "setRelationship() " + RelationshipNetwork.getRelationshipNameByNumber(relationship) + " " + a.characterName + " " + b.characterName);
			if(!this.getRelationship(relationship, b, a)) {
				this.addWeight(1 << int(relationship), b.networkID, a.networkID, true);
			}
		
			if(!this.getRelationship(relationship, a, b)) {
				this.addWeight(1 << relationship, a.networkID, b.networkID, true);
			}
		}
		
		 /** 
		 * Removes a relationship from the character playing role A to the
		 * character playing role B. If the relationship a reciprocal one (i.e
		 * dating, friends or enemies), the network values are set
		 * bidirectionally. If the relationship is a directed one, it is set in the
		 * direction of A to B.
		 * 
		 * 
		 * @param	relationship The relationship value for the relationship to be removed.
		 * @param	a The Character for which the relationship is modified.
		 * @param	b The Character that is the object of the relationship change.
		 */
		public function removeRelationship(relationship:Number, a:Character, b:Character):void {
			if (relationship == RelationshipNetwork.FRIENDS || 
				relationship == RelationshipNetwork.DATING ||
				relationship == RelationshipNetwork.ENEMIES) {
					//add the b->a reciprocal relationship link
					if(this.getRelationship(relationship, b, a)) {
						this.addWeight(-(1 << relationship), b.networkID, a.networkID, true);
					}
			}
			if(this.getRelationship(relationship, a, b)) {
				this.addWeight( -(1 << relationship), a.networkID, b.networkID, true);
			}
		}
		
		/**
		 * Checks for a relationship between two characters. It always checks if
		 * the character of the second parameter has the relationship denoted by
		 * the first paramater with the character represented by the third
		 * parameter. Reciprocal and directional relationshipes are treated
		 * identically.
		 * 
		 * @usage relationshipNet.getRelationship(RelationshipNetwork.Dating, Lily, Edward);
		 * //relationshipNet is an instance of the RelationshipNetwork class.
		 * 
		 * @param	relationship The relationship value for the relationship to be checked.
		 * @param	a The Character for which the relationship is checked.
		 * @param	b The Character that is the object of the relationship check.
		 * @return True if the relationship is present from a to b. False if it is
		 * not.
		 */
		public function getRelationship(relationship:Number, a:Character, b:Character):Boolean {
			if (a == null)
			{
				//TODO: this is a temporary fix to a much bigger problem
				return false;
				//Debug.debug(this, "getRelationship() A is null");
			}
			if (b == null)
			{
				//TODO: this is a temporary fix to a much bigger problem
				return false;
				//Debug.debug(this, "getRelationship() B is null");
			}
			//Debug.debug(this, "getRelationship() " + RelationshipNetwork.getRelationshipNameByNumber(relationship) + " " + a.networkID + ", " + b.networkID);
			//Debug.debug(this, "getRelationship() network size: " + this.network.length);
			return 0 < ( (1 << relationship) & this.getWeight(a.networkID, b.networkID));
		}
		
/*		public override function clone(): RelationshipNetwork {
			var returnRelNet:RelationshipNetwork = super.clone() as RelationshipNetwork;
			//var r:RelationshipNetwork = new RelationshipNetwork();
			r.network = this.network; //?
			r.type = this.type;
			return returnRelNet;
		}
		*/
		public static function equals(x:RelationshipNetwork, y:RelationshipNetwork): Boolean {
			if (x.network.length != y.network.length) return false;
			for (var i:Number = 0; i < x.network.length; ++i) {
				for (var j:Number = 0; j < x.network.length; ++j) {
					if (x.network[i][j] != y.network[i][j]) return false;
				}
			}
			if (x.type != y.type) return false;
			return true;
		}
		
		//Returns a String representation of this RelationshipNetwork in XML format.
		public override function toXMLString():String {
			var returnstr:String = new String();
			var theCast:Cast = Cast.getInstance();
			returnstr += "<Relationships>\n";
			var i:int;
			var j:int;
			var k:int;
			for (i = 0; i < RELATIONSHIP_COUNT; ++i) { // go through each type of relationship
				for (j = 0; j < theCast.length - 1; ++j) {
					for (k = j + 1; k < theCast.length; ++k) { // go through each pair of characters
						if (getRelationship(i, theCast.characters[j], theCast.characters[k])) {
							//then characters with network ids j and k DO have relationship i with each other.
							returnstr += "<Relationship type=\"" + getRelationshipNameByNumber(i) + "\" from=\"" + theCast.characters[j].characterName + "\" to=\"" + theCast.characters[k].characterName + "\" />";
							returnstr += "\n";
						}
					}
				}
			}
			returnstr += "</Relationships>";
			return returnstr;
		}
		
	}

}