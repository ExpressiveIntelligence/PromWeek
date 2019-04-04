package CiF 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 */
	public final class SocialGamesLib 
	{
		/**
		 * Singleton instance of the SocialGamesLibrary
		 */
		private static var _instance:SocialGamesLib = new SocialGamesLib();
		/**
		 * The social games in the library.
		 */
		public var games:Vector.<SocialGame>;
		/*
		 * Hashes the games by their name element.
		 */
		public var gamesByName:Dictionary;
		/**
		 * The interrupt social games in the library.
		 */
		public var interrupts:Vector.<SocialGame>;
		
		public function SocialGamesLib() 		{
			if (_instance != null) {
				throw new Error("SocialGamesLib can only be accessed through SocialGamesLib.getInstance()");
			}
			this.games = new Vector.<SocialGame>();
			this.interrupts = new Vector.<SocialGame>();
			this.gamesByName = new Dictionary();
		}
		
		public static function getInstance():SocialGamesLib {
			return _instance;
		}
		
		public static function get instance():SocialGamesLib {
			return _instance;
		}

		/**
		 * Adds a game to the social game library. References to the game are added
		 * to the games vector and gamesByName dictionary elements.
		 * 
		 * @param	sg
		 * @return
		 */
		public function addGame(sg:SocialGame):void {
			//add to the vector
			this.games.push(sg);
			//add to the dictionary
			this.gamesByName[sg.name] = sg;
			this.gamesByName[sg.name.toLowerCase()] = sg;
		}
		
		/**
		 * Removes the social game from the social game library.
		 * @param	sg	The social game to remove.
		 */
		public function removeGame(sg:SocialGame):void {
			this.games.splice(this.games.lastIndexOf(sg, 0), 1);
			this.gamesByName[sg.name] = null;
			
		}
		
		/**
		 * Retrieves a games from the library via its name.
		 * @param	name	The name of the game to retrieve.
		 * @return	A reference to the game in the library or null if there is
		 * no game associated with the name.
		 */
		public function getByName(name:String):SocialGame {
			
			return this.gamesByName[name as String];
			
			/*for (var i:int = 0; i < games.length; ++i) {
				if (games[i].specificTypeOfGame.toLowerCase() == name.toLowerCase()) {
					return games[i];
				}
			}
			return null; */
		}
		
		/**
		 * Provides the index of the game associated with the name.
		 * @param	name	The name of the game.
		 * @return	The index into the library's vector of games corresponding
		 * to the game that matches the name. Returns -1 if there was no game
		 * corresponding to the name.
		 */
		public function getIndexByName(name:String):int {
			for (var i:int = 0; i < games.length; ++i) {
				if (games[i].name.toLowerCase() == name.toLowerCase()) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * Retrieves a games from the library via its name.
		 * @param	name	The name of the game to retrieve.
		 * @return	A reference to the game in the library or null if there is
		 * no game associated with the name.
		 */
		public function getInterruptByName(name:String):SocialGame {
			for (var i:int = 0; i < this.interrupts.length; ++i) {
				if (this.interrupts[i].specificTypeOfGame.toLowerCase() == name.toLowerCase()) {
					return this.games[i];
				}
			}
			return null;
		}
		
		/**
		 * Provides the index of the game associated with the name.
		 * @param	name	The name of the game.
		 * @return	The index into the library's vector of games corresponding
		 * to the game that matches the name. Returns -1 if there was no game
		 * corresponding to the name.
		 */
		public function getInterruptIndexByName(name:String):int {
			for (var i:int = 0; i < this.interrupts.length; ++i) {
				if (this.interrupts[i].name.toLowerCase() == name.toLowerCase()) {
					return i;
				}
			}
			return -1;
		}
		
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/

		public function clone():SocialGamesLib {
			var sgl:SocialGamesLib = new SocialGamesLib();
			for each(var sg:SocialGame in this.games) {
				sgl.addGame(sg.clone());
			}
			return sgl;
		}
		
		public static function equals(x:SocialGamesLib, y:SocialGamesLib): Boolean {
			if (x.games.length != y.games.length) return false;
			for (var i:Number = 0; i < x.games.length; ++i) {
				if (!SocialGame.equals(x.games[i], y.games[i])) return false;
			}
			return true;
		}
		
		public function toXMLString():String {
			var output:String = "<SocialGameLibrary>\n";
			var i:int;
			for (i = 0; i < this.games.length; ++i) {
				output += games[i].toXMLString();
			}
			output += "</SocialGameLibrary>\n";
			return output;
		}



	}

}