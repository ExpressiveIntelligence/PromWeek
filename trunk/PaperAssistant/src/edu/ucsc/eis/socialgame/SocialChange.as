/******************************************************************************
 * edu.ucsc.eis.socialgame.SocialChange
 * 
 * The SocialChange class is used to store an instance of social state change
 * to be used in social game events (aka a reference from the SocialGameEvent
 * class). This reference is intended to be read by the social AI module
 * and by the module that affects the social state change when the a social
 * game is being realized.
 * 
 * 
 *****************************************************************************/

package edu.ucsc.eis.socialgame
{
	import edu.ucsc.eis.socialservices.SGutils;
	public class SocialChange
	{
		/* Set of constants that correspond to the supported types of social
		 * change we wish to account for in the system.
		 *
		 * It would be nice to use an enum here but I'm not sure if Flex
		 * has enums. Maybe a value class created from a data file or 
 		 * config file later. The idea would be to manifest each facet
 		 * of social state that would be allowed variance as a value
 		 * object that would be able to encode some domain knowledge
 		 * about that facet.
 		 */
		
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
			
		/**
		 *The type of this value object correlated to the types of social
		 *change.
		 *
		 *In the future, this would be replaced with a reference to a value
		 *object.
		 *
		 *A value of -1 means the type has not been specified.
		 */
		private var type:int;
		
		/*The amount of social change according to the type.
		 *
		 * Would be nice to keep these values normalized between [-1,1]
		 *
		 *This value would be 1 if the type is a binary social change state.
		 */
		private var amount:Number;
		
		/*The role to which the social change happens.
		 */
		private var role:Role;
		
		public function SocialChange()
		{
			this.type = new int(-1);
			this.amount = new Number(0.0);
			this.role = new Role();
		}	

		/* Accessors */
		
		public function getType():int {return this.type;}
		public function getAmount():Number{return this.amount;}
		
		
		public function setType(t:int):void {this.type=t;}
		public function setAmount(n:Number):void {this.amount=n;}

		public function getRole():Role {return this.role;}
		public function setRole(r:Role):void {this.role = r;}

		/***
		 * 
		 * 
		 **/
		
		
		public function toString():String {
			var returnStr:String = new String();
			var util:SGutils = new SGutils();
			return returnStr.concat("SocialChange,", this.role.getTitle(), ",", util.needIDFromInt(this.type), ",", this.amount);
		}
	}
}