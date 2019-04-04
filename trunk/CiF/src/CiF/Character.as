package CiF 
{
	import flash.utils.Dictionary;
	/**
	 * The Character class stores the basic information a character needs to
	 * operate in CiF. Characters have a set of traits, a name, a network ID
	 * and a prospective memory to store their social game scores.
	 * 
	 * @see CiF.Character
	 * @see CiF.SocialNetwork
	 * @see CiF.ProspectiveMemory
	 * 
	 * TODO: if a trait is already assigned to a character, make sure it doesn't appear twice.
	 */
	public class Character
	{
		public static const LABEL_BEST_FRIEND:int = 0;
		public static const LABEL_DATING:int = 1;
		public static const LABEL_TRUE_LOVE:int = 2;
		public static const LABEL_IDOL:int = 3;
		public static const LABEL_BIGGEST_LOSER:int = 4;
		public static const LABEL_WORST_ENEMY:int = 5;
		
		public static const NUM_LABELS:int = 6;

		/**
		 * The name of the character.
		 */
		public var characterName:String;
		/**
		 * The traits associated with a character.
		 */
		public var traits:Vector.<Number>;
		/**
		 * The gender of the character.
		 */
		public var gender:String;
		/**
		 * The statuses associated with a character.
		 */
		//public var statuses:Dictionary;
		public var statuses:Vector.<Status>;
		/**
		 * The character's unique ID wrt social networks.
		 */
		public var networkID:Number;
		/**
		 * The character's prospective memory used by intent formation and
		 * goal setting.
		 */
		public var prospectiveMemory:ProspectiveMemory;
		/**
		 * speakerForMixInLocution -- flagged as true if this is the character meant to say something for a mix in locution
		 */
		public var isSpeakerForMixInLocution:Boolean;
		/**
		 * The character specific mix ins that are used in performance realizations
		 */
		public var locutions:Dictionary;

		
		/**
		 * The character's main "best friend" "girlfriend" "worst enemy"
		 */
		public var characterLabels:Vector.<String>;
		
		public var cif:CiFSingleton;
		
		public static var defaultLocutions:Dictionary = new Dictionary();
		defaultLocutions["greeting"] = "What's up";
		defaultLocutions["shocked"] = "Holy crap!!!";
		defaultLocutions["positiveadj"] = "cool";
		defaultLocutions["pejorative"] = "loser";
		defaultLocutions["sweetie"] = "sweetie";
		defaultLocutions["buddy"] = "dude";
		//defaultLocutions["buddyMale"] = "dude";
		//defaultLocutions["buddyFemale"] = "dudette";
		
		public function Character() {
			cif = CiFSingleton.getInstance();
			
			this.characterLabels = new Vector.<String>();
			for (var i:int = 0; i < NUM_LABELS; i++ )
			{
				this.characterLabels[i] = "";
			}
			
			this.traits = new Vector.<Number>();
			this.characterName = "";
			this.networkID = -1;
			this.prospectiveMemory = new ProspectiveMemory();
			//this.statuses = new Dictionary();
			this.statuses = new Vector.<Status>();
			this.locutions = new Dictionary();
			this.isSpeakerForMixInLocution = false;
		}
		
		/**
		 * This function upates who a character think their best friend is, etc.
		 */
		public function updateCharacterLabels():void
		{
			for (var i:int = 0; i < Character.NUM_LABELS; i++ )
			{
				switch (i)
				{
					case Character.LABEL_BEST_FRIEND:
						this.characterLabels[i] = getBestFriend();
						break;
					case Character.LABEL_BIGGEST_LOSER:
						this.characterLabels[i] = getBiggestLoser();
						break;
					case Character.LABEL_DATING:
						this.characterLabels[i] = getDating();
						break;
					case Character.LABEL_IDOL:
						this.characterLabels[i] = getIdol();
						break;
					case Character.LABEL_TRUE_LOVE:
						this.characterLabels[i] = getTrueLove();
						break;
					case Character.LABEL_WORST_ENEMY:
						this.characterLabels[i] = getWorstEnemy();
						break;
				}
			}
		}
		
		public function getBestFriend():String
		{
			var bestFriend:String = "";
			var highestNetwork:Number = 0;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.FRIENDS, forChar, char))
					{
						var budScore:Number = cif.buddyNetwork.getWeight(forChar.networkID, char.networkID);
						if (budScore > 66)
						{
							if (budScore > highestNetwork)
							{
								bestFriend = char.characterName;
								highestNetwork = budScore;
							}
						}
					}
				}
			}
			return bestFriend;
		}
		
		public function getIdol():String
		{
			var idol:String = "";
			var highestNetwork:Number = 0;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					var coolScore:Number = cif.coolNetwork.getWeight(forChar.networkID, char.networkID);
					if (coolScore > 66)
					{
						if (coolScore > highestNetwork)
						{
							idol = char.characterName;
							highestNetwork = coolScore;
						}
					}
				}
			}
			return idol;
		}
		
		public function getTrueLove():String
		{
			var trueLove:String = "";
			var highestNetwork:Number = 0;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					var romanceScore:Number = cif.romanceNetwork.getWeight(forChar.networkID, char.networkID);
					if (romanceScore > 66)
					{
						if (romanceScore > highestNetwork || (forChar.hasStatus(Status.HAS_A_CRUSH_ON,char) && romanceScore > (highestNetwork - 20)) )
						{
							trueLove = char.characterName;
							highestNetwork = romanceScore;
						}
					}
				}
			}
			return trueLove;
		}
		
		public function getBiggestLoser():String
		{
			var biggestLoser:String = "";
			var lowestNetwork:Number = 20;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					if (!cif.relationshipNetwork.getRelationship(RelationshipNetwork.FRIENDS, forChar, char))
					{
						var coolScore:Number = cif.coolNetwork.getWeight(forChar.networkID, char.networkID);
						if (coolScore < 20)
						{
							if (coolScore < lowestNetwork)
							{
								biggestLoser = char.characterName;
								lowestNetwork = coolScore;
							}
						}
					}
				}
			}
			return biggestLoser;
		}
		
		public function getDating():String
		{
			var dating:String = "";
			var highestNetwork:Number = 0;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.DATING, forChar, char))
					{
						var romanceScore:Number = cif.coolNetwork.getWeight(forChar.networkID, char.networkID);
						if (romanceScore > highestNetwork)
						{
							dating = char.characterName;
							highestNetwork = romanceScore;
						}
					}
				}
			}
			return dating;
		}
		
		public function getWorstEnemy():String
		{
			var worstEnemy:String = "";
			var lowestNetwork:Number = 0;
			var forChar:Character = cif.cast.getCharByName(this.characterName);
			for each (var char:Character in cif.cast.characters)
			{
				if (char.characterName != forChar.characterName)
				{
					if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.ENEMIES, forChar, char))
					{
						var budScore:Number = cif.buddyNetwork.getWeight(forChar.networkID, char.networkID);
						if (budScore < 34)
						{
							if (budScore < lowestNetwork)
							{
								worstEnemy = char.characterName;
								lowestNetwork = budScore;
							}
						}
					}
				}
			}
			return worstEnemy;
		}
		
		public static function getLabelNameByID(id:int):String
		{
			switch(id)
			{
				case Character.LABEL_BEST_FRIEND:
					return "Best Friend";
				case Character.LABEL_BIGGEST_LOSER:
					return "Lamest";
				case Character.LABEL_DATING:
					return "Dating";
				case Character.LABEL_IDOL:
					return "Idol";
				case Character.LABEL_TRUE_LOVE:
					return "True Love";					
				case Character.LABEL_WORST_ENEMY:
					return "Rival";
				default:
					Debug.debug(Character, "getLabelNameByID() " + id + " is not a valid id number");
			}
			return "";
		}
		
		
		/**
		 * Assigns a trait to the character.
		 * @param t
		 */
		public function setTrait(t:Number):void {
			if (t <= Trait.LAST_CATEGORY_COUNT)
			{
				for each (var i:Number in CiF.Trait.CATEGORIES)
				{
					this.traits.push(i);
				}
			}
			else
			{
				this.traits.push(t);
			}
			
		}
		
		/**
		 * Returns true if the character has the specified trait. It matches 
		 * the number in traits vector with the const indentifiers in the Trait
		 * class.
		 * 
		 * @param t
		 * @return 
		 */
		public function hasTrait(t:Number):Boolean {
			var i:Number = 0;
			if (t <= Trait.LAST_CATEGORY_COUNT)
			{
				for each (var cat_trait:Number in CiF.Trait.CATEGORIES[t])
				{
					for (i = 0; i < this.traits.length; ++i) {
						if (this.traits[i] == cat_trait) return true;
					}
				}
			}
			else
			{
				for (i = 0; i < this.traits.length; ++i) {
					if (this.traits[i] == t) 
					{
						return true;
					}
				}
			}
			return false
		}
		
		/**
		 * 
		 * @param	nid
		 */
		public function setNetworkID(nid:Number):void {
			this.networkID = nid;
		}
		
		/*******
		 * Sets a name for the character
		 * @param newName
		 ******* */
		public function setName(newName:String):void {
			this.characterName = newName;
		}
		
		/**********************************************************************
		 * Status Functions
		 *********************************************************************/

		 /**
		 * Determines if the character has a status with a type with a character 
		 * status target if the status is directed.
		 * @param	statusType		The type of the status.
		 * @param	towardCharacter	The character the status is directed to.
		 * @return	True if the character has the status, false if he does not.
		 */
		public function hasStatus(statusID:int = 0, towardChar:Character = null):Boolean 
		{
			var i:Number = 0;
			if (statusID <= Status.LAST_CATEGORY_COUNT) {
				for each (var cat_status:Number in Status.CATEGORIES[statusID])
				{
					for each (var status2:Status in this.statuses) {
						if (status2.type == cat_status) return true;
					}
				}
			}
			else {
				for each (var status:Status in this.statuses)
				{
					if (statusID == status.type)
					{
						if (statusID >= Status.FIRST_DIRECTED_STATUS)
						{
							if (towardChar)
							{
								if (status.directedToward.toLocaleLowerCase() == towardChar.characterName.toLowerCase())
								{
									return true;	
								}
							}
						}
						else
						{
							return true;
						}
					}
				}
			}

			
			//Debug.debug(this,"getStatus() "+this.characterName+" does not have the status "+Status.getStatusNameByNumber(statusID));
			
			return false;
		}
