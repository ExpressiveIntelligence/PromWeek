
package edu.ucsc.eis
{
	
	import __AS3__.vec.Vector;
	import edu.ucsc.eis.socialservices.SGutils;
	
	import edu.ucsc.eis.socialgame.*;

	
 /**
 * Implements interface edu.ucsc.eis.Entity
 * 
 * <p>A SocialEntity is a special type of entity that is capable of having the 
 * the social AI system run over it. Specifically, the SocialEntity has a
 * personality description, a basic needs state, stored goal volition, and 
 * access to the social state.</p>
 * 
 * <p>The SocialEntity also stores some agent-specific mental state for book
 * keeping during the social AI process. </p>
 * 
 */

	public class SocialEntity implements Entity
	{
		public var currentNeedsState:Vector.<Number>;
		private var personalityDescription:PersonalityDescription;
		private var name:String;

		/* Stores the goals and their normalized probability space from
		 * the SetGoals service.
		 */
		private var goals:Vector.<SocialGoal>;

		/* Stores the name of the goal chosen by the intent planning
		 * service.
		 */
		private var intendedSocialGame:String;
		
		/* Stores the string name of the preferred role in the chosen
		 * social game.
		 */
		private var intendedRole:String;
		
		/* Volitions matrix. */
		public var volition:Vector.<Vector.<Vector.<Number>>>;
		
		/* Volition modifier. A value of 1.0 is normal volition.*/
		public var volitionModifier:Number;
		
		private var inRole:Boolean;
		
		
		public function SocialEntity() {
			this.currentNeedsState = new Vector.<Number>(16);
			for (var i:int = 0; i < this.currentNeedsState.length; ++i)
				this.currentNeedsState[i] = 0.0;
			this.personalityDescription = new PersonalityDescription();
			this.name = new String();

			
			this.goals = new Vector.<SocialGoal>();
			this.intendedSocialGame = new String();
			this.intendedRole = new String();			
			this.inRole = new Boolean(false);
			this.volitionModifier = new Number(1.0);
		}
		
		/**
		 * Choses an event from a set of events by chosing the event that
		 * has the highest volition ending as a possible ending.
		 * @param	events 	The social game events to choose from.
		 * @param 	game	The social game the events are from.
		 * @return	Id of the chosen social game event.
		 */
		public function chooseEvent(events:Vector.<SocialGameEvent>, game:SocialGame):int {
			var bestEvent:SocialGameEvent = events[0];
			var bestEventScore:Number = 0.0;
			
			for each (var e:SocialGameEvent in events) {
				var volition:Number = this.getHighestVolitionFromEventEndings(e, game);
				if (volition > bestEventScore) {
					bestEventScore = volition;
					bestEvent = e;
				}
			}
			//trace("SocialEntity:chooseEvent(): chosen event id - " + bestEvent.getId());
			return bestEvent.getId();
		}
		
		private function getHighestVolitionFromEventEndings(event:SocialGameEvent, game:SocialGame):Number {
			var bestVolition:Number = 0.0;
			var curRoleIndex:int = int(0);
			var curNeedIndex:int = int(0);

			for each (var end:int in event.getPossibleEnds()) {
				for(curRoleIndex=0; curRoleIndex < game.getNumRoles(); ++curRoleIndex) {
					var score:Number = new Number(0.0);
					var volition:Number = new Number(0.0);
					for (curNeedIndex = 0; curNeedIndex < this.personalityDescription.NUMBER_OF_NEEDS; ++curNeedIndex) {
						score = game.getNeedChangeByRoleAndEnd(curNeedIndex, curRoleIndex, end);
						//trace(score);
						volition += this.getNeedValence(curNeedIndex) * score * this.getNeedVolition(curNeedIndex);
					}
					if (volition > bestVolition) bestVolition = volition;
				}
			}
			return bestVolition;
		}
		
		/**
		 * 	Updates the current need state according to the need profile in
		 *  the personality description. The higher the described need strenth
		 *  the faster the current need will increase. The basic need will
		 *  increase its regeneration value in proportion to the regeneration
		 *  cycles input to the function.
		 * 
		 * @param regenCycles:Number The amount the regeneration value of each
		 * basic need is factored by to determine change to the current need 
		 * strength.
		 * 
		 */
		public function updateNeedState(regenCycles:Number):void {
			var i:int = new int(0);
			for(;i< this.currentNeedsState.length; ++i) {
				var regen:Number = this.personalityDescription.getNeedRegen(i);
				var capacity:Number = this.personalityDescription.getNeedCapacity(i);
				
				this.currentNeedsState[i] += regenCycles * regen * this.getNeedValence(i);
				if (Math.abs(this.currentNeedsState[i]) >= Math.abs(capacity))
					this.currentNeedsState[i] = capacity;
				
				//if need value will be over capacity after update, keep it at cap
				/*if(Math.abs(this.currentNeedsState[i] + (regenCycles * regen)) >= Math.abs(capacity)) {
					this.currentNeedsState[i] = capacity;
				}else{
					this.currentNeedsState[i] += regenCycles * regen * this.getNeedValence(i);
				}*/ 
			}
		}
		
		
		/**
		 * @desc Directs the SocialEntity to have it's PersonalityDescription initialize
		 * itself from the specified personality description XML file. The name of
		 * the character must be set with the SocialEntity.setName() before this
		 * intialization can happen.
		 * 
		 * @param pathToXMLFile:String The path to the XML file holding the
		 * personality description in String form.
		 * 
		 * @param callback:Function The function to call when the XML parsing is finished.
		 */ 
		public function loadPersonalityDescriptionFromXMLFile(pathToXMLFile:String, callback:Function):void {
			if(""==this.name) {
				trace("SocialEntity attempted to load a personality description from XML without setting a character name. Skipping the loading.");
			} else {
				this.personalityDescription.loadPersonalityFromXML(this.name, pathToXMLFile, callback);
			}
		}
		
		/***
		 * Initiates the loading of a personality description from an XML object
		 * that is already in memory.
		 * 
		 * @param characterXML:XML An XML object that contains a character description.
		 */
		public function loadPersonalityDescriptionFromXML(characterXML:XML):void {
			this.personalityDescription.createPersonalityDescriptionFromXML(characterXML, this.name);
			
		}
		
		/**
		 * Creates the multi-dimensional vector that houses the volition matrix.
		 * 
		 * @param	sglib	A library of social games.
		 */
		
		public function initializeVolitionMatrix(sglib:SocialGameLibrary):void {
			this.volition = new Vector.<Vector.<Vector.<Number>>>();
			
			var curGameIndex:int = new int();
			var curRoleIndex:int = new int();
			var curNeedIndex:int = new int();
			var curEndIndex:int = new int();
			
			for (curGameIndex = 0; curGameIndex < sglib.getLength(); ++curGameIndex) {
				var numRoles:int = new int(0);
				var game:SocialGame = new SocialGame();
				var antiEnds:Vector.<int>;
				game = sglib.getSocialGame(curGameIndex);
				numRoles = game.getNumRoles();
				this.volition.push(new Vector.<Vector.<Number>>());
				//antiEnds = game.getAntiEnds().slice();
				for (curEndIndex = 0; curEndIndex < game.getAntiEndCount()+1; ++curEndIndex) {
					this.volition[curGameIndex].push(new Vector.<Number>(numRoles));
					/*Uncomment this if the volition matrix needs to be initialized to 0.0.
					 * 
					 for(curRoleIndex=0; curRoleIndex < numRoles; ++curRoleIndex) {
						this.volition[curGameIndex][curEndIndex][curRoleIndex] = 0.0;

					}*/
				}
			}
		}
		
		/**
		 * Places a volition value in the volition matrix.
		 * 
		 * @param	gameIndex	Index in the volition matrix of the game dimension.
		 * @param	endIndex	Index in the volition matrix of the game end dimension.
		 * @param	roleIndex	Index in the volition matrix of the role dimension.
		 * @param	value		Volition value to be placed in the matrix.
		 */
		public function setVolitionMatrixValue(gameIndex:int, endIndex:int, roleIndex:int, value:Number):void {
			this.volition[gameIndex][endIndex][roleIndex] = value;
		}
		
		public function getVolitionMatrixValue(gameIndex:int, endIndex:int, roleIndex:int):Number {
			return this.volition[gameIndex][endIndex][roleIndex];
		}
		
		//getters
		public function getName():String { return this.name;}
		public function getNeedState(index:int, name:String = ""):Number {
			var util:SGutils = new SGutils();
			if (name != "") 
				return this.currentNeedsState[util.needIDFromString(name)];
			return this.currentNeedsState[index];
		}
		public function isParsed():Boolean {return this.personalityDescription.isXMLParsed();}
		public function hasRole():Boolean { return this.inRole;}
		public function setInRole(isInRole:Boolean):void { this.inRole = isInRole;}
		
		public function getNeedGoal(needType:int):BasicNeedGoal { 
			for each (var g:SocialGoal in this.goals) {
				if (g.isBasicNeeds()) {
					var bng:BasicNeedGoal = g as BasicNeedGoal;
					if (bng.getBasicNeed() == needType)
						return bng;
				}
			}
			return null;
		}
		
		public function getNeedVolition(needType:int):Number {
			return this.getNeedGoal(needType).getVolition();
		}
		
		/**
		 * Get the top n traditional social game endings sorted by volition value.
		 * 
		 * @param	endsWanted Number of traditional ends to include in the return vector.
		 * @return The top volition values correlated with indexes into the volition matrix.
		 */
		public function getTopTradEnds(endsWanted:int = 3):Vector.<VolitionValue> {
			var values:Vector.<VolitionValue> = new Vector.<VolitionValue>();
			/*function compare(x:VolitionValue, y:VolitionValue):Number { 
				if (x.volition > y.volition) 
					return -1.0;
				else if (x.volition < y.volition)
					return 1.0;
				return 0.0;}*/
			//add all traditional ends and role combinations to volition vector
			for (var curGameIndex:int = new int(0); curGameIndex < this.volition.length; ++curGameIndex) {
				for (var curRoleIndex:int = new int(0); curRoleIndex < this.volition[curGameIndex][0].length; ++curRoleIndex) {
					var vv:VolitionValue = new VolitionValue();
					vv.characterName = this.name;
					vv.game = curGameIndex;
					vv.endIndex = 0; //traditional role is always 0
					vv.role = curRoleIndex;
					//trace("SocialEntity.getTopTradEnds(): game - " + curGameIndex + " role - " + curRoleIndex);
					vv.volition = this.volition[curGameIndex][0][curRoleIndex];
					values.push(vv);
				}
			}
			//sort vector
			//splice top n from vector
			return values.sort(vv.compare).splice(0, endsWanted);
		}
		
		/**
		 * Get the top traditional social game endings for the White role sorted by volition value.
		 * @param	endsWanted
		 * @return	The top volition values correlated with indexes into the volition matrix.
		 */
		public function getTopTradEndsForWhite(endsWanted:int = 3):Vector.<VolitionValue> {
			var values:Vector.<VolitionValue> = new Vector.<VolitionValue>();
			/*function compare(x:VolitionValue, y:VolitionValue):Number { 
				if (x.volition > y.volition) 
					return -1.0;
				else if (x.volition < y.volition)
					return 1.0;
				return 0.0;}*/
			//add all traditional ends and role combinations to volition vector
			for (var curGameIndex:int = new int(0); curGameIndex < this.volition.length; ++curGameIndex) {
				//for (var curRoleIndex:int = new int(0); curRoleIndex < this.volition[curGameIndex][0].length; ++curRoleIndex) {
				var vv:VolitionValue = new VolitionValue();
				vv.characterName = this.name;
				vv.game = curGameIndex;
				vv.endIndex = 0; //traditional role is always 0
				vv.role = 0;
				//trace("SocialEntity.getTopTradEnds(): game - " + curGameIndex + " role - " + curRoleIndex);
				vv.volition = this.volition[curGameIndex][0][0];
				values.push(vv);
				
			}
			//sort vector
			//splice top n from vector
			return values.sort(vv.compare).splice(0, endsWanted);
		}
		
		/**
		 * Finds the top volition antithetical game/role combinations of a certain game.
		 * 
		 * @param	gameIndex Index in the voltion matrix of the game from which to find values.
		 * @param	endsWanted Number of ends to include in the return vector.
		 * @return The top antithetical end/role combinations.
		 */
		public function getTopAntiEndsByGame(gameIndex:int, endsWanted:int = 3):Vector.<VolitionValue> {
			var values:Vector.<VolitionValue> = new Vector.<VolitionValue>();
				
			for (var curGameIndex:int = new int(0); curGameIndex < this.volition.length; ++curGameIndex) {
				//start at index 1 to avoid the traditional end volition value
				for (var curEndIndex:int = new int(1); curEndIndex < this.volition[curGameIndex].length; ++ curEndIndex) {
					for (var curRoleIndex:int = new int(0); curRoleIndex < this.volition[curGameIndex][0].length; ++curRoleIndex) {
						var vv:VolitionValue = new VolitionValue();
						vv.characterName = this.name;
						vv.game = curGameIndex;
						vv.endIndex = curEndIndex; 
						vv.role = curRoleIndex;
						//trace("SocialEntity.getTopAntiEndsByGame(): game - " + curGameIndex + " end - " + curEndIndex + " role - " + curRoleIndex);
						vv.volition = this.volition[curGameIndex][curEndIndex][curRoleIndex];
						values.push(vv);
					}
				}
			}
			return values.sort(vv.compare).splice(0, endsWanted);
		}
		
		/**
		 * Returns the top volition ends (both traditional and antithetical) 
		 * of this character for a given game and role.
		 * 
		 * @param	gameIndex	Index of the game in the character's volition matrix.
		 * @param	roleIndex	Index of the role in the character's volition matrix.
		 * @param	endsWanted	Number of ends to include in the return vector.
		 * @return	The top volitions for this character in a specific role and social game.
		 */
		public function getTopEndsByGameAndRole(gameIndex:int, roleIndex:int , endsWanted:int = 3):Vector.<VolitionValue> {
			var values:Vector.<VolitionValue> = new Vector.<VolitionValue>();
			for (var curEndIndex:int = new int(0); curEndIndex < this.volition[gameIndex].length; ++ curEndIndex) {
					var vv:VolitionValue = new VolitionValue();
					vv.characterName = this.name;
					vv.game = gameIndex;
					vv.endIndex = curEndIndex; 
					vv.role = roleIndex;
					vv.volition = this.volition[gameIndex][curEndIndex][roleIndex];
					//trace("SocialEntity.getTopEndsByGameAndRole(): game - " + gameIndex + " end - " + curEndIndex + " role - " + roleIndex + " volition - " + vv.volition);
					values.push(vv);
			}
			
			return values.sort(vv.compare).splice(0, endsWanted);
		}
		
		/***
		 * Returns the valence of the basic need capapcity for the character
		 * as either 1.0 if the valence is positive, -1.0 if negative, or 0.0
		 * if the character has 0.0 capacity.
		 * 
		 * @param The enumerated integer value associated with a basic need.
		 ***/
		public function getNeedValence(needType:int):Number {
			if ( this.getCapacity(needType) > 0.0) return 1.0;
			if ( this.getCapacity(needType) < 0.0) return -1.0;
			return 0.0;
			
		}
		
		//setters
		public function setName(newName:String):void { this.name = newName;}
		
		/**
		 * Updates the a need state and ensures the state is not of a different
		 * sign or greater than the capacity the social entity has of that 
		 * need.
		 * @param	index	Index of the basic need.
		 * @param	amount	Amount to set the basic need state to.
		 */
		public function setNeedState(index:int, amount:Number):void { 
			this.currentNeedsState[index] = amount; 
			
			//capacity bounds checking
			if (this.currentNeedsState[index] < 0 && this.getCapacity(index) > 0.0) {
				this.currentNeedsState[index] = 0.0;
			}else if (this.currentNeedsState[index] > 0.0 && this.getCapacity(index) < 0.0) {
				this.currentNeedsState[index] = 0.0;
			}else if (this.getCapacity(index) == 0.0 && this.currentNeedsState[index] != 0.0) {
				this.currentNeedsState[index] = 0.0;
			}
			//if update took need state over capacity, set the state equal to the capacity
			if (Math.abs(this.getCapacity(index)) < Math.abs(this.currentNeedsState[index])) {
				this.currentNeedsState[index] = this.getCapacity(index);
			}			
		}
		
		public function setNeedStateByName(need:String, amount:Number):void {
			var utils:SGutils = new SGutils();
			this.currentNeedsState[utils.needIDFromString(need)] = amount;
		}
		public function addToNeedState(index:int, amount:Number):void {
			if(-1.0 > (this.currentNeedsState[index] + amount) ||
				1.0 < (this.currentNeedsState[index] + amount) ) {
					trace("Last basic need state change will take agent " + this.name + "'s basic need " 
						+ index + "out of [-1,1]. Skipping this current basic need state update.");
				}else {
					this.currentNeedsState[index] += amount;	
				}
		}
		public function setPossibleGoalSet(goalSet:Vector.<SocialGoal>):void {
			this.goals = goalSet;
		}
		
		
		public function getNumAuthorGoals():int { 
			return this.personalityDescription.getAllGoals().length; 
		}
		public function getAllAuthorGoals():Vector.<AdHocSocialGoal> { 
			return this.personalityDescription.getAllGoals(); 
		}
		//get author goal by name
		//get author goal by index
		
		
		/***
		 * Get basic need capacity by enumerated type or string. String takes precedence.
		 * 
		 * @param typeAsInt:int The type number associated with the basic need capacity.
		 * @param typeAsStr:String The type string associated with the basic need capacity.
		 ***/
		
		public function getCapacity(typeAsInt:int, typeAsStr:String = ""):Number {
			var util:SGutils = new SGutils();
			if (typeAsStr != "")
				return this.personalityDescription.getNeedCapacity(util.needIDFromString(typeAsStr));
			return this.personalityDescription.getNeedCapacity(typeAsInt);
		}
		
		/**
		 * Update the character state as a result of playing a social game.
		 * 
		 * @param	sg	The social game played (with all roles and ending taken loaded).
		 */
		public function updateFromGameplay(sg:SocialGame):void {
			//get role index from social game
			if (sg.isCharacterInGame(this.name)) {
				for (var i:int = new int(0); i < sg.getNumRoles(); ++i) {
					//trace("SocialEntity.updateFromGameplay(): rolename - " + sg.getRole(i).getCharacterName());
					if (this.name.toLowerCase() == sg.getRole(i).getCharacterName().toLowerCase()) {
						trace("SocialEntity.updateFromGameplay(): " + this.name + " changed basic need state as a result of participating in a game.");
						for (var curNeedIndex:int = new int(0); curNeedIndex < this.personalityDescription.NUMBER_OF_NEEDS; ++curNeedIndex) {
							//TODO: check this formula
							this.currentNeedsState[curNeedIndex] += Math.abs(this.getCapacity(curNeedIndex)) / 2 * sg.getNeedChangeByRoleAndEnd(curNeedIndex, i , sg.getEndTaken());
							//trace("SocialEntity.updateFromGameplay: "+this.name+ " changed - " + sg.getNeedChangeByRoleAndEnd(curNeedIndex, i , sg.getEndTaken()));
							//if a positive capacity character has a negative need satiation, make the current need state 0.0
							if (this.currentNeedsState[curNeedIndex] < 0 && this.getCapacity(curNeedIndex) > 0.0) {
								this.currentNeedsState[curNeedIndex] = 0.0;
							}else if (this.currentNeedsState[curNeedIndex] > 0.0 && this.getCapacity(curNeedIndex) < 0.0) {
								this.currentNeedsState[curNeedIndex] = 0.0;
							}else if (this.getCapacity(curNeedIndex) == 0.0 && this.currentNeedsState[curNeedIndex] != 0.0) {
								this.currentNeedsState[curNeedIndex] = 0.0;
							}
							//if update took need state over capacity, set the state equal to the capacity
							if (Math.abs(this.getCapacity(curNeedIndex)) < Math.abs(this.currentNeedsState[curNeedIndex])) {
								this.currentNeedsState[curNeedIndex] = this.getCapacity(curNeedIndex);
							}
							//c
						}
					}
				}
			}
			//for each basic need
			//  get need change for this role for the proper ending
		}
		
		/****************************************
		 * functions used for databinding callbacks
		 * *************************************/
		/**
		 * Used to create a properly scoped closure when binding the volition
		 * modifier.
		 * 
		 * @param	modifier The new modifier value to update to.
		 */
		public function volitionModifierBinder(modifier:Number):void {
			this.volitionModifier = modifier;
		}
		
		/**
		 * Function used to create a proper closure when the basic need state
		 * of power is to be bound.
		 * @param	amt
		 */
		public function powerStateBinder(amt:Number):void {
			this.setNeedStateByName("Power", amt);
		}
		
		/**
		 * Function used to create a proper closure when the basic need state
		 * of status is to be bound.
		 * @param	amt
		 */
		public function statusStateBinder(amt:Number):void {
			this.setNeedStateByName("Status", amt);
		}
		
		/**
		 * Function used to create a proper closure when the basic need state
		 * of acceptance is to be bound.
		 * @param	amt
		 */
		public function acceptanceStateBinder(amt:Number):void {
			this.setNeedStateByName("Acceptance", amt);
		}
		
		/**
		 * Function used to create a proper closure when the basic need state
		 * of vengeance is to be bound.
		 * @param	amt
		 */
		public function vengeanceStateBinder(amt:Number):void {
			this.setNeedStateByName("Vengeance", amt);
		}
		
		public function toString():String {
			var returnStr:String = new String( "SocialAgent:");
			returnStr = returnStr.concat(this.name, "[", this.currentNeedsState, "],[g", this.goals, "],[V:", this.volition, "]");
			returnStr += "[" + this.personalityDescription + "]";
			return returnStr;
		}

	}
}