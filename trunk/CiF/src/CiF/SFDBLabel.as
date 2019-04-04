package CiF 
{
	/**
	 * The SFDBLabel class encompasses a valuated SFDB label and is to be
	 * instantiated by classes that implement the SFDBContext interface.
	 * 
	 * @author Josh
	 */
	public class SFDBLabel 	{
		
		/**
		 * The label type in string form (i.e. "romantic").
		 */
		public var type:String;
		/**
		 * The character orginating the social performance associated with the label.
		 */
		public var from:String;
		/**
		 * The character affected by the label.
		 */
		public var to:String;
		
		public function SFDBLabel(type:String = "", from:String="", to:String="") {
			this.type = type;
			this.from = from;
			this.to = to;
		}
		
		/**********************************************************************
		 * UTILITIES
		 *********************************************************************/
		
		 
		public function toString():String {
			return this.toXML().toXMLString();
		}
		
		public function toXML():XML {
			var xml:XML = <SFDBLabel type={this.type} from={this.from} />;
			if(this.to) xml.@to = this.to;
			return xml;
		}
		
		public static function equals(x:SFDBLabel, y:SFDBLabel):Boolean {
			if (x.type != y.type) return false;
			if (x.from != y.from) return false;
			if (x.to != y.to) return false;
			return true;
		}
	}

}