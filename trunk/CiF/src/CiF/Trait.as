package CiF 
{
	/**
	 * Defines the constants associated with trait types.
	 *
	 */
	public class Trait
	{
		public static const CAT_SEXY:Number = 0;
		public static const CAT_JERK:Number = 1;
		public static const CAT_NICE:Number = 2;
		public static const CAT_SHARP:Number = 3;
		public static const CAT_SLOW:Number = 4;
		public static const CAT_INTROVERTED:Number = 5;
		public static const CAT_EXTROVERTED:Number = 6;
		public static const CAT_CHARACTER_FLAW:Number = 7;
		public static const CAT_CHARACTER_VIRTUE:Number = 8;
		public static const CAT_NAMES:Number = 9;
		public static const CAT_REPUTATION:Number = 10;
		
		public static const LAST_CATEGORY_COUNT:Number = 10;
		
		public static const ATTENTION_HOG:Number = 11
		public static const IMPULSIVE:Number = 12
		public static const COLD:Number = 13
		public static const KIND:Number = 14
		public static const IRRITABLE:Number = 15
		public static const LOYAL:Number = 16
		public static const LOVING:Number = 17
		public static const SYMPATHETIC:Number = 18
		public static const MEAN:Number = 19
		public static const CLUMSY:Number = 20
		public static const CONFIDENT:Number = 21
		public static const INSECURE:Number = 22
		public static const MOPEY:Number = 23
		public static const BRAINY:Number = 24
		public static const DUMB:Number = 25
		public static const DEEP:Number = 26
		public static const SHALLOW:Number = 27
		public static const SMOOTH_TALKER:Number = 28
		public static const INARTICULATE:Number = 29
		public static const SEX_MAGNET:Number = 30
		public static const AFRAID_OF_COMMITMENT:Number = 31
		public static const TAKES_THINGS_SLOWLY:Number = 32
		public static const DOMINEERING:Number = 33
		public static const HUMBLE:Number = 34
		public static const ARROGANT:Number = 35
		public static const DEFENSIVE:Number = 36
		public static const HOTHEAD:Number = 37
		public static const PACIFIST:Number = 38
		public static const RIPPED:Number = 39
		public static const WEAKLING:Number = 40
		public static const FORGIVING:Number = 41
		public static const EMOTIONAL:Number = 42
		public static const SWINGER:Number = 43
		public static const JEALOUS:Number = 44
		public static const WITTY:Number = 45
		public static const SELF_DESTRUCTIVE:Number = 46
		public static const OBLIVIOUS:Number = 47
		public static const VENGEFUL:Number = 48
		public static const COMPETITIVE:Number = 49
		public static const STUBBORN:Number = 50
		public static const DISHONEST:Number = 51
		public static const HONEST:Number = 52
		public static const OUTGOING:Number = 53
		public static const SHY:Number = 54
		
		public static const FIRST_TO_IGNORE:Number = 55
		
		public static const FEMALE:Number = 55
		public static const MALE:Number = 56
		
		public static const FIRST_NAME_NUMBER:Number = 57
		public static const SIMON:Number = 57
		public static const MONICA:Number = 58
		public static const OSWALD:Number = 59
		public static const NICHOLAS:Number = 60
		public static const LIL:Number = 61
		public static const NAOMI:Number = 62
		public static const BUZZ:Number = 63
		public static const JORDAN:Number = 64
		public static const CHLOE:Number = 65
		public static const CASSANDRA:Number = 66
		public static const LUCAS:Number = 67
		public static const EDWARD:Number = 68
		public static const MAVE:Number = 69
		public static const GUNTHER:Number = 70
		public static const PHOEBE:Number = 71
		public static const KATE:Number = 72
		public static const DOUG:Number = 73
		public static const ZACK:Number = 74
		public static const GRACE:Number = 75
		public static const TRIP:Number = 76
		public static const LAST_NAME_NUMBER:Number = 76
		
		/**
		 * Everyone has this trait!
		 */
		public static const ANYONE:Number = 77
		
		public static const FIRST_INVISIBLE:Number = 78;
		
		public static const WEARS_A_HAT:Number = 79;
		public static const MUSCULAR:Number = 80;
		public static const CARES_ABOUT_FASHION:Number = 81;
		
		public static const TRAIT_COUNT:Number = 82
		
		
        public static const CATEGORIES:Object = new Object()
        // This block is run once when the class is first accessed
        {
            CATEGORIES[Trait.CAT_SEXY] = new Array(Trait.SMOOTH_TALKER, Trait.SEX_MAGNET, Trait.RIPPED, Trait.SWINGER);
            CATEGORIES[Trait.CAT_REPUTATION] = new Array(Trait.RIPPED, Trait.SEX_MAGNET, Trait.WEAKLING);
            CATEGORIES[Trait.CAT_JERK] = new Array(Trait.MEAN, Trait.COLD, Trait.DOMINEERING, Trait.ARROGANT, Trait.HOTHEAD, Trait.JEALOUS, Trait.VENGEFUL, Trait.COMPETITIVE, Trait.DISHONEST);
            CATEGORIES[Trait.CAT_NICE] = new Array(Trait.KIND, Trait.LOYAL, Trait.SYMPATHETIC, Trait.HUMBLE, Trait.FORGIVING, Trait.HONEST);
            CATEGORIES[Trait.CAT_SHARP] = new Array(Trait.CONFIDENT, Trait.BRAINY, Trait.DEEP, Trait.WITTY);
			CATEGORIES[Trait.CAT_INTROVERTED] = new Array(Trait.SHY, Trait.MOPEY, Trait.INARTICULATE, Trait.AFRAID_OF_COMMITMENT, Trait.TAKES_THINGS_SLOWLY, Trait.HUMBLE, Trait.WEAKLING, Trait.FORGIVING);
			CATEGORIES[Trait.CAT_EXTROVERTED] = new Array(Trait.WITTY, Trait.IMPULSIVE, Trait.IRRITABLE, Trait.LOVING, Trait.CONFIDENT, Trait.SMOOTH_TALKER, Trait.SEX_MAGNET, Trait.DOMINEERING, Trait.ARROGANT, Trait.HOTHEAD, Trait.COMPETITIVE);
			CATEGORIES[Trait.CAT_CHARACTER_FLAW] = new Array(Trait.SHY, Trait.ATTENTION_HOG, Trait.IRRITABLE, Trait.CLUMSY, Trait.INSECURE, Trait.DUMB, Trait.SHALLOW, Trait.INARTICULATE, Trait.AFRAID_OF_COMMITMENT, Trait.ARROGANT, Trait.DEFENSIVE, Trait.EMOTIONAL, Trait.JEALOUS, Trait.SELF_DESTRUCTIVE, Trait.OBLIVIOUS, Trait.VENGEFUL, Trait.STUBBORN, Trait.DISHONEST);
			CATEGORIES[Trait.CAT_CHARACTER_VIRTUE] = new Array(Trait.KIND, Trait.LOYAL, Trait.LOVING, Trait.SYMPATHETIC, Trait.WITTY, Trait.CONFIDENT, Trait.HUMBLE, Trait.HONEST);
			CATEGORIES[Trait.CAT_NAMES] = new Array(Trait.DOUG, Trait.SIMON, Trait.MONICA, Trait.OSWALD, Trait.ZACK, Trait.NICHOLAS, Trait.LIL, Trait.NAOMI, Trait.BUZZ, Trait.JORDAN, Trait.CHLOE, Trait.CASSANDRA, Trait.LUCAS, Trait.EDWARD, Trait.MAVE, Trait.GUNTHER, Trait.PHOEBE, Trait.KATE);
			CATEGORIES[Trait.CAT_SLOW] = new Array(Trait.DUMB, Trait.CLUMSY, Trait.OBLIVIOUS);
        }

		public static function isTraitInCategory(traitID:int, catID:int):Boolean
		{
			for each (var tID:Number in Trait.CATEGORIES[catID])
			{
				if (tID == traitID)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Given the Number representation of a Label, this function
		 * returns the String representation of that type. This is intended to
		 * be used in UI elements of the design tool.
		 * 
		 * @example <listing version="3.0">
		 * Trait.getNameByNumber(Trait.CONFIDENCE); //returns "confidence"
		 * </listing>
		 * 
		 * @param	type The Label type as a Number.
		 * @return The String representation of the Label type.
		 */
		public static function getNameByNumber(type:Number):String {
			switch (type) {
				case Trait.CAT_SEXY:
					return "cat: sexy";
				case Trait.CAT_JERK:
					return "cat: jerk";
				case Trait.CAT_NICE:					
					return "cat: nice";
				case Trait.CAT_REPUTATION:					
					return "cat: reputation";
				case Trait.CAT_SHARP:
					return "cat: sharp";
				case Trait.CAT_INTROVERTED:
					return "cat: introverted";
				case Trait.CAT_EXTROVERTED:
					return "cat: extroverted";
				case Trait.CAT_CHARACTER_FLAW:
					return "cat: character flaw";
				case Trait.CAT_CHARACTER_VIRTUE:
					return "cat: character virtue";
				case Trait.CAT_SLOW:
					return "cat: slow";
				case Trait.CAT_NAMES:
					return "cat: names";
				
				case Trait.OUTGOING:
					return "outgoing";
				case Trait.SHY:
					return "shy";
				case Trait.ATTENTION_HOG:
					return "attention hog";
				case Trait.IMPULSIVE:
					return "impulsive";
				case Trait.COLD:
					return "cold";
				case Trait.KIND:
					return "kind";
				case Trait.IRRITABLE:
					return "irritable";
				case Trait.LOYAL:
					return "loyal";
				case Trait.LOVING:
					return "loving";
				case Trait.SYMPATHETIC:
					return "sympathetic";
				case Trait.MEAN:
					return "mean";
				case Trait.CLUMSY:
					return "clumsy";
				case Trait.CONFIDENT:
					return "confident";
				case Trait.INSECURE:
					return "insecure";
				case Trait.MOPEY:
					return "mopey";
				case Trait.BRAINY:
					return "brainy";
				case Trait.DUMB:
					return "dumb";
				case Trait.DEEP:
					return "deep";
				case Trait.SHALLOW:
					return "shallow";
				case Trait.SMOOTH_TALKER:
					return "smooth talker";
				case Trait.INARTICULATE:
					return "inarticulate";
				case Trait.SEX_MAGNET:
					return "sex magnet";
				case Trait.AFRAID_OF_COMMITMENT:
					return "afraid of commitment";
				case Trait.TAKES_THINGS_SLOWLY:
					return "takes things slowly";
				case Trait.DOMINEERING:
					return "domineering";
				case Trait.HUMBLE:
					return "humble";
				case Trait.ARROGANT:
					return "arrogant";
				case Trait.DEFENSIVE:
					return "defensive";
				case Trait.HOTHEAD:
					return "hothead";
				case Trait.PACIFIST:
					return "pacifist";
				case Trait.RIPPED:
					return "ripped";
				case Trait.WEAKLING:
					return "weakling";
				case Trait.FORGIVING:
					return "forgiving";
				case Trait.EMOTIONAL:
					return "emotional";
				case Trait.SWINGER:
					return "swinger";
				case Trait.JEALOUS:
					return "jealous";
				case Trait.WITTY:
					return "witty";
				case Trait.SELF_DESTRUCTIVE:
					return "self destructive";
				case Trait.OBLIVIOUS:
					return "oblivious";
				case Trait.VENGEFUL:
					return "vengeful";
				case Trait.COMPETITIVE:
					return "competitive";
				case Trait.STUBBORN:
					return "stubborn";
				case Trait.DISHONEST:
					return "dishonest";
				case Trait.HONEST:
					return "honest";
					
				case Trait.MALE:
					return "male";
				case Trait.FEMALE:
					return "female";
					
				case Trait.SIMON:
					return "simon";
				case Trait.MONICA:
					return "monica";
				case Trait.OSWALD:
					return "oswald";
				case Trait.ZACK:
					return "zack";
				case Trait.NICHOLAS:
					return "nicholas";
				case Trait.LIL:
					return "lil";
				case Trait.NAOMI:
					return "naomi";
				case Trait.BUZZ:
					return "buzz";
				case Trait.JORDAN:
					return "jordan";
				case Trait.CHLOE:
					return "chloe";
				case Trait.CASSANDRA:
					return "cassandra";
				case Trait.LUCAS:
					return "lucas";
				case Trait.EDWARD:
					return "edward";
				case Trait.MAVE:
					return "mave";
				case Trait.GUNTHER:
					return "gunter";
				case Trait.PHOEBE:
					return "phoebe";
				case Trait.KATE:
					return "kate";
				case Trait.DOUG:
					return "doug";
				case Trait.GRACE:
					return "grace";
				case Trait.TRIP:
					return "trip";
					
					
				case Trait.ANYONE:
					return "anyone";
					
				case Trait.WEARS_A_HAT:
					return "wears a hat";
				case Trait.MUSCULAR:
					return "muscular";
				case Trait.CARES_ABOUT_FASHION:
					return "cares about fashion";
				default:
					return "trait not declared";				
			}
		}
		
		/**
		 * Given the String representation of a Label, this function
		 * returns the Number representation of that type. This is intended to
		 * be used in UI elements of the design tool.
		 * 
		 * @example <listing version="3.0">
		 * Trait.getNumberByName("cool"); //returns Trait.COOL
		 * </listing>
		 * 
		 * @param	type The Label type as a String.
		 * @return The Number representation of the Label type.
		 */
		public static function getNumberByName(name:String):Number {
			switch (name.toLowerCase()) {
				case "cat: sexy":
					return Trait.CAT_SEXY;		
				case "cat: jerk":
					return Trait.CAT_JERK;		
				case "cat: nice":
					return Trait.CAT_NICE;		
				case "cat: sharp":
					return Trait.CAT_SHARP;		
				case "cat: reputation":
					return Trait.CAT_REPUTATION;		
				case "cat: introverted":
					return Trait.CAT_INTROVERTED;		
				case "cat: extroverted":
					return Trait.CAT_EXTROVERTED;		
				case "cat: character flaw":
					return Trait.CAT_CHARACTER_FLAW;		
				case "cat: character virtue":
					return Trait.CAT_CHARACTER_VIRTUE;	
				case "cat: slow":
					return Trait.CAT_SLOW;
				case "cat: names":
					return Trait.CAT_NAMES;
				
				case "outgoing":
					return Trait.OUTGOING;
				case "shy":
					return Trait.SHY;
				case "attention hog":
					return Trait.ATTENTION_HOG;
				case "impulsive":
					return Trait.IMPULSIVE;
				case "cold":
					return Trait.COLD;
				case "kind":
					return Trait.KIND;
				case "irritable":
					return Trait.IRRITABLE;
				case "loyal":
					return Trait.LOYAL;
				case "loving":
					return Trait.LOVING;
				case "sympathetic":
					return Trait.SYMPATHETIC;
				case "mean":
					return Trait.MEAN;
				case "clumsy":
					return Trait.CLUMSY;
				case "confident":
					return Trait.CONFIDENT;
				case "insecure":
					return Trait.INSECURE;
				case "mopey":
					return Trait.MOPEY;
				case "brainy":
					return Trait.BRAINY;
				case "dumb":
					return Trait.DUMB;
				case "deep":
					return Trait.DEEP;
				case "shallow":
					return Trait.SHALLOW;
				case "smooth talker":
					return Trait.SMOOTH_TALKER;
				case "inarticulate":
					return Trait.INARTICULATE;
				case "sex magnet":
					return Trait.SEX_MAGNET;
				case "afraid of commitment":
					return Trait.AFRAID_OF_COMMITMENT;
				case "takes things slowly":
					return Trait.TAKES_THINGS_SLOWLY;
				case "domineering":
					return Trait.DOMINEERING;
				case "humble":
					return Trait.HUMBLE;
				case "arrogant":
					return Trait.ARROGANT;
				case "defensive":
					return Trait.DEFENSIVE;
				case "hothead":
					return Trait.HOTHEAD;
				case "pacifist":
					return Trait.PACIFIST;
				case "ripped":
					return Trait.RIPPED;
				case "weakling":
					return Trait.WEAKLING;
				case "forgiving":
					return Trait.FORGIVING;
				case "emotional":
					return Trait.EMOTIONAL;
				case "swinger":
					return Trait.SWINGER;
				case "jealous":
					return Trait.JEALOUS;
				case "witty":
					return Trait.WITTY;
				case "self destructive":
					return Trait.SELF_DESTRUCTIVE;
				case "oblivious":
					return Trait.OBLIVIOUS;
				case "vengeful":
					return Trait.VENGEFUL;
				case "competitive":
					return Trait.COMPETITIVE;
				case "stubborn":
					return Trait.STUBBORN;
				case "dishonest":
					return Trait.DISHONEST;
				case "honest":
					return Trait.HONEST;
				case "male":
					return Trait.MALE;
				case "female":
					return Trait.FEMALE;
					
					
					
				case "simon":
					return Trait.SIMON;
				case "monica":
					return Trait.MONICA;
				case "oswald":
					return Trait.OSWALD;
				case "zack":
					return Trait.ZACK;
				case "nicholas":
					return Trait.NICHOLAS;
				case "lil":
					return Trait.LIL;
				case "naomi":
					return Trait.NAOMI;
				case "buzz":
					return Trait.BUZZ;
				case "jordan":
					return Trait.JORDAN;
				case "chloe":
					return Trait.CHLOE;
				case "cassandra":
					return Trait.CASSANDRA
				case "lucas":
					return Trait.LUCAS;
				case "edward":
					return Trait.EDWARD;
				case "mave":
					return Trait.MAVE;
				case "gunter":
					return Trait.GUNTHER;
				case "phoebe":
					return Trait.PHOEBE;
				case "kate":	
					return Trait.KATE;
				case "doug":
					return Trait.DOUG;
				case "grace":
					return Trait.GRACE;
				case "trip":
					return Trait.TRIP;
					
				case "anyone":
					return Trait.ANYONE;
					
				case "wears a hat":
					return Trait.WEARS_A_HAT;
				case "muscular":
					return Trait.MUSCULAR;
				case "cares about fashion":
					return Trait.CARES_ABOUT_FASHION;
					
					
				default:
					return -1;
			}
		}
		
		
		
		public function Trait() 
		{
			
		}
		
		
		public function clone(): Trait {
			var t:Trait = new Trait();
			return t;
		}
		
		public static function equals(x:Trait, y:Trait): Boolean {
			return true;
		}
		
	}

}
