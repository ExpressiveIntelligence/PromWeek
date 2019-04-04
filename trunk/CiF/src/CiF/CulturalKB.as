package CiF 
{
	import adobe.utils.CustomActions;
	import adobe.utils.ProductManager;
	
	/**
	 * The CulturalKB class contains/creates vectors of propositions, a singleton instance, toString function, and loading of XML
	 * Currently working on findItem function to compare Char subjectivity items with Truth items
	 * 
	 * 
	 * TODO: add the CKB toXML functionality to this class.
	 */

	 public class CulturalKB {
		
		private static var _instance:CulturalKB = new CulturalKB();

		/**
		 * The number of truth labels that appear in the CKB.
		 */
		public static const TRUTH_LABEL_COUNT:Number = 11;
		//labels
		public static const COOL:Number = 0;
		public static const LAME:Number = 1;
		public static const ROMANTIC:Number = 2;
		public static const GROSS:Number = 3;
		public static const FUNNY:Number = 4;
		public static const BAD_ASS:Number = 5;
		public static const MEAN:Number = 6;
		public static const NICE:Number = 7;
		public static const TABOO:Number = 8;
		public static const RUDE:Number = 9;
		public static const CHEATING:Number = 10;
		//labels end
		
		
		
		/**
		 * 	The number of subjective labels that appear in the CKB.
		 */
		public static const SUBJECTIVE_LABEL_COUNT:Number = 4;
		 
		public static const LIKES:Number = 0;
		public static const DISLIKES:Number = 1;
		public static const WANTS:Number = 2;
		public static const HAS:Number = 3;
		
		/**
		 * The subjective propositions (e.g. Edward likes pie).
		 */
		public var propsSubjective:Vector.<Proposition>;
		/**
		 * The truth propositions (e.g. pie is cool).
		 */
		public var propsTruth:Vector.<Proposition>;		
	
		/**
		 * constructor for CKB, used as a singleton
		 */
		public function CulturalKB() {
			if (_instance != null) {
				throw new Error("Singleton can only be accessed through Singleton.getInstance()");
			}
			else {
				this.propsSubjective = new Vector.<Proposition>();
				this.propsTruth = new Vector.<Proposition>();
			}
		}
		
		
		/**
		 * getInstance returns the singleton instance of our CulturalKB
		 *
		 *@return _instance 
		 */
		public static function getInstance():CulturalKB {
			return _instance;
		}
		
		/**
		 * findItem returns the character's match for liking/disliking all items that match the label 
		 * @param	character
		 * @param	connectionType
		 * @param	label
		 * @return  returnItemNames
		 */
		public function findItem(character:String, connectionType:String=null, label:String=null):Vector.<String> {
			
			var returnItemNames:Vector.<String> = new Vector.<String>();
			for each (var path:CKBPath in this.findFullCKBPaths(character, connectionType, null, label)) {
				returnItemNames.push(path.itemName);
			}
			return returnItemNames;
		}
		
		/**
		 * Returns all full path matches in the CKB given the constraints on 
		 * the CKB in the parameterization of the function.
		 * @param	character
		 * @param	connectionType
		 * @param	item
		 * @param	label
		 * @return	The paths matching the constraints.
		 */
		public function findFullCKBPaths(character:String, connectionType:String=null, item:String=null, label:String=null):Vector.<CKBPath> {
			var charAndTypeMatches:Vector.<Proposition> = new Vector.<Proposition>();
			var labelMatches:Vector.<Proposition> = new Vector.<Proposition>();
			var returnCKBPaths:Vector.<CKBPath> = new Vector.<CKBPath>();
			var i:int, j:int;
			var p:Proposition;
			
			//Debug.debug(this, "findItem() character: " + character + " connectionType: " + connectionType + " label: " + label);
			
			for (i = 0; i < this.propsSubjective.length; ++i) {
				p = this.propsSubjective[i];
				//Debug.debug(this, "current subjective: " + p.toString() + "  character: " + character + " connectionType: " + connectionType);
				//if the connection type is not null, match to it.
				//if the connection type is null, treat it as a wild card; return all as matches.
				if(connectionType) {
					if (p.head.toLowerCase() == character.toLowerCase() && p.connection.toLowerCase() == connectionType.toLowerCase()){
						charAndTypeMatches.push(p);
						//Debug.debug(this, "current subjective is char and type match: " + p.toString());
					}
				}else {
					if (p.head.toLowerCase() == character.toLowerCase()){
						charAndTypeMatches.push(p);
						//Debug.debug(this, "current subjective is char (type ignored): " + p.toString());
					}
				}
			}
			
			//if the label is not null, match to it.
			//if the label type is null, treat it as a wild card; return all as matches.
			if(label) {
				for (i = 0; i < this.propsTruth.length; ++i) {
					p = this.propsTruth[i];
					//Debug.debug(this, "current truth: " + p.toString());
					if (p.tail == label) {
						labelMatches.push(p);
						//Debug.debug(this, "current truth is label match: " + p.toString());
					}
				}
			} else {
				//Debug.debug(this, "findItem() all labels accepted.");
				labelMatches = this.propsTruth;
			}
			
			for (i = 0; i < charAndTypeMatches.length; ++i) {
				for (j = 0; j < labelMatches.length; ++j) {
					var s:Proposition = charAndTypeMatches[i];
					var t:Proposition = labelMatches[j];
					if (s.tail == t.head) {
						//returnItemNames.push(s.tail);
						var path:CKBPath = new CKBPath();
						path.characterName = s.head;
						path.connectionType = s.connection;
						path.itemName = s.tail;
						path.truthLabel = t.tail;
						returnCKBPaths.push(path);
					}
				}
			}
			return returnCKBPaths;
			
		}
		
		/**
		 * Given the Number representation of a Label, this function
		 * returns the String representation of that type. This is intended to
		 * be used in UI elements of the design tool.
		 * 
		 * @example <listing version="3.0">
		 * CulturalKB.getNameByNumber(CulturalKB.COOL); //returns "cool"
		 * </listing>
		 * 
		 * @param	type The Label type as a Number.
		 * @return The String representation of the Label type or empty string
		 * if the number did not match a label.
		 */
		public static function getTruthNameByNumber(type:Number):String {
			switch (type) {
				case CulturalKB.COOL:
					return "cool";
				case CulturalKB.LAME:
					return "lame";
				case CulturalKB.ROMANTIC:
					return "romantic";
				case CulturalKB.GROSS:
					return "gross";
				case CulturalKB.FUNNY:
					return "funny";
				case CulturalKB.BAD_ASS:
					return "bad ass";
				case CulturalKB.MEAN:
					return "mean";
				case CulturalKB.NICE:
					return "nice";
				case CulturalKB.TABOO:
					return "taboo";
				case CulturalKB.RUDE:
					return "rude";
				case CulturalKB.CHEATING:
					return "cheating";
				default:
					return "";
			}
		}
		
		/**
		 * Given the String representation of a Label, this function
		 * returns the Number representation of that type. This is intended to
		 * be used in UI elements of the design tool.
		 * 
		 * @example <listing version="3.0">
		 * CulturalKB.getNumberByName("cool"); //returns CulturalKB.COOL
		 * </listing>
		 * 
		 * @param	type The Label type as a String.
		 * @return The Number representation of the Label type or -1 if the
		 * number did not match a label.
		 */
		public static function getTruthNumberByName(type:String):Number {
			switch (type.toLowerCase()) {
				case "cool":
					return CulturalKB.COOL;
				case "lame":
					return CulturalKB.LAME;
				case "romantic":
					return CulturalKB.ROMANTIC;
				case "gross":
					return CulturalKB.GROSS;
				case "gross":
					return CulturalKB.FUNNY;
				case "bad ass":
					return CulturalKB.BAD_ASS;
				case "mean":
					return CulturalKB.MEAN;
				case "nice":
					return CulturalKB.NICE;
				case "taboo":
					return CulturalKB.TABOO;
				case "rude":
					return CulturalKB.RUDE;
				case "cheating":
					return CulturalKB.CHEATING;
				default:
					return -1;
			}
		}
		
		public static function getSubjectiveNameByNumber(num:Number):String {
			switch (num) {
				case CulturalKB.LIKES:
					return "likes";
				case CulturalKB.DISLIKES:
					return "dislikes";
				case CulturalKB.WANTS:
					return "wants";					
				case CulturalKB.HAS:
					return "has";					
				default:
					return "";
			}
		}
		
		public static function getSubjectiveNumberByName(name:String):Number {
			switch (name.toLowerCase()) {
				case "likes":
					return CulturalKB.LIKES;
				case "dislikes":
					return CulturalKB.DISLIKES;
				case "wants":
					return CulturalKB.WANTS;	
				case "has":
					return CulturalKB.HAS;	
				default:
					return -1;
			}
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		 /**
		 * toString gathers all proposition information
		 * @see CiF.Proposition
		 * 
		 * @return a CulturalKB as a string
		 */		
		public function toString(): String{
			var returnstr:String = new String();
			var i:int = 0;
			returnstr += "Cultural Knowledge Base";
			for (i = 0; i < this.propsSubjective.length; ++i) {
				returnstr += "\n   " + this.propsSubjective[i];
			}
			for (i = 0; i < this.propsTruth.length; ++i) {
				returnstr += "\n   " + this.propsTruth[i];
			}
			returnstr += "\nCultural Knowledge Base End";
			return returnstr;
		}
		
		/**
		 * toXMLString gathers are proposition information in XML format.
		 * @see CiF.Proposition
		 * 
		 * @return a CulturalKB as an XML String
		 */
		public function toXMLString(): String {
			var returnStr:String = new String();
			var i:int = 0;
			returnStr = "<CulturalKB>\n";
			for (i = 0; i < this.propsSubjective.length; ++i) {
				returnStr += this.propsSubjective[i].toXMLString();
				returnStr += "\n";
			}
			for (i = 0; i < this.propsTruth.length; ++i) {
				returnStr += this.propsTruth[i].toXMLString();
				returnStr += "\n";
			}
			returnStr += "</CulturalKB>";
			return returnStr;
		}

		
		 public function clone(): CulturalKB {
			var ckb:CulturalKB = new CulturalKB();
			ckb.propsSubjective = new Vector.<Proposition>();
			ckb.propsTruth = new Vector.<Proposition>();
			for each(var p:Proposition in this.propsSubjective) {
				ckb.propsSubjective.push(p.clone());
			}
			for each(p in this.propsTruth) {
				ckb.propsTruth.push(p.clone());
			}
			return ckb;
		}
		
		public static function equals(x:CulturalKB, y:CulturalKB): Boolean {
			if (x.propsSubjective.length != y.propsSubjective.length) return false;
			for (var i:Number = 0; i < x.propsSubjective.length; ++i) {
				if (!Proposition.equals(x.propsSubjective[i], y.propsSubjective[i])) return false;
			}
			if (x.propsTruth.length != y.propsTruth.length) return false;
			for (i = 0; i < x.propsTruth.length; ++i) {
				if (!Proposition.equals(x.propsTruth[i], y.propsTruth[i])) return false;
			}
			return true;
		}
	}
}