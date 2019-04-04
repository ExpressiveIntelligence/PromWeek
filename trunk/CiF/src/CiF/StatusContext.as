package CiF 
{
	/**
	 * Consists of a predicate and a time.
	 * Example XML:

	 */
	public class StatusContext implements SFDBContext
	{
		//public var predicate:Predicate;
		public var time:int;
		public var statusType:Number;
		public var negated:Boolean;
		public var from:Character;
		public var to:Character;
		
		public function StatusContext() 
		{
			//this.predicate = new Predicate();
			this.time = -1;
		}

		
		/**********************************************************************
		 * SFDBContext Interface implementation.
		 *********************************************************************/
		public function getTime():int { return this.time; }
		 
		public function isSocialGame():Boolean { return false; }
		
		public function isTrigger():Boolean { return false; }
		
		public function isJuice():Boolean { return false; }
		
		public function isStatus():Boolean { return true; }
		
		public function getChange():Rule {
			var r:Rule = new Rule();
			var p:Predicate = new Predicate();
			p.setStatusPredicate(this.from.characterName, (this.to)?this.to.characterName:"", this.statusType, this.negated);			
			r.predicates.push(p);
			return r;
		}
		
		/**
		 * Determines if the StatusContext represents a status change consistent
		 * with the passed-in Predicate.
		 * 
		 * @param	p	Predicate to check for.
		 * @param	x	Primary character.
		 * @param	y	Secondary character.
		 * @param	z	Tertiary character.
		 * @return	True if the StatusContext's change is the same as the valuation
		 * of p. False if not.
		 */
		public function isPredicateInChange(p:Predicate, x:Character, y:Character, z:Character):Boolean {
			if (p.type != Predicate.STATUS) return false;
			if (p.status != this.statusType) return false;
			if (p.negated != this.negated) return false;
			if (x.characterName != this.from.characterName) return false;
			if(y) {
				if (y.characterName != this.to.characterName) return false;
				if (Status.FIRST_DIRECTED_STATUS > p.status) return false;
				//if (Status.FIRST_DIRECTED_STATUS > this.status) return false;
			}
			return true;
		}
		
		/**********************************************************************
		 * Utility Functions
		 * *******************************************************************/
		
		public function toXML():XML {
			var outXML:XML = <StatusContext time = { this.time } status={Status.getStatusNameByNumber(this.statusType)} from={this.from.characterName} negated={this.negated} /> ;
			if (Status.FIRST_DIRECTED_STATUS <= this.statusType) {
				outXML.@to = this.to.characterName;
			}
			
			//Debug.debug(this, "toXML()\n" + outXML.toXMLString());
			return outXML;
		}
		 
		public function toXMLString():String {
			return this.toXML().toString();
			//var returnString:String = new String();
			//returnString += "<StatusContext time=\"" + time + "\" >\n" + predicate.toXMLString() + "\n</StatusContext>";
			//return returnString;
		}
		
		public function clone(): StatusContext {
			var sc:StatusContext = new StatusContext();
			sc.time = this.time;
			sc.to = this.to;
			sc.from = this.from;
			sc.statusType = this.statusType;
			sc.negated = this.negated;
			return sc;
		}
		
		public static function equals(x:StatusContext, y:StatusContext): Boolean {
			if (x.time != y.time) return false;
			if (x.negated != y.negated) return false;
			if (x.to != y.to) return false;
			if (x.from != y.from) return false;
			if (x.statusType != y.statusType) return false;
			return true;
		}
		
		public function loadFromXML(xml:XML):SFDBContext
		{
			//this is currently handled in ParseXML SFDBContextParse
			return null;
		}
		
	}

}