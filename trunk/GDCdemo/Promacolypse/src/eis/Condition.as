package eis 
{
	/**
	var c:Condition = new Condition();
	c.type = Condition.TRAIT;
	c.trait = Trait.REGULATION_HOTTIE
	c.primary = "A";
	//or
	c.type = Condition.Network
	c.networkValue = 40.0;
	c.primary = "B"
	c.secondary = "A"
	c.comparisonOperator = "<"
	
	//or
	c.type = Condition.STATUS;
	c.primary = "B"
	c.secondary = "A"
	c.status = Status.FRIEND;
	  
	 */
	public class Condition
	{
		public static const TRAIT:int = 1;
		public static const NETWORK:int = 2;
		public static const STATUS:int = 3;
		public static const NOTTRAIT:int = 4;
		public static const NOTSTATUS:int = 5;
		
		
		public var type:int;
		public var trait:int;
		public var primary:String;
		public var secondary:String;
		public var networkValue:Number;
		public var comparisonOperator:String;
		public var status:int;
		public var networkType:int;
		
		public function Condition() {
			this.type = -1;
			this.trait = -1;
			this.primary = "Z";
			this.secondary = "Z";
			this.networkValue = 0;
			this.comparisonOperator = "~";
			this.status = -1;
			this.networkType = -1;
		}
		
		public function setTraitCondition(type:int, trait:int, primary:String):void {
			this.type = type;
			this.trait = trait;
			this.primary = primary;
		}
		
		public function setNetworkCondition(type:int, networkValue:int, primary:String, secondary:String, comparisonOperator:String, networkType:int):void {
			this.type = type;
			this.networkValue = networkValue;
			this.primary = primary;
			this.secondary = secondary;
			this.comparisonOperator = comparisonOperator;
			this.networkType = networkType;
		}
		
		public function setStatusCondition(type:int, primary:String, secondary:String, status:int):void {
			this.type = type;
			this.primary = primary;
			this.secondary = secondary;
			this.status = status;
		}
			
	}

}