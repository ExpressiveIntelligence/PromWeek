package CiF 
{
	import flash.utils.Dictionary;
	/**
	 * A record of influence rules that fire when forming intent. For use for displaying rules that were true;
	 */
	public class RuleRecord
	{

		
		public var cif:CiFSingleton = CiFSingleton.getInstance();
		
		public static const MICROTHEORY_TYPE:Number = 0;
		public static const SOCIAL_GAME_TYPE:Number = 1;

		public var influenceRule:InfluenceRule;
		public var type:int;
		public var name:String;
		public var initiator:String;
		public var responder:String;
		public var other:String;
		
		
		public function RuleRecord() {
			
		}
		
		
		public function clone():RuleRecord 
		{
			var ruleRecord:RuleRecord = new RuleRecord();
			ruleRecord.name = this.name;
			ruleRecord.influenceRule = this.influenceRule.clone() as InfluenceRule;
			ruleRecord.type = this.type;
			ruleRecord.initiator = this.initiator;
			ruleRecord.responder = this.responder;
			ruleRecord.other = this.other;
			
			return ruleRecord;
		}
	
		public function toString():String {
			var result:String = "Rule Record\n"
			
			return result;
		}
		
		public static function equals(x:RuleRecord, y:RuleRecord): Boolean {
			if (x.type != y.type) return false;
			if (x.name != y.name) return false;
			if (!InfluenceRule.equals(x.influenceRule, y.influenceRule)) return false;
			if (x.initiator != y.initiator) return false;
			if (x.responder != y.responder) return false;
			if (x.other != y.other) return false;
			return true;
		}
	}
}