/*			
			//Debug.debug(this, "hasStatus() determining if " + this.characterName + " has status of " + Status.getStatusNameByNumber(statusType) + " " + statusType);
			//Debug.debug(this, "status: "+statusType+" is "+Status.getStatusNameByNumber(statusType));
			
			//if it is a status category loop through all ones of that category
			if (statusType <= Status.LAST_CATEGORY_COUNT)
			{
				//Debug.debug(this, "hasStatus(): "+Status.getStatusNameByNumber(statusType) + " is a category");
				for each (var type:int in Status.CATEGORIES[statusType])
				{
					if (this.statuses[type])
					{
						status = this.statuses[type] as Status;
						
						//Debug.debug(this, "hasStatus(): testing if " + Status.getStatusNameByNumber(type) + " is in " + Status.getStatusNameByNumber(statusType));
						if (status.type >= Status.FIRST_DIRECTED_STATUS)
						{
							if (status.directedToward.toLowerCase() == towardCharacter.characterName.toLowerCase())
								return true;
						}
						else
						{
							return true;
						}
					}
				}
			}
			else if (this.statuses[statusType])
			{
				//Debug.debug(this, "hasStatus() status is in dictionary; checking to see if second character is expected: " + status.directedToward);
				//Debug.debug(this, "hasStatus() status is in dictionary; checking to see if second character is expected: " + status.directedToward);
				//Debug.debug(this, "hasStatus() "+Status.getStatusNameByNumber(statusType)+" status is in dictionary;");
				
				var status:Status;
				//otherwise, just see that we have the status
				status = this.statuses[statusType] as Status;
				
						//Debug.debug(this, Status.getStatusNameByNumber(statusType) );
						//Debug.debug(this, towardCharacter.characterName.toLowerCase());
						//Debug.debug(this, status.directedToward.toLowerCase());
				
				if (status.type >= Status.FIRST_DIRECTED_STATUS)
				{
					if (!towardCharacter)
					{
						Debug.debug(this, "Malformed rule: " + this.characterName + " has status " + Status.getStatusNameByNumber(status.type) + " toward no one");
						return false;
					}
					
					
					if (status.directedToward.toLowerCase() == towardCharacter.characterName.toLowerCase())
					{
						return true;
					}
				}
				else
				{
					return true;
				}
			}
			return false;			
		}
*/
		/**
		 * Give the character a status with a type and a character status target
		 * if the status is directed.
		 * @param	statusType		The type of the status.
		 * @param	towardCharacter	The character the status is directed to.
		 */
		public function addStatus(statusType:int = 0, towardCharacter:Character = null):void 
		{
			var status:Status;
			
			
			
			//if the type is a status category
			if (statusType < Status.FIRST_NOT_DIRECTED_STATUS)
			{
				//apply all statuses in that category
				for each (var type:int in Status.CATEGORIES[statusType])
				{
					if (!this.getStatus(type, towardCharacter))
					{
						Debug.debug(this,"addStatus() HEY! Don't do this! Don't add category statuses, it's just weird.");
						status = new Status();
						status.type = type;
						if (status.type >= Status.FIRST_DIRECTED_STATUS)
							if (!towardCharacter) Debug.debug(this, "addStatus(): Tried to add a directed status without providing a target Character.");
							else status.directedToward = towardCharacter.characterName;
						//Debug.debug(this, "addStatus(): status added to " + this.characterName + " - " + Status.getStatusNameByNumber(statusType) + " " + statusType ); 
						//this.statuses[statusType] = status;

						this.statuses.push(status);
					}
				}
			}
			else
			{
				if (this.getStatus(statusType, towardCharacter))
				{
					return;
				}
				
				status = new Status();
				status.type = statusType;
				//if (status.isDirected)
				if (status.type >= Status.FIRST_DIRECTED_STATUS)
					if (!towardCharacter) Debug.debug(this, "addStatus(): Tried to add a directed status without providing a target Character.");
					else status.directedToward = towardCharacter.characterName;
				//Debug.debug(this, "addStatus(): status added to " + this.characterName + " - " + Status.getStatusNameByNumber(statusType) + " " + statusType ); 
				//this.statuses[statusType] = status;
				this.statuses.push(status);
			}
			//Debug.debug(this, "addStatus(): adding status of " + Status.getStatusNameByNumber(status.type) + " " + this.characterName + ((towardCharacter)?" to " + towardCharacter.characterName : ""));
		}
		
		/**
		 * Removes a status from the character according to status type.
		 * @param	statusType	The type of status to remove.
		 */
		public function removeStatus(statusType:int = 0, towardCharacter:Character = null):void {
			//if the type is a status category
			var i:int = 0;
			var status:Status;
			if (statusType <= Status.LAST_CATEGORY_COUNT)
			{
				//delete all statuses in that category
				for each (var type:int in Status.CATEGORIES[statusType])
				{
					for (i = 0; i < this.statuses.length; i++ )
					{
						status = new Status();
						//status.directedToward //??????
						if (this.statuses[i].type == statusType)
						{
							if (statusType >= Status.FIRST_DIRECTED_STATUS)
							{
								if (this.statuses[i].directedToward.toLowerCase() == towardCharacter.characterName.toLowerCase())
								{
									this.statuses.splice(i, 1);
								}
							}
							else
							{
								//not directed
								this.statuses.splice(i, 1);
							}
						}
					}
				}
			}
			else
			{
				for (i = 0; i < this.statuses.length; i++ )
				{
					status = new Status();
					//status.directedToward //??????
					if (this.statuses[i].type == statusType)
					{
						if (statusType >= Status.FIRST_DIRECTED_STATUS)
						{
							if (this.statuses[i].directedToward.toLowerCase() == towardCharacter.characterName.toLowerCase())
							{
								this.statuses.splice(i, 1);
							}
						}
						else
						{
							//not directed
							this.statuses.splice(i, 1);
						}
					}
				}
			}
		}
		
		/**
		 * Give the character a trait.  This should only be done in 'special circumstances' like
		 * on the console, OR maybe if the player has omnipotent god like powers!
		 * @param	traitType		The type of the trait.
		 */
		public function addTrait(traitType:int = 0):void 
		{	
			if (this.hasTrait(traitType))
			{
				return;
			}
			this.traits.push(traitType);
		}
		
		/**
		 * Removes a trait from the character according to trait type.
		 * Should only be used on the console or if giving the player
		 * special god-like powers to fundamentally change the nature of characters.
		 * @param	statusType	The type of status to remove.
		 */
		public function removeTrait(traitType:int):void {
			var i:int = 0;
			for (i = 0; i < this.traits.length; i++ )
			{
				if (this.traits[i] == traitType)
				{
					this.traits.splice(i, 1);
				}
			}
			
		}
		
		/**
		 * Returns the status if the character has it
		 * 
		 */
		public function getStatus(statusID:int, towardChar:Character=null):Status
		{
			for each (var status:Status in this.statuses)
			{
				if (statusID == status.type)
				{
					if (statusID >= Status.FIRST_DIRECTED_STATUS)
					{
						if (towardChar)
						{
							if (status.directedToward.toLocaleLowerCase() == towardChar.characterName.toLowerCase())
							{
								return status;	
							}
						}
					}
					else
					{
						return status;
					}
				}
			}
			
			//Debug.debug(this,"getStatus() "+this.characterName+" does not have the status "+Status.getStatusNameByNumber(statusID));
			
			return null;
		}
		
		/**
		 * Returns the number of the trait if the character has it, -1 if the character does not.		 * 
		 */
		public function getTrait(traitID:int):Number
		{
			for each (var trait:Number in this.traits)
			{
				if (traitID == trait)
				{
					return trait
				}
			}
			
			return -1;
		}
		 
		/**
		 * Updates the duration of all statuses held by the character. Removes
		 * statuses that have 0 or less remaining duration.
		 * 
		 * TODO: add the status removal to the SFDB.
		 * 
		 * @param	timeElapsed	The amount of time to remove from the statuses.
		 */
		public function updateStatusDurations(timeElapsed:int = 1):void 
		{
			for each (var status:Status in this.statuses) 
			{
				if (status.type != Status.POPULAR)
				{
					status.remainingDuration -= timeElapsed;
					if (status.remainingDuration <= 0) 
					{
						removeStatus(status.type,CiFSingleton.getInstance().cast.getCharByName(status.directedToward));
					}
				}
			}
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toXML():XML {
			var returnXML:XML;
			var status:Status;
			returnXML = <Character name={this.characterName} networkID={this.networkID} />;
			for each (var traitType:Number in this.traits) {
				returnXML.appendChild(<Trait type={Trait.getNameByNumber(traitType)} />);
			}
			for (var locutionKey:Object in this.locutions)
			{
				returnXML.appendChild(<Locution type={locutionKey as String} >{this.locutions[locutionKey]}</Locution>);
			}
			//for (var key:Object in this.statuses) {
				//status = this.statuses[key] as Status;
				//returnXML.appendChild(<Status type={Status.getStatusNameByNumber(key as int)} from={this.characterName} to={status.directedToward} />);
			//}
			for each(status in this.statuses) {
				//status = this.statuses[key] as Status;
				returnXML.appendChild(<Status type={Status.getStatusNameByNumber(status.type)} from={this.characterName} to={status.directedToward} />);
			}
			return returnXML;
		}
		 
		public function toXMLString():String {
			return this.toXML().toXMLString();
			//var returnStr:String = new String();
			//returnStr = "<Character name=\"" + this.characterName + "\" networkID=\"" + this.networkID +"\" >\n";
			//for each (var trait:Number in this.traits) {
				//returnStr += "<Trait type=\"" + Trait.getNameByNumber(trait) + "\" />\n";
			//}
			//returnStr += "</Character>";
			//Debug.debug(this, returnStr);
			//return returnStr;
		}
		
		public function clone(): Character {
			var ch:Character = new Character();
			var status:Status;
			var locution:String;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			ch.characterName = this.characterName;
			ch.networkID = this.networkID;
			ch.prospectiveMemory = this.prospectiveMemory;
			ch.traits = new Vector.<Number>();
			for each(var i:Number in this.traits) {
				ch.traits.push(i);
			}
			//for (var key:Object in this.statuses) {
				//status = this.statuses[key] as Status;
				//ch.addStatus(key as int, cif.cast.getCharByName(status.directedToward));
			//}
			for each (status in this.statuses) {
				//status = this.statuses[key] as Status;
				ch.addStatus(status.type, cif.cast.getCharByName(status.directedToward));
			}
			for (var key:Object in this.locutions) {
				locution = this.locutions[key] as String;
				ch.locutions[key] = locution;
			}
			return ch;
		}
		
		public static function equals(x:Character, y:Character): Boolean {
			if (x.traits.length !=y.traits.length) return false;
			for (var i:Number = 0; i < x.traits.length; ++i) {
				if ((x.traits[i] != y.traits[i])) return false;
			}
			if (x.characterName != y.characterName) return false;
			if (x.networkID != y.networkID) return false;
			if (x.prospectiveMemory != y.prospectiveMemory) return false;
			return true;
		}
	}
}