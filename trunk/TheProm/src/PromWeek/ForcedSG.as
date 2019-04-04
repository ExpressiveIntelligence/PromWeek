package PromWeek 
{
	/**
	 * Inside of quick play mode, perhaps you want to force pairs of characters to play specific social games,
	 * or maybe a specific instantiation of a specific social game. you can specify that in a quick play level's
	 * Story XML file. This is a data structure that essentially stores the data read in from that file.
	 * @author Ben
	 */
	public class ForcedSG 
	{
		
		/**
		 * the 'from' character -- who is going to be initiating this social game.
		 */
		public var initiator:String; // 
		
		/**
		 * the 'to' character -- who is going to be the responder in this social game.
		 */
		public var responder:String; // 
		
		/**
		 * the name of the social game we want these characters to be playing.
		 */
		public var gameName:String; // 
		
		/**
		 * how many turns into the level we want to force this game/instantiation. 0 means the first turn of the level.
		 */
		public var turnsIn:int; // 
		
		/**
		 * the id of the instantiation we want to play.  -1 means ignore this specification, and use the instantiation it wanted to use in the first place.
		 */
		public var instantiationID:int; 
		
		public function ForcedSG() 
		{
			
		}
		
		public function loadFromXML(forcedSGXML:XML):void {
			
			this.initiator = (forcedSGXML.@initiator.toString())?forcedSGXML.@initiator:"";
			this.responder = (forcedSGXML.@responder.toString())?forcedSGXML.@responder:"";
			this.gameName = (forcedSGXML.@gameName.toString())?forcedSGXML.@gameName:"";
			this.turnsIn = (forcedSGXML.@turnsIn.toString())?forcedSGXML.@turnsIn:-1;
			this.instantiationID = (forcedSGXML.@turnsIn.toString())?forcedSGXML.@instantiationID:-1;
			
			
			/**
			 * this.nextChallengeName = (storyXML.@nextChallengeName.toString())?storyXML.@nextChallengeName:"NONE";
			 * 			this.quickPlayDescription = (storyXML.QuickPlayDescription.text())?storyXML.QuickPlayDescription.text():"undescribed";
			this.quickPlayEndingDescription = (storyXML.QuickPlayEndingDescription.text())?storyXML.QuickPlayEndingDescription.text():"undescribed";
			this.istutorial = (storyXML.@isTutorial.toString() == "true")?true:false;
			this.isQuickPlay = (storyXML.@isQuickPlay.toString() == "true")?true:false;
			this.quickPlayNumberOfGamesAvailable = (storyXML.@numberOfQuickPlaySGAvailable.toString())?storyXML.@numberOfQuickPlaySGAvailable:10;
			 */

		}
		
	}

}