package ScenarioUI 
{
	import CiF.Character;
	import flash.events.Event;
	
	/**
	 * The custom event for character representation selection the scenerio
	 * design UI.
	 */
	public class CharacterRepresentationSelectedEvent extends Event
	{
		public static const CHARACTER_REPRESENTATION_SELECTED:String = "characterRepresentationSelected";
		
		public var selectedChar:Character;
		
		
		
		/**
		 * The index of the character representation selected in the design
		 * simulation UI's characterState component.
		 */
		public var selectedIndex:int = 0;
		
		public function CharacterRepresentationSelectedEvent(bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			super(CHARACTER_REPRESENTATION_SELECTED, bubbles, cancelable);
		}
	}
}