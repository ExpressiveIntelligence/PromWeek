package CiF 
{
	/**
	 * The InfluenceRule class is a Rule with a weight attached. It is intended
	 * to be aggregated by an instance of the InfluceRuleSet class.
	 * 
	 * @see CiF.Rule
	 * @see InfluenceRuleSet
	 */
	public class InfluenceRule extends Rule
	{
		/**
		 * Vesitigial way to link rules to social game outcome.
		 */
		public var romanNumeral:Number;
		/**
		 * The weight associated with the influence rule.
		 */
		public var weight:Number;
		/**
		 * The weight of the rule evaluated in a microtheory + cast context. This
		 * will only be different than the weight if it is a rule that includes an
		 * other role.
		 */
		public var evaluatedWeight:Number;
		//vector of conditions

		
		public function InfluenceRule() {
			super();
			this.romanNumeral = 0.0;
			this.weight = 0.0;
			this.evaluatedWeight = 0.0;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public override function toString():String {
			return  this.weight + ": " + super.toString();//this.weight + "(" + this.id + "): " + super.toString();
		}
		
		public override function toXMLString(): String {
			var returnstr:String = new String();
			returnstr += "<InfluenceRule weight=\"" + this.weight + "\" name=\""+this.name+"\" id=\"" + this.id + "\">\n";
			for (var i:Number = 0; i < this.predicates.length; ++i) {
				//returnstr += "   ";
				returnstr += this.predicates[i].toXMLString();
				returnstr += "\n";
			}			
			returnstr += "</InfluenceRule>\n";
			return returnstr;
		}
		
		public override function toXML():XML {
			var outXML:XML = <InfluenceRule weight={this.weight} name={this.name}></InfluenceRule>;
			for each(var pred:Predicate in this.predicates) {
				outXML.appendChild(new XML(pred.toXMLString()));
			}
			return outXML;
			
		}
		
		public override function clone():Rule {
			var ir:InfluenceRule = new InfluenceRule();
			ir.predicates = new Vector.<Predicate>();
			for each(var p:Predicate in this.predicates) {
				ir.predicates.push(p.clone());
			}
			ir.name = this.name;
			ir.id = this.id;
			ir.romanNumeral = this.romanNumeral;
			ir.weight = this.weight;
			return ir as InfluenceRule;
		}
		
		public static function equals(x:InfluenceRule, y:InfluenceRule): Boolean {
			if (x.romanNumeral != y.romanNumeral) return false;
			if (x.weight != y.weight) return false;
			if (!Rule.equals(x as Rule, y as Rule)) return false;
			return true;
		}
	}
}