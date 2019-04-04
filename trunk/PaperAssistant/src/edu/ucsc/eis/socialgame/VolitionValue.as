package edu.ucsc.eis.socialgame 
{
	/**
	 * Volition values grounded with game, end and role associations.
	 * @author Josh McCoy
	 */
	public class VolitionValue
	{
		
		public var game:int;
		public var endIndex:int;
		public var role:int;
		public var endEventId:int;
		public var volition:Number;
		public var characterName:String;
		
		public function VolitionValue() 
		{
			this.game = new int(-1);
			this.endIndex = new int(-1);
			this.role = new int(-1);
			this.endEventId = new int(-1);
			this.volition = new Number(Number.MIN_VALUE);
			this.characterName  = "";
		}
		
		public final function compare(x:VolitionValue, y:VolitionValue):Number { 
				if (x.volition > y.volition) 
					return -1.0;
				else if (x.volition < y.volition)
					return 1.0;
				return 0.0;
		}
		
		public function toString():String {
			var rtn:String = new String();
			rtn = "VolitionValue[" + this.characterName + "," + this.game + "," + this.endIndex + "," + this.role + "," + this.volition + "]"
			return rtn;
		}
	}

}