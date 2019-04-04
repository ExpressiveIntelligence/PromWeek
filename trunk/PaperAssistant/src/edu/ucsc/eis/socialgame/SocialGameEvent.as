

package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;
/*****************************************************************************
 * The SocialGameEvent class is the implementation of the social game events
 * that comprise the nodes of the dependency graph in the social game.
 * 
 * <p>From AAAI-INT2 Symposium paper:
 * "Social game events are composed of a list of participating actors, temporal 
 * properties, actions taken by actors, functional world change, and social 
 * facts modified by the event.  Optionally, the events can reference other 
 * social games to create a hierarchical decomposition of social games."</p>
 * 
 * 
 *****************************************************************************/

	public class SocialGameEvent
	{
		/*The roles associated with this game event.
		 */
		private var roles:Vector.<Role>;
		/* The social change that occurs in this event. Must have an
		 * associated role that is in the vector of roles.
		 */
		private var socialChange:Vector.<SocialChange>;
		
		/* The human language identifier of the game event. */
		private var name:String;
		
		/* The general social game description of the event. */
		private var description:String;
		
		/* The internal id of the game event specified in the social
		 * game library.
		 */
		private var id:int;
		
		/* Holds the title of the decision maker role. */
		private var decisionMaker:String;
		
		/*True if this event is at the root of a dependency graph.*/
		private var start:Boolean;
		
		/*True if this event represents a social game end state.*/
		private var end:Boolean;
		
		/*True if this event is in an antithetical path through the
		 * social game. 
		 */
		private var antithetical:Boolean;
		
		/* The id of endings this event leads to. */
		private var possibleEnds:Vector.<int>;
		
		public function SocialGameEvent() {
			this.roles = new Vector.<Role>();
			this.socialChange = new Vector.<SocialChange>();
			this.description = new String();
			this.decisionMaker = new String();
			this.start = new Boolean(false);
			this.end = new Boolean(false);
			this.antithetical = new Boolean(false);
			this.possibleEnds = new Vector.<int>();
		}
		
		public function addRole(r:Role):void {
			this.roles.push(r);
		}
		
		public function addSocialChange(sc:SocialChange):void {
			this.socialChange.push(sc);
		}
		
		public function setDescription(desc:String):void {
			this.description = desc;
		}
		
		public function getDescription():String {
			return this.description;
		}
		
		public function setDecisionMaker(title:String):void {
			this.decisionMaker = title;
		}
		
		public function getDecisionMaker():String {
			return this.decisionMaker;
		}
		
		public function isDecisionMaker():Boolean {
			return (this.decisionMaker != "");
		}
		
		/***
		 * Sets the flag for the event to think of itself as a start event.
		 * 
		 *@param isStart:Boolean Sets the event to be a start event.
		 ***/
		public function setStart(isStart:Boolean):void {
			this.start = isStart;
		}
		
		/**
		 * Flags the event as being in an antithetical path through the social game.
		 * 
		 * @param antiFlag:Boolean True if the event is to be flagged antithetical or false if not.
		 */
		public function setAntithetical(antiFlag:Boolean):void {
			this.antithetical = antiFlag;
		}
		 
		/**
		 * True if this event is in an antithetical path through the
		 * social game.
		 * 
		 * @return True if the event is in an antithetical path through the
		 * social game. False if the event is not in such a path.
		 */
		
		public function isAntithetical():Boolean {
			return this.antithetical;
		}
		
		/***
		 * Sets th eflag for the event to think of itself as an end state.
		 * 
		 * @param isEnd:Boolean True if this event is an end state.
		 ***/
		public function setEnd(isEnd:Boolean):void {
			this.end = isEnd;
		}
		
		public function isStart():Boolean {
			return this.start;
		}
		
		public function isEnd():Boolean {
			return this.end;
		}
		
		public function getRoles():Vector.<Role> { return this.roles;}
		public function getSocialChange():Vector.<SocialChange> { return this.socialChange;}
		public function getName():String {return this.name;}
		public function getId():int {return this.id;}
		public function getNumSocialChanges():int { return this.socialChange.length; }
		public function getSocialChageByIndex(i:int):SocialChange { return this.socialChange[i]; }
		
		
		
		public function setName(n:String):void {this.name = new String(n);}
		public function setId(ident:int):void {this.id = new int(ident);}
		
		public function getPossibleEnds():Vector.<int> {
			return this.possibleEnds.slice();
		}
		
		public function setPossibleEnds(ends:Vector.<int>):void {
			this.possibleEnds = ends.slice();
		}
		
		public function setPossibleEnd(end:int):void {
			this.possibleEnds.push(end);
		}
		
		
		/* Smarter accessors. */
		
		
		/**
		 * Determines the change of a chosen basic need with respect to a chosen role in this event.
		 * 
		 * @param	need Type Integer identifier for a basic need.
		 * @param	role Role as indexed by the social game.
		 * @return Amount of change to the specified basic need with regard to the specified role in this event.
		 */
		
		public function getNeedChangeByRole(needType:int, role:int):Number {
			for each (var sc:SocialChange in this.socialChange) {
				if (sc.getRole().getTitle() == this.roles[role].getTitle() && sc.getType() == needType)
					return sc.getAmount();
			}
			//trace("SocialGameEvent.getNeedChangeByRole(): This event, " + this.id + " does not have change of type " + needType + " for role " + role + " (" + this.roles[role].getTitle() + ").");
			return 0;
		}
		
		public function toString():String {
			var returnStr:String = new String();
			returnStr = "SocialGameEvent," + this.id + ","
			if (this.start)
				returnStr += "start,";
			if (this.end)
				returnStr += "end";
			if (this.antithetical)
				returnStr += "*,";
			returnStr += "[";
			//+ roles.toString() + 
			for each(var r:Role in this.roles)
				if (r.getTitle() == this.getDecisionMaker())
					returnStr += r.toString().toUpperCase() +",";
				else
					returnStr += r.toString().toLowerCase()+",";
			returnStr += "],[" + socialChange.toString() + "][" + this.description + "]";
			return returnStr;
		
		}

	}
}