package edu.ucsc.eis
{
	import flash.events.Event;

	public class AllXMLLoadedEvent extends Event
	{
		// Define static constant.
        public static const ALL_XML_LOADED:String = "allXMLLoaded";
		// Define a public variable to hold the state of the enable property.
        public var agentsLoaded:Boolean;
        public var sgLibLoaded:Boolean;

		public function AllXMLLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.agentsLoaded = new Boolean(false);
			this.sgLibLoaded = new Boolean(false);
		}
		
		public function setAgentsLoaded(b:Boolean):void { this.agentsLoaded=b; }
		public function setsgLibLoaded(b:Boolean):void {this.sgLibLoaded=b;}
		
		override public function clone():Event {
            var clonedEvent:AllXMLLoadedEvent = new AllXMLLoadedEvent(type);
            clonedEvent.agentsLoaded = this.agentsLoaded;
            clonedEvent.sgLibLoaded = this.sgLibLoaded;
            return clonedEvent;
        }
		
	}
}