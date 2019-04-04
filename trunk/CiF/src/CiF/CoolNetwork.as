package CiF 
{
	/**
	 * 
	 * TODO: finish utlity funcitons.
	 */
	public final class CoolNetwork extends SocialNetwork
	{
		public static var _instance:CoolNetwork = new CoolNetwork();
		
		public static function getInstance():CoolNetwork {
			return _instance;
		}

		public function CoolNetwork() {
			if (_instance != null) {
				throw new Error("CoolNetwork (Constructor): CoolNetwork can only be accessed through CoolNetwork.getInstance()");
			}
			 this.type = COOL;
			 
		}

		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		/*public function clone(): CoolNetwork {
			var cn:CoolNetwork = new CoolNetwork();
			cn..type = this.type; //?
			cn.network = this.network;
			return cn;
		}*/
		
		public static function equals(x:CoolNetwork, y:CoolNetwork): Boolean {
			if (x.network != y.network) return false;
			if (x.type != y.type) return false;
			return true;
		}
		
		//Returns an XML formatted String representation of this CoolNetwork.
		
		public override function toXMLString():String {
			var returnstr:String = new String();
			var theCast:Cast;
			theCast = Cast.getInstance();
			returnstr += "<Network type=\"cool\" numChars=\"" + this.network.length + "\">\n";
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