package edu.ucsc.eis.socialservices 
{
	/**
	 * ...
	 * @author Josh
	 */
	public class SGutils
	{
		
		/*Enumeration of basic needs.*/
		public const ACCEPTANCE:int = 0;
		public const CURIOSITY:int = 1;
		public const EATING:int = 2;
		public const FAMILY:int = 3; 
		public const HONOR:int = 4;
		public const IDEALISM:int = 5;
		public const INDEPENDENCE:int = 6;
		public const ORDER:int = 7;
		public const PHYSICAL:int = 8;
		public const POWER:int = 9;
		public const ROMANCE:int = 10;
		public const SAVING:int = 11;
		public const CONTACT:int = 12;
		public const STATUS:int = 13;
		public const TRANQUILITY:int = 14;
		public const VENGEANCE:int = 15;
		//the number of basic needs
		public const NUMBER_OF_NEEDS:int = 16;
		
		/* Need representation mapping String=>int via hash. */ 
		private var needsStrToInt:Object = {
			acceptance:ACCEPTANCE,
			curiosity:CURIOSITY,
			eating:EATING,
			family:FAMILY,
			honor:HONOR,
			idealism:IDEALISM,
			independence:INDEPENDENCE,
			order:ORDER,
			physical:PHYSICAL,
			power:POWER,
			romance:ROMANCE,
			saving:SAVING,
			contact:CONTACT,
			status:STATUS,
			tranquility:TRANQUILITY,
			vengeance:VENGEANCE
		};
		
		public function SGutils() 
		{
			
			
		}
		
		/***
		 * Provides a String=>int mapping for the basic need identifiers.
		 * 
		 * @param need:String A basic need in the form of a string.
		 *
		 ***/
		public function needIDFromString(need:String):int {
			var intID:int = this.needsStrToInt[need.toLowerCase()];
			if (intID == 0 && "acceptance" != need.toLowerCase()) {
				trace("SGutils:Failed to translate need from String to int.");
			}
			return intID;
		}
		
		public function needIDFromInt(need:int):String {
			switch(need) {
				case 0: return "acceptance";
				case 1: return "curiosity";
				case 2: return "eating";
				case 3: return "family";
				case 4: return "honor";
				case 5: return "idealism";
				case 6: return "independence";
				case 7: return "order";
				case 8: return "physical";
				case 9: return "power";
				case 10: return "romance";
				case 11: return "saving";
				case 12: return "contact";
				case 13: return "status";
				case 14: return "tranquility";
				case 15: return "vengeance";
				default: 
					trace("SGutils: Need type number " +need + " is not in need range.");
					return "";
				
				
			}
		}
	}

}