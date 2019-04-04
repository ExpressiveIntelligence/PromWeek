package CiF 
{
	/**
	 * ...
	 * @author Ryan Andonian
	 */
	public final class RomanceNetwork extends SocialNetwork
	{
		
		//public static const BUDDY:int 	= 1;
		//public static const ROMANCE:int			= 2;
		//public static const COOL:int 	= 3;
		
		//{ Singleton Stuffs
		public static var _instance:RomanceNetwork = new RomanceNetwork();
		
		public static function getInstance():RomanceNetwork {
			return _instance;
		}
		//}
		public function RomanceNetwork() 
		{
			if (_instance != null) {
				throw new Error("RomanceNetwork (Constructor): " + " RomanceNetwork can only be accessed through RomanceNetwork.getInstance()");
			}
			this.type = ROMANCE;
		}
		/*public function clone(): RomanceNetwork {
			var r:RomanceNetwork = new RomanceNetwork();
			r.network = this.network; //?
			r.type = this.type;
			return r;
		}*/
		
		public static function equals(x:RomanceNetwork, y:RomanceNetwork): Boolean {
			if (x.network != y.network) return false;
			if (x.type != y.type) return false;
			return true;
		}
		
		//Returns an XML formatted String representation of this Romance Network.
		
		public override function toXMLString():String {
			var returnstr:String = new String();
			var theCast:Cast;
			theCast = Cast.getInstance();
			returnstr += "<Network type=\"romance\" numChars=\"" + this.network.length + "\">\n";
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