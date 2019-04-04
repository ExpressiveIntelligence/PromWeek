package eis 
{
	/**
	 * ...
	 * 
	 */
	public class Influence
	{
		public var romanNumeral:int;
		public var weight:Number;
		//vector of conditions
		public var conditions:Vector.<Condition>;
		
		public function Influence(romanNumeral:int, weight:Number) 
		{
			this.romanNumeral = romanNumeral;
			this.weight = weight;
			this.conditions = new Vector.<Condition>;
			
		}
		
	}

}