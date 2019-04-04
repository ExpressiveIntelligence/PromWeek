package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import CiF.*;
		
	
	/**
	 * ...
	 * @author Ben*
	 */
	public class Main extends Sprite 
	{
		private var cif:CiFSingleton;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			trace("Hello World!");
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}