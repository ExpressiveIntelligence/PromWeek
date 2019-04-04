package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;
	import flash.external.ExternalInterface;
/******************************************************************************
 * 
 * The DependencyGraph class is the data structure manifestation of the graph
 * of social game event dependencies that help structure the social games. This
 * is accomplished through a vector of references to social events coupled with
 * pairs of index values to the vector representing links between events. These
 * links are directed; the first number is the origin of link while the second
 * number is the destination.
 * 
 *****************************************************************************/
	
	public class DependencyGraph
	{
		/* Vector of social game events
		*/
		
		private var gameEvents:Vector.<SocialGameEvent>;


		/*Links array.
		 *Pair these by twos in a linear array, use two arrays, or make
		 *a link object? Probably two arrays for the first code cut.
		 */
		private var linkStart:Vector.<int>;
		private var linkEnd:Vector.<int>;
		
		/* An index to the gameEvents vector that indicates the event
		 * at which the game starts.
		 */
		private var startIndex:int;
		
		/* Vector of integers that represent the id number of the events
		 * that are antithetical end nodes in the social game.
		 */
		private var antiEnds:Vector.<int>;
		
		/* The id of the event that represents the end of the game that is
		 * inline with the "spirit of the game."
		 */
		private var traditionalEnd:int;
		
		public function DependencyGraph(){
			this.gameEvents = new Vector.<SocialGameEvent>();
			this.linkStart = new Vector.<int>();
			this.linkEnd = new Vector.<int>();
			this.antiEnds = new Vector.<int>();
			this.traditionalEnd = new int();
			this.startIndex = new int();
		}

		/*functionality to add:
		 *
		 *x-add event
		 *x-get event (probably index of event in the gameEvents vector)
		 *x-add link
		 *-traverse links
		 *-check traversiblity of graph
		 *-get list of social outcomes on a per-role basis
		 *-get roles for an event via index
		 *
		 */

		public function addLink(start:int, end:int):void {
			this.linkStart.push(start);
			this.linkEnd.push(end);
		}
		
		public function addEvent(event:SocialGameEvent):void {
			this.gameEvents.push(event);
		}
		
		/**
		 * Returns the SocialGameEvent with a specific id or null if no
		 * SocialGameEvent with that id was found in the DependencyGraph.
		 * 
		 * @param id The id of the SocialGameEvent to find.
		 * 
		 * @return A SocialGameEvent object with the id of the id parameter or null no object associated with the desired id was found.
		 */
		public function getEvent(id:int):SocialGameEvent {
			for(var i:int = new int(0); i<this.gameEvents.length; ++i)
				if (id == this.gameEvents[i].getId())
					return this.gameEvents[i];
			return null;
		}
		
		public function getNumEvents():int {
			return this.gameEvents.length;
		}
		
		public function getFirstEventIndex():int { return this.startIndex; }
		public function setFirstEventIndex(index:int):void {this.startIndex=index;}
		
		/**
		 * Finds the end nodes that can be reached for each event in the graph.
		 * The possible end nodes are stored in event.
		 */
		public function findPossibleEndsPerEvent():void {
			//start at the end nodes and work up three
			//number of antiends + 1 for trad end.
			for (var curEndIndex:int = new int(0); curEndIndex < this.antiEnds.length + 1; ++curEndIndex) {
				//for each link that ends in the current event
				//  mark the event corresponding to the start of that link with the ending
				//  make the current event the link's start
				//  repeat
				var endId:int;
				var path:Vector.<int>;
				if (curEndIndex < this.antiEnds.length) {
					//incIndexes = this.getLinksToEvent(this.antiEnds[curEndIndex]);
					endId = this.antiEnds[curEndIndex];
				} else { 
					//incIndexes = getLinksToEvent(this.traditionalEnd);
					endId = this.traditionalEnd;
				}
				
				path = getPathFromEndToStart(endId);
				for each (var node:int in path) {
					this.gameEvents[getEventIndexFromId(node)].setPossibleEnd(endId);
				}
				
			}
		}
		
		
		
		public function getPathFromEndToStart(endId:int):Vector.<int> {
			var curEventId:int = endId;
			var path:Vector.<int> = new Vector.<int>();
			//trace("start: " + this.linkStart + " end: " + this.linkEnd);
			while (curEventId != getEventIdFromIndex(this.startIndex)) {
				//this.gameEvents[getEventIndexFromId(curEventId)].setPossibleEnd(endId);
				//trace(curEventId);
				path.push(curEventId);
				curEventId = this.linkStart[this.linkEnd.indexOf(curEventId)];
			}
			path.push(curEventId);
			//trace("DependencyGraph.getPathFromEndToStart(): path " + path);
			return path;
		}
		
		
		
		public function getEventIdFromIndex(index:int):int {
			return this.gameEvents[index].getId();
		}

		public function getEventIndexFromId(id:int):int {
			for (var i:int = new int(0); i < this.gameEvents.length; ++i) {
				if (this.gameEvents[i].getId() == id)
					return i;
			}
			trace("DependencyGraph.getEventIndexFromId(): social game event not found with id " + id);
			return -1;
		}
		
		/*Returns a vector of destination indexes that start with the event with 
		 *the index of the index:int function argument.
		 */
		public function getLinksFromEvent(id:int):Vector.<int> { 
			var i:int = new int();
			var returnVec:Vector.<int> = new Vector.<int>();
			for(i=0; i<this.linkStart.length; ++i) {
					if(id == this.linkStart[i]) {
						returnVec.push(i);
					}
			}
			return returnVec;
		}

		
		public function getLinkStartByIndex(index:int):int {
			return this.linkStart[index];
		}
		
		public function getLinkEndByIndex(index:int):int {
			return this.linkEnd[index];
		}
		
		/**
		 * Gets links that lead into event.
		 * 
		 * @param	eventId	The id of the event.
		 * @return	The indexes into the depedency graph's links structures.
		 */
		public function getLinksToEvent(eventId:int):Vector.<int> {
			var returnVector:Vector.<int> = new Vector.<int>();
			for (var i:int = new int(0); i < this.linkEnd.length; ++i) {
				if (eventId == this.linkEnd[i])
					returnVector.push(i);
			}
			return returnVector;
		}
		
		/**
		 * Marks an event as either an antithetical or normal ending to the game.
		 * 
		 * @param	id The id of the event that is an ending.
		 * @param	isAntithetical = "false" True if the event is antithetical.
		 */
		public function addEnding(id:int, isAntithetical:Boolean = false):void {
//			if (id == this.traditionalEnd || this.antiEnds.filter(function(item:int, index:int, vector:Vector.<int>):Boolean { return item == id } )) {
			for each (var end:int in this.antiEnds) {
				if(id == end) {	
					trace("DependencyGraph.addEnding(): Tried adding a new ending that already exists with an event id of " + id + ".");
					return
				}
			}
			
			if(isAntithetical) {
				this.antiEnds.push(id);
				//this.getEvent(id).setAntithetical(isAntithetical);
				//trace("DependencyGraph.addEnding(): Added new antithetical end with an event id of " + id + ".");
			}else {
				this.traditionalEnd = id;
				//trace("DependencyGraph.addEnding(): Added new traditional end with an event id of " + id + ".");
			}
			
		}
		
		/**
		 * Gets the id of the traditional end social game event.
		 * 
		 * @return The id of the traditional end social game event.
		 */
		public function getTraditionalEnd():int {
			return this.traditionalEnd;
		}
		
		public function getAntiEnds():Vector.<int> {
			//trace("DependencyGraph.getAntiEnds: this.antiEnds - " + this.antiEnds);
			
			return this.antiEnds.slice();
		}
		
		public function getAntiEndCount():int {
			return this.antiEnds.length;
		}
		
		public function getNextEventIds(eventId:int):Vector.<int> {
			//var nextLinkIndexes:Vector.<int> = this.getLinksFromEvent(this.getEventIndexFromId(eventId));
			var nextLinkIndexes:Vector.<int> = this.getLinksFromEvent(eventId);
			var nextEventIds:Vector.<int> = new Vector.<int>();
			
			//trace("DependencyGraph.getNextEventIds(): eventId - " + eventId + " nextLinkIndexes - " + nextLinkIndexes);
			
			for each (var index:int in nextLinkIndexes) {
				nextEventIds.push(this.linkEnd[index]);
			}
			return nextEventIds.slice();
		}
		
		public function validate():Boolean {
			//Make sure start, ending, and antithetical tags are consistent between the dependency graph
			//and the events.
			
			//ensure each event is accessible
			/*
			Check start node.
			Depth first search?
			Cycle recognition? 
			*/
			//make sure each link has a start and end
			return true;
		}
		
		public function traceAllPossibleEnds():void {
			for each (var e:SocialGameEvent in this.gameEvents) {
				trace(e.getId() + " - " + e.getPossibleEnds());
			}
		}
		
		public function toString():String {
			var returnStr:String = new String();
			returnStr = returnStr.concat("DependencyGraph[");
			//, this.gameEvents, "],[", this.linkStart, "],[", this.linkEnd, "]");
			for each (var e:SocialGameEvent in this.gameEvents)
				returnStr += "\n    " + e;
			returnStr += "],[", this.linkStart, "],[", this.linkEnd, "]";
			return returnStr;	
		}
		
		
	}
}
