/******************************************************************************
 * edu.ucsc.eis.socialgame.Role
 * 
 * The Role class represents the concept of a performance role in dramaturgical
 * analysis and how it applies to social games. As a data structure, it 
 * affords a conceptual space to store role data. This is used by the social
 * game events' representation as a way to represent what roles are available
 * in the game while providing an object to link game roles with dramatrugical
 * preconditions. During role negotiation and performance realization, the role
 * class is associated with an character actor and is used as a bridge between a
 * social game specification and the game's parameterization of characters in 
 * roles. 
 * 
 *****************************************************************************/
 
package edu.ucsc.eis.socialgame
{
	public class Role
	{
		/* Used to store the title of the role when used by an unparameterized
		 * social game (i.e. "role1", "role2", "audience", "black", "white").
		 *
		 * title of "" means no title has been given.   
		 */
		private var title:String;
		private var titled:Boolean;
		
		/* Used to store the associate between the unparameterized social game
		 * title and an actual character in the system.
		 *
		 * characterID of -1 means no assignment has been made.		
		 */
		private var characterID:int;
		private var characterName:String;
		private var hasCharacter:Boolean; //probably bad naming here
		
		public function Role()
		{
			this.title = new String();
			this.titled = new Boolean(false);
			this.characterID = new int( -1);
			this.characterName = new String();
			this.hasCharacter = new Boolean(false); 
		}
		
		//getters
		public function getTitle():String {return this.title;}
		public function getCharacterID():int { return this.characterID; }
		public function getCharacterName():String { return this.characterName;}
		
		//setters
		public function setTitle(t:String):void {
			this.title = t; 
			this.titled=true;
		}
		public function setCharacterID(id:int):void {
			this.characterID = id;
			this.hasCharacter = true;
		}
		
		public function setCharacterName(name:String):void {
			this.characterName = name;
			this.hasCharacter = true;
		}
		public function setTitled(b:Boolean):void {this.titled=b;}
		public function setHasCharacterAssigned(b:Boolean):void {this.hasCharacter=b;}

		public function hasTitle():Boolean {return this.titled;}
		public function hasCharacterAssigned():Boolean {return this.hasCharacter;}

		public function createClone():Role {
			var r:Role = new Role();
			r.setTitle(this.title);
			r.setTitled(this.titled);
			r.setCharacterID(this.characterID);
			r.setHasCharacterAssigned(this.hasCharacter);
			return r;
		}

		public function toString():String {
			var str:String = new String();
			//long version
			//str=str.concat(this.title, ",", this.titled, ",", this.characterID, ",", this.hasCharacter);
			//short version
			str = str.concat("Role,", this.title);
			if (this.hasCharacter) str += "{" + this.characterName  + "}";
			return str;
		}

	}
}