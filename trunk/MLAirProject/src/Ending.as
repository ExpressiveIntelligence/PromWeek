package
{
	public class Ending
	{
		import CiF.*;
		
		public var name:String = "";
		public var preconditions:Vector.<Rule>;
		public var instantiations:Vector.<Instantiation>;
		
		//The people who are finishing the game!
		public var firstName:String;
		public var secondName:String;
		public var thirdName:String;

		public function Ending()
		{
			this.instantiations = new Vector.<Instantiation>();
			this.preconditions = new Vector.<Rule>();
		}

		/**
		 * Adds an instantation the the social game's instantions and gives
		 * it an ID. 
		 * @param	instantiation	The instantiation to add.
		 */
		public function addInstantiation(instantiation:Instantiation):void {
			var instant:Instantiation = instantiation.clone();
			var idToUse:Number = 0;
			for each(var iterInstant:Instantiation in this.instantiations) {
				if (iterInstant.id > idToUse)
					idToUse = iterInstant.id + 1;
			}
			instant.id = this.instantiations.length;
			this.instantiations.push(instant);
		}
		
		/**
		 * Evaluates the precditions of the social game with respect to 
		 * character/role mapping given in the arguments.
		 * 
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return True if all precondition rules evaluate to true. False if 
		 * they do not.
		 */
		public function checkPreconditions(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
			for each (var preconditionRule:Rule in this.preconditions) {
				//if (name.toLowerCase() == "true love's kiss") 
					//Debug.debug(this, initiator.characterName + ", " + responder.characterName + " on " + preconditionRule.toString());
				if (!preconditionRule.evaluate(initiator, responder, other, sg))
					return false;
			}
			return true;
		}
		
		
		/**
		 * Synonym setter for the game's name (backward compatability with
		 * GDC demo.
		 */
		public function get specificTypeOfGame():String {
			return this.name;
		}
		
		/**
		 * Synonym setter for the game's name (backward compatability with
		 * GDC demo.
		 */
		public function set specificTypeOfGame(n:String):void {
			this.name = n;
		}
		
		/**
		 * Determines if we need to find a third character for the intent
		 * formation process.
		 * @return True if a third character is needed, false if not.
		 */
		public function thirdForIntentFormation():Boolean {
			for each (var r:Rule in this.preconditions) 
				if (r.requiresThirdCharacter()) return true;

			return false;
		}
		
		
		/**
		 * Finds an instantiation given an id. 
		 * @param	id	id of instantiation to find.
		 * @return	Instantiation with the parameterized id, null if not
		 * found.
		 */
		public function getInstantiationById(id:int):Instantiation {
			for each(var inst:Instantiation in this.instantiations) {
				if (id == inst.id)
					return inst;
			}
			Debug.debug(this, "getInstiationById() id not found. id=" + id);
			return null;
		}
		
		public function prepareLocutions():void
		{
			for each (var i:Instantiation in this.instantiations)
			{
				for each (var lod:LineOfDialogue in i.lines) 
				{
					//Debug.debug(this, "prepareLocutions() for game " + sg.name);
					lod.initiatorLocutions = Util.createLocutionVectors(lod.initiatorLine);
					lod.responderLocutions = Util.createLocutionVectors(lod.responderLine);
					lod.otherLocutions = Util.createLocutionVectors(lod.otherLine);
					//Debug.debug(this, "prepareLocutions(): initiatior loction count for line: " + lod.initiatorLocutions.length);
				}
			}
		}
		
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		public function toXMLString():String {
			var returnstr:String = new String();
			var i:Number = 0;
			returnstr += "<Ending name=\"" + this.name + "\""
			
			
			returnstr += ">\n";
	
			
			returnstr += "<Preconditions>\n";
			for (i = 0; i < this.preconditions.length; ++i) 
			{
				returnstr += this.preconditions[i].toXMLString();
			}
			returnstr += "</Preconditions>\n";
			
			returnstr += "<Instantiations>\n";
			for (i = 0; i < this.instantiations.length; ++i) {
				returnstr += this.instantiations[i].toXMLString();
			}
			returnstr += "</Instantiations>\n";
			
			returnstr += "</Ending>\n";
			return returnstr;
		}
		 
		
		public function toXML():XML {
			var returnXML:XML;
			
			returnXML = <Ending name={this.name}></Ending>;
			returnXML.appendChild(<Preconditions/>);
			returnXML.appendChild(<Instantiations/>);
			
			for each (var r:Rule in this.preconditions) 
			{
				returnXML.Preconditions.appendChild(r.toXML());
			}
			
			for each (var i:Instantiation in this.instantiations) {
				returnXML.Instantiations.appendChild(i.toXML());
			}
			
			return returnXML;
		}
		
		
		/**
		 * Translates <Level> XML objects to the elements of this instantiation
		 * of the level class.
		 * 
		 * @param	levelXML	An XML representation of a level.
		 */
		public function loadFromXML(endingXML:XML):void 
		{
			this.name = (endingXML.@name.toString())?endingXML.@name:"untitled";
			
			for each(var preconditionXML:XML in endingXML.Preconditions..Rule) {
				this.preconditions.push(ParseXML.ruleParse(preconditionXML));
			}
			
			for each (var instXML:XML in endingXML.Instantiations..Instantiation) {
				this.instantiations.push(ParseXML.parseInstantiation(instXML));
			}
		}
		
		public function clone(): Ending {
			var sg:Ending = new Ending();
			sg.name = this.name;
			
			sg.preconditions = new Vector.<Rule>();
			for each(var r:Rule in this.preconditions) {
				sg.preconditions.push(r.clone());
			}
			sg.instantiations = new Vector.<Instantiation>();
			for each(var i:Instantiation in this.instantiations) {
				sg.instantiations.push(i.clone());
			}
			return sg;
		}
		
		public static function equals(x:Ending, y:Ending): Boolean {
			if (x.name != y.name) return false;
			var i:Number = 0;
			if (x.preconditions.length != y.preconditions.length) return false;
			for (i=0; i < x.preconditions.length; ++i) {
				if (!Rule.equals(x.preconditions[i], y.preconditions[i])) return false;
			}
			if (x.instantiations.length != y.instantiations.length) return false;
			for (i = 0; i < x.instantiations.length; ++i) {
				if (!Instantiation.equals(x.instantiations[i], y.instantiations[i])) return false;
			}
			return true;
		}
	}
	
}