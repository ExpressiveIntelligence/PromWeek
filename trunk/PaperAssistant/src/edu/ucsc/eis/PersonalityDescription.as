/******************************************************************************
 * edu.ucsc.eis.PersonalityDescription
 * 
 * The PersonalityDescription class captures character-specific details that 
 * affect social decisions made by the social AI services. Each personality
 * description consists of several types of descriptors: 16 basic needs
 * descriptions consisting of need type, capacity, and regeneration; traits
 * consisting of a tagged trait from motivation analysis as a single string;
 * and ad hoc or author goals consisting of a name, a subject, object, and 
 * volition.
 * 
 * This object has the cability to fill out the personality description stored
 * in an XML file. It requires a path to the XML file as a String and the name
 * of the agent for which the personality description is required.
 *
 * example XML file: 
  <characters>

	<character name="bill">
		<need type="0"  capacity=".6" regen=".5" name="acceptance"/>
		<need type="1"  capacity=".6" regen=".5" name="curiosity" />
		<need type="2"  capacity=".6" regen=".5" name="eating" />
		<need type="3"  capacity=".6" regen=".5" name="family" />
		<need type="4"  capacity=".6" regen=".5" name="honor" />
		<need type="5"  capacity=".6" regen=".5" name="idealism" />
		<need type="6"  capacity=".6" regen=".5" name="independence" />
		<need type="7"  capacity=".6" regen=".5" name="order" />
		<need type="8"  capacity=".6" regen=".5" name="physical" />
		<need type="9"  capacity=".6" regen=".5" name="power" />
		<need type="10" capacity=".6" regen=".5" name="romance" />
		<need type="11" capacity=".6" regen=".5" name="saving" />
		<need type="12" capacity=".6" regen=".5" name="contact" />
		<need type="13" capacity=".6" regen=".5" name="status" />
		<need type="14" capacity=".6" regen=".5" name="tranquility" />
		<need type="15" capacity=".6" regen=".5" name="vengeance" />
		
		<trait name="self-doubt" />
		
		<goal name="friend" subject="bill" object="ted" volition="0.6"/>
		
	</character>

  </characters>
 * 
 *****************************************************************************/

