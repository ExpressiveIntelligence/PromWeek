package CiF 
{
	/**
	 * 
	 */
	public class Status
	{
		/**
		 * The default initial duration of a status.
		 */
		public static const DEFAULT_INITIAL_DURATION:int = 3;
		
		
		//The first ones (through FIRST_NOT_DIRECTED_STATUS are status categories)
		public static const CAT_FEELING_BAD:int = 0;
		public static const CAT_FEELING_GOOD:int = 1;
		public static const CAT_FEELING_BAD_ABOUT_SOMEONE:int = 2;
		public static const CAT_FEELING_GOOD_ABOUT_SOMEONE:int = 3;
		public static const CAT_REPUTATION_BAD:int = 4;
		public static const CAT_REPUTATION_GOOD:int = 5;
		
		public static const LAST_CATEGORY_COUNT:int = 5;
		public static const FIRST_NOT_DIRECTED_STATUS:int = 6;
		
		public static const EMBARRASSED:int = 6;
		public static const CHEATER:int = 7
		public static const SHAKEN:int = 8
		public static const DESPERATE:int = 9
		public static const CLASS_CLOWN:int = 10
		public static const BULLY:int = 11
		public static const LOVE_STRUCK:int = 12
		public static const GROSSED_OUT:int = 13
		public static const EXCITED:int = 14
		public static const POPULAR:int = 15
		public static const SAD:int = 16
		public static const ANXIOUS:int = 17
		public static const HONOR_ROLL:int = 18
		public static const LOOKING_FOR_TROUBLE:int = 19
		public static const GUILTY:int = 20
		public static const FEELS_OUT_OF_PLACE:int = 21
		public static const HEARTBROKEN:int = 22
		public static const CHEERFUL:int = 23
		public static const CONFUSED:int = 24
		public static const LONELY:int = 25
		public static const HOMEWRECKER:int = 26
		
		
		public static const FIRST_TO_IGNORE_NON_DIRECTED:int = 27;
		public static const RESIDUAL_POPULAR:int = 27 //
		
		
		public static const FIRST_DIRECTED_STATUS:int = 28

		public static const HAS_A_CRUSH_ON:int = 28 //pink
		public static const ANGRY_AT:int = 29 //dark red
		public static const WANTS_TO_PICK_ON:int = 30 //dark orange
		public static const ANNOYED_WITH:int = 31 //
		public static const SCARED_OF:int = 32 //dark purple
		public static const PITIES:int = 33 //light blue
		public static const ENVIES:int = 34 //green
		public static const GRATEFUL_TOWARD:int = 35 //bright green
		public static const TRUSTS:int = 36 //solid blue
		public static const FEELS_SUPERIOR_TO:int = 37 //brown
		public static const CHEATING_ON:int = 38 //
		public static const CHEATED_ON_BY:int = 39 //
		public static const HOMEWRECKED:int = 40 //
		


		public static const STATUS_COUNT:int = 41
	
        public static const CATEGORIES:Object = new Object()
        // This block is run once when the class is first accessed
        {
            CATEGORIES[Status.CAT_FEELING_BAD] = new Array(Status.EMBARRASSED, Status.SHAKEN, Status.DESPERATE, Status.GROSSED_OUT, Status.SAD, Status.ANXIOUS, Status.GUILTY, Status.FEELS_OUT_OF_PLACE, Status.HEARTBROKEN, Status.CONFUSED, Status.LONELY);
            CATEGORIES[Status.CAT_FEELING_GOOD] = new Array(Status.LOVE_STRUCK, Status.EXCITED, Status.CHEERFUL);
            CATEGORIES[Status.CAT_FEELING_BAD_ABOUT_SOMEONE] = new Array(Status.ANGRY_AT, Status.ENVIES,Status.WANTS_TO_PICK_ON, Status.ANNOYED_WITH, Status.SCARED_OF, Status.FEELS_SUPERIOR_TO, Status.CHEATED_ON_BY);
            CATEGORIES[Status.CAT_FEELING_GOOD_ABOUT_SOMEONE] = new Array(Status.HAS_A_CRUSH_ON, Status.PITIES, Status.GRATEFUL_TOWARD, Status.TRUSTS);
			CATEGORIES[Status.CAT_REPUTATION_BAD] = new Array(Status.CHEATER, Status.BULLY, Status.HOMEWRECKER);
			CATEGORIES[Status.CAT_REPUTATION_GOOD] = new Array(Status.CLASS_CLOWN, Status.POPULAR, Status.HONOR_ROLL);
        }
		
		/**
		 * The type of this instance of Status.
		 */
		public var type:int;
		/**
		 * The name of the character the status is directed toward.
		 */
		public var directedToward:String;
		/**
		 * The how long the status will be in effect after it is placed.
		 */
		public var initialDuration:int;
		/**
		 * How long the status has before it is removed.
		 */
		public var remainingDuration:int;
		
		public function Status() {
			this.type = DESPERATE;
			this.directedToward = "";
			this.initialDuration = DEFAULT_INITIAL_DURATION;
			this.remainingDuration = this.initialDuration;
		}
		
		public function get isDirected():Boolean {
			if (FIRST_DIRECTED_STATUS <= this.type || this.type == Status.CAT_FEELING_BAD_ABOUT_SOMEONE || this.type == Status.CAT_FEELING_GOOD_ABOUT_SOMEONE) return true;
			return false;
		}
		
		
		
		public static function isStatusInCategory(statusID:int, catID:int):Boolean
		{
			for each (var sID:Number in Status.CATEGORIES[catID])
			{
				if (sID == statusID)
				{
					return true;
				}
			}
			return false;
		}
		
		
		
		
		/**
		 * Returns a status name when called with a status constant.
		 * 
		 * @param	n	A status numeric representation.
		 * @return The String representation of the status denoted by the first
		 * parameter or an empty string if the number did not match a status.
		 */
		public static function getStatusNameByNumber(n:int):String {
			
			switch(n) {
				case Status.CAT_FEELING_BAD:
					return "cat: feeling bad";
				case Status.CAT_FEELING_GOOD:
					return "cat: feeling good";
				case Status.CAT_FEELING_BAD_ABOUT_SOMEONE:
					return "cat: feeling bad about someone";
				case Status.CAT_FEELING_GOOD_ABOUT_SOMEONE:
					return "cat: feeling good about someone";
				case Status.CAT_REPUTATION_BAD:
					return "cat: reputation bad";
				case Status.CAT_REPUTATION_GOOD:
					return "cat: reputation good";
				
				case Status.EMBARRASSED:
					return "embarrassed";
				case Status.CHEATER:
					return "cheater";
				case Status.SHAKEN:
					return "shaken";
				case Status.DESPERATE:
					return "desperate";
				case Status.CLASS_CLOWN:
					return "class clown";
				case Status.BULLY:
					return "bully";
				case Status.LOVE_STRUCK:
					return "love struck";
				case Status.GROSSED_OUT:
					return "grossed out";
				case Status.EXCITED:
					return "excited";
				case Status.POPULAR:
					return "popular";
				case Status.SAD:
					return "sad";
				case Status.ANXIOUS:
					return "anxious";
				case Status.HONOR_ROLL:
					return "honor roll";
				case Status.LOOKING_FOR_TROUBLE:
					return "looking for trouble";
				case Status.GUILTY:
					return "guilty";
				case Status.FEELS_OUT_OF_PLACE:
					return "feels out of place";
				case Status.HEARTBROKEN:
					return "heartbroken";
				case Status.CHEERFUL:
					return "cheerful";
				case Status.CONFUSED:
					return "confused";
				case Status.LONELY:
					return "lonely";
				case Status.HOMEWRECKER:
					return "homewrecker";
					
					
				case Status.HAS_A_CRUSH_ON:
					return "has a crush on";
				case Status.ANGRY_AT:
					return "angry at";
				case Status.WANTS_TO_PICK_ON:
					return "wants to pick on";
				case Status.ANNOYED_WITH:
					return "annoyed with";
				case Status.SCARED_OF:
					return "scared of";
				case Status.PITIES:
					return "pities";
				case Status.ENVIES:
					return "envies";
				case Status.GRATEFUL_TOWARD:
					return "grateful toward";
				case Status.TRUSTS:
					return "trusts";
				case Status.FEELS_SUPERIOR_TO:
					return "feels superior to";
				case Status.CHEATING_ON:
					return "cheating on";
				case Status.CHEATED_ON_BY:
					return "cheated on by";
				case Status.HOMEWRECKED:
					return "homewrecked";
					
				case Status.RESIDUAL_POPULAR:
					return "residual popular"
				
				default:
					return "";
			}
		}
		
		public static function getShortStatusNameByNumber(n:int):String {
			
			switch(n) {
				case Status.CAT_FEELING_BAD:
					return "feels bad";
				case Status.CAT_FEELING_GOOD:
					return "feels good";
				case Status.CAT_FEELING_BAD_ABOUT_SOMEONE:
					return "negative";
				case Status.CAT_FEELING_GOOD_ABOUT_SOMEONE:
					return "positive";
				case Status.CAT_REPUTATION_BAD:
					return "bad rep";
				case Status.CAT_REPUTATION_GOOD:
					return "good rep";
				
				case Status.EMBARRASSED:
					return "embarrass";
				case Status.CHEATER:
					return "cheater";
				case Status.SHAKEN:
					return "shaken";
				case Status.DESPERATE:
					return "desperate";
				case Status.CLASS_CLOWN:
					return "class clown";
				case Status.BULLY:
					return "bully";
				case Status.LOVE_STRUCK:
					return "love struck";
				case Status.GROSSED_OUT:
					return "gross";
				case Status.EXCITED:
					return "excited";
				case Status.POPULAR:
					return "popular";
				case Status.SAD:
					return "sad";
				case Status.ANXIOUS:
					return "anxious";
				case Status.HONOR_ROLL:
					return "honors";
				case Status.LOOKING_FOR_TROUBLE:
					return "trouble";
				case Status.GUILTY:
					return "guilty";
				case Status.FEELS_OUT_OF_PLACE:
					return "out of place";
				case Status.HEARTBROKEN:
					return "heartbroke";
				case Status.CHEERFUL:
					return "cheerful";
				case Status.CONFUSED:
					return "confused";
				case Status.LONELY:
					return "lonely";
				case Status.HOMEWRECKER:
					return "homewrecker";
					
					
				case Status.HAS_A_CRUSH_ON:
					return "crush on";
				case Status.ANGRY_AT:
					return "angry at";
				case Status.WANTS_TO_PICK_ON:
					return "pick on";
				case Status.ANNOYED_WITH:
					return "annoyed with";
				case Status.SCARED_OF:
					return "scared of";
				case Status.PITIES:
					return "pities";
				case Status.ENVIES:
					return "envies";
				case Status.GRATEFUL_TOWARD:
					return "grateful";
				case Status.TRUSTS:
					return "trusts";
				case Status.FEELS_SUPERIOR_TO:
					return "superior to";
				case Status.CHEATING_ON:
					return "cheat on";
				case Status.CHEATED_ON_BY:
					return "cheat on by";
				case Status.HOMEWRECKED:
					return "homewrecked";
					
				case Status.RESIDUAL_POPULAR:
					return "residual popular";
				
				default:
					return "";
			}
		}
		
		
		
		/**
		 * Returns the string name of a status given the number representation
		 * of that status.
		 *  
		 * @param	name	The name of the status.
		 * @return The number that corresponds to the name of the status or -1
		 * if the name did not correspond to a status.
		 */
		public static function getStatusNumberByName(name:String):int {
			switch(name.toLowerCase()) {
			//switch(name) {
				case "cat: feeling bad":
					return Status.CAT_FEELING_BAD;
				case "cat: feeling good":
					return Status.CAT_FEELING_GOOD;
				case "cat: feeling bad about someone":
					return Status.CAT_FEELING_BAD_ABOUT_SOMEONE;
				case "cat: feeling good about someone":
					return Status.CAT_FEELING_GOOD_ABOUT_SOMEONE;
				case "cat: reputation bad":
					return Status.CAT_REPUTATION_BAD;
				case "cat: reputation good":
					return Status.CAT_REPUTATION_GOOD;
					
				case "embarrassed":
					return Status.EMBARRASSED;
				case "cheater":
					return Status.CHEATER;
				case "shaken":	
					return Status.SHAKEN;
				case "desperate":	
					return Status.DESPERATE;
				case "class clown":	
					return Status.CLASS_CLOWN;
				case "bully":	
					return Status.BULLY;
				case "love struck":	
					return Status.LOVE_STRUCK;
				case "grossed out":	
					return Status.GROSSED_OUT;
				case "excited":	
					return Status.EXCITED;
				case "popular":	
					return Status.POPULAR;
				case "sad":
					return Status.SAD;
				case "anxious":	
					return Status.ANXIOUS;
				case "honor roll":	
					return Status.HONOR_ROLL;
				case "looking for trouble":	
					return Status.LOOKING_FOR_TROUBLE;
				case "guilty":	
					return Status.GUILTY;
				case "feels out of place":	
					return Status.FEELS_OUT_OF_PLACE;
				case "heartbroken":	
					return Status.HEARTBROKEN;
				case "cheerful":	
					return Status.CHEERFUL;						
				case "confused":	
					return Status.CONFUSED;
				case "lonely":
					return Status.LONELY;
				case "homewrecker":
					return Status.HOMEWRECKER;
					
				case "has a crush on":
					return Status.HAS_A_CRUSH_ON;
				case "angry at":	
					return Status.ANGRY_AT;
				case "wants to pick on":	
					return Status.WANTS_TO_PICK_ON;
				case "annoyed with":	
					return Status.ANNOYED_WITH;
				case "scared of":	
					return Status.SCARED_OF;
				case "pities":
					return Status.PITIES;
				case "envies":
					return Status.ENVIES;
				case "grateful toward":
					return Status.GRATEFUL_TOWARD;
				case "trusts":
					return Status.TRUSTS;
				case "feels superior to":
					return Status.FEELS_SUPERIOR_TO;
				case "cheating on":
					return Status.CHEATING_ON;
				case "cheated on by":
					return Status.CHEATED_ON_BY;
				case "homewrecked":
					return Status.HOMEWRECKED;
					
				case "residual popular":
					return Status.RESIDUAL_POPULAR;
					
				default:
					return -1;
			}
		}
	}
}