package PromWeek 
{
	/**
	 * ...
	 * @author Ben*
	 */
	import CiF.Debug;
	 
	public class TutorialStep
	{
		public var popupText:String;
		public var preText:String; // text that is displayed BEFORE a tutorial step.
		public var postText:String; // text that is displayed AFTER a tutorial step.
		public var eventType:String;
		public var object:String;
		public var name:String; // this has more identifying information, such as if you have to click on an avatar, the NAME of the avatar you have to click on.
		public var disableExceptions:String; //things that the user can click on, but it doesn't progress the tutorial.
		public var disableExceptionsButStillProgress:String; // things that the user can click on, and it DOES progress the tutorial.
		public var nextVisible:String;
		public var internalText:String;
		public var isOver:Boolean;
		public var stop:Boolean;
		public var sgName:String;
		public var quadrant:int;
		public var socialGameButtonNumber:int;
		public var centerOnCharacter:String;
		public var positionX:Number;
		public var positionY:Number;
		public var stateVizHead:String;
		
		public function TutorialStep() 
		{
			popupText = "";
			eventType = "";
			object = "";
		}
		
		public function toString():String {
			return "object: " + object + " eventType: " + eventType + " popupText: " + popupText + " name: " + name + " preText: " + preText + " postText: " + postText + " centerOnCharacter: " + centerOnCharacter;
		}
	}

}