package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;

/******************************************************************************
 * The SocialGame class is the implation of the social game concept. It is 
 * comprised of a set of dramaturgical preconditions, a dependency graph of
 * social game events, a set of associated roles, and functions over the data
 * that aggregates and/or provides the information in the social game's 
 * associated data structures in a more convenient packaging.
 * 
 * <p>Should we keep this as more of a value object or place the hooks into the
 * class for social game execution?</p>
 * 
 *****************************************************************************/

	
	public class SocialGame
	{
		private var depGraph:DependencyGraph;
		private var dramaPreconds:Vector.<DramaturgicalPrecondition>;
		private var roles:Vector.<Role>;
		/* The name of the SocialGame.
		 */
		private var name:String;
		
		/* State members for social game simulation. */
		/* The end node reached at the end of a simulation. */
		private var endTaken:int;
		//* The id of the current event when simulation is running.*/
		private var curEventId:int;
		/* Name of the character name who is the decision maker. */
		private var decisionMaker:String;
		/* True if the simulation has reached an end.*/
		private var done:Boolean;
		
		
		public function SocialGame() {
			this.depGraph = new DependencyGraph();
			this.dramaPreconds = new Vector.<DramaturgicalPrecondition>();
			this.roles = new Vector.<Role>();
			this.name = new String();
			this.endTaken = new int(-1);
			this.curEventId = new int(0);
			this.decisionMaker = new String();
			this.done = new Boolean(false);
		}

		
		/* Game simulation methods. */
		
		/**
		 * Initializes the social game for simulation mode.
		 */
		public function start():void {
			this.curEventId = this.getNextDecisionPoint(this.depGraph.getFirstEventIndex());
			this.decisionMaker = this.depGraph.getEvent(this.curEventId).getDecisionMaker();
		}
		
		/**
		 * Advances the social game simulation. Updates current event id to
		 * next decision point. Updates decision maker member. Checks for
		 * game end conditions. To be called by the performance realization
		 * process. 
		 * @param	eventId	The id of the social game event to advance from
		 * (intended to be the choice of the decision making character).
		 */
		public function advance(eventId:int):void {
			/*this.curEventId = this.getNextDecisionPoint(eventId);
			this.decisionMaker = this.depGraph.getEvent(this.curEventId).getDecisionMaker();*/
			if (this.depGraph.getEvent(this.curEventId).isEnd()) {
				this.done = true;
				this.endTaken = this.curEventId;
			}else {
				this.curEventId = this.getNextDecisionPoint(eventId);
				this.decisionMaker = this.depGraph.getEvent(this.curEventId).getDecisionMaker();
			}
			if (this.depGraph.getEvent(this.curEventId).isEnd()) {
				this.done = true;
				this.endTaken = this.curEventId;
			}
			
			//trace("SocialGame.advance(): curEventId - " + this.curEventId + " decision maker - " + this.decisionMaker + " done - " + this.done);
				
		}
		
		/**
		 * Given the social game simulation's current event id, this function
		 * provides the next social game events and is intended to aide the
		 * decision making character in the decision making process.
		 * @return	The next social game events.
		 */
		public function getNextEvents():Vector.<SocialGameEvent> {
			var nextEventIds:Vector.<int> = this.depGraph.getNextEventIds(this.curEventId);
			var nextEvents:Vector.<SocialGameEvent> = new Vector.<SocialGameEvent>();
			for each (var id:int in nextEventIds) {
				nextEvents.push(this.depGraph.getEvent(id));
			}
			
			return nextEvents;
		}
		
		/**
		 * Checks to see if the simlated social game is completed.
		 * @return True of the game has reached an end or false if
		 * the game is still in progress.
		 */
		public function isDone():Boolean {
			return this.done;
		}
		
		/**
		 * Finds the next decision point after a specified event.
		 * @param	eventId	Id of the event to find the next decision point from.
		 * @return	Id of the event that is the next decision point.
		 */
		public function getNextDecisionPoint(eventId:int):int {
			var curId:int = eventId;
			var linkIndexes:Vector.<int> = this.depGraph.getLinksFromEvent(curId);
			var eventCount:int = this.depGraph.getNumEvents();
			
			//trace("SocialGame.getNextDecisionPoint(): curId - " + curId + " link indexes - " + linkIndexes + " event count - " + eventCount);
			
			while (linkIndexes.length < 2 && eventCount > 0 && linkIndexes.length != 0) {
				curId = this.depGraph.getLinkEndByIndex(linkIndexes[0]);
				linkIndexes = this.depGraph.getLinksFromEvent(curId);
				--eventCount;
				//trace("SocialGame.getNextDecisionPoint(): curId - " + curId + " link indexes - " + linkIndexes + " event count - " + eventCount);
			}
			if (eventCount < 1) {
				//trace("SocialGame.getNextDecisionPoint(): No remaining decision points.");
				return eventId;
			}
			return curId;
		}
		
		public function getDescriptionOfEvent(eventId:int):String {
			return this.depGraph.getEvent(eventId).getDescription();
		}
		
		//getters
		public function getDecisionMaker():String { return this.decisionMaker; }
		public function getName():String {return this.name;}
		public function getRole(i:int):Role {return this.roles[i];}
		public function getAllRoles():Vector.<Role> {
			//better to clone this one
			var returnRoles:Vector.<Role> = new Vector.<Role>();
			for(var i:int = new int(0); i<this.roles.length; ++i) {
				returnRoles.push(this.roles[i]);
			} 
			return returnRoles.slice();
		}
		public function getRoleTitleString(i:int):String {
			return new String(this.roles[i].getTitle());
		}
		public function getAllRoleTitles():Vector.<String> {
			var roleTitles:Vector.<String> = new Vector.<String>();
			for(var i:int = new int(0); i<this.roles.length; ++i) {
				roleTitles.push(new String(this.getRoleTitleString(i)));
			}
			return roleTitles;
		}
		public function getNumRoles():int { return this.roles.length; }

		
		
		//setters
		public function setName(n:String):void { this.name = n; }

		public function addRole(role:Role):void {
			this.roles.push(role);
		}

		public function addPrecond(precond:DramaturgicalPrecondition):void {
			this.dramaPreconds.push(precond);
		}
		
		public function addDependencyGraph(graph:DependencyGraph):void {
			this.depGraph = graph;
		}
		
		public function getAntiEndCount():int {
			return this.depGraph.getAntiEndCount();
		}

		public function setEndTaken(end:int):void { this.endTaken = end; }
		public function getEndTaken():int { return this.endTaken; }
	
		/**
		 * Determines the decisions and their possible end outcomes.
		 * 
		 * @return	The end states reachable by each choice available in the social game.
		 */
		 
/*		public function getEndingChoices():Vector.<Vector.<int>> {
			
		}
*/		
		
		//smarter mutators
		
		public function unAssignAllRoles():void {
			for (var i:int = new int (0); i < this.roles.length; ++i) {
				this.roles[i].setCharacterName("");
				this.roles[i].setHasCharacterAssigned(false);
			}
		}
		
		
		public function assignCharacterToRoleByName(characterName:String, roleTitle:String):void {
			for (var i:int = new int (0); i < this.roles.length; ++i) {
				if (this.roles[i].getTitle().toLowerCase() == roleTitle.toLowerCase()) {
					//trace("SocialGame:assignCharacterToRoleByName(): Role " + this.roles[i].getTitle() + " assigned to " + characterName);
					this.roles[i].setCharacterName(characterName);
					return;
				}
			}
			/*for each (var role:Role in this.roles) {
				if (role.getTitle() == roleTitle) {
					role.setCharacterName(characterName);
					return;
				}
			}*/
		}
		
		
		//smarter accessors

		/* Package up information from other social game data structures:
		 * - SocialChange by Role
		 * - 
		 * - 
		 */
		 
		 /**
		  * Determines the how a specific basic need is impacted with respect to an individual role in
		  * the social game.
		  * 
		  * @param	need The need for which to track changes.
		  * @param	role The role to which the social changes apply.
		  * @return The amount by which the basic need was satiated by the events in the game regardless of ending.
		  */
		 
		 public function getNeedChangeByRole(need:int, role:int):Number {
		 	var needChange:Number = new Number(0.0);
		 	var roleTitle:String = new String();
		 	roleTitle = this.getRoleTitleString(role);
		 	
		 	for(var curEventIndex:int = new int(0); curEventIndex<this.depGraph.getNumEvents(); ++curEventIndex) {
		 		var gameEvent:SocialGameEvent = this.depGraph.getEvent(curEventIndex);		 		
		 		for(var curChangeIndex:int = new int(0); curChangeIndex<gameEvent.getNumSocialChanges(); ++curChangeIndex ) {
		 			var change:SocialChange = gameEvent.getSocialChageByIndex(curChangeIndex);
		 			//trace(change);
		 			if(change.getType()==need && change.getRole().getTitle() == roleTitle) {
		 				needChange += change.getAmount();
		 			}
		 		}
		 	}
		 	//trace("socialgame.needChange: " + needChange);
		 	return needChange;
		 }
		 
		 /**
		  * Determine the change of a particular basic need with respect to social game, role, and game ending.
		  * 
		  * @param	need Type The need for which to track changes.
		  * @param	role The role to which the social changes apply.
		  * @param	ending The changes that take place in the game events leading to the ending specifed by this argument.
		  * @return The amount by which the basic need was satiated by the events in the game.
		  */ 
		public function getNeedChangeByRoleAndEnd(needType:int, role:int, ending:int):Number {
			var sgevent:SocialGameEvent = this.depGraph.getEvent(ending);
			if (!sgevent.isEnd()) {
				trace("SocialGameEvent.getNeedChangeByRoleAndEnding(): event " + ending + " is not an end event.");
				return 0;
			}
			return sgevent.getNeedChangeByRole(needType, role);
			 
		}
		 
		/**
		 * Determines if a character is assigned a role in this social game.
		 * 
		 * @param	name Name of character to check.
		 * @return	True if the character has already been assigned a role or
		 * false if the character is not yet associated with the social game.
		 */
		public function isCharacterInGame(name:String):Boolean {
			for each (var role:Role in this.roles) {
				if (name.toLowerCase() == role.getCharacterName().toLowerCase())
					return true;
			}
			return false;
		}
		
		public function getCharacterInRole(roleTitle:String):String {
			
			for each (var role:Role in this.roles) {
				if (role.getTitle().toLowerCase() == roleTitle.toLowerCase())
					return role.getCharacterName();
			}
			return "";
		}
		
		public function getTraditionalEndId():int {
			return this.depGraph.getTraditionalEnd();
		}
		
		public function getAntiEnds():Vector.<int> {
			//trace("SocialGames.getAntiEnds: antiEnds - " + this.depGraph.getAntiEnds());
			return this.depGraph.getAntiEnds();
		}
		
		public function createClone():SocialGame {
			var sg:SocialGame = new SocialGame();
			sg.depGraph = this.depGraph;
			sg.dramaPreconds = this.dramaPreconds.concat();
			sg.roles = this.roles.concat();
			sg.name = this.name;
			return sg;
		}
		 
		public function toString():String {
			var returnStr:String = new String();
			returnStr = returnStr.concat("SocialGame:",this.name,",[",this.roles,"],[",this.dramaPreconds,"],[",this.depGraph,"]");
			return returnStr;
		}

	}
}