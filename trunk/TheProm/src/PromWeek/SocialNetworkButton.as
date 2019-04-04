package PromWeek
{
	import spark.components.Button;
	import flash.events.MouseEvent;
	
	public class SocialNetworkButton extends Button
	{	
		public var network:String;
		
		public var toggleStatus:Boolean;
		
		public var offsetX:Number;
		public var offsetY:Number;
		
		public function SocialNetworkButton(net:String)
		{
			network = net;
			//this.addEventListener(MouseEvent.CLICK, clickHander);
			
			toggleStatus = false;
			
			this.width = 40;
			this.height = 40;
			
			this.label = network;
		}
	}
}