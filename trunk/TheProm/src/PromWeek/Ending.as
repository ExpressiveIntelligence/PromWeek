package PromWeek 
{
	public class Ending
	{
		import CiF.*;
		import flash.filters.ConvolutionFilter;
		import flash.utils.Dictionary;
		
		public var name:String = "";
		public var preconditions:Vector.<Rule>;
		public var instantiations:Vector.<Instantiation>;
		
		//The people who are finishing the game!
		public var firstName:String;
		public var secondThirdPairs:Vector.<Dictionary>;
		
		
		public var actualSecondThirdPair:Dictionary;
		
		
		//public var secondNames:Vector.<String>;
		//public var thirdNames:Vector.<String>;
		
		public var completionProgress:Number;
		
		public var dramaScore:Number;
		
		/**
		 * The ToDoItems this ending is linked to.
		 */
		public var linkedToDoItems:Vector.<ToDoItem>;
		
		public function Ending()
		{
			this.instantiations = new Vector.<Instantiation>();
			this.preconditions = new Vector.<Rule>();
			this.linkedToDoItems = new Vector.<ToDoItem>();
			
			this.actualSecondThirdPair = new Dictionary();
			
			//this.secondNames = new Vector.<String>();
			//this.thirdNames = new Vector.<String>();
		}

		
		/**
		 * Sets the percent complete value for this ending.
		 */
		public function scoreCompletionProgress():void
		{
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var gameEngine:GameEngine = GameEngine.getInstance();
			
			var maxNumPredsTrue:int = -1;
			var percentTrue:Number;
			var maxPercentTrue:Number = 0;
			//find which precodition is the closes to completion
			for each (var rule:Rule in this.preconditions)
			{
				percentTrue = rule.getPercentageTrueForInitiator(cif.cast.getCharByName(gameEngine.currentStory.storyLeadCharacter))["percent"];
				if (percentTrue > maxPercentTrue)
				{
					maxPercentTrue = percentTrue;
				}
			}
			
			this.completionProgress = maxPercentTrue;
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
				i.toc1.locutions = Util.createLocutionVectors(i.toc1.rawString);
				i.toc2.locutions = Util.createLocutionVectors(i.toc2.rawString);
				i.toc3.locutions = Util.createLocutionVectors(i.toc3.rawString);
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
			returnstr += "<Ending name=\"" + this.name + "\" dramaScore=\"" + this.dramaScore + "\""
			
			
			returnstr += ">\n";
	
			returnstr += "<ToDoItems>\n";
			for each(var t:ToDoItem in this.linkedToDoItems) {
				returnstr += "<ToDoItem name=\"" + t.name + "\" />\n";
			}
			
			
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
			
			returnXML = <Ending name={this.name} dramaScore={this.dramaScore}></Ending>;
			returnXML.appendChild(<ToDoItems/>);
			returnXML.appendChild(<Preconditions/>);
			returnXML.appendChild(<Instantiations/>);
			
			for each (var t:ToDoItem in this.linkedToDoItems) {
				returnXML.ToDoItems.appendChild(<ToDoItem name={t.name}/>)
			}
			
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
		public function loadFromXML(endingXML:XML, toDoList:Vector.<ToDoItem>=null):void 
		{
			var t:ToDoItem;
			var name:String
			
			this.name = (endingXML.@name.toString())?endingXML.@name:"untitled";
			
			this.dramaScore = (endingXML.@dramaScore)?endingXML.@dramaScore:0;
			
			//store the linked todo items
			for each (var linkedToDoXML:XML in endingXML.ToDoItems..ToDoItem) {
				name = linkedToDoXML.@name.toString();
				for each (t in toDoList) {
					if (t.name.toLowerCase() == name.toLowerCase()) {
						this.linkedToDoItems.push(t);
					}
				}
			}
			
			for each(var preconditionXML:XML in endingXML.Preconditions..Rule) {
				this.preconditions.push(ParseXML.ruleParse(preconditionXML));
			}
			
			for each(var toDoRuleXML:XML in endingXML.Preconditions..ToDoRule) {
				//get the todoItem
				name = toDoRuleXML.@name.toString()
				//put the todoItem's conditions into the ending's preconditions
				for each (t in toDoList) {
					if (t.name.toLowerCase() == name.toLowerCase()) {
						this.preconditions.push(t.condition);
					}
				}

			}
			
			for each (var instXML:XML in endingXML.Instantiations..Instantiation) {
				this.instantiations.push(ParseXML.parseInstantiation(instXML));
			}
			
			if (this.name == "Just Chillin'") {
				Debug.debug(this, "loadFromXML() Just Chillin' example: " + this.toXML());
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
			if (x.dramaScore != y.dramaScore) return false;
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