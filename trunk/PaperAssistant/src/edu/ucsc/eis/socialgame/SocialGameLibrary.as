
package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;
	import mx.collections.ArrayCollection;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import edu.ucsc.eis.socialservices.SGutils;

/******************************************************************************
 * 
 * 
 * 
 * 
 * 
 *****************************************************************************/

	
	public class SocialGameLibrary
	{
		/* Vector of social games objects that comprises the bulk of the
		 * social game library
		 */
		private var library:Vector.<SocialGame>;
		
		
		/* Stores the loaded XML library from a file.*/
		private var socialGameLibXML:XML;
		
		/* The object that requests the XML file from a URL string.*/
		private var xmlurl:URLRequest;
		
		/* Loads the requested XML from the URL after this.xmlurl 
		 * performs its task.
		 */
		private var xmlLoader:URLLoader;
		
		/* Function to call when the XML containing the library has been
		 * fully parsed.
		 */
		private var callbackWhenXMLParsingDone:Function;

		/* true when the XML parsing has been completed. */
		private var parsedXML:Boolean;
		
		public function SocialGameLibrary()	{
			this.library = new Vector.<SocialGame>();
			this.socialGameLibXML = new XML();
			this.parsedXML = new Boolean(false);
		}

		public function unAssignAllRoles():void {
			for (var i:int = new int(0); i < this.library.length; ++i) {
				this.library[i].unAssignAllRoles();
			}
		}
		
		public function getGameNames():ArrayCollection {
			var names:ArrayCollection = new ArrayCollection();
			for (var i:int = new int(0); i < this.library.length; ++i) {
				names.addItem(this.library[i].getName());
			}
			return names;
		}
	
		/**
		 * Reads an XML file from a URL and places the contents in the 
		 * SocialGameLibrary's socialGameLibXML member.
		 * 
		 * @param url A string representation of the URL at which the social game library XML file is found.
		 */
		public function readXMLFromFile(url:String, callback:Function):void {
			this.callbackWhenXMLParsingDone = callback;
			this.xmlurl = new URLRequest(url);
			this.xmlLoader = new URLLoader(this.xmlurl);
			this.xmlLoader.addEventListener("complete", this.xmlLoadedCallback);
		}

		/***
		 * Loads the XML for the social game library from an XML object that
		 * resides in memory. Now that Flex 4 allows for an easy method to load
		 * XML in a declarations/xml tag set (see Assistant.mxml), the
		 * error prone and complicated method of URL loading a local XML file
		 * with the appropriate callback functions can be depricated.
		 * 
		 * @param sglibXML:XML The social game library in an XML object.
		 ***/
		public function readXML(sglibXML:XML):void {
			this.socialGameLibXML = sglibXML;
		}
		
		//getters
		public function isXMLParsed():Boolean { return this.parsedXML;}
		public function getLibraryXML():XML { return this.socialGameLibXML; }
		/**
		 * Returns a clone of the ith social game in the library.
		 * 
		 * @param	i	Index of the social game to clone.
		 * @return		Clone of the ith social game.
		 */
		public function getSocialGame(i:int):SocialGame { return this.library[i].createClone(); }
		
		public function getGameByName(name:String):SocialGame {
			for(var i:int = new int(0); i < this.library.length; ++i) {
				if(name == this.library[i].getName()) {
					return this.library[i];
				}
			} 
			trace("Library does not contain a social game with the name of "+name+".");
			return new SocialGame();
		}
		
		/**
		 * Gets the index of a game in the social game library given the game's name.
		 * 
		 * @param	name	Name of the social game.
		 * @return	Index of the social game in the library or -1 if the library does
		 * not contain a game corresponding to the name parameter.
		 */
		public function getGameIndexByName(name:String):int {
			for(var i:int = new int(0); i < this.library.length; ++i) {
				if(name == this.library[i].getName()) {
					return i;
				}
			} 
			trace("Library does not contain a social game with the name of "+name+".");
			return -1;
		}
		
		public function getLength():int { return this.library.length;}
		
		//setters

		/**
		 * The event handler called when the XML is loaded from the URL. It
		 * places the social game library xml in this.socialGameLibXML for
		 * later use.
		 */
		private function xmlLoadedCallback(evt:Event):void {
			this.socialGameLibXML = XML(this.xmlLoader.data);
			this.createSocialGameLibFromXML();
		}
		
		/**
		 * Creates the social game library data structures from an XML
		 * representation. Requires the XML be loaded via the preferred
		 * this.readXML() or this.readXMLFromFile().
		 */
		public function createSocialGameLibFromXML():void {
			//load social game utilities for need string=>int mapping
			var util:SGutils = new SGutils();
			
			/*for each (var num:XML in employees..@ssn) {
                trace(num);                             // 123-123-1234
            }*/
            for each(var game:XML in this.socialGameLibXML..SocialGame) {
            	var tempGame:SocialGame = new SocialGame();
            	//add the roles
            	//trace(game..Role);
            	for each(var role:XML in game..Role) {
            		var tempRole:Role = new Role();
            		tempRole.setTitle(role.@name);
            		tempGame.addRole(tempRole);
            		//trace(role.@name);
            	}
            	//add the dramaturgical preconditions
            	for each(var precond:XML in game..DramaturgicalPrecondition) {
            		var tempPrecond:DramaturgicalPrecondition;
            		if("relation" == precond.@type) {
            			tempPrecond = new RelationPrecondition();
            			tempPrecond.setPrecondition(precond.@firstRole,precond.@relation,precond.@secondRole);
            		}else if("fact" == precond.@type) {
            			tempPrecond = new FactPrecondition();
            			tempPrecond.setPrecondition(precond.@role,precond.fact);
            		}
            		tempGame.addPrecond(tempPrecond);
            	}
            	
            	/*Create the dependency graph that will be filled in over the bulk
            	  * of the remainder of this function.
            	  */
            	var tempDependencyGraph:DependencyGraph = new DependencyGraph();
            	
            	//add the social game events
            	// * active roles
            	//   * social change in roles
				// * set ending flag
				// * set starting flag
            	for each(var event:XML in game..Event) {
            		var tempEvent:SocialGameEvent = new SocialGameEvent();
            		tempEvent.setId(event.@id);
            		
					//get descriptions into events from XML
					//translate the social change need type from string to int
					//put roles in events
					//put roles in social changes
					//mark decision maker role title in events
					
            		for each(var activeRole:XML in event..ActiveRole) {
            			var tempActiveRole:Role = new Role();
            			tempActiveRole.setTitle(activeRole.@name);
            			for each (var change:XML in activeRole.SocialChange) {
            				var tempSocialChange:SocialChange = new SocialChange();
							//In the XML, the types in <SocialChange> are strings
							//so we need to convert them to ints.
            				tempSocialChange.setType(util.needIDFromString(change.@type));
            				tempSocialChange.setAmount(change.@amount);
            				tempSocialChange.setRole(tempActiveRole);
            				tempEvent.addSocialChange(tempSocialChange);
            			}
						
						
            			tempEvent.addRole(tempActiveRole);
            		}
					//determine if a decision maker is present
					if (event.DecisionMaker)
						tempEvent.setDecisionMaker(event.DecisionMaker.@name);
					
					if (event.@antithetical == true) {
						tempEvent.setAntithetical(true);
						//tempDependencyGraph.addEnding(tempEvent.getId(), true);
					}else{
						tempEvent.setAntithetical(false);
						//tempDependencyGraph.addEnding(tempEvent.getId(), false);
					}
						
					(event.@start == true) ? tempEvent.setStart(true) : tempEvent.setStart(false);
					if (event.@end == true) { 
						tempEvent.setEnd(true);
						tempDependencyGraph.addEnding(tempEvent.getId(), tempEvent.isAntithetical());
					}else {
						tempEvent.setEnd(false);
					}
					
					
					
					if (event.Description)
						tempEvent.setDescription(event.Description);
						
            		tempDependencyGraph.addEvent(tempEvent);
            	}
            	
            	//add links to the dependency graph
            	for each(var link:XML in game..Link) {
            		tempDependencyGraph.addLink(link.@start,link.@end);
            	}
				
            	tempGame.setName(game.@name);
				
            	//process possible ends in the dependency graph
				//trace(tempGame.getName());
				tempDependencyGraph.findPossibleEndsPerEvent();
				//tempDependencyGraph.traceAllPossibleEnds();
				
            	//add dependency graph to the social game
            	tempGame.addDependencyGraph(tempDependencyGraph);
            	
            	
            	
            	//profit!!
            	
            	//trace(tempGame);
            	this.library.push(tempGame);	
            }
            this.parsedXML = true;
            trace("SocialGameLibrary has finished loading and parsing XML.");
			//this.callbackWhenXMLParsingDone();
			
			//trace(this.toString());
		}
		
		public function toString():String {
			var returnStr:String = new String("SocialGameLibrary:[");
			for each (var g:SocialGame in this.library)
				returnStr += "\n  " + g;
			returnStr += "]\n";
			return returnStr;
		}
	}
}