package edu.ucsc.eis
{
	import __AS3__.vec.Vector;
	
	import edu.ucsc.eis.socialgame.AdHocSocialGoal;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	

	public class PersonalityDescription
	{
		/* temporary kludge - need to find a way to make these constants
		 * program or package wide without making them globally accessible.
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
		//the number of basic needs
		public const NUMBER_OF_NEEDS:int = 16;

		private var biography:String;
		
		private var needCapacity:Vector.<Number>;
		private var needRegen:Vector.<Number>;
		private var currentNeedState:Vector.<Number>;
		
		private var traits:Vector.<String>;
		
		private var characterNameToLoad:String;
		
		private var adHocGoals:Vector.<AdHocSocialGoal>;
		
		/* Stores the loaded XML library from a file.*/
		private var personalityDescriptionXML:XML;
		
		/* The object that requests the XML file from a URL string.*/
		private var xmlurl:URLRequest;
		
		/* Loads the requested XML from the URL after this.xmlurl 
		 * performs its task.
		 */
		private var xmlLoader:URLLoader;
		
		/* true if the PersonalityDescription is current loading XML.
		 * false if no loading is taking place.
		 */
		private var parsedXML:Boolean;
		
		private var callbackWhenXMLParsingDone:Function;
		
			
		public function PersonalityDescription(){
			
			this.needCapacity = new Vector.<Number>(this.NUMBER_OF_NEEDS);
			this.needRegen = new Vector.<Number>(this.NUMBER_OF_NEEDS);
			this.currentNeedState = new Vector.<Number>(this.NUMBER_OF_NEEDS);
			this.traits = new Vector.<String>();
			this.adHocGoals = new Vector.<AdHocSocialGoal>();
			this.biography = new String();
			
			this.characterNameToLoad = new String();
			this.personalityDescriptionXML = new XML();
			this.parsedXML = new Boolean(false);
		}

		//Setters
		public function setBasicNeed(type:int, cap:Number, regen:Number):void {
			this.needCapacity[type] = cap;
			this.needRegen[type] = regen;
		}
		public function addTrait(trait:String):void { this.traits.push(trait);}
		public function addGoal(subject:String, topic:String, object:String, volition:Number):void {
			var g:AdHocSocialGoal = new AdHocSocialGoal();
			g.setTopic(topic);
			g.setSubject(subject);
			g.setObject(object);
			this.adHocGoals.push(g);
		}
		
		//Accessors
		public function getNeedCapacity(type:int):Number {
			return this.needCapacity[type];
		}
		public function getNeedRegen(type:int):Number {
			return this.needRegen[type];
		}
		//trait accessors
		public function getTrait(index:int):String {
			return this.traits[index];
		}
		public function getAllTraits():Vector.<String> {
			return new Vector.<String>(this.traits);
		}
		public function getNumTraits():int {
			return this.traits.length;
		}
		
		public function getBiography():String {
			return this.biography;
		}
		
		//ad hoc goal accessors
		public function getGoal(index:int):AdHocSocialGoal {
			return this.adHocGoals[index];
		}
		public function getAllGoals():Vector.<AdHocSocialGoal> {
			var returnVec:Vector.<AdHocSocialGoal> = new Vector.<AdHocSocialGoal>();
			var i:int = new int();
			for(i=0; i<this.adHocGoals.length; ++i) {
				returnVec.push(this.adHocGoals[i].createClone());	
			}
			//trace("returnVec:"+returnVec);
			return returnVec;
		}
		public function getNumGoals():int {
			return this.adHocGoals.length;
		}
		
		
		public function isXMLParsed():Boolean { return this.parsedXML;}

		/**
		 *
		 * @param characterName:String The string identifier of the character.
		 * 
		 * @param pathToXML:String The path to the XML file in String form.
		 * 
		 * @param callback:Function The function to call when the XML parsing is finished. 
		 * 
		 */
		public function loadPersonalityFromXML(characterName:String, pathToXML:String, callback:Function):void {
			
			this.characterNameToLoad = characterName;
			this.callbackWhenXMLParsingDone = callback;
			this.xmlurl = new URLRequest(pathToXML);
			this.xmlLoader = new URLLoader(this.xmlurl);
			this.xmlLoader.addEventListener("complete", this.xmlLoadedCallback);	
		}
		
		private function xmlLoadedCallback(evt:Event):void {
			this.personalityDescriptionXML = XML(this.xmlLoader.data);
			this.createPersonalityDescriptionFromXML();
		}

		public function createPersonalityDescriptionFromXML(incXML:XML = null, charName:String = ""):void {
			//trace(this.personalityDescriptionXML);
			var characterXML:XML = new XML();
			
			if (XML != null) {
				this.personalityDescriptionXML = incXML;
				this.characterNameToLoad = charName;
				//characterXML = this.personalityDescriptionXML.character.(@name==this.characterNameToLoad)[0];
				//trace(this.personalityDescriptionXML.character.(@name==this.characterNameToLoad).toString());
			}
			
				
			this.personalityDescriptionXML = incXML.character.(@name == charName)[0];
			//trace(this.personalityDescriptionXML..need);
			
			characterXML = this.personalityDescriptionXML;
			
			//get the basic needs information
			for each (var needXML:XML in characterXML..need) {
				this.needCapacity[needXML.@type]=needXML.@capacity;
				this.needRegen[needXML.@type]=needXML.@regen;
				//trace(needXML.@type + ", " + needXML.@capacity + ", " + needXML.@regen);
			}
			
			//get the traits
			for each(var traitXML:XML in characterXML..trait) {
				this.traits.push(traitXML.@name);
			}
			
			//get the ad hoc goals
			for each(var goalXML:XML in characterXML..goal) {
				var tempGoal:AdHocSocialGoal = new AdHocSocialGoal();
				tempGoal.setTopic(goalXML.@topic);
				tempGoal.setSubject(goalXML.@subject);
				tempGoal.setObject(goalXML.@object);
				tempGoal.setVolition(goalXML.@volition);
				this.adHocGoals.push(tempGoal);	
			}
			
			//get the biography
			this.biography = characterXML..bio;
		
			
			trace("Done loading XML into personality description for " + this.characterNameToLoad + ".");
			
			if(XML == null){
				this.parsedXML = true;
				this.callbackWhenXMLParsingDone();
			}
			//trace(this.toString());
		}
		
		public function toString():String {
			var returnStr:String = new String();
			returnStr = returnStr.concat("PersonalityDescription:[",this.needCapacity,"],[",this.needRegen,"],[",this.currentNeedState,"],[",this.traits,"],[",this.adHocGoals,"]["+this.biography+"]");
			return returnStr;
		}
	}
}