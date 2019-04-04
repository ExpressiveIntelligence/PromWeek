package PromWeek 
{
	import CiF.CiFSingleton;
	import CiF.Debug;
	import flash.utils.Dictionary;
	/**
	 * The EndingManager is to be instantiated when the ending of a Story is reached.
	 * Given the story and which goals are satisfied, the EndingManager will determine
	 * which are the best endings to display. Endings that cover more goals have priority.
	 */
	public class EndingManager 
	{
		public var story:Story;
		
		/**
		 * The vector of newly-filled ToDoItems for reporting to the backend which goals
		 * were newly fulfilled to the player.
		 */
		public var newlyFulfilledItems:Vector.<ToDoItem>;
		public var gameEngine:PromWeek.GameEngine;
		
		public function EndingManager(s:Story=null) 
		{
			this.story = s;
			gameEngine = PromWeek.GameEngine.getInstance();
		}
		
		public function determineEndings(shouldMarkAsSeen:Boolean = true ):Vector.<Ending> {
			var endingsToPlay:Vector.<Ending> = new Vector.<Ending>()
			
			Debug.debug(this, "determineEndings() reached.");
			//Utility.log(this, "determineEndings() reached.");
			
			//determine which ToDoItems are fulfilled
			
			var itemsToFill:Vector.<ToDoItem> = this.story.evaluateToDoItems(CiFSingleton.getInstance().cast.characters)
			this.setNewlyFulfilledItems(itemsToFill);
			
			if (shouldMarkAsSeen)
			{
				this.markGoalsAsSeen(itemsToFill)
			}
			
			
			
			//match possible endings to fulfilled ToDoItems
			
			//pick a set of endings that exactly matches the fulfilled ToDoItems
			
			//sort the endings
			gameEngine.possibleEndings.sort(this.sortEndingsByLinkedToDoItemsDescending)
			
			//Utility.log(this, "determineEndings() itemsToFill.length=" + itemsToFill.length);
			//Debug.debug(this, "determineEndings() itemsToFill.length=" + itemsToFill.length);
			for each(var ending:Ending in gameEngine.possibleEndings) {
				if (this.isEndingApplicable(ending, itemsToFill) && ending.linkedToDoItems.length > 0) {
					itemsToFill = this.removeItemsEnded(ending, itemsToFill)
					endingsToPlay.push(ending)
					//Utility.log(this, "determineEndings() ending.name=" + ending.name + "(" + ending.dramaScore + ") itemsToFill.length=" + itemsToFill.length);
					//Debug.debug(this, "determineEndings() ending.name=" + ending.name + "(" + ending.dramaScore + ") itemsToFill.length=" + itemsToFill.length);
				}
			}
			
			//if none were found, put in the generic
			if (0 == endingsToPlay.length)
				endingsToPlay.push(gameEngine.possibleEndings[gameEngine.possibleEndings.length - 1]);
			
			return endingsToPlay
		}
		
		/**
		 * Sets this.newlyFulfilledItems to be the ToDoItems that are fulfilled for the first time for this player.
		 * 
		 * @param	all All the ToDoItems fulfilled in this story (new or previously-fulfilled).
		 */
		public function setNewlyFulfilledItems(all:Vector.<ToDoItem>):void {
			var sm:StatisticsManager = StatisticsManager.getInstance()
			this.newlyFulfilledItems = new Vector.<ToDoItem>()
			
			for each(var item:ToDoItem in all) {
				if (!sm.goalsSeen[this.story.storyLeadCharacter + "-" + item.name]) {
					this.newlyFulfilledItems.push(item)
					Debug.debug(this, "setNewlyFulfilledItems() a newly fulfilled goal was found: " + item.name)
					//Utility.log (this, "setNewlyFulfilledItems() a newly fulfilled goal was found: " + item.name)
				}
			}
		}
		
		private function sortEndingsByLinkedToDoItemsDescending(x:Ending, y:Ending):Number {
			//return x.linkedToDoItems.length - y.linkedToDoItems.length;
			return y.linkedToDoItems.length - x.linkedToDoItems.length;
		}
		/**
		 * Determines if an Ending is associated with a set of ToDoItems in the list of fulfilled
		 * ToDoItems.
		 * @param	The ending containing the ToDoItems to remove.
		 * @param	itemsToFill	The ToDoItem set to be checked against.
		 * @return True if the ending was applicable, false if not.
		 */
		private function isEndingApplicable(e:Ending, itemsToFill:Vector.<ToDoItem>):Boolean {
			var wasItemFound:Boolean = false;
			
			for each (var endingItem:ToDoItem in e.linkedToDoItems) {
				wasItemFound = false;
				for each (var fulfilledItem:ToDoItem in itemsToFill) {
					if (endingItem.name == fulfilledItem.name) {
						wasItemFound = true;
					}
				}
				if (!wasItemFound) return false;
			}
			return true;
		}
		
		
		public function getCharactersForEnding():Vector.<Dictionary>
		{
			var gameEngine:PromWeek.GameEngine = PromWeek.GameEngine.getInstance();
			
			var pickedList:Vector.<Dictionary> = new Vector.<Dictionary>();
			
			var highestDramaPickIndex:int = 0;
			var haveAddedPairForThisEnding:Boolean;
			
			var ending:Ending;
			for (var i:int = gameEngine.possibleEndings.length - 1; i >= 0; i-- )
			{
				ending = gameEngine.possibleEndings[i];
				haveAddedPairForThisEnding = false;
				if (i == gameEngine.possibleEndings.length - 1)
				{
					pickedList.push(ending.secondThirdPairs[highestDramaPickIndex]);
					haveAddedPairForThisEnding = true;
				}
				else
				{
					for (var j:int = 0; (j < ending.secondThirdPairs.length && !haveAddedPairForThisEnding); j++ )
					{
						if (!isPairInList(ending.secondThirdPairs[j], pickedList))
						{
							pickedList.push(ending.secondThirdPairs[j]);
							haveAddedPairForThisEnding = true;
						}
					}
				}
				
				if (!haveAddedPairForThisEnding)
				{
					i = gameEngine.possibleEndings.length - 1;
					highestDramaPickIndex++;
					
					if (highestDramaPickIndex >= gameEngine.possibleEndings[i].secondThirdPairs.length)
					{
						return this.randomlyPickCharacterPairs();
					}
				}
			}
			
			return pickedList;
		}
		
		
		public function randomlyPickCharacterPairs():Vector.<Dictionary>
		{
			var pickedList:Vector.<Dictionary> = new Vector.<Dictionary>();
			for each (var ending:Ending in gameEngine.possibleEndings)
			{
				pickedList.push(ending.secondThirdPairs[Utility.randRange(0,ending.secondThirdPairs.length - 1)]);
			}
			return pickedList;
		}
		
		
		
		public function isPairInList(pair:Dictionary, list:Vector.<Dictionary>):Boolean
		{
			for each (var dict:Dictionary in list)
			{
				if (pair["responder"] != null && dict["responder"] != null)
				{
					if (pair["responder"] == dict["responder"])
					{
						if (pair["other"] != null && dict["other"] != null)
						{
							if (pair["other"] == dict["other"])
							{
								return true;
							}
						}
						else if (pair["other"] != null && dict["other"] != null)
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		
		/**
		 * Removes the ToDoItems accounted for by the Ending from the un-ended, fulfilled ToDoItems.
		 * @param	e			The ending containing the ToDoItems to remove.
		 * @param	itemsToFill	The ToDoItem set to be reduced.
		 * @return The remaining ToDoItems after removal.
		 */
		private function removeItemsEnded(e:Ending, itemsToFill:Vector.<ToDoItem>):Vector.<ToDoItem> {
			var prunedItemsToFill:Vector.<ToDoItem> = itemsToFill;
			for each (var endingItem:ToDoItem in e.linkedToDoItems) {
				for (var i:int=0; i < prunedItemsToFill.length; ++i ) {
					if (endingItem.name == prunedItemsToFill[i].name) {
						Debug.debug(this, "removeItemsEnded() Removed: " + prunedItemsToFill[i].name)
						prunedItemsToFill.splice(i, 1);
					}
				}
			}
			return prunedItemsToFill;
		}
		
		/**
		 * Marks the completed goals as seen in the StatisticsManager.
		 * 
		 * @param	goals The goals to mark as completed.
		 */
		public function markGoalsAsSeen(goals:Vector.<ToDoItem>):void {
			var sm:StatisticsManager = StatisticsManager.getInstance()
			for each(var g:ToDoItem in goals) {
				sm.goalsSeen[this.story.storyLeadCharacter + "-" + g.name] = true
			}
		}
	}

}