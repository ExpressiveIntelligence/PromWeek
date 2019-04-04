package PromWeek 
{
	import CiF.*;

	import flash.utils.Dictionary;

	public class AutonomousAction
	{		
		public static const DEFAULT_INITIAL_TIME_BEFORE_ACTION:int = 3;
		
		public static const DEFAULT_NECESSARY_SCORE:int = 40;

		public var cif:CiFSingleton;
		public var gameEngine:PromWeek.GameEngine;
		
		public var remainingTimeUntilAction:int;
		public var intensityScore:int;
		public var necessaryScore:int;
		public var initiator:String;
		public var responder:String;
		public var gameName:String;
		
		public function AutonomousAction()
		{
			
			this.necessaryScore = DEFAULT_NECESSARY_SCORE;
			this.remainingTimeUntilAction = DEFAULT_INITIAL_TIME_BEFORE_ACTION;
		}
	}
}