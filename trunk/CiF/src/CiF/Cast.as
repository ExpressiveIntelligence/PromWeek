package CiF 
{
	import flash.utils.Dictionary;
	import flashx.textLayout.utils.CharacterUtil;
	/**
	 * 
	 * 
	 *  
	 */
	public final class Cast
	{
		
		private static var _instance:Cast = new Cast();
		
		/**
		 * The characters in the cast.
		 */
		public var characters:Vector.<Character> = new Vector.<Character>();
		/**
		 * A hash matching Character class references with the key of the character's name as a String.
		 */
		private var charactersByName:Dictionary;
		
		public static function getInstance():Cast {
			return _instance;
		}
		
		public function Cast() {
			if (_instance != null) {
				throw new Error("Cast (Constructor): " + "Cast can only be accessed through Cast.getInstance()");
			}
			this.characters = new Vector.<Character>();
			this.charactersByName = new Dictionary();
		}
		
		/**
		 * Accessor to the number of characters currently in the class.
		 */
		public function get length():Number {return this.characters.length;}
		
		/**
		 * Returns the Character class associated with a String character name.
		 * @param	name The name of the character.
		 * @return	The instantiation of the Character class corresponding to 
		 * the name.
		 */
		public function getCharByName(name:String):Character {
			
			return this.charactersByName[name as String];
			
			/*for each (var char:Character in this.characters) {
				if (char.characterName.toLowerCase() == name.toLowerCase())
					return char;
			}
			Debug.debug(this, "getCharByName() character with name " + name + " is not in the cast",2);		
			return null;*/
		}
		
		public function getCharByID(id:int):Character {
			for each (var char:Character in this.characters) {
				if (char.networkID == id)
					return char;
			}
			Debug.debug(this, "getCharByID() character with id " + id + " is not in the cast",2);		
			return null;
		}
		
		public function addCharacter(c:Character):void {
			this.characters.push(c);
			this.charactersByName[c.characterName] = c;
			this.charactersByName[c.characterName.toLowerCase()] = c;
		}
		
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function prospectiveMemeoriesToString(topToShow:int=0):String {
			var out:String = "";
			for each (var c:Character in this.characters) {
				if (topToShow > 0) {
					out += c.characterName + "\n";
					for each (var gs:GameScore in c.prospectiveMemory.getHighestGameScores(topToShow)) {
						out += "\t" + gs.toString() + "\n";
					}
					out += "\n";
				}else {
					out += c.characterName + "\n" + c.prospectiveMemory.toString();
				}
			}
			return out;
		}
	
		 
		public function clone(): Cast {
			var c:Cast = new Cast();
			c.characters = new Vector.<Character>();
			for each(var ch:Character in this.characters) {
				c.addCharacter(ch.clone());
			}
			return c;
		}
		
		public function toXML():XML {
			var outXML:XML = <Cast />;
			for each(var char:Character in this.characters) {
				outXML.appendChild(char.toXML());
			}
			return outXML;
		}
		
		/*
		 * Returns a String in properly formatted XML representing the cast.
		 * */
		public function toXMLString():String {
			return this.toXML().toXMLString();
			//var output:String = new String();
			//output = "<Cast>\n";
			//for (var i:int = 0; i < this.characters.length; i++) {
				//output += this.characters[i].toXMLString();
				//output += "\n";
			//}
			//output += "</Cast>\n";
			//return output;
		}
		
		public static function equals(x:Cast, y:Cast): Boolean {
			if (x.characters.length !=y.characters.length) return false;
			for (var i:Number = 0; i < x.characters.length; ++i) {
				if (!Character.equals(x.characters[i], y.characters[i])) return false;
			}
			return true;
		}
	}
}
