package CiF 
{
	/**
	 *This class contains proposition information and construction to be used for truth and subjective type propositions.
	 * 
	 *@see CiF.CulturalKB
	 */
	public class Proposition
	{
		public var type:String;
		public var head:String;
		public var connection:String;
		public var tail:String;
		
		public function Proposition() 
		{
			this.type = new String();
			this.head = new String();
			this.connection = new String();
			this.tail= new String();
			
		}
		public function toString(): String{
			var returnstr:String = new String();
			returnstr = "type = " + type + " --- head = " + head + " --- connection = " + connection + " --- tail = " + tail;
			return returnstr;
		}
		
		public function toXMLString():String {
			var returnstr:String = new String();
			returnstr = "<Proposition type=\"" + type + "\" head=\"" + head + "\" connection=\"" + connection + "\" tail=\"" + tail + "\" />";
			return returnstr;
		}
		
		public function clone(): Proposition {
			var p:Proposition = new Proposition();
			p.type = this.type;
			p.head = this.head;
			p.connection = this.connection;
			p.tail = this.tail; //?
			return p;
		}
		
		public static function equals(x:Proposition, y:Proposition): Boolean {
			if (x.type != y.type) return false;
			if (x.head != y.head) return false;
			if (x.connection != y.connection) return false;
			if (x.tail != y.tail) return false;
			return true;
		}
	}

}