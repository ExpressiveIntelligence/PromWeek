package CiF
{
	/**
	 * 
	 * TODO: finish utility functions
	 */
	public final class BuddyNetwork extends SocialNetwork
	{
		//public static const BUDDY:int 	= 1;
		//public static const ROMANCE:int			= 2;
		//public static const COOL:int 	= 3;
		
		//{ Singleton Stuffs
		public static var _instance:BuddyNetwork = new BuddyNetwork();
		
		public static function getInstance():BuddyNetwork{
			return _instance;
		}
		//}
		
		public function BuddyNetwork() {
			if (_instance != null) {
				throw new Error("BuddyNetwork (Constructor): BuddyNetwork can only be accessed through BuddyNetwork.getInstance()");
			}
			this.type = BUDDY;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		/*public function clone(): BuddyNetwork {
			var b:BuddyNetwork = new BuddyNetwork();
			b.network = this.network; //?
			b.type = this.type;
			return b;
		}*/
		
		public static function equals(x:BuddyNetwork, y:BuddyNetwork): Boolean {
			if (x.network.length != y.network.length) return false;
			for (var i:Number = 0; i < x.network.length; ++i) {
				for (var j:Number = 0; j < x.network.length; ++j) {
					if (x.network[i][j] != y.network[i][j]) return false;
				}
			}
			if (x.type != y.type) return false;
			return true;
		}
		
		//Returns an XML formatted String representation of this BuddyNetwork.
		
		public override function toXMLString():String {
			var returnstr:String = new String();
			var theCast:Cast;
			theCast = Cast.getInstance();
			returnstr += "<Network type=\"buddy\" numChars=\"" + this.network.length + "\">\n";
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
		
	}
}