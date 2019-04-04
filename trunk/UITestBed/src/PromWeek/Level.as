package PromWeek 
{
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.ParseXML;
	import CiF.Predicate;
	import CiF.Rule;
	import flash.utils.Dictionary;


	public class Level 
	{	
		/**
		 * The cast for this level.
		 */
		public var cast:Vector.<Character>;
		
		public function Level() {
			cast = new Vector.<Character>();
		}
	}
}