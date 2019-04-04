package PromWeek 
{
	import CiF.*;

	
	/**
	 * This contains all the level specific information and is loaded by WorldGroup
	 */
	public class ScenarioDescription
	{
		/**
		 * Once this goal is achieved (checked in gameEngine onEnterFrame) the level should end
		 */
		public var goalRule:Rule;
		
		/**
		 * A list of the names of the characters that will be in this scenario
		 */
		public var characters:Vector.<String>;
		
		/**
		 * The background image that will be drawn
		 */
		public var settingName:String
		
		public function ScenarioDescription() 
		{
			characters = new Vector.<String>();
			
			goalRule = new Rule();
			
			var predicate:Predicate = new Predicate();
			predicate.setRelationshipPredicate("robert", "debbie", RelationshipNetwork.DATING);
			goalRule.predicates.push(predicate);
		}	
		
		public function addCharacter(charName:String):void
		{
			characters.push(charName);
		}
		
		public function setLocation(locName:String):void
		{
			settingName = locName;
		}
	}
}